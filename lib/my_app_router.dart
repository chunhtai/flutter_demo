import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  MyRouterDelegate _delegate = MyRouterDelegate();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routeInformationParser: MyRouteInformationParser(),
      routerDelegate: _delegate,
    );
  }
}

// {
//   '/': (_) => MyHomePage(),
//   '/tab': (_) => MyTabPage(),
// }
enum MyConfiguration{home, tab}






class MyRouteInformationParser extends RouteInformationParser<MyConfiguration> {
  @override
  Future<MyConfiguration> parseRouteInformation(RouteInformation routeInformation) async {
    final String routeName = routeInformation.location;
    if (routeName == '/')
      return MyConfiguration.home;
    else if (routeName == '/tab')
      return MyConfiguration.tab;
    throw 'unknown';
  }

  @override
  RouteInformation restoreRouteInformation(MyConfiguration configuration) {
    switch(configuration) {
      case MyConfiguration.home:
        return const RouteInformation(location: '/');
      case MyConfiguration.tab:
        return const RouteInformation(location: '/tab');
    }
    throw 'unknown';
  }
}









class MyRouterDelegate extends RouterDelegate<MyConfiguration> with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyConfiguration>{
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  MyConfiguration get configuration => _configuration;
  MyConfiguration _configuration;
  set configuration(MyConfiguration value) {
    if (_configuration == value)
      return;
    _configuration = value;
    notifyListeners();
  }


  @override
  Future<void> setNewRoutePath(MyConfiguration configuration) async {
    _configuration = configuration;
  }

  // For web application
  @override
  MyConfiguration get currentConfiguration => configuration;

  bool _handlePopPage(Route<dynamic> route, dynamic result) {
    final bool success = route.didPop(result);
    if (success) {
      _configuration = MyConfiguration.home;
      notifyListeners();
    }
    return success;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: <Page<void>>[
        MaterialPage(key: ValueKey('home'), child: MyHomePage()),
        if (configuration == MyConfiguration.tab)
          MaterialPage(key: ValueKey('tab'), child: MyTabPage()),
      ],
      onPopPage: _handlePopPage,
    );
  }
}










class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('home')),
      body: Center(child: Column(
        children: <Widget>[
          MaterialButton(
            child: Text('open tab'),
            onPressed: () {
              (Router.of(context).routerDelegate as MyRouterDelegate).configuration = MyConfiguration.tab;
            },
          )
        ],
      )),
    );
  }
}



class MyTabPage extends StatefulWidget {
  @override
  MyTabPageState createState() => MyTabPageState();
}

class MyTabPageState extends State<MyTabPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.directions_car)),
            Tab(icon: Icon(Icons.directions_transit)),
          ],
        ),
        title: Text('Tab'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Icon(Icons.directions_car),
          Icon(Icons.directions_transit),
        ],
      ),
    );
  }
}