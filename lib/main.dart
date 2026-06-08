import 'dart:async';
import 'package:flutter/material.dart';

// ---- Domain ----------------------------------------------------------------

class EvolutionMilestone {
  const EvolutionMilestone(this.stage, this.elapsed);
  final String stage;
  final Duration elapsed;
}

class MonsterState {
  MonsterState({
    required this.stage,
    required this.startedAt,
    required this.nextEvolutionAt,
    required this.mode,
    required this.lastEvent,
  });

  String stage;
  DateTime startedAt;
  DateTime nextEvolutionAt;
  String mode;
  String lastEvent;
}

const List<EvolutionMilestone> milestones = [
  EvolutionMilestone('Digitama', Duration.zero),
  EvolutionMilestone('Zurumon', Duration(seconds: 10)),
  EvolutionMilestone('Pagumon', Duration(minutes: 10, seconds: 10)),
  EvolutionMilestone('Gazimon', Duration(hours: 6, minutes: 10, seconds: 10)),
  EvolutionMilestone('DarkTyrannomon', Duration(hours: 30, minutes: 10, seconds: 10)),
  EvolutionMilestone('MetalTyrannomon', Duration(hours: 66, minutes: 10, seconds: 10)),
];

// ---- Sprites ---------------------------------------------------------------

const List<List<int>> digitamaSprite = [
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0],[0,0,0,0,0,1,1,0,1,0,1,0,0,0,0,0],
  [0,0,0,0,1,0,1,0,1,1,0,1,0,0,0,0],[0,0,0,1,0,1,1,0,0,1,0,0,1,0,0,0],
  [0,0,0,1,0,1,0,0,0,1,1,0,1,0,0,0],[0,0,1,0,0,1,0,0,1,1,1,0,0,1,0,0],
  [0,0,1,0,1,1,0,0,1,0,1,1,0,1,0,0],[0,0,1,0,1,0,0,0,1,0,0,1,0,1,0,0],
  [0,0,1,0,1,0,0,0,1,0,0,1,0,1,0,0],[0,0,0,1,1,0,0,1,0,0,1,1,1,0,0,0],
  [0,0,0,0,1,1,1,1,0,0,1,1,0,0,0,0],[0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0],
];

const List<List<int>> zurumonSprite = [
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0],
  [0,0,0,0,0,1,0,1,0,1,1,0,0,0,0,0],[0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0],
  [0,0,0,0,0,1,1,0,1,1,1,1,0,0,0,0],[0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0],
];

const List<List<int>> pagumonSprite = [
  [0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0],[0,0,1,0,1,1,1,1,1,1,0,0,1,1,0,0],
  [0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0],[1,0,1,0,0,0,0,0,0,0,1,0,0,0,0,1],
  [1,0,1,0,1,0,0,0,1,0,0,1,0,0,0,1],[1,0,1,0,1,0,0,0,1,0,0,0,1,0,0,1],
  [0,1,1,0,0,0,1,0,0,0,0,0,0,1,1,0],[0,0,1,0,0,1,0,1,0,0,0,0,0,1,0,0],
  [0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
];

const List<List<int>> gazimonSprite = [
  [0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0],[0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0],
  [0,1,0,0,0,0,1,1,0,0,0,0,1,0,0,0],[1,0,0,0,0,1,0,1,1,0,0,0,0,1,0,0],
  [1,0,0,0,0,0,1,1,1,0,0,0,0,1,0,0],[0,1,1,1,1,0,0,0,0,0,1,0,0,1,0,0],
  [0,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0],[0,0,1,1,1,1,0,0,1,1,0,0,1,0,0,0],
  [0,1,0,0,1,0,0,1,0,0,0,0,0,1,0,0],[0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1],
  [0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1],[0,0,1,1,1,1,0,0,0,1,0,0,1,0,1,0],
  [0,1,0,1,0,1,1,1,1,0,1,0,0,1,0,0],[0,1,1,1,1,1,1,0,1,1,1,1,1,1,0,0],
];

const List<List<int>> darkTyrannomonSprite = [
  [0,0,0,0,1,1,1,1,1,1,0,1,1,0,0,0],[0,0,0,1,1,1,1,1,1,1,1,0,1,0,0,0],
  [0,0,0,1,1,1,1,0,0,1,1,1,0,0,0,0],[0,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0],
  [1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0],[1,1,1,1,1,0,1,1,1,1,1,1,1,0,0,0],
  [0,1,0,0,0,0,0,1,1,1,1,1,1,1,1,0],[0,0,1,1,1,1,1,1,1,1,1,1,1,0,1,0],
  [0,0,0,0,0,1,1,1,0,0,1,1,1,1,1,0],[0,0,1,0,1,1,1,0,1,1,1,1,1,1,0,0],
  [0,1,1,0,1,1,1,0,1,1,1,1,0,1,0,1],[0,1,1,0,1,1,1,1,0,0,0,0,1,1,1,1],
  [0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1],[0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
  [0,1,0,1,1,1,1,1,1,1,0,1,0,1,0,1],[0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1],
];

const List<List<int>> metalTyrannomonSprite = [
  [0,0,0,0,1,1,1,1,1,1,0,1,1,0,0,0],[0,0,0,1,1,1,1,0,0,1,1,0,1,0,0,0],
  [0,1,1,1,1,1,0,0,1,1,1,1,0,0,0,0],[1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
  [1,1,1,1,1,0,1,1,1,1,0,1,0,1,0,0],[0,1,0,0,0,0,0,1,1,1,0,1,1,0,0,0],
  [0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,0],[0,0,0,0,1,0,1,1,0,1,0,1,1,0,1,0],
  [0,0,0,1,0,0,1,1,0,0,1,1,1,1,1,0],[0,1,0,1,1,0,0,0,1,1,1,1,0,1,0,0],
  [1,1,0,1,1,1,0,0,1,1,1,1,0,1,0,1],[1,1,0,1,1,0,0,0,0,0,0,0,1,1,1,1],
  [0,0,0,0,1,1,0,1,0,1,1,0,0,0,1,1],[0,1,1,1,0,1,1,0,1,1,1,1,1,1,1,0],
  [1,0,1,1,1,0,1,1,1,1,0,1,0,1,0,1],[1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1],
];

// ---- Utilities -------------------------------------------------------------

String formatRemaining(Duration duration) {
  if (duration.isNegative) return 'まもなく';
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  if (hours > 0) return '${hours}時間${minutes}分';
  if (minutes > 0) return '${minutes}分${seconds}秒';
  return '${seconds}秒';
}

({List<List<int>> sprite, int offsetX, int offsetY}) spriteForStage(String stage) {
  switch (stage) {
    case 'Zurumon':
      return (sprite: zurumonSprite, offsetX: 12, offsetY: 18);
    case 'Pagumon':
      return (sprite: pagumonSprite, offsetX: 12, offsetY: 18);
    case 'Gazimon':
      return (sprite: gazimonSprite, offsetX: 8, offsetY: 18);
    case 'DarkTyrannomon':
      return (sprite: darkTyrannomonSprite, offsetX: 8, offsetY: 18);
    case 'MetalTyrannomon':
      return (sprite: metalTyrannomonSprite, offsetX: 8, offsetY: 18);
    default:
      return (sprite: digitamaSprite, offsetX: 18, offsetY: 18);
  }
}

// ---- Entry -----------------------------------------------------------------

void main() {
  runApp(const DigimonApp());
}

class DigimonApp extends StatelessWidget {
  const DigimonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DIGITAL MONSTER v2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF22c55e)),
        fontFamily: 'sans-serif',
      ),
      home: const DigimonScreen(),
    );
  }
}

// ---- Screen ----------------------------------------------------------------

class DigimonScreen extends StatefulWidget {
  const DigimonScreen({super.key});

  @override
  State<DigimonScreen> createState() => _DigimonScreenState();
}

class _DigimonScreenState extends State<DigimonScreen> {
  late MonsterState _current;
  Timer? _timer;
  bool _panelVisible = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _current = MonsterState(
      stage: milestones.first.stage,
      startedAt: now,
      nextEvolutionAt: now.add(milestones[1].elapsed),
      mode: 'observe',
      lastEvent: '誕生しました',
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(_updateStageByTime);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateStageByTime() {
    final elapsed = DateTime.now().difference(_current.startedAt);
    for (var i = milestones.length - 1; i >= 0; i--) {
      if (elapsed >= milestones[i].elapsed) {
        if (_current.stage != milestones[i].stage) {
          _current.stage = milestones[i].stage;
          _current.lastEvent = '${milestones[i].stage}に進化しました';
        }
        final nextIndex = i + 1;
        _current.nextEvolutionAt = _current.startedAt.add(
          nextIndex < milestones.length
              ? milestones[nextIndex].elapsed
              : milestones.last.elapsed,
        );
        return;
      }
    }
  }

  void _skipTime(Duration delta, String label) {
    setState(() {
      _current.startedAt = _current.startedAt.subtract(delta);
      _current.lastEvent = '$label 時間を進めました';
      _updateStageByTime();
    });
  }

  void _resetTime() {
    setState(() {
      _current.startedAt = DateTime.now();
      _current.stage = milestones.first.stage;
      _current.lastEvent = '時間をリセットしました';
      _updateStageByTime();
    });
  }

  bool get _isFinalStage => _current.stage == milestones.last.stage;

  String get _remainingText {
    if (_isFinalStage) return '最終段階';
    return formatRemaining(_current.nextEvolutionAt.difference(DateTime.now()));
  }

  String get _summaryText {
    if (_isFinalStage) return '最終段階に到達しました';
    final remaining = _current.nextEvolutionAt.difference(DateTime.now());
    return '次の進化まで ${formatRemaining(remaining)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Column(
                  children: [
                    _StatusBar(
                      lastEvent: _current.lastEvent,
                      summary: _summaryText,
                    ),
                    const SizedBox(height: 14),
                    _DeviceBody(stage: _current.stage),
                    const SizedBox(height: 14),
                    _InfoPanel(
                      visible: _panelVisible,
                      stage: _current.stage,
                      remainingText: _remainingText,
                      onToggle: () => setState(() => _panelVisible = !_panelVisible),
                      onSkip10s: () => _skipTime(const Duration(seconds: 10), '+10秒'),
                      onSkip10m: () => _skipTime(const Duration(minutes: 10), '+10分'),
                      onSkip6h: () => _skipTime(const Duration(hours: 6), '+6時間'),
                      onReset: _resetTime,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---- Widgets ---------------------------------------------------------------

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.lastEvent, required this.summary});
  final String lastEvent;
  final String summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.9),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.18),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF22c55e).withOpacity(0.2),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Digital Monster v2',
              style: TextStyle(
                color: Color(0xFF86EFAC),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$lastEvent / $summary',
              style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceBody extends StatelessWidget {
  const _DeviceBody({required this.stage});
  final String stage;

  @override
  Widget build(BuildContext context) {
    final (:sprite, :offsetX, :offsetY) = spriteForStage(stage);
    return Container(
      width: 380,
      height: 270,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF44DD88),
            Color(0xFF117755),
            Color(0xFF117755),
            Color(0xFF006633),
            Color(0xFF004422),
          ],
          stops: [0.0, 0.01, 0.5, 0.99, 1.0],
        ),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Monitor area (220x220 = 200x200 screen + 10px border each side)
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFFCB03), width: 10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.8),
                    blurRadius: 10,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: ClipRRect(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEE7E0),
                    image: DecorationImage(
                      image: AssetImage('background.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: CustomPaint(
                    size: const Size(200, 200),
                    painter: SpritePainter(
                      sprite: sprite,
                      offsetX: offsetX,
                      offsetY: offsetY,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // A / B / C buttons
          Positioned(
            bottom: 30,
            left: 240,
            child: Row(
              children: [
                _LegacyButton(label: 'A'),
                const SizedBox(width: 8),
                _LegacyButton(label: 'B'),
                const SizedBox(width: 8),
                _LegacyButton(label: 'C'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegacyButton extends StatelessWidget {
  const _LegacyButton({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '今回は観察モードです',
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFFFCB03),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF006611), width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004411),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.visible,
    required this.stage,
    required this.remainingText,
    required this.onToggle,
    required this.onSkip10s,
    required this.onSkip10m,
    required this.onSkip6h,
    required this.onReset,
  });

  final bool visible;
  final String stage;
  final String remainingText;
  final VoidCallback onToggle;
  final VoidCallback onSkip10s;
  final VoidCallback onSkip10m;
  final VoidCallback onSkip6h;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (visible) ...[
            const Text(
              '時間の経過にあわせて進化していくデジモンを観察できます。',
              style: TextStyle(
                color: Color(0xFF0F172A),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            _StatusCards(stage: stage, remainingText: remainingText),
            const SizedBox(height: 14),
          ],
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _SecondaryButton(
                label: visible ? '表示切替' : '表示を戻す',
                onPressed: onToggle,
              ),
            ],
          ),
          if (visible) ...[
            const SizedBox(height: 14),
            _DebugPanel(
              onSkip10s: onSkip10s,
              onSkip10m: onSkip10m,
              onSkip6h: onSkip6h,
              onReset: onReset,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusCards extends StatelessWidget {
  const _StatusCards({required this.stage, required this.remainingText});
  final String stage;
  final String remainingText;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _StatusCard(label: '成長段階', value: stage),
        const _StatusCard(label: '空腹度', value: 'なし'),
        const _StatusCard(label: '体力', value: 'なし'),
        _StatusCard(label: '状態', value: remainingText),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

class _DebugPanel extends StatelessWidget {
  const _DebugPanel({
    required this.onSkip10s,
    required this.onSkip10m,
    required this.onSkip6h,
    required this.onReset,
  });
  final VoidCallback onSkip10s;
  final VoidCallback onSkip10m;
  final VoidCallback onSkip6h;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFCBD5E1))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'デバッグ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _SecondaryButton(label: '+10秒', onPressed: onSkip10s),
              _SecondaryButton(label: '+10分', onPressed: onSkip10m),
              _SecondaryButton(label: '+6時間', onPressed: onSkip6h),
              _SecondaryButton(label: 'リセット', onPressed: onReset),
            ],
          ),
        ],
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: const Color(0xFFE2E8F0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: const StadiumBorder(),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: const TextStyle(fontSize: 14)),
    );
  }
}

// ---- Painter ---------------------------------------------------------------

class SpritePainter extends CustomPainter {
  const SpritePainter({
    required this.sprite,
    this.offsetX = 0,
    this.offsetY = 0,
  });

  final List<List<int>> sprite;
  final int offsetX;
  final int offsetY;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF111827);
    for (var y = 0; y < sprite.length; y++) {
      for (var x = 0; x < sprite[y].length; x++) {
        if (sprite[y][x] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              (offsetX + x * 11).toDouble(),
              (offsetY + y * 11).toDouble(),
              10,
              10,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(SpritePainter old) =>
      old.sprite != sprite || old.offsetX != offsetX || old.offsetY != offsetY;
}
