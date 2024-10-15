import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'provider/theme_provider.dart';

/// Initializes the FlutterFire default app, and runs the app with a
/// [ThemeProvider] that allows the user to switch between light and dark
/// themes.
///
/// This function is the entry point of the app, as declared in the
/// `lib/main.dart` file.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
      create: (_) => ThemeProvider(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override

  /// Loads the theme from the preferences as soon as the widget is created.
  ///
  /// This is a special method of the [State] class that is called when this
  /// object is inserted into the tree. It is used to load the theme from the
  /// preferences, so that the theme is available as soon as the app is started.
  ///
  void initState() {
    super.initState();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.loadTheme();
  }

  @override

  /// Builds the root widget of the app, which is a [MaterialApp] that
  /// displays the [HomePage] as its home.
  ///
  /// The theme of the [MaterialApp] is determined by the [ThemeProvider]
  /// instance, which is obtained from the [BuildContext] using the
  /// [Provider] library.
  ///
  /// The [MaterialApp] is given a title of "Firebase Database", and the
  /// debug banner is hidden.
  ///
  /// The [MaterialApp] is built with the theme that is currently stored in
  /// the preferences, as loaded by the [ThemeProvider] instance.
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'Firebase Database',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      home: HomePage(themeProvider: themeProvider),
    );
  }
}
