import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_book/util/ui_image_util.dart';
import 'package:flutter_book/widget/particles/particle_model.dart';
import 'package:flutter_book/widget/particles/particle_painter.dart';
import 'package:flutter_book/widget/toast/toast.dart';
import 'package:simple_animations/simple_animations.dart';

class ParticlesView extends StatefulWidget {
  final int numberOfParticles;
  ParticlesView(this.numberOfParticles);
  @override
  _ParticlesViewState createState() => _ParticlesViewState();
}

class _ParticlesViewState extends State<ParticlesView> {
  final Random random = Random();
  final List<ParticleModel> particles = [];
  ui.Image image;

  @override
  void initState() {
    List.generate(widget.numberOfParticles, (index) {
      particles.add(ParticleModel(random, defaultMilliseconds: 2000));
    });
    initImage();
    super.initState();
  }

  initImage() async {
    ui.Image s = await UiImageUtil().rootBundleImage('img/actionbar_checkin.png');
    setState(() {
      image = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Rendering(
      startTime: Duration(seconds: 50),
      onTick: _simulateParticles,
      builder: (context, time) {
        _simulateParticles(time);
        return CustomPaint(
          painter: ParticlePainter(particles, time, image: image,color: Colors.red),
        );
      },
    );
  }

  _simulateParticles(Duration time) {
    particles.forEach((p) => p.maintainRestart(time));
  }
}
