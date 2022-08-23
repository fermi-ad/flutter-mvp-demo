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

class PlotWidget extends StatelessWidget {
  const PlotWidget({Key? key, required this.state}) : super(key: key);

  final RootState state;

  @override
  Widget build(BuildContext context) {
    var label = 'Plotting ${state._device}';

    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label),
        TextButton(
          child: const Text('Stop Plot'),
          onPressed: () {
            state.clearDevice();
          },
        )
      ],
    ));
  }
}

class QueryWidget extends StatelessWidget {
  const QueryWidget({Key? key, required this.state}) : super(key: key);

  final RootState state;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('Device to plot:'),
        Expanded(child: TextField(
          onSubmitted: (String name) {
            state.setDevice(name);
          },
        ))
      ],
    ));
  }
}
