import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show radians;

class RadialFab extends StatefulWidget {
  const RadialFab({Key key}) : super(key: key);

  @override
  _RadialFabState createState() => _RadialFabState();
}

class _RadialFabState extends State<RadialFab> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return RadialAnimation(controller: controller);
  }
}

class RadialAnimation extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> translation;
  final Animation<double> rotation;
  RadialAnimation({Key key, this.controller})
      : scale = Tween<double>(
          begin: 1,
          end: 0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
        ),
        translation = Tween<double>(
          begin: 0.0,
          end: 80.0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.linear),
        ),
        rotation = Tween<double>(
          begin: radians(90),
          end: radians(180),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.decelerate,
          ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: rotation.value,
          child: Stack(
            children: [
              _buildButton(0, color: Colors.green, iconData: Icons.location_pin),
              _buildButton(90, color: Colors.green, iconData: Icons.build),
              Transform.scale(
                scale: scale.value - 1,
                child: FloatingActionButton(
                  onPressed: _close,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.close),
                ),
              ),
              Transform.scale(
                scale: scale.value,
                child: FloatingActionButton(
                  onPressed: _open,
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.add),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton(double angle, {Color color, IconData iconData}) {
    final double rad = radians(angle);
    return Transform(
      transform: Matrix4.identity()
        ..translate(
          translation.value * cos(rad),
          translation.value * sin(rad),
        ),
      child: Transform.rotate(
        angle: radians(180),
        child: FloatingActionButton(
          backgroundColor: color,
          onPressed: _close,
          child: Icon(iconData),
        ),
      ),
    );
  }

  void _open() {
    controller.forward();
  }

  void _close() {
    controller.reverse();
  }
}
