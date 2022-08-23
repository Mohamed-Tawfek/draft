import 'package:fatora/cubit/fatora_cubit.dart';
import 'package:fatora/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FatoraCubit.initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData(
          primarySwatch: Colors.grey,
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF15202B),
          ),
          scaffoldBackgroundColor: Color(0xFF15202B)),
      themeMode: ThemeMode.dark,
      home: Directionality(
        child: const HomeScreen(),
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
