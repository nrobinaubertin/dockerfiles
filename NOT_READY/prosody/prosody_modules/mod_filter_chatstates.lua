local filters = require "util.filters";
local st = require "util.stanza";

module:depends("csi");

local function chatstate_tag_filter(tag)
	if tag.attr.xmlns ~= "http://jabber.org/protocol/chatstates" then
		return tag;
	end
end

local function filter_chatstates(stanza)
	if stanza.name == "message" then
		stanza = st.clone(stanza);
		stanza:maptags(chatstate_tag_filter);
		if #stanza.tags == 0 then
			return nil;
		end
	end
	return stanza;
end

module:hook("csi-client-inactive", function (event)
	local session = event.origin;
	filters.add_filter(session, "stanzas/out", filter_chatstates);
end);

module:hook("csi-client-active", function (event)
	local session = event.origin;
	filters.remove_filter(session, "stanzas/out", filter_chatstates);
end);
