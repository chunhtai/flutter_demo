import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: <String, WidgetBuilder>{
        '/': (_) => MyHomePage(),
        '/tab': (_) => MyTabPage(),
      }
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
            onPressed: () => Navigator.pushNamed(context, '/tab'),
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