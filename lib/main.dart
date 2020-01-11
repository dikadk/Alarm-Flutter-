import 'dart:collection';

import 'package:alarm/alarms.dart';
import 'package:alarm/clocks_model.dart';
import 'package:alarm/fab_bottom_app_bar.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';
import 'package:timezone/standalone.dart';

void main() => runApp(MyApp());

const Color backgroundColor = Color.fromARGB(255, 241, 245, 254);
const Color purpleColor = Color.fromARGB(255, 66, 36, 70);
const Color goldColor = Color.fromARGB(255, 255, 202, 95);
const Color blueColor = Color.fromARGB(255, 224, 232, 253);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          backgroundColor: backgroundColor,
          appBarTheme: AppBarTheme(
              elevation: 0,
              color: backgroundColor,
              brightness: Brightness.light)),
      initialRoute: "/",
      routes: {
        '/': (context) => HomePage(),
        '/alarms': (context) => Alarms(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 100),
          child: Center(
            child: Text(
              "World Clock",
              style: TextStyle(fontWeight: FontWeight.bold, color: purpleColor),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 24,
        ),
        onPressed: () {},
        backgroundColor: Colors.redAccent,
        elevation: 2.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(),
      body: WorldClock(),
    );
  }
}

class BottomAppBar extends StatelessWidget {
  const BottomAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FABBottomAppBar(
      selectedColor: goldColor,
      color: Colors.white,
      iconSize: 32,
      notchedShape: CircularNotchedRectangle(),
      notchedMargin: 8,
      backgroundColor: purpleColor,
      onTabSelected: (index) {
        var routeName;
        switch (index) {
          case 0:
            routeName = "/";
            break;
          case 1:
            routeName = "/alarms";
            break;
          case 2:
            routeName = "/bed";
            break;
          case 2:
            routeName = "/timer";
            break;
          default:
        }
        Navigator.pushNamed(context, routeName);
      },
      items: [
        FABBottomAppBarItem(iconData: Icons.watch_later),
        FABBottomAppBarItem(iconData: Icons.alarm),
        FABBottomAppBarItem(iconData: Icons.brightness_4),
        FABBottomAppBarItem(iconData: Icons.timer),
      ],
    );
  }
}

class WorldClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClocksModel>(
      create: (_) => ClocksModel(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(44),
                child: Text(
                  "04:45 AM",
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: purpleColor),
                ),
              ),
              Center(
                child: Consumer<ClocksModel>(
                  builder: (context, clocks, child) {
                    return ClockWidget(clocks.items[clocks.selectedItem]);
                  },
                ),
              ),
              Expanded(
                child: Consumer<ClocksModel>(
                  builder: (context, clocks, child) {
                    return ClocksList(clocks.items, clocks.selectedItem);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClocksList extends StatelessWidget {
  final UnmodifiableListView<CityTimeItem> _items;
  final int _selectedItem;

  ClocksList(this._items, this._selectedItem);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ClockListTile(
              text: _items[index].name, index: index, selected: _selectedItem);
        });
  }
}

class ClockListTile extends StatelessWidget {
  const ClockListTile({
    Key key,
    @required this.text,
    @required this.index,
    @required this.selected,
  }) : super(key: key);

  final String text;
  final int index;
  final int selected;

  @override
  Widget build(BuildContext context) {
    final Color firstColor = index == selected
        ? goldColor.withOpacity(0.3)
        : blueColor.withOpacity(0.3);
    final Color secondColor = index == selected ? goldColor : blueColor;
    return Padding(
      padding: EdgeInsets.all(10),
      child: GradientButton(
        textStyle: TextStyle(color: purpleColor, fontWeight: FontWeight.bold),
        increaseHeightBy: 20,
        increaseWidthBy: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(width: 2, color: Colors.white)),
        child: Text(text),
        callback: () {
          Provider.of<ClocksModel>(context, listen: false).setSelection(index);
        },
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [firstColor, secondColor]),
        shadowColor: Gradients.backToFuture.colors.last.withOpacity(0.25),
      ),
    );
  }
}

class ClockWidget extends StatefulWidget {
  final CityTimeItem _item;

  ClockWidget(this._item);

  @override
  ClockState createState() {
    return ClockState();
  }
}

class ClockState extends State<ClockWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.center, children: [
      Container(
        height: 330,
        width: 330,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
            border: Border.all(
              color: blueColor,
              width: 42,
            ),
            boxShadow: [
              BoxShadow(
                  color: blueColor,
                  blurRadius: 25.0,
                  offset: Offset(2.0, 2.0),
                  spreadRadius: 8)
            ]),
      ),
      Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                  color: blueColor,
                  blurRadius: 12.0,
                  offset: Offset(2.0, 2.0),
                  spreadRadius: 0.1)
            ]),
      ),
      AnalogClock(
        height: 320,
        isLive: true,
        hourHandColor: goldColor,
        minuteHandColor: purpleColor,
        secondHandColor: Colors.redAccent,
        showSecondHand: true,
        showNumbers: false,
        textScaleFactor: 1.4,
        showTicks: true,
        showDigitalClock: false,
        datetime: provideZonedDateTime(widget._item.name),
      ),
    ]);
  }

  //Add async stuff
  DateTime provideZonedDateTime(String locationName) {
    final localTime = DateTime.now();
    return TZDateTime.from(localTime, getLocation(locationName));
  }
}
