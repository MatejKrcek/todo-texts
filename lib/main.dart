import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:todo/pages/main_page.dart';
import 'package:todo/provider/text_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: TextProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF212332),
          primaryColor: const Color(0xFF2697FF),
          textTheme:
              GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          canvasColor: const Color(0xFF2A2D3E),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: const Color(0xFF2A2D3E)),
        ),
        home: MainPage(
          key: key,
        ),
      ),
    );
  }
}
