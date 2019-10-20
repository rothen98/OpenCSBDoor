import 'package:flutter/material.dart';
import 'package:open_csb_door/util/constants.dart';
import '../../models/door.dart';
import 'widgets/settings.dart';
import '../../services/webservice.dart';
import 'package:logger/logger.dart' as Logger;
import 'widgets/wide_button.dart';
final logger = Logger.Logger();
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _fetchingData = false;
  List<Door> _doors = new List();


  void _setFetchingData(bool status) {
    setState(() {
      _fetchingData = status;
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

  

  Widget _buildItemsForListView(BuildContext context, int index) {
    return Center(
        child: Container(
            height:100,
            //width: 400,
            padding: EdgeInsets.only(top: 10),
            child:
            WideButton(door: _doors[index], backgroundColor:Theme.of(context).colorScheme.surface)
               ));
  }

  @override
  Widget build(BuildContext context) {
    

   
      Widget widgetToShow = Container(
          child: CustomScrollView(
        slivers: <Widget>[
          ///First sliver is the App Bar
          SliverAppBar(

              ///Properties of app bar

              //backgroundColor: Colors.white,
              backgroundColor: Theme.of(context).colorScheme.background,
              floating: false,
              pinned: false,
              expandedHeight: 70.0,
              title: Text("Open The Door", textAlign: TextAlign.center,
              style:Theme.of(context).textTheme.headline.copyWith( color:Theme.of(context).colorScheme.onBackground)),
              centerTitle: true,
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
                    background: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background
                ),
              ), );
              }),
              actions: <Widget>[
                IconButton(
                  iconSize: 40,
                  icon: Icon(Icons.settings, color:Theme.of(context).colorScheme.onBackground ),
                  tooltip: 'Settings',
                  onPressed: (){Navigator.pushNamed(context, Constants.SETTINGS_ROUTE);},//this._toggleSettings,
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
              Container(padding:EdgeInsets.only(top:20,bottom:20),color:Theme.of(context).colorScheme.primaryVariant, child: Text("This app was made by Tobias Lindroth",
              textAlign:TextAlign.center, style:TextStyle(color: Theme.of(context).colorScheme.onPrimary)),),
              
            ],
          )),
        ],
      ));

      
    
    

    return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Center(
            child:  widgetToShow),
          
          // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}