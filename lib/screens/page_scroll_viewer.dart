import 'package:flutter/material.dart';

class PageScrollViewer extends StatelessWidget {
  const PageScrollViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: PageView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        children: const <Widget>[
          Center(
            child: Text('First Page'),
          ),
          Center(
            child: Text('Second Page'),
          ),
          Center(
            child: Text('Third Page'),
          ),
        ],
      ),
    );
  }
}
