import 'package:flutter/material.dart';
import 'package:todo/pages/input_page.dart';
import 'package:todo/pages/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/text_provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<TextProvider>(context, listen: false).loadEles(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                child: const CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: const SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: false,
                    pinned: true,
                    expandedHeight: 70,
                    elevation: 0,
                    backgroundColor: Color(0xFF212332),
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text("Life Notes"),
                      centerTitle: true,
                    ),
                  ),
                  TextWidget(),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InputPage()),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add),
            ),
          );
        }
      },
    );
  }
}
