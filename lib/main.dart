import 'package:alarm/alarms.dart';
import 'package:alarm/fab_bottom_app_bar.dart';
import 'package:alarm/inner_shadow.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

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
      bottomNavigationBar: FABBottomAppBar(
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
      ),
      body: WorldClock(),
    );
  }
}

class WorldClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Center(child: ClockWidger()),
            Expanded(
              child: ClocksList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ClocksList extends StatefulWidget {
  int _selectedIndex = 0;
  List<String> cities = ["NEW YORK", "LONDON", "LOS ANGELES", "PARIS"];

  @override
  ClocksListState createState() {
    return ClocksListState();
  }
}

class ClocksListState extends State<ClocksList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.cities.length,
        itemBuilder: (context, index) {
          return ClockListTile(
              text: widget.cities[index],
              index: index,
              selected: widget._selectedIndex);
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
        callback: () {},
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [firstColor, secondColor]),
        shadowColor: Gradients.backToFuture.colors.last.withOpacity(0.25),
      ),
    );
  }
}

class ClockWidger extends StatefulWidget {
  @override
  ClockState createState() {
    return ClockState();
  }
}

class ClockState extends State<ClockWidger> {
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
        datetime: DateTime.now(),
      ),
    ]);
  }
}
