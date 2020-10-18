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
enum MyRoute{home, tab}
class MyConfiguration{
  const MyConfiguration(this.myRoute, this.tab);
  final MyRoute myRoute;
  final int tab;
}

class MyRouteInformationParser extends RouteInformationParser<MyConfiguration> {
  @override
  Future<MyConfiguration> parseRouteInformation(RouteInformation routeInformation) async {
    final String routeName = routeInformation.location;
    if (routeName == '/')
      return MyConfiguration(MyRoute.home, routeInformation.state);
    else if (routeName == '/tab')
      return MyConfiguration(MyRoute.tab, routeInformation.state);
    throw 'unknown';
  }

  @override
  RouteInformation restoreRouteInformation(MyConfiguration configuration) {
    switch(configuration.myRoute) {
      case MyRoute.home:
        return RouteInformation(location: '/', state: configuration.tab);
      case MyRoute.tab:
        return RouteInformation(location: '/tab', state: configuration.tab);
    }
    throw 'unknown';
  }
}

class MyRouterDelegate extends RouterDelegate<MyConfiguration> with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyConfiguration>{
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  MyRoute get myRoute => _myRoute;
  MyRoute _myRoute;
  set myRoute(MyRoute value) {
    if (_myRoute == value)
      return;
    _myRoute = value;
    notifyListeners();
  }

  int get tab => _tab;
  int _tab = 0;
  set tab(int value) {
    if (_tab == value)
      return;
    _tab = value;
    notifyListeners();
  }


  @override
  Future<void> setNewRoutePath(MyConfiguration configuration) async {
    _myRoute = configuration.myRoute;
    _tab = configuration.tab ?? 0;
  }

  // For web application
  @override
  MyConfiguration get currentConfiguration => MyConfiguration(myRoute, tab);

  bool _handlePopPage(Route<dynamic> route, dynamic result) {
    final bool success = route.didPop(result);
    if (success) {
      _myRoute = MyRoute.home;
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
        if (_myRoute == MyRoute.tab)
          MaterialPage(key: ValueKey('tab'), child: MyTabPage(_tab)),
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
              (Router.of(context).routerDelegate as MyRouterDelegate).myRoute = MyRoute.tab;
            },
          )
        ],
      )),
    );
  }
}



class MyTabPage extends StatefulWidget {
  MyTabPage(this.tab): super();
  final int tab;
  @override
  MyTabPageState createState() => MyTabPageState();
}

class MyTabPageState extends State<MyTabPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: widget.tab, length: 2, vsync: this)..addListener(_onTabIndexChange);
  }
  @override
  void didUpdateWidget(MyTabPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _tabController.index = widget.tab;
  }

  void _onTabIndexChange(){
    if (_tabController.indexIsChanging)
      return;
    final MyRouterDelegate state = Router.of(context).routerDelegate as MyRouterDelegate;
    if (state.tab == _tabController.index)
      return;
    Router.navigate(context, () {
      state.tab = _tabController.index;
    });
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