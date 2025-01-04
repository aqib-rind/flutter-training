import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:profondo/screens/home_page.dart';
import 'package:profondo/screens/login_page.dart';
import 'package:profondo/screens/my_papers.dart';
import 'package:profondo/screens/paper_view_page.dart';
import 'package:profondo/screens/profile_page.dart';
import 'package:profondo/screens/register_page.dart';
import 'package:profondo/screens/upload_page.dart';
import 'package:profondo/utils/routes.dart';
import 'package:profondo/utils/theme.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:profondo/utils/global_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalState()), // Add GlobalState
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: MythemeData.lightTheme(context),
      darkTheme: MythemeData.darkTheme(context),
      debugShowCheckedModeBanner: false,
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? "/login" : "/home",
      routes: {
        MyRoutes.loginRoute: (context) => const LoginPage(),
        MyRoutes.homeRoute: (context) => const HomePage(),
        MyRoutes.registerRoute: (context) => const RegisterPage(),
        MyRoutes.uploadRoute: (context) => const UploadResearchPaperPage(),
        MyRoutes.profileRoute: (context) => const ProfilePage(),
        MyRoutes.myPapersRoute: (context) => const MyPapersPage(),
        MyRoutes.paperViewRoute: (context) => const PaperViewPage()
      },
    );
  }
}
