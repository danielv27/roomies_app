import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class PopInAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final bool explodeLeft; //if set to false explodes right

  PopInAnimation({
    Key? key,
    required this.child,
    required this.delay,
    required this.duration,
    required this.explodeLeft
  }) : super(key: key);

  @override
  State<PopInAnimation> createState() => _PopInAnimationState();
}

class _PopInAnimationState extends State<PopInAnimation> {
  
  final ConfettiController _controller = ConfettiController(duration: const Duration(milliseconds: 400));


  @override
  void dispose() {
    _controller.dispose();
    // _controllerCenterRight.dispose();
    // _controllerCenterLeft.dispose();
    // _controllerTopCenter.dispose();
    // _controllerBottomCenter.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }


  Path drawHouse(Size size) {

    final path = Path();

    path.moveTo(0, size.height);
    path.lineTo(0, size.height / 2);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.6, size.height);
    path.lineTo(size.width * 0.6, size.height * 0.5);
    path.lineTo(size.width * 0.4, size.height * 0.5);
    path.lineTo(size.width * 0.4, size.height);
    path.close();

    return path;
  }
  
  double scale = 0;
  Future<void> popIn() async {
    await Future.delayed(widget.delay);
    if(mounted){
      setState(() {
        scale = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    popIn();
    if(scale == 0){
      Timer(Duration(milliseconds: widget.delay.inMilliseconds + 700),(){
        _controller.play();
      });
    } else {
      _controller.stop();
    }
    return Stack(
      children: [
        ConfettiWidget(
          minimumSize: const Size(10,5),
          maximumSize: const Size(40,20),
          numberOfParticles: 8,
          minBlastForce: 12,
          maxBlastForce: 18,
          confettiController: _controller,
          blastDirectionality: BlastDirectionality.explosive,
          colors: const [
          Color.fromARGB(255, 223, 105, 115),
          Color.fromRGBO(244, 130, 114, 1),
          Color.fromRGBO(239, 85, 100, 1),
              ], 
          createParticlePath: drawHouse,
        ),
        AnimatedScale(
          scale: scale,
          duration: widget.duration,
          curve: Curves.elasticInOut,
          child: widget.child,
        ),
      ]
    );
  }
}