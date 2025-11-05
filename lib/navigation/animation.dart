import 'package:flutter/material.dart';

Route createSlideRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400), 
    reverseTransitionDuration: const Duration(milliseconds: 400), 
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); 
      const end = Offset.zero; 
      const curve = Curves.easeInOut; 

      final tween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: curve)); 

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
