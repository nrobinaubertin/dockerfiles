var domain = ' <DOMAIN>';
module.exports = {

    httpAddress: '::',

    httpHeaders: {
        "X-XSS-Protection": "1; mode=block",
        "X-Content-Type-Options": "nosniff",
    },

    contentSecurity: [
        "default-src 'none'",
        "style-src 'unsafe-inline' 'self'" + domain,
        "script-src 'self'" + domain,
        "font-src 'self' data:" + domain,
        "child-src 'self' blob: *",
        "media-src * blob:",
        "connect-src 'self' ws: wss: blob:" + domain,
        "img-src 'self' data: blob:",
        "frame-ancestors 'self' accounts.cryptpad.fr",
    ].join('; '),

    padContentSecurity: [
        "default-src 'none'",
        "style-src 'unsafe-inline' 'self'" + domain,
        "script-src 'self' 'unsafe-eval' 'unsafe-inline'" + domain,
        "font-src 'self'" + domain,
        "child-src 'self' *",
        "connect-src 'self' ws: wss:" + domain,
        "img-src * blob:",
    ].join('; '),

    httpPort: 3000,
    websocketPath: '/cryptpad_websocket',
    websocketPort: 3000,
    useSecureWebsockets: false,
    logToStdout: false,
    verbose: false,

    mainPages: [
        'index',
        'privacy',
        'terms',
        'about',
        'contact',
        'what-is-cryptpad'
    ],

    removeDonateButton: true,
    allowSubscriptions: false,
    myDomain: domain,
    defaultStorageLimit: 50 * 1024 * 1024, // 50MB
    adminEmail: false,
    storage: './storage/file',
    filePath: './datastore/',
    pinPath: './pins',
    blobPath: './blob',
    blobStagingPath: './blobstage',
    channelExpirationMs: 30000,
    openFileLimit: 2048,
    rpc: './rpc.js',
    suppressRPCErrors: false,
    enableUploads: true,
    restrictUploads: false,
    maxUploadSize: 20 * 1024 * 1024,
};
