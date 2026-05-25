import 'package:face_log/router/app_router.dart';
import 'package:face_log/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(const FaceLogApp());

class FaceLogApp extends StatelessWidget {
  const FaceLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FaceLog',
      debugShowCheckedModeBanner: false,
      theme: LumenTheme.light(),
      darkTheme: LumenTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
