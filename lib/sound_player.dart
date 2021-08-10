

import 'package:flutter/cupertino.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';

const pathToReadAudio = 'audio_example.mp3';

class SoundPlayer{
  FlutterSoundPlayer? _audioPlayer;

  bool get isPlaying => _audioPlayer!.isPlaying;

  Future init() async{
    _audioPlayer = FlutterSoundPlayer();
    await _audioPlayer!.openAudioSession();
  }

  void dispose(){
    _audioPlayer!.closeAudioSession();
    _audioPlayer = null;
  }

  Future _play(VoidCallback whenFinished) async{
    print(pathToReadAudio.toString());
    await _audioPlayer!.startPlayer(
      fromURI: pathToReadAudio,
      whenFinished: whenFinished,
    );
  }


  Future _stop() async{
    await _audioPlayer!.stopPlayer();
  }

  Future tooglePlaying({required VoidCallback whenFinished}) async{

    if(_audioPlayer!.isStopped){
      await _play(whenFinished);
    }else{
      await _stop();
    }
  }
}