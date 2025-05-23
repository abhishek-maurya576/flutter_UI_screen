import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedParticlesBackground extends StatefulWidget {
  final int numberOfParticles;
  final List<Color> colors;

  const AnimatedParticlesBackground({
    Key? key,
    this.numberOfParticles = 50,
    this.colors = const [
      Colors.blue,
      Colors.blueAccent,
      Colors.lightBlueAccent,
      Colors.white,
    ],
  }) : super(key: key);

  @override
  _AnimatedParticlesBackgroundState createState() =>
      _AnimatedParticlesBackgroundState();
}

class _AnimatedParticlesBackgroundState extends State<AnimatedParticlesBackground>
    with TickerProviderStateMixin {
  final List<ParticleModel> particles = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initializeParticles();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _animationController.addListener(() {
      _updateParticlePositions();
    });
  }

  void _initializeParticles() {
    final Random random = Random();
    for (int i = 0; i < widget.numberOfParticles; i++) {
      particles.add(
        ParticleModel(
          position: Offset(
            random.nextDouble() * 400,
            random.nextDouble() * 800,
          ),
          speed: Offset(
            (random.nextDouble() - 0.5) * 2,
            (random.nextDouble() - 0.5) * 2,
          ),
          size: 3 + random.nextDouble() * 10,
          color: widget.colors[random.nextInt(widget.colors.length)]
              .withOpacity(0.2 + random.nextDouble() * 0.6),
        ),
      );
    }
  }

  void _updateParticlePositions() {
    if (!mounted) return;

    setState(() {
      for (final particle in particles) {
        particle.position += particle.speed;

        // Wrap around screen
        if (particle.position.dx < 0) {
          particle.position = Offset(400, particle.position.dy);
        } else if (particle.position.dx > 400) {
          particle.position = Offset(0, particle.position.dy);
        }

        if (particle.position.dy < 0) {
          particle.position = Offset(particle.position.dx, 800);
        } else if (particle.position.dy > 800) {
          particle.position = Offset(particle.position.dx, 0);
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ParticlePainter(particles),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}

class ParticleModel {
  Offset position;
  Offset speed;
  double size;
  Color color;

  ParticleModel({
    required this.position,
    required this.speed,
    required this.size,
    required this.color,
  });
}

class ParticlePainter extends CustomPainter {
  final List<ParticleModel> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()..color = particle.color;
      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
} 