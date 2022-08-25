import "dart:async";
import "dart:math";

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controls App Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RootWidget(title: 'Controls App Demo'),
    );
  }
}

class RootWidget extends StatefulWidget {
  const RootWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<RootWidget> createState() => RootState();
}

class RootState extends State<RootWidget> {
  String? _device;

  void setDevice(String name) {
    setState(() {
      _device = name;
    });
  }

  void clearDevice() {
    setState(() {
      _device = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var core =
        _device != null ? PlotWidget(state: this) : QueryWidget(state: this);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: core);
  }
}

class PlotWidget extends StatefulWidget {
  const PlotWidget({Key? key, required this.state}) : super(key: key);

  final RootState state;

  @override
  _ChartState createState() => _ChartState(state);
}

class _ChartState extends State<PlotWidget> {
  _ChartState(this.state);

  final RootState state;

  final pointLimit = 40;
  final points = <FlSpot>[const FlSpot(0.0, 70.0)];

  double xValue = 0.0;
  double yValue = 70.0;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        xValue = xValue + 1.0;
        yValue += (10.0 * Random().nextDouble()).floorToDouble() / 10.0 - 0.5;
        points.add(FlSpot(xValue, yValue));
        if (points.length > pointLimit) {
          points.removeAt(0);
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var label = 'Plotting ${state._device}';
    var yBase = ((points.last.y + 2.5) / 5.0).floorToDouble() * 5.0;

    return points.isNotEmpty
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(label,
                      style: Theme.of(context).textTheme.headline6)),
              SizedBox(
                  width: 640,
                  height: 480.0,
                  child: LineChart(LineChartData(
                      minY: yBase - 10.0,
                      maxY: yBase + 10.0,
                      minX: points.last.x - pointLimit + 1,
                      maxX: points.last.x,
                      clipData: FlClipData.all(),
                      lineBarsData: [LineChartBarData(spots: points)]))),
              ElevatedButton(
                child: const Text('Stop Plot'),
                onPressed: () {
                  state.clearDevice();
                },
              )
            ],
          ))
        : Container();
  }
}

class QueryWidget extends StatelessWidget {
  const QueryWidget({Key? key, required this.state}) : super(key: key);

  final RootState state;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              decoration: const InputDecoration(
                  labelText: 'Device Name*', border: OutlineInputBorder()),
              onSubmitted: (String name) {
                if (name.isNotEmpty) {
                  state.setDevice(name.toUpperCase());
                }
              },
            )));
  }
}
