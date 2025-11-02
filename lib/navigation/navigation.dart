import 'package:flutter/material.dart';

Route createSlideRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400), // thời gian hiệu ứng
    reverseTransitionDuration: const Duration(milliseconds: 400), // khi quay lại
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // bắt đầu từ bên phải
      const end = Offset.zero; // kết thúc ở giữa
      const curve = Curves.easeInOut; // hiệu ứng mượt

      final tween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: curve)); // tween + curve

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
