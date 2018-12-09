-- Information on configuring Prosody can be found on our
-- website at http://prosody.im/doc/configure

-- do not daemonize for s6
daemonize = false

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
    certificate = "/data/certs/cert.pem";
    key = "/data/certs/key.pem";
    protocol = "tlsv1+"
}

VirtualHost "<DOMAIN>"
    enabled = true
    http_host = "<DOMAIN>"

-- plugin_paths = { "/prosody_modules" }
modules_enabled = {

    -- OMEMO support (https://serverfault.com/questions/835635/what-prosody-modules-do-i-need-to-support-conversations)
    "proxy65"; -- https://prosody.im/doc/modules/mod_proxy65
    "blocklist"; -- https://prosody.im/doc/modules/mod_blocklist
    "cloud_notify"; -- https://modules.prosody.im/mod_cloud_notify.html
    "carbons"; -- https://prosody.im/doc/modules/mod_carbons
    "smacks"; -- https://modules.prosody.im/mod_smacks.html
    "mam"; -- https://modules.prosody.im/mod_mam.html
    "csi"; -- https://modules.prosody.im/mod_csi

    -- csi additions
    "throttle_presence"; -- https://modules.prosody.im/mod_throttle_presence.html
    "filter_chatstates"; -- https://modules.prosody.im/mod_filter_chatstates.html

    -- Generally required
    "roster"; -- Allow users to have a roster. Recommended ;)
    "saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
    "tls"; -- Add support for secure TLS on c2s/s2s connections
    "dialback"; -- s2s dialback support
    "disco"; -- Service discovery

    -- Not essential, but recommended
    "private"; -- Private XML storage (for room bookmarks, etc.)
    "vcard"; -- Allow users to set vCards

    -- Nice to have
    "version"; -- Replies to server version requests
    "uptime"; -- Report how long server has been running
    "time"; -- Let others know the time here on this server
    "ping"; -- Replies to XMPP pings with pongs
    "pep"; -- Enables users to publish their mood, activity, playing music and more
    "register"; -- Allow users to register on this server using a client and change passwords

    -- HTTP modules
    "http"; -- https://prosody.im/doc/http
    "http_upload"; -- https://modules.prosody.im/mod_http_upload.html
    "bosh"; -- Enable BOSH clients, aka "Jabber over HTTP"
    -- "http_files"; -- Serve static files from a directory over HTTP

    -- Other specific functionality
    -- "groups"; -- Shared roster support
    -- "announce"; -- Send announcement to all online users
    -- "welcome"; -- Welcome users who register accounts
    -- "watchregistrations"; -- Alert admins of registrations
    -- "motd"; -- Send a message to users when they log in
}

-- These modules are auto-loaded, but should you want
-- to disable them then uncomment them here:
modules_disabled = {
    -- "c2s" -- Handle client connections
    "s2s" -- Handle server-to-server connections
}

-- For advanced logging see http://prosody.im/doc/logging
log = {
    "*console"; -- Log to the console, useful for debugging with daemonize=false
}
