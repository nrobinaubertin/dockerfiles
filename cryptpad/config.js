module.exports = {

    httpAddress: '::',

    httpHeaders: {
        "X-XSS-Protection": "1; mode=block",
        "X-Content-Type-Options": "nosniff",
    },

    contentSecurity: [
        "default-src 'none'",
        "style-src 'unsafe-inline' 'self'",
        "script-src 'self'",
        "font-src 'self' data:",
        "child-src 'self' blob: *",
        "media-src * blob:",
        "connect-src 'self' ws: wss: blob:",
        "img-src 'self' data: blob:",
        "frame-ancestors 'self' accounts.cryptpad.fr",
    ].join('; '),

    padContentSecurity: [
        "default-src 'none'",
        "style-src 'unsafe-inline' 'self'",
        "script-src 'self' 'unsafe-eval' 'unsafe-inline'",
        "font-src 'self'",
        "child-src 'self' *",
        "connect-src 'self' ws: wss:",
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
    ],

    removeDonateButton: true,
    allowSubscriptions: false,
    myDomain: 'i.did.not.read.my.config.myserver.tld',
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
    enableUploads: false,
    maxUploadSize: 20 * 1024 * 1024,
};
