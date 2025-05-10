import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const HappyBirthday());
}

class HappyBirthday extends StatelessWidget {
  const HappyBirthday({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Confetti()
    );
  }
}


class Confetti extends StatefulWidget {
  @override
  _ConfettiState createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> {
  late ConfettiController _controller;
  final player = audioplayers.AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: Duration(seconds: 27));
    player.onPlayerComplete.listen((_) {
      _controller.stop();
      setState(() {
        _isPlaying = false;
      });
    });
  }


  void _showConfetti() {
    if (!_isPlaying) {
      setState(() {
        _isPlaying = true;
      });
      player.play(AssetSource('audio/birthday_by_orchestra.mp3'));
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0c1540),
      appBar: AppBar(
        title: const Text(
          'Happy Birthday',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0c1540),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/Happy_Birthday.jpg'),
              const SizedBox(height: 20), // Add spacing
              ElevatedButton(
                onPressed: _isPlaying ? null : _showConfetti,
                child: const Text('Celebrate!'),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: _isPlaying,
              emissionFrequency: 0.02,
              numberOfParticles: 100,
              gravity: 0.1,
              minBlastForce: 5,
              maxBlastForce: 20,
              colors: const [
                Color(0xFF39bce9),
                Colors.deepPurpleAccent,
                Colors.blue,
                Colors.white,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
