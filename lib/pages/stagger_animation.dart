import 'package:cliente/pages/registrar.dart';
import 'package:cliente/widgets/load_animation.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';

class StaggerAnimation extends StatelessWidget {
  final AnimationController controller;
  final padding;
  final text;
  final color;
  final textColor;
  final function;
  final colorCircular;
  final Route route;

  StaggerAnimation(
      {this.controller,
      this.padding,
      this.text,
      this.color,
      this.textColor,
      this.function,
      this.colorCircular,
      this.route})
      : buttonSqueeze = Tween(begin: 200.0, end: 50.0).animate(
            CurvedAnimation(parent: controller, curve: Interval(0.0, 0.150))),
        buttonZoomOut = Tween(begin: 50.0, end: 2000.0).animate(CurvedAnimation(parent: controller, curve: Interval(0.5,1.0, curve: Curves.bounceOut)));

  final Animation<double> buttonSqueeze;
  final Animation<double> buttonZoomOut;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Positioned(
      top: 450,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: function,
              child: Container(
                width: buttonSqueeze.value,
                height: 50,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(10)),
                child: _buildInside(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInside(BuildContext context) {
    if (buttonSqueeze.value > 85.0) {
      return Center(
          child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .button
            .copyWith(color: textColor, fontSize: 16),
      ));
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        // child: CheckAnimation(
        //   onComplete: () {
        //     print('Completo');
        //     Navigator.push(
        //       context,
        //       PageRouteBuilder(
        //         pageBuilder: (BuildContext context, _, __) {
        //           return Registrar();
        //         },
        //         transitionsBuilder: (context, animation,
        //             secondaryAnimation, child) {
        //           var begin = Offset(0.0, -1.0);
        //           var end = Offset.zero;
        //           var tween = Tween(begin: begin, end: end);
        //           var offsetAnimation = animation.drive(tween);
        //           return SlideTransition(
        //             position: offsetAnimation,
        //             child: child,
        //           );
        //         },
        //         transitionDuration: Duration(milliseconds: 600),
        //       ),
        //     );
        //   },
        // ),
        child: animationLoad(colorCircular: colorCircular, route: route),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

class animationLoad extends StatefulWidget {
  const animationLoad({
    Key key,
    @required this.colorCircular, this.route
  }) : super(key: key);

  final Color colorCircular;
  final Route route;

  @override
  _animationLoadState createState() => _animationLoadState();
}

class _animationLoadState extends State<animationLoad> {

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(milliseconds: 5500), () {
    //   setState(() {
    //     load = false;
    //   });
    // });
    return load 
      ? CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(widget.colorCircular),
        strokeWidth: 5.0,
        backgroundColor: Colors.white,
      )
      : CheckAnimation(
          onComplete: () {
            print('Complete');            
            Navigator.push(context, widget.route);          
          },
        );
  }
}

class SlideLeftRoute extends MaterialPageRoute {
  SlideLeftRoute({WidgetBuilder builder, RouteSettings settings})
    : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    Animation<Offset> custom = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation);
      return SlideTransition(position: custom, child: child,);
    // return super.buildTransitions(context, animation, secondaryAnimation, child);
  }
}

class SlideRightRoute extends MaterialPageRoute {
  SlideRightRoute({WidgetBuilder builder, RouteSettings settings})
    : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    Animation<Offset> custom = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation);
      return SlideTransition(position: custom, child: child,);
    // return super.buildTransitions(context, animation, secondaryAnimation, child);
  }
}