import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';

class Function1 extends StatelessWidget {
  const Function1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Center(
              child: Text(''),
            ),
          ),
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(''),
                    Text('')
                  ],
                ),
                Row(
                   children: [
                    Text(''),
                    Text('')
                  ],
                ),
                Row(
                  children: [
                    ColoredButton(text: ''),
                    ColoredButton(text: '')
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