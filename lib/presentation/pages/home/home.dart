import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        surfaceTintColor: Theme.of(context).appBarTheme.surfaceTintColor,
        titleSpacing: 20,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Title(color: Colors.limeAccent, child: const Text('MEMOZA')),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.settings))
                  ],
                )
              ],
            ),
            const Divider(
              height: 1,
              color: Colors.white30,
            )
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          
        ],
      ),
    );
  }
}

