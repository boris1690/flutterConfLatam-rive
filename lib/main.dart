import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as flutterImage;
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 197, 2, 15)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'FlutterConfLatam 2024'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Declare artboard and inputs
  Artboard? _artboard;
  SMIBool? _jumpInput;
  SMIBool? _angryInput;
  SMINumber? _redInput;
  SMINumber? _greenInput;
  SMINumber? _blueInput;

  void _jump() {
    setState(() {
      _jumpInput?.value = !_jumpInput!.value;
    });
  }

  void _angry() {
    _angryInput?.value = !_angryInput!.value;
  }

  @override
  void initState() {
    super.initState();

    _loadRive();
  }

  void _loadRive() async {
    // Load rive file
    final file = await RiveFile.asset('assets/rive/dash.riv');

    final artboard = file.artboardByName('Dash')!.instance();

    final controller =
        StateMachineController.fromArtboard(artboard, 'Dash State');

    if (controller != null) {
      _jumpInput = controller.getBoolInput('jump');
      _angryInput = controller.getBoolInput('angry');
      _redInput = controller.getNumberInput('red');
      _blueInput = controller.getNumberInput('blue');
      _greenInput = controller.getNumberInput('green');

      artboard.addController(controller);
    }

    setState(() {
      _artboard = artboard;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: const Color(0xFFDB414B),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                flutterImage.Image.asset(
                  'assets/images/background.jpg',
                ),
                if (_artboard != null)
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 350,
                      child: Rive(
                        artboard: _artboard!,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor:
                      _jumpInput?.value == true ? Colors.green : null,
                  onPressed: _jump,
                  tooltip: 'Jump',
                  child: const Icon(Icons.arrow_circle_up),
                ),
                const SizedBox(
                  width: 50,
                ),
                FloatingActionButton(
                  onPressed: _angry,
                  tooltip: 'Angry',
                  child: const Icon(Icons.error_outline),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text(
                'Red',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Slider(
              activeColor: Colors.red,
              value: _redInput?.value ?? 0,
              min: 0,
              max: 255,
              onChanged: (value) {
                setState(() {
                  _redInput?.value = value;
                });
              },
            ),
            const Center(
              child: Text(
                'Blue',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Slider(
              activeColor: Colors.blue,
              value: _blueInput?.value ?? 0,
              min: 0,
              max: 255,
              onChanged: (value) {
                setState(() {
                  _blueInput?.value = value;
                });
              },
            ),
            const Center(
              child: Text(
                'Green',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Slider(
              activeColor: Colors.green,
              value: _greenInput?.value ?? 0,
              max: 255,
              min: 0,
              onChanged: (value) {
                setState(() {
                  _greenInput?.value = value;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
