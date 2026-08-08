import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'feature/core/supabase/supabase_config.dart';
import 'feature/core/supabase/supabase_providers.dart';
import 'feature/presentation/page/route/app_routes.dart';
import 'feature/presentation/view/member_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.memberQuiz: (context) => const MemberQuizPage(),
      },
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase connected'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              session.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stackTrace) =>
                    Text('Authentication error: $error'),
                data: (currentSession) => Text(
                  currentSession == null
                      ? 'Supabase is ready. No user is signed in.'
                      : 'Signed in as '
                      '${currentSession.user.email ?? currentSession.user.id}',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  AppRoutes.memberQuiz,
                ),
                child: const Text('멤버 맞추기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
