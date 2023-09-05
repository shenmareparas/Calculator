import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/settings_model.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  final TextEditingController sigFigInput = TextEditingController();
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text("Settings"),
          ),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  leading: const Icon(Icons.color_lens_outlined),
                  title: const Text("Theme"),
                  onTap: () =>
                      Navigator.push(context, _createRoute(const ThemePage())),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  static const platform =
      MethodChannel('bored.codebyk.mintcalc/androidversion');

  int av = 0;
  Future<int> androidVersion() async {
    final result = await platform.invokeMethod('getAndroidVersion');
    return await result;
  }

  void fetchVersion() async {
    final v = await androidVersion();
    setState(() {
      av = v;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchVersion();
  }

  @override
  Widget build(BuildContext context) {
    SettingsModel settings = Provider.of<SettingsModel>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text("Theme"),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SegmentedButton(
                    segments: const [
                      ButtonSegment(
                          value: ThemeMode.system, label: Text("System")),
                      ButtonSegment(
                          value: ThemeMode.light, label: Text("Light")),
                      ButtonSegment(value: ThemeMode.dark, label: Text("Dark")),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (p0) {
                      settings.themeMode = p0.first;
                    },
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  children: [
                    SwitchListTile(
                      value: settings.isSystemColor,
                      onChanged: av >= 31
                          ? (value) => settings.isSystemColor = value
                          : null,
                      title: const Text("Use system color scheme"),
                      subtitle: Text(settings.isSystemColor
                          ? "Using system dynamic color"
                          : "Using default color scheme"),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
