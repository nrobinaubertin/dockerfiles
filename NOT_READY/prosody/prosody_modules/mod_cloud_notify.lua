-- XEP-0357: Push (aka: My mobile OS vendor won't let me have persistent TCP connections)
-- Copyright (C) 2015-2016 Kim Alvefur
-- Copyright (C) 2017 Thilo Molitor
--
-- This file is MIT/X11 licensed.

local st = require"util.stanza";
local jid = require"util.jid";
local dataform = require"util.dataforms".new;
local filters = require"util.filters";
local hashes = require"util.hashes";

local xmlns_push = "urn:xmpp:push:0";

-- configuration
local include_body = module:get_option_boolean("push_notification_with_body", false);
local include_sender = module:get_option_boolean("push_notification_with_sender", false);
local max_push_errors = module:get_option_number("push_max_errors", 50);

local host_sessions = prosody.hosts[module.host].sessions;
local push_errors = {};

-- For keeping state across reloads while caching reads
local push_store = (function()
	local store = module:open_store();
	local push_services = {};
	local api = {};
	function api:get(user)
		if not push_services[user] then
			local err;
			push_services[user], err = store:get(user);
			if not push_services[user] and err then
				module:log("warn", "Error reading push notification storage for user '%s': %s", user, tostring(err));
				push_services[user] = {};
				return push_services[user], false;
			end
		end
		if not push_services[user] then push_services[user] = {} end
		return push_services[user], true;
	end
	function api:set(user, data)
		push_services[user] = data;
		local ok, err = store:set(user, push_services[user]);
		if not ok then
			module:log("error", "Error writing push notification storage for user '%s': %s", user, tostring(err));
			return false;
		end
		return true;
	end
	function api:set_identifier(user, push_identifier, data)
		local services = self:get(user);
		services[push_identifier] = data;
		return self:set(user, services);
	end
	return api;
end)();

-- Forward declarations, as both functions need to reference each other
local handle_push_success, handle_push_error;

function handle_push_error(event)
	local stanza = event.stanza;
	local error_type, condition = stanza:get_error();
	local node = jid.split(stanza.attr.to);
	local from = stanza.attr.from;
	local user_push_services = push_store:get(node);

	for push_identifier, _ in pairs(user_push_services) do
		local stanza_id = hashes.sha256(push_identifier, true);
		if stanza_id == stanza.attr.id then
			if user_push_services[push_identifier] and user_push_services[push_identifier].jid == from and error_type ~= "wait" then
				push_errors[push_identifier] = push_errors[push_identifier] + 1;
				module:log("info", "Got error of type '%s' (%s) for identifier '%s': "
					.."error count for this identifier is now at %s", error_type, condition, push_identifier,
					tostring(push_errors[push_identifier]));
				if push_errors[push_identifier] >= max_push_errors then
					module:log("warn", "Disabling push notifications for identifier '%s'", push_identifier);
					-- remove push settings from sessions
					for _, session in pairs(host_sessions[node].sessions) do
						if session.push_identifier == push_identifier then
							session.push_identifier = nil;
							session.push_settings = nil;
						end
					end
					-- save changed global config
					push_store:set_identifier(node, push_identifier, nil);
					push_errors[push_identifier] = nil;
					-- unhook iq handlers for this identifier (if possible)
					if module.unhook then
						module:unhook("iq-error/bare/"..stanza_id, handle_push_error);
						module:unhook("iq-result/bare/"..stanza_id, handle_push_success);
					end
				end
			elseif user_push_services[push_identifier] and user_push_services[push_identifier].jid == from and error_type == "wait" then
				module:log("debug", "Got error of type '%s' (%s) for identifier '%s': "
					.."NOT increasing error count for this identifier", error_type, condition, push_identifier);
			end
		end
	end
	return true;
end

function handle_push_success(event)
	local stanza = event.stanza;
	local node = jid.split(stanza.attr.to);
	local from = stanza.attr.from;
	local user_push_services = push_store:get(node);

	for push_identifier, _ in pairs(user_push_services) do
		if hashes.sha256(push_identifier, true) == stanza.attr.id then
			if user_push_services[push_identifier] and user_push_services[push_identifier].jid == from and push_errors[push_identifier] > 0 then
				push_errors[push_identifier] = 0;
				module:log("debug", "Push succeeded, error count for identifier '%s' is now at %s", push_identifier, tostring(push_errors[push_identifier]));
			end
		end
	end
	return true;
end

-- http://xmpp.org/extensions/xep-0357.html#disco
local function account_dico_info(event)
	(event.reply or event.stanza):tag("feature", {var=xmlns_push}):up();
end
module:hook("account-disco-info", account_dico_info);

-- http://xmpp.org/extensions/xep-0357.html#enabling
local function push_enable(event)
	local origin, stanza = event.origin, event.stanza;
	local enable = stanza.tags[1];
	origin.log("debug", "Attempting to enable push notifications");
	-- MUST contain a 'jid' attribute of the XMPP Push Service being enabled
	local push_jid = enable.attr.jid;
	-- SHOULD contain a 'node' attribute
	local push_node = enable.attr.node;
	if not push_jid then
		origin.log("debug", "Push notification enable request missing the 'jid' field");
		origin.send(st.error_reply(stanza, "modify", "bad-request", "Missing jid"));
		return true;
	end
	local publish_options = enable:get_child("x", "jabber:x:data");
	if not publish_options then
		-- Could be intentional
		origin.log("debug", "No publish options in request");
	end
	local push_identifier = push_jid .. "<" .. (push_node or "");
	local push_service = {
		jid = push_jid;
		node = push_node;
		count = 0;
		options = publish_options and st.preserialize(publish_options);
	};
	local ok = push_store:set_identifier(origin.username, push_identifier, push_service);
	if not ok then
		origin.send(st.error_reply(stanza, "wait", "internal-server-error"));
	else
		origin.push_identifier = push_identifier;
		origin.push_settings = push_service;
		origin.log("info", "Push notifications enabled for %s (%s)", tostring(stanza.attr.from), tostring(origin.push_identifier));
		origin.send(st.reply(stanza));
	end
	return true;
end
module:hook("iq-set/self/"..xmlns_push..":enable", push_enable);

-- http://xmpp.org/extensions/xep-0357.html#disabling
local function push_disable(event)
	local origin, stanza = event.origin, event.stanza;
	local push_jid = stanza.tags[1].attr.jid; -- MUST include a 'jid' attribute
	local push_node = stanza.tags[1].attr.node; -- A 'node' attribute MAY be included
	if not push_jid then
		origin.send(st.error_reply(stanza, "modify", "bad-request", "Missing jid"));
		return true;
	end
	local user_push_services = push_store:get(origin.username);
	for key, push_info in pairs(user_push_services) do
		if push_info.jid == push_jid and (not push_node or push_info.node == push_node) then
			origin.log("info", "Push notifications disabled (%s)", tostring(key));
			if origin.push_identifier == key then
				origin.push_identifier = nil;
				origin.push_settings = nil;
			end
			user_push_services[key] = nil;
			push_errors[key] = nil;
			if module.unhook then
				module:unhook("iq-error/bare/"..key, handle_push_error);
				module:unhook("iq-result/bare/"..key, handle_push_success);
			end
		end
	end
	local ok = push_store:set(origin.username, user_push_services);
	if not ok then
		origin.send(st.error_reply(stanza, "wait", "internal-server-error"));
	else
		origin.send(st.reply(stanza));
	end
	return true;
end
module:hook("iq-set/self/"..xmlns_push..":disable", push_disable);

local push_form = dataform {
	{ name = "FORM_TYPE"; type = "hidden"; value = "urn:xmpp:push:summary"; };
	{ name = "message-count"; type = "text-single"; };
	{ name = "pending-subscription-count"; type = "text-single"; };
	{ name = "last-message-sender"; type = "jid-single"; };
	{ name = "last-message-body"; type = "text-single"; };
};

-- http://xmpp.org/extensions/xep-0357.html#publishing
local function handle_notify_request(stanza, node, user_push_services)
	local pushes = 0;
	if not user_push_services or not #user_push_services then return pushes end
	
	for push_identifier, push_info in pairs(user_push_services) do
		local send_push = true;		-- only send push to this node when not already done for this stanza or if no stanza is given at all
		if stanza then
			if not stanza._push_notify then stanza._push_notify = {}; end
			if stanza._push_notify[push_identifier] then
				module:log("debug", "Already sent push notification for %s@%s to %s (%s)", node, module.host, push_info.jid, tostring(push_info.node));
				send_push = false;
			end
			stanza._push_notify[push_identifier] = true;
		end
		
		if send_push then
			-- increment count and save it
			push_info.count = push_info.count + 1;
			push_store:set_identifier(node, push_identifier, push_info);
			-- construct push stanza
			local stanza_id = hashes.sha256(push_identifier, true);
			local push_publish = st.iq({ to = push_info.jid, from = node .. "@" .. module.host, type = "set", id = stanza_id })
				:tag("pubsub", { xmlns = "http://jabber.org/protocol/pubsub" })
					:tag("publish", { node = push_info.node })
						:tag("item")
							:tag("notification", { xmlns = xmlns_push });
			local form_data = {
				["message-count"] = tostring(push_info.count);
			};
			if stanza and include_sender then
				form_data["last-message-sender"] = stanza.attr.from;
			end
			if stanza and include_body then
				form_data["last-message-body"] = stanza:get_child_text("body");
			end
			push_publish:add_child(push_form:form(form_data));
			push_publish:up(); -- / notification
			push_publish:up(); -- / publish
			push_publish:up(); -- / pubsub
			if push_info.options then
				push_publish:tag("publish-options"):add_child(st.deserialize(push_info.options));
			end
			-- send out push
			module:log("debug", "Sending push notification for %s@%s to %s (%s)", node, module.host, push_info.jid, tostring(push_info.node));
			-- handle push errors for this node
			if push_errors[push_identifier] == nil then
				push_errors[push_identifier] = 0;
				module:hook("iq-error/bare/"..stanza_id, handle_push_error);
				module:hook("iq-result/bare/"..stanza_id, handle_push_success);
			end
			module:send(push_publish);
			pushes = pushes + 1;
		end
	end
	return pushes;
end

-- small helper function to extract relevant push settings
local function get_push_settings(stanza, session)
	local to = stanza.attr.to;
	local node = to and jid.split(to) or session.username;
	local user_push_services = push_store:get(node);
	return node, user_push_services;
end

-- publish on offline message
module:hook("message/offline/handle", function(event)
	local node, user_push_services = get_push_settings(event.stanza, event.origin);
	handle_notify_request(event.stanza, node, user_push_services);
end, 1);

-- publish on unacked smacks message
local function process_smacks_stanza(stanza, session)
	if session.push_identifier then
		session.log("debug", "Invoking cloud handle_notify_request() for smacks queued stanza");
		local user_push_services = {[session.push_identifier] = session.push_settings};
		local node = get_push_settings(stanza, session);
		handle_notify_request(stanza, node, user_push_services);
	end
	return stanza;
end

local function process_smacks_queue(queue, session)
	if not session.push_identifier then return; end
	local user_push_services = {[session.push_identifier] = session.push_settings};
	for i=1, #queue do
		local stanza = queue[i];
		local node = get_push_settings(stanza, session);
		session.log("debug", "Invoking cloud handle_notify_request() for smacks queued stanza: %d", i);
		if handle_notify_request(stanza, node, user_push_services) ~= 0 then
			session.log("debug", "Cloud handle_notify_request() > 0, not notifying for other queued stanzas");
			return;		-- only notify for one stanza in the queue, not for all in a row
		end
	end
end

-- smacks hibernation is started
local function hibernate_session(event)
	local session = event.origin;
	local queue = event.queue;
	-- process unacked stanzas
	process_smacks_queue(queue, session);
	-- process future unacked (hibernated) stanzas
	filters.add_filter(session, "stanzas/out", process_smacks_stanza);
end

-- smacks hibernation is ended
local function restore_session(event)
	local session = event.resumed;
	if session then		-- older smacks module versions send only the "intermediate" session in event.session and no session.resumed one
		filters.remove_filter(session, "stanzas/out", process_smacks_stanza);
		-- this means the counter of outstanding push messages can be reset as well
		if session.push_settings then
			session.push_settings.count = 0;
			push_store:set_identifier(session.username, session.push_identifier, session.push_settings);
		end
	end
end

-- smacks ack is delayed
local function ack_delayed(event)
	local session = event.origin;
	local queue = event.queue;
	-- process unacked stanzas (handle_notify_request() will only send push requests for new stanzas)
	process_smacks_queue(queue, session);
end

-- archive message added
local function archive_message_added(event)
	-- event is: { origin = origin, stanza = stanza, for_user = store_user, id = id }
	-- only notify for new mam messages when at least one device is only
	if not event.for_user or not host_sessions[event.for_user] then return; end
	local stanza = event.stanza;
	local user_session = host_sessions[event.for_user].sessions;
	local to = stanza.attr.to;
	to = to and jid.split(to) or event.origin.username;

	-- only notify if the stanza destination is the mam user we store it for
	if event.for_user == to then
		local user_push_services = push_store:get(to);
		if not #user_push_services then return end
		
		-- only notify nodes with no active sessions (smacks is counted as active and handled separate)
		local notify_push_sevices = {};
		for identifier, push_info in pairs(user_push_services) do
			local identifier_found = nil;
			for _, session in pairs(user_session) do
				-- module:log("debug", "searching for '%s': identifier '%s' for session %s", tostring(identifier), tostring(session.push_identifier), tostring(session.full_jid));
				if session.push_identifier == identifier then
					identifier_found = session;
					break;
				end
			end
			if identifier_found then
				identifier_found.log("debug", "Not cloud notifying '%s' of new MAM stanza (session still alive)", identifier);
			else
				notify_push_sevices[identifier] = push_info;
			end
		end

		handle_notify_request(event.stanza, to, notify_push_sevices);
	end
end

module:hook("smacks-hibernation-start", hibernate_session);
module:hook("smacks-hibernation-end", restore_session);
module:hook("smacks-ack-delayed", ack_delayed);
module:hook("archive-message-added", archive_message_added);

local function send_ping(event)
	local user = event.user;
	local user_push_services = push_store:get(user);
	local push_services = event.push_services or user_push_services;
	handle_notify_request(nil, user, push_services);
end
-- can be used by other modules to ping one or more (or all) push endpoints
module:hook("cloud-notify-ping", send_ping);

-- TODO: this has to be done on first connect not on offline broadcast, else the counter will be incorrect
-- TODO: it seems this is already done, so this could be safely removed, couldn't it?
-- module:hook("message/offline/broadcast", function(event)
-- 	local origin = event.origin;
-- 	local user_push_services = push_store:get(origin.username);
-- 	if not #user_push_services then return end
-- 
-- 	for _, push_info in pairs(user_push_services) do
-- 		if push_info then
-- 			push_info.count = 0;
-- 		end
-- 	end
-- 	push_store:set(origin.username, user_push_services);
-- end, 1);

module:log("info", "Module loaded");
function module.unload()
	if module.unhook then
		module:unhook("account-disco-info", account_dico_info);
		module:unhook("iq-set/self/"..xmlns_push..":enable", push_enable);
		module:unhook("iq-set/self/"..xmlns_push..":disable", push_disable);

		module:unhook("smacks-hibernation-start", hibernate_session);
		module:unhook("smacks-hibernation-end", restore_session);
		module:unhook("smacks-ack-delayed", ack_delayed);
		module:unhook("archive-message-added", archive_message_added);
		module:unhook("cloud-notify-ping", send_ping);

		for push_identifier, _ in pairs(push_errors) do
			local stanza_id = hashes.sha256(push_identifier, true);
			module:unhook("iq-error/bare/"..stanza_id, handle_push_error);
			module:unhook("iq-result/bare/"..stanza_id, handle_push_success);
		end
	end

	module:log("info", "Module unloaded");
end
