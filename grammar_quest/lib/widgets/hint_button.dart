import 'package:flutter/material.dart';

class HintButton extends StatelessWidget {
  final VoidCallback onHint;
  const HintButton({super.key, required this.onHint});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onHint,
      icon: const Icon(Icons.lightbulb_rounded),
      label: const Text('HINT (20)'),
      backgroundColor: Colors.amber,
      foregroundColor: Colors.white,
    );
  }
}
