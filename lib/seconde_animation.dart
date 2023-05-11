import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:math' show pi;

class SecondeAnemation extends StatefulWidget {
  const SecondeAnemation({super.key});

  @override
  State<SecondeAnemation> createState() => _SecondeAnemationState();
}

class _SecondeAnemationState extends State<SecondeAnemation>
    with TickerProviderStateMixin {
  late AnimationController counterClockwiseAnimationControler;
  late Animation<double> counterClockwiseAnimation;
  late AnimationController flipController;
  late Animation<double> flipAnimation;

  @override
  void initState() {
    counterClockwiseAnimationControler =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    counterClockwiseAnimation = Tween<double>(
      begin: 0,
      end: -(pi / 2),
    ).animate(CurvedAnimation(
        parent: counterClockwiseAnimationControler, curve: Curves.bounceOut));

    //Flip Animation

    flipController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    flipAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(
        parent: flipController,
        curve: Curves.bounceOut,
      ),
    );

    //Status liseners

    counterClockwiseAnimationControler.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          flipAnimation = Tween<double>(
                  begin: flipAnimation.value, end: flipAnimation.value + pi)
              .animate(
            CurvedAnimation(
              parent: flipController,
              curve: Curves.bounceOut,
            ),
          );
             flipController
      ..reset()
      ..forward();
        }
     
      },

      
    );

    

    flipController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          counterClockwiseAnimation = Tween<double>(
            begin: counterClockwiseAnimation.value,
            end: counterClockwiseAnimation.value + -(pi / 2),
          ).animate(CurvedAnimation(
              parent: counterClockwiseAnimationControler,
              curve: Curves.bounceOut));

               counterClockwiseAnimationControler
      ..reset()
      ..forward();
        }
       
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    counterClockwiseAnimationControler.dispose();
    flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 1),
      () {
        counterClockwiseAnimationControler
          ..reset()
          ..forward();
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Seconde amimation"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: counterClockwiseAnimationControler,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(counterClockwiseAnimation.value),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: flipController,
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.centerRight,
                          transform: Matrix4.identity()
                            ..rotateY(flipAnimation.value),
                          child: ClipPath(
                            clipper: CustumPath(),
                            child: Container(
                              color: Colors.blue,
                              width: 150,
                              height: 150,
                            ),
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: flipController,
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.centerLeft,
                          transform: Matrix4.identity()
                            ..rotateY(flipAnimation.value),
                          child: ClipPath(
                            clipper: CustumPath2(),
                            child: Container(
                              color: Colors.yellow,
                              width: 150,
                              height: 150,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustumPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final Offset offset;

    path.moveTo(size.width, 0);

    offset = Offset(size.width, size.height);

    path.arcToPoint(
      offset,
      clockwise: false,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CustumPath2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final Offset offset;

    offset = Offset(0, size.height);

    path.arcToPoint(
      offset,
      clockwise: true,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
