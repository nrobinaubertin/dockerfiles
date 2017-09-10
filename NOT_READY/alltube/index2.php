<?php

ini_set('display_errors', 'On');
error_reporting(E_ALL);

require_once __DIR__.'/vendor/autoload.php';
use Alltube\Config;
use Alltube\Controller\FrontController;
use Alltube\LocaleManager;
use Alltube\LocaleMiddleware;
use Alltube\PlaylistArchiveStream;
use Alltube\UglyRouter;
use Alltube\ViewFactory;
use Slim\App;

if (isset($_SERVER['REQUEST_URI']) && strpos($_SERVER['REQUEST_URI'], '/index.php') !== false) {
    header('Location: '.str_ireplace('/index.php', '/', $_SERVER['REQUEST_URI']));
    die;
}

stream_wrapper_register('playlist', PlaylistArchiveStream::class);

$app = new App();
$configuration = [
    'settings' => [
        'displayErrorDetails' => true,
    ],
];
$container = $app->getContainer($configuration);
$config = Config::getInstance();
if ($config->uglyUrls) {
    $container['router'] = new UglyRouter();
}
$container['view'] = ViewFactory::create($container);
$container['locale'] = new LocaleManager($_COOKIE);
$app->add(new LocaleMiddleware($container));

$controller = new FrontController($container, null, $_COOKIE);

// $container['errorHandler'] = [$controller, 'error'];
// $container['errorHandler'] = function ($container) {
//     return function ($request, $response, $exception) use ($container) {
//         return $container['response']->withStatus(500)
//                              ->withHeader('Content-Type', 'text/html')
//                              ->write('Something went wrong!');
//     };
// };

$app->get(
    '/',
    [$controller, 'index']
)->setName('index');
$app->get(
    '/extractors',
    [$controller, 'extractors']
)->setName('extractors');
$app->any(
    '/video',
    [$controller, 'video']
)->setName('video');
$app->get(
    '/redirect',
    [$controller, 'redirect']
)->setName('redirect');
$app->get(
    '/locale/{locale}',
    [$controller, 'locale']
)->setName('locale');
$app->run();

