/* import 'package:charla_vertex_gemini/presentation/courses/courses_page.dart'; */

import 'package:charla_vertex_gemini/features/create_commit_use_case.dart';
import 'package:charla_vertex_gemini/firebase_options.dart';
import 'package:charla_vertex_gemini/presentation/commit_creater_page.dart';
import 'package:charla_vertex_gemini/presentation/courses/courses_page.dart';
import 'package:charla_vertex_gemini/presentation/create_story_page.dart';
import 'package:charla_vertex_gemini/presentation/options_generator_page.dart';
/* import 'package:charla_vertex_gemini/presentation/create_story_page.dart';
import 'package:charla_vertex_gemini/presentation/options_generator_page.dart'; */
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: CreateStoryPage(),
      // home: CreateSimplePage(),
      // home: OptionsGeneratorPage(),
      home: CommitCreaterPage(
        createCommitUseCase: CreateCommitUseCase(),
      ),
    );
  }
}
// functions call
