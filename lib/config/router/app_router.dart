
import 'package:gemini_app/presentation/screens/basic_prompt/basic_propmpt_screen.dart';
import 'package:gemini_app/presentation/screens/home/home_sreen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/basic-prompt',
      builder: (context, state) => const BasicPromptScreen(),
    ),
  ],
);