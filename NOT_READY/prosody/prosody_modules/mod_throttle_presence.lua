local filters = require "util.filters";
local st = require "util.stanza";

module:depends("csi");

local function presence_filter(stanza, session)
	if getmetatable(stanza) ~= st.stanza_mt then
		return stanza; -- Things we don't want to touch
	end
	if stanza._flush then
		stanza._flush = nil;
		return stanza;
	end
	local buffer = session.presence_buffer;
	local from = stanza.attr.from;
	if stanza.name == "presence" and (stanza.attr.type == nil or stanza.attr.type == "unavailable") then
		module:log("debug", "Buffering presence stanza from %s to %s", stanza.attr.from, session.full_jid);
		buffer[stanza.attr.from] = st.clone(stanza);
		return nil; -- Drop this stanza (we've stored it for later)
	else
		local cached_presence = buffer[stanza.attr.from];
		if cached_presence then
			module:log("debug", "Important stanza for %s from %s, flushing presence", session.full_jid, from);
			stanza._flush = true;
			cached_presence._flush = true;
			session.send(cached_presence);
			buffer[stanza.attr.from] = nil;
		end
	end
	return stanza;
end

local function throttle_session(event)
	local session = event.origin;
	if session.presence_buffer then return; end
	module:log("debug", "Suppressing presence updates to %s", session.full_jid);
	session.presence_buffer = {};
	filters.add_filter(session, "stanzas/out", presence_filter);
end

local function restore_session(event)
	local session = event.origin;
	if not session.presence_buffer then return; end
	filters.remove_filter(session, "stanzas/out", presence_filter);
	module:log("debug", "Flushing buffer for %s", session.full_jid);
	for jid, presence in pairs(session.presence_buffer) do
		session.send(presence);
	end
	session.presence_buffer = nil;
end

module:hook("csi-client-inactive", throttle_session);
module:hook("csi-client-active", restore_session);
