import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/coin_display.dart';
import '../widgets/xp_bar.dart';
import '../providers/game_provider.dart';
import 'level_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: BackgroundPainter(_controller.value),
                size: Size.infinite,
              );
            },
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 150, child: XPBar()),
                      const CoinDisplay(),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    'Grammar Quest',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Master your English grammar through play!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const Spacer(),
                  _buildMenuButton(
                    context,
                    'PLAY',
                    Icons.play_arrow_rounded,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LevelScreen()),
                    ),
                    isPrimary: true,
                  ),
                  const SizedBox(height: 16),
                  _buildMenuButton(
                    context,
                    'SETTINGS',
                    Icons.settings_rounded,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool isPrimary = false,
  }) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28),
        label: Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        onPressed: onPressed,
        style: isPrimary 
          ? theme.elevatedButtonTheme.style
          : ElevatedButton.styleFrom(
              backgroundColor: theme.cardColor,
              foregroundColor: theme.primaryColor,
              elevation: 2,
            ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double progress;
  BackgroundPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 5; i++) {
        final x = (size.width * (progress + i * 0.2)) % size.width;
        final y = (size.height * (progress * 0.5 + i * 0.3)) % size.height;
        canvas.drawCircle(Offset(x, y), 50 + i * 20, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) => true;
}
