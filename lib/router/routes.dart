import 'package:diary/ui/app_configuration/app_configuration.dart';
import 'package:diary/ui/default/default_page.dart';
import 'package:diary/ui/index/index.dart';
import 'package:diary/ui/write_new/write_new.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

// 路由出错的默认页面
Handler errorHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) => const DefaultPage(),
);

// 程序参数配置页面
Handler appConfigurationHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) => const AppConfigurationPage(),
);

// 主页面
Handler indexHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) => const IndexPage(),
);

//写日记
var writeDiaryHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        if (params.isNotEmpty && params['id'] != null) {
            return WriteNewPage(id: params['id']![0]);
        } else {
            return const WriteNewPage(id: "-1");
        }
    });

// 路由
class Routes {

    static String indexPage = "/";

    static String errorPage = '/error';

    static String writeDiaryPage = '/writeDiary';

    static String appConfigurationPage = '/appConfiguration';

    static void configureRoutes(FluroRouter router) {
        router.define(errorPage, handler: errorHandler);
        router.define(appConfigurationPage, handler: appConfigurationHandler);
        router.define(indexPage, handler: indexHandler);
        router.define('$writeDiaryPage/:id', handler: writeDiaryHandler);
        router.notFoundHandler = errorHandler;
    }

}