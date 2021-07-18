// cf: https://raw.githubusercontent.com/xwiki-labs/cryptpad/master/config/config.example.js
var domain = ' <DOMAIN>';

// Content-Security-Policy
var baseCSP = [
  "default-src 'none'",
  "style-src 'unsafe-inline' 'self'" + domain,
  "font-src 'self' data:" + domain,

  /*  child-src is used to restrict iframes to a set of allowed domains.
   *  connect-src is used to restrict what domains can connect to the websocket.
   *
   *  it is recommended that you configure these fields to match the
   *  domain which will serve your CryptPad instance.
   */
  "child-src blob: *",
  // IE/Edge
  "frame-src blob: *",

  /*  this allows connections over secure or insecure websockets
      if you are deploying to production, you'll probably want to remove
      the ws://* directive, and change '*' to your domain
  */
  "connect-src 'self' ws: wss: blob:" + domain,

  // data: is used by codemirror
  "img-src 'self' data: blob:" + domain,
  "media-src * blob:",

  // for accounts.cryptpad.fr authentication and cross-domain iframe sandbox
  "frame-ancestors *",
  ""
];

module.exports = {

  httpAddress: '::',

  httpHeaders: {
    "X-XSS-Protection": "1; mode=block",
    "X-Content-Type-Options": "nosniff",
    "Access-Control-Allow-Origin": "*"
  },

  contentSecurity: baseCSP.join('; ') + "script-src 'self'" + domain,

  padContentSecurity: baseCSP.join('; ') + "script-src 'self' 'unsafe-eval' 'unsafe-inline'" + domain,

  httpPort: 3000,
  httpUnsafeOrigin: domain.trim(),
  httpSafeOrigin: domain.trim(),
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
    'what-is-cryptpad',
    'features',
    'faq',
    'maintenance'
  ],

  removeDonateButton: true,
  allowSubscriptions: false,
  myDomain: domain.trim(),
  defaultStorageLimit: 50 * 1024 * 1024, // 50MB
  adminEmail: false,
  channelExpirationMs: 30000,
  openFileLimit: 2048,
  rpc: './rpc.js',
  suppressRPCErrors: false,
  enableUploads: true,
  restrictUploads: false,

  /* =====================
   *        STORAGE
   * ===================== */

  /*  By default the CryptPad server will run scheduled tasks every five minutes
   *  If you want to run scheduled tasks in a separate process (like a crontab)
   *  you can disable this behaviour by setting the following value to true
   */
  disableIntegratedTasks: false,

  /*  Pads that are not 'pinned' by any registered user can be set to expire
   *  after a configurable number of days of inactivity (default 90 days).
   *  The value can be changed or set to false to remove expiration.
   *  Expired pads can then be removed using a cron job calling the
   *  `delete-inactive.js` script with node
   */
  inactiveTime: 90, // days

  /*  CryptPad can be configured to remove inactive data which has not been pinned.
   *  Deletion of data is always risky and as an operator you have the choice to
   *  archive data instead of deleting it outright. Set this value to true if
   *  you want your server to archive files and false if you want to keep using
   *  the old behaviour of simply removing files.
   *
   *  WARNING: this is not implemented universally, so at the moment this will
   *  only apply to the removal of 'channels' due to inactivity.
   */
  retainData: true,

  /*  As described above, CryptPad offers the ability to archive some data
   *  instead of deleting it outright. This archived data still takes up space
   *  and so you'll probably still want to remove these files after a brief period.
   *  The intent with this feature is to provide a safety net in case of accidental
   *  deletion. Set this value to the number of days you'd like to retain
   *  archived data before it's removed permanently.
   *
   *  If 'retainData' is set to false, there will never be any archived data
   *  to remove.
   */
  archiveRetentionTime: 15,

  /*  Max Upload Size (bytes)
   *  this sets the maximum size of any one file uploaded to the server.
   *  anything larger than this size will be rejected
   */
  maxUploadSize: 20 * 1024 * 1024,

  /* =====================
   *   DATABASE VOLUMES
   * ===================== */

  /*
   *  CryptPad stores each document in an individual file on your hard drive.
   *  Specify a directory where files should be stored.
   *  It will be created automatically if it does not already exist.
   */
  filePath: './datastore/',

  /*  CryptPad offers the ability to archive data for a configurable period
   *  before deleting it, allowing a means of recovering data in the event
   *  that it was deleted accidentally.
   *
   *  To set the location of this archive directory to a custom value, change
   *  the path below:
   */
  archivePath: './data/archive',

  /*  CryptPad allows logged in users to request that particular documents be
   *  stored by the server indefinitely. This is called 'pinning'.
   *  Pin requests are stored in a pin-store. The location of this store is
   *  defined here.
   */
  pinPath: './data/pins',

  /*  if you would like the list of scheduled tasks to be stored in
      a custom location, change the path below:
      */
  taskPath: './data/tasks',

  /*  if you would like users' authenticated blocks to be stored in
      a custom location, change the path below:
      */
  blockPath: './block',

  /*  CryptPad allows logged in users to upload encrypted files. Files/blobs
   *  are stored in a 'blob-store'. Set its location here.
   */
  blobPath: './datastore/blob',

  /*  CryptPad stores incomplete blobs in a 'staging' area until they are
   *  fully uploaded. Set its location here.
   */
  blobStagingPath: './data/blobstage',

  /* CryptPad supports logging events directly to the disk in a 'logs' directory
   * Set its location here, or set it to false (or nothing) if you'd rather not log
   */
  logPath: './data/logs',
};
