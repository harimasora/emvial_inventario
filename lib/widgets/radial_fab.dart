import 'package:emival_inventario/screens/add_place.dart';
import 'package:emival_inventario/screens/add_tool.dart';
import 'package:emival_inventario/screens/inventory_screen.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final Animation<double> degOneTranslationAnimation, degTwoTranslationAnimation, degThreeTranslationAnimation;
  final Animation<double> rotationAnimation;
  final Animation<Color> colorAnimation;
  RadialAnimation({Key key, this.controller})
      : degOneTranslationAnimation = TweenSequence([
          TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
          TweenSequenceItem<double>(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
        ]).animate(controller),
        degTwoTranslationAnimation = TweenSequence([
          TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
          TweenSequenceItem<double>(tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
        ]).animate(controller),
        degThreeTranslationAnimation = TweenSequence([
          TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
          TweenSequenceItem<double>(tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
        ]).animate(controller),
        rotationAnimation =
            Tween<double>(begin: 0.0, end: 180.0).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut)),
        colorAnimation = ColorTween(begin: Colors.blue, end: Colors.red).animate(controller),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            const IgnorePointer(
              child: SizedBox(
                height: 150.0,
                width: 150.0,
              ),
            ),
            Transform.translate(
              offset: Offset.fromDirection(radians(270), degOneTranslationAnimation.value * 100),
              child: Transform(
                transform: Matrix4.rotationZ(radians(rotationAnimation.value))..scale(degOneTranslationAnimation.value),
                alignment: Alignment.center,
                child: Transform.rotate(
                  angle: radians(180),
                  child: CircularButton(
                    color: Colors.green,
                    width: 50,
                    height: 50,
                    icon: const Icon(
                      Icons.build,
                      color: Colors.white,
                    ),
                    onClick: () {
                      final places = context.read(placesProvider);
                      _togglerAnimation();
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                        builder: (context) => AddToolScreen(places: places.state),
                        fullscreenDialog: true,
                      ));
                    },
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset.fromDirection(radians(180), degTwoTranslationAnimation.value * 100),
              child: Transform(
                transform: Matrix4.rotationZ(radians(rotationAnimation.value))..scale(degTwoTranslationAnimation.value),
                alignment: Alignment.center,
                child: Transform.rotate(
                  angle: radians(180),
                  child: CircularButton(
                    color: Colors.green,
                    width: 50,
                    height: 50,
                    icon: const Icon(
                      Icons.place,
                      color: Colors.white,
                    ),
                    onClick: () {
                      _togglerAnimation();
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                        builder: (context) => const AddPlaceScreen(),
                        fullscreenDialog: true,
                      ));
                    },
                  ),
                ),
              ),
            ),
            Transform(
              transform: Matrix4.rotationZ(radians(rotationAnimation.value / 4)),
              alignment: Alignment.center,
              child: CircularButton(
                color: colorAnimation.value,
                width: 60,
                height: 60,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onClick: _togglerAnimation,
              ),
            )
          ],
        );
      },
    );
  }

  void _togglerAnimation() {
    if (controller.isCompleted) {
      controller.reverse();
    } else {
      controller.forward();
    }
  }
}

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final void Function() onClick;

  const CircularButton({this.color, this.width, this.height, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: width,
      height: height,
      child: IconButton(icon: icon, onPressed: onClick),
    );
  }
}
