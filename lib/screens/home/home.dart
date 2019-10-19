import 'package:flutter/material.dart';
import '../../models/door.dart';
import 'widgets/settings.dart';
import '../../services/webservice.dart';
import 'package:logger/logger.dart' as Logger;
import 'widgets/wide_button.dart';
final logger = Logger.Logger();
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _fetchingData = false;
  List<Door> _doors = new List();
  bool _showingSettings = false;

  void _setFetchingData(bool status) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _fetchingData = status;
    });
  }

  _toggleSettings() {
    setState(() {
      _showingSettings = !_showingSettings;
    });
  }

  @override
  void initState() {
    _fetchingData = true;
    _populateDoors();
    super.initState();
  }

  void _populateDoors() async {
    //todo implment with webservice
    Webservice().load(Door.all).then((doors){
      setState(() {
        _fetchingData = false;
        _doors = doors;
      });
    }).catchError((err){
      setState(() {
        _fetchingData = false;
       
      });
      logger.i("Error fetching doors");
    });
    
  }

  Future<bool> _onWillPop() async {
    if (_showingSettings) {
      _toggleSettings();
      return false;
    } else {
      return true;
    }
  }

  Widget _buildItemsForListView(BuildContext context, int index) {
    return Center(
        child: Container(
            height:100,
            //width: 400,
            padding: EdgeInsets.only(top: 10),
            child:
            WideButton(door: _doors[index], backgroundColor:Colors.white)
               ));
  }

  @override
  Widget build(BuildContext context) {
    Widget openOrSettings;

    if (!this._showingSettings) {
      Widget widgetToShow = Container(
          child: CustomScrollView(
        slivers: <Widget>[
          ///First sliver is the App Bar
          SliverAppBar(

              ///Properties of app bar

              //backgroundColor: Colors.white,

              floating: false,
              pinned: false,
              expandedHeight: 100.0,

              ///Properties of the App Bar when it is expanded
              flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                // print('constraints=' + constraints.toString());
                
                return FlexibleSpaceBar(
                    centerTitle: true,
                    title: AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      //opacity: top == 80.0 ? 1.0 : 0.0,
                      opacity: 1.0,
                    ),
                    background: Image.asset(
                      'images/bannernewtwo.png',
                      fit: BoxFit.contain,
                    ));
              }),
              actions: <Widget>[
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.settings),
                  tooltip: 'Settings',
                  onPressed: this._toggleSettings,
                ),
              ]),
              
          SliverPadding(
              padding: EdgeInsets.only(top:8, left:5,right:5,bottom:8),
              sliver: SliverList(
                
                

                ///Lazy building of list
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _buildItemsForListView(context, index);
                  },

                  /// Set childCount to limit no.of items
                  childCount: _doors.length,
                ),
              )),
              SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(padding:EdgeInsets.only(top:20,bottom:20),color:Colors.blue[400], child: Text("This app was made by Tobias Lindroth",
              textAlign:TextAlign.center, style:TextStyle(color: Colors.white)),),
              
            ],
          )),
        ],
      ));

      openOrSettings = widgetToShow;
    } else {
      openOrSettings = SingleChildScrollView(child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Settings(),
            SizedBox(height: 40),
            Container(
                height: 80.0,
                width: 80.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).accentColor),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: this._toggleSettings,
                ))
          ]));
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Center(
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Interval(
                  0.5,
                  1,
                  curve: Curves.easeIn,
                ),
                switchOutCurve: Interval(
                  0.5,
                  1,
                  curve: Curves.linear,
                ),
                child: openOrSettings),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}