import 'package:flutter/material.dart'; // Flutter UI framework
import 'package:confetti/confetti.dart'; // For confetti animation
import 'package:audioplayers/audioplayers.dart'; // For using AudioPlayer directly

void main() {
  runApp(const HappyBirthday());
}

class HappyBirthday extends StatelessWidget {
  const HappyBirthday({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Confetti(),
    );
  }
}

// Confetti widget is stateful because it involves animation and sound state
class Confetti extends StatefulWidget {
  @override
  _ConfettiState createState() => _ConfettiState(); // Creates the mutable state
}

class _ConfettiState extends State<Confetti> {
  late ConfettiController _controller; // Controller for managing confetti animation
  final player = AudioPlayer(); // Audio player instance
  bool _isPlaying = false; // Tracks whether audio and confetti are playing

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: Duration(seconds: 27)); // Confetti duration
    // Listener to stop confetti when audio finishes
    player.onPlayerComplete.listen((_) {
      _controller.stop(); // Stops confetti
      setState(() {
        _isPlaying = false; // Updates state
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Stop and release confetti controller resources
    player.dispose(); // Stop and release audio player resources
    super.dispose(); // Call the parent dispose method
  }


  // Function to start playing audio and show confetti
  void _showConfetti() {
    if (!_isPlaying) { // Prevent multiple triggers
      setState(() {
        _isPlaying = true; // Update state to playing
      });
      player.play(AssetSource('audio/birthday_by_orchestra.mp3')); // Play audio from assets
      _controller.play(); // Start confetti animation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0c1540), // Dark background
      appBar: AppBar(
        title: const Text(
          'Happy Birthday', // App bar title
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0c1540),
        elevation: 0, // No shadow
      ),
      body: Stack(
        children: [
          // Main content: image and button
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/Happy_Birthday.jpg'), // Birthday image
              const SizedBox(height: 20), // Spacing
              ElevatedButton(
                onPressed: _isPlaying ? null : _showConfetti, // Disable button if already playing
                child: const Text('Celebrate!'), // Button label
              ),
            ],
          ),
          // Confetti animation overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller, // Confetti controller
              blastDirectionality: BlastDirectionality.explosive, // Random directions
              shouldLoop: _isPlaying, // Loop while playing
              emissionFrequency: 0.02, // Particle frequency
              numberOfParticles: 100, // Amount of particles per blast
              gravity: 0.1, // Confetti fall speed
              minBlastForce: 5,
              maxBlastForce: 20,
              colors: const [ // Confetti colors
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
