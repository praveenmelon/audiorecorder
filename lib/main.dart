import 'dart:io';

import 'package:audiorecorder/sound_player.dart';
import 'package:audiorecorder/sound_recorder.dart';
import 'package:audiorecorder/timer_widget.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final recorder = SoundRecorder();
  late Directory appDirectory;
  final player = SoundPlayer();
  List<String> records = [];
  List<File> fileRecords = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recorder.init();
    player.init();
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;

      appDirectory.list().listen((onData) {
        if (onData.path.contains('.mp3')) records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();

        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    player.dispose();
    super.dispose();
    recorder.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          buildStart(),
          buildPlay(),
          ElevatedButton(
              onPressed: () async {
                await getApplicationDocumentsDirectory().then((value) {
                  appDirectory = value;
                  print(appDirectory);
                  appDirectory.list().listen((onData) {
                    print(onData.toString());
                    if (onData.path.contains('.mp3')) {
                      records.add(onData.path);
                    } else {
                      print('no');
                    }
                  }).onDone(() {
                    print(records);
                    records = records.reversed.toList();
                    setState(() {});
                  });
                });

                File aud = File(records[0]);
                print('------${aud.path.toString()}');
              },
              child: Text(records.isNotEmpty ? records[0].toString() : '-'))
        ],
      ),
    );
  }

  Widget buildStart() {
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? 'STOP' : 'START';
    final primary = isRecording ? Colors.red : Colors.white;
    final onPrimary = isRecording ? Colors.white : Colors.black;

    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            maximumSize: Size(175, 50), primary: primary, onPrimary: onPrimary),
        onPressed: () async {
          await recorder.toogleRecording();
          setState(() {});
        },
        icon: Icon(icon),
        label: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ));
  }

  Widget buildPlay() {
    final isPlaying = player.isPlaying;
    final icon = isPlaying ? Icons.stop : Icons.play_arrow;
    final text = isPlaying ? 'STOP PLAY' : 'START PLAY';

    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            maximumSize: Size(175, 50),
            primary: Colors.white,
            onPrimary: Colors.black),
        onPressed: () async {
          await player.tooglePlaying(whenFinished: () => setState(() {}));
          setState(() {});
        },
        icon: Icon(icon),
        label: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ));
  }

  Widget buildPlayer() {
    final text = recorder.isRecording ? 'Now Recording' : 'Press Start';
    final animate = recorder.isRecording;

    return AvatarGlow(
      child: CircleAvatar(
        radius: 100,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 92,
          backgroundColor: Colors.indigo.shade900.withBlue(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.mic,
                size: 32,
              ),
              SizedBox(
                height: 8,
              ),
              Text(text),
            ],
          ),
        ),
      ),
      endRadius: 140,
      animate: animate,
      repeatPauseDuration: Duration(milliseconds: 100),
    );
  }
}
