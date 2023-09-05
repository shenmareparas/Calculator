import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import './pages/pages.dart';
import 'models/settings_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsmodel = SettingsModel();
  settingsmodel.load();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: settingsmodel),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsModel settings = Provider.of<SettingsModel>(context);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: true,
      systemNavigationBarColor: Colors.transparent,
    ));

    final defaultLightColorScheme =
        ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 9, 116, 216));

    final defaultDarkColorScheme = ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 9, 116, 216),
        brightness: Brightness.dark);

    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mint Calc',
          theme: ThemeData(
            colorScheme: settings.isSystemColor
                ? lightColorScheme
                : defaultLightColorScheme,
            fontFamily: 'Manrope',
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: settings.isSystemColor
                ? darkColorScheme
                : defaultDarkColorScheme,
            fontFamily: 'Manrope',
            useMaterial3: true,
          ),
          themeMode: settings.themeMode,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const List _pages = [
    StdCalc(),
  ];
  final _pageTitles = {
    StdCalc: StdCalc.pageTitle,
  };
  int selectedIndex = 0;

  Route _createRoute(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String appBarText = _pageTitles[_pages[selectedIndex].runtimeType] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarText),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.push(context, _createRoute(SettingsPage())),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: _pages.elementAt(selectedIndex),
    );
  }
}
