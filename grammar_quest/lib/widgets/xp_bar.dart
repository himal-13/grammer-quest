import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coin_provider.dart';

class XPBar extends StatelessWidget {
  const XPBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CoinProvider>(
      builder: (context, coinProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Level ${coinProvider.currentLevelXP}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Text(
                  '${(coinProvider.xpProgress * 100).toInt()}%',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: coinProvider.xpProgress,
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                minHeight: 10,
              ),
            ),
          ],
        );
      },
    );
  }
}
