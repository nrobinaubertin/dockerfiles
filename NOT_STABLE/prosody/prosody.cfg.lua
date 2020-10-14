-- Information on configuring Prosody can be found on our
-- website at http://prosody.im/doc/configure

cross_domain_bosh = true
consider_bosh_secure = true
http_paths = {
    bosh = "/http-bind"; -- Serve BOSH at /http-bind
}
http_upload_path = "/data/files";
http_upload_file_size_limit = <HTTP_UPLOAD_FILE_SIZE_LIMIT>; -- bytes
http_upload_expire_after = <HTTP_UPLOAD_EXPIRE_AFTER>; --seconds
http_upload_quota = <HTTP_UPLOAD_QUOTA>; --bytes

data_path = "/data"
allow_registration = true
registration_throttle_max = 5
registration_throttle_period = 86400
c2s_require_encryption = true
authentication = "internal_hashed"
storage = "sql"
sql = {
    driver = "SQLite3";
    database = "data.db";
}

ssl = {
    certificate = "<SSL_CERT>";
    key = "<SSL_KEY>";
    protocol = "tlsv1+"
}

contact_info = {
    admin = { "mailto:<ADMIN_EMAIL>", "xmpp:<ADMIN_XMPP>" };
}

turncredentials_secret = "<TURNCREDENTIALS_SECRET>";
turncredentials_host = "<DOMAIN>";
turncredentials_port = 3478;
turncredentials_ttl = 86400;

-- For advanced logging see http://prosody.im/doc/logging
log = {
    {
        to = "*console", -- Log to the console, useful for debugging with daemonize=false
        levels = { min = "warn" } -- Only match messages with a level of 'warn' or higher
    }
}

Component "conference.<DOMAIN>" "muc"
    modules_enabled = {
        "muc_mam";
    }
    name = "The conference.<DOMAIN> chatrooms server"
    muc_room_default_public = true
    muc_room_default_persistent = false
    muc_room_default_members_only = false
    muc_room_default_moderated = false
    muc_room_default_public_jids = false
    muc_room_default_change_subject = false
    muc_room_default_history_length = 20
    muc_room_default_language = "en"
    muc_tombstones = true
    muc_tombstone_expiry = 86400 * 31
    max_history_messages = 100
    restrict_room_creation = "local"
    muc_log_by_default = true
    muc_log_presences = false
    log_all_rooms = false
    muc_log_expires_after = "1w"
    muc_log_cleanup_interval = 4 * 60 * 60

VirtualHost "<DOMAIN>"
    enabled = true
    http_host = "<DOMAIN>"

plugin_paths = { "/prosody/plugins" }
modules_enabled = {

    -- Modules marked with '*' are not in the default distribution

    -- OMEMO support (https://serverfault.com/questions/835635/what-prosody-modules-do-i-need-to-support-conversations)
    "proxy65"; -- https://prosody.im/doc/modules/mod_proxy65
    "blocklist"; -- https://prosody.im/doc/modules/mod_blocklist
    "carbons"; -- https://prosody.im/doc/modules/mod_carbons
    "cloud_notify"; -- https://modules.prosody.im/mod_cloud_notify.html *
    "smacks"; -- https://modules.prosody.im/mod_smacks.html *
    "mam"; -- https://modules.prosody.im/mod_mam.html
    "csi"; -- https://modules.prosody.im/mod_csi

    -- Csi additions
    "throttle_presence"; -- https://modules.prosody.im/mod_throttle_presence.html *
    "filter_chatstates"; -- https://modules.prosody.im/mod_filter_chatstates.html *

    -- Generally required
    "roster"; -- Allow users to have a roster. Recommended ;)
    "saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
    "tls"; -- Add support for secure TLS on c2s/s2s connections
    "dialback"; -- s2s dialback support
    "disco"; -- Service discovery

    -- Not essential, but recommended
    "private"; -- Private XML storage (for room bookmarks, etc.)

    -- Nice to have
    "version"; -- Replies to server version requests
    "uptime"; -- Report how long server has been running
    "time"; -- Let others know the time here on this server
    "ping"; -- Replies to XMPP pings with pongs
    "pep"; -- Enables users to publish their mood, activity, playing music and more
    -- "register"; -- Allow users to register on this server using a client and change passwords
    "server_contact_info"; -- Allow contact infos to be published
    -- "vcard_muc"; -- https://modules.prosody.im/mod_vcard_muc.html
    "vcard_legacy"; -- https://prosody.im/doc/modules/mod_vcard_legacy

    -- HTTP modules
    "http"; -- https://prosody.im/doc/http
    "http_upload"; -- https://modules.prosody.im/mod_http_upload.html *
    "bosh"; -- Enable BOSH clients, aka "Jabber over HTTP"
    -- "http_files"; -- Serve static files from a directory over HTTP
    "conversejs";

    -- A/V Calls https://gist.github.com/iNPUTmice/a28c438d9bbf3f4a3d4c663ffaa224d9#notes-for-server-admins
    "turncredentials"; -- https://modules.prosody.im/mod_turncredentials.html

    -- Other specific functionality
    -- "groups"; -- Shared roster support
    -- "announce"; -- Send announcement to all online users
    -- "welcome"; -- Welcome users who register accounts
    -- "watchregistrations"; -- Alert admins of registrations
    -- "motd"; -- Send a message to users when they log in
    "log_auth"; -- https://modules.prosody.im/mod_log_auth.html
}

-- These modules are auto-loaded, but should you want
-- to disable them then uncomment them here:
modules_disabled = {
    -- "c2s" -- Handle client connections
    -- "s2s" -- Handle server-to-server connections
    "posix";
}
