import 'package:flutter/material.dart';

import 'dart:ui' as ui;
import 'package:flutter_book/widget/particles/particle_model.dart';

class ParticlePainter extends CustomPainter {
  List<ParticleModel> particles;
  Duration time;
  Color color;
  ui.Image image;

  ParticlePainter(this.particles, this.time, { this.image, this.color = Colors.white});
  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()..color = color.withAlpha(50);
    particles.forEach((p) {
      var progress = p.animationProgress.progress(time);
      final animation = p.tween.transform(progress);
      final position = Offset(animation['x'] * size.width, animation['y'] * size.height);
      canvas.drawCircle(position, size.width * 0.1 * p.size, paint);
      canvas.drawImage(image, position, paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
