import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coin_provider.dart';

class CoinDisplay extends StatelessWidget {
  const CoinDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
          const SizedBox(width: 4),
          Consumer<CoinProvider>(
            builder: (context, coinProvider, child) {
              return Text(
                '${coinProvider.coins}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              );
            },
          ),
        ],
      ),
    );
  }
}
