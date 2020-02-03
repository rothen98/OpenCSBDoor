import 'package:flutter/material.dart';
import 'package:open_csb_door/util/constants.dart';
import '../../models/door.dart';
import '../../services/webservice.dart';
import 'package:logger/logger.dart' as Logger;
import 'widgets/door_button.dart';

final logger = Logger.Logger();

class HomePage extends StatelessWidget{
  Future<List<Door>> _getDoors() {
    return Webservice().load(Door.all);
  }


  Widget createDoorWidget(BuildContext context, Door d) {
    return Center(
        child: Container(
            height: 100,
            //width: 400,
            padding: EdgeInsets.only(top: 10),
            child: DoorButton(
                door: d,
                backgroundColor: Theme.of(context).colorScheme.surface)));
  }

 

  Widget _buildNormalView(BuildContext context, List<Door> doors) {
    return Container(
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
            title: Text("Open The Door",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
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
                      color: Theme.of(context).colorScheme.background),
                ),
              );
            }),
            actions: <Widget>[
              IconButton(
                iconSize: 40,
                icon: Icon(Icons.settings,
                    color: Theme.of(context).colorScheme.onBackground),
                tooltip: 'Settings',
                onPressed: () {
                  Navigator.pushNamed(context, Constants.SETTINGS_ROUTE);
                }, //this._toggleSettings,
              ),
            ]),

        SliverPadding(
          padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 8),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
                doors.map((d) => createDoorWidget(context, d)).toList()),
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
          child: FutureBuilder<List<Door>>(
              future: _getDoors(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Could not fetch the doors :(");
                } else if (snapshot.hasData) {
                  return _buildNormalView(context, snapshot.data);
                } else {
                  return Text("Loading");
                }
              })),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
