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
    required this.lastEvent,
    required this.hunger,
    required this.strength,
    required this.nextHungerDecayAt,
    required this.nextStrengthDecayAt,
  });

  String stage;
  DateTime startedAt;
  DateTime nextEvolutionAt;
  String lastEvent;
  int hunger; // 0..4
  int strength; // 0..4
  DateTime nextHungerDecayAt;
  DateTime nextStrengthDecayAt;
}

const List<EvolutionMilestone> milestones = [
  EvolutionMilestone('Digitama', Duration.zero),
  EvolutionMilestone('Zurumon', Duration(seconds: 10)),
  EvolutionMilestone('Pagumon', Duration(minutes: 10, seconds: 10)),
  EvolutionMilestone('Gazimon', Duration(hours: 6, minutes: 10, seconds: 10)),
  EvolutionMilestone('DarkTyrannomon', Duration(hours: 30, minutes: 10, seconds: 10)),
  EvolutionMilestone('MetalTyrannomon', Duration(hours: 66, minutes: 10, seconds: 10)),
];

const int maxHearts = 4;
const Duration hungerDecayInterval = Duration(minutes: 3);
const Duration strengthDecayInterval = Duration(minutes: 4);

enum FoodKind { meat, protein }

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

// 食事シーン用のドット絵（8x8）。かじられて3段階で小さくなる。
const List<List<List<int>>> meatSprites = [
  [
    [0,0,1,1,1,1,0,0],
    [0,1,1,1,1,1,1,0],
    [1,1,1,1,1,1,1,0],
    [1,1,1,1,1,1,1,0],
    [0,1,1,1,1,1,0,0],
    [0,0,1,1,1,0,0,0],
    [0,0,0,1,1,0,0,0],
    [0,0,0,1,1,1,0,0],
  ],
  [
    [0,0,1,1,1,0,0,0],
    [0,1,1,1,1,0,0,0],
    [1,1,1,1,1,0,0,0],
    [1,1,1,1,0,0,0,0],
    [0,1,1,1,0,0,0,0],
    [0,0,1,1,0,0,0,0],
    [0,0,0,1,1,0,0,0],
    [0,0,0,1,1,1,0,0],
  ],
  [
    [0,0,0,0,0,0,0,0],
    [0,0,1,1,0,0,0,0],
    [0,1,1,0,0,0,0,0],
    [0,1,1,0,0,0,0,0],
    [0,0,1,0,0,0,0,0],
    [0,0,0,1,0,0,0,0],
    [0,0,0,1,1,0,0,0],
    [0,0,0,1,1,1,0,0],
  ],
];

const List<List<List<int>>> proteinSprites = [
  [
    [0,0,0,1,1,0,0,0],
    [0,0,0,1,1,0,0,0],
    [0,0,1,1,1,1,0,0],
    [0,1,1,1,1,1,1,0],
    [0,1,1,0,0,1,1,0],
    [0,1,1,0,0,1,1,0],
    [0,1,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,0],
  ],
  [
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,1,1,0,0,0],
    [0,1,1,1,1,1,1,0],
    [0,1,0,0,0,0,1,0],
    [0,1,0,0,0,0,1,0],
    [0,1,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,0],
  ],
  [
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,1,1,1,1,1,1,0],
    [0,1,0,1,1,0,1,0],
    [0,1,1,1,1,1,1,0],
  ],
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

String heartsText(int value) => '♥' * value + '♡' * (maxHearts - value);

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
  Timer? _eatTimer;
  bool _panelVisible = true;
  bool _idleShift = false;
  bool _eating = false;
  int _eatFrame = 0;
  FoodKind? _eatingFood;
  int _menuIndex = -1; // -1: メニュー非表示, 0: ごはん, 1: プロテイン

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _current = MonsterState(
      stage: milestones.first.stage,
      startedAt: now,
      nextEvolutionAt: now.add(milestones[1].elapsed),
      lastEvent: '誕生しました',
      hunger: maxHearts,
      strength: maxHearts,
      nextHungerDecayAt: now.add(hungerDecayInterval),
      nextStrengthDecayAt: now.add(strengthDecayInterval),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _updateStageByTime();
        _updateNeedsByTime();
        if (!_eating) _idleShift = !_idleShift;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _eatTimer?.cancel();
    super.dispose();
  }

  bool get _isEgg => _current.stage == milestones.first.stage;

  void _updateStageByTime() {
    final elapsed = DateTime.now().difference(_current.startedAt);
    for (var i = milestones.length - 1; i >= 0; i--) {
      if (elapsed >= milestones[i].elapsed) {
        if (_current.stage != milestones[i].stage) {
          final wasEgg = _isEgg;
          _current.stage = milestones[i].stage;
          _current.lastEvent = '${milestones[i].stage}に進化しました';
          if (wasEgg) {
            // 孵化した直後はおなかをすかせている
            final now = DateTime.now();
            _current.hunger = 2;
            _current.strength = 2;
            _current.nextHungerDecayAt = now.add(hungerDecayInterval);
            _current.nextStrengthDecayAt = now.add(strengthDecayInterval);
          }
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

  void _updateNeedsByTime() {
    if (_isEgg) return;
    final now = DateTime.now();
    while (!now.isBefore(_current.nextHungerDecayAt)) {
      if (_current.hunger > 0) {
        _current.hunger--;
        if (_current.hunger == 0) {
          _current.lastEvent = 'おなかをすかせて呼んでいます';
        }
      }
      _current.nextHungerDecayAt =
          _current.nextHungerDecayAt.add(hungerDecayInterval);
    }
    while (!now.isBefore(_current.nextStrengthDecayAt)) {
      if (_current.strength > 0) {
        _current.strength--;
        if (_current.strength == 0) {
          _current.lastEvent = '元気がなくなっています';
        }
      }
      _current.nextStrengthDecayAt =
          _current.nextStrengthDecayAt.add(strengthDecayInterval);
    }
  }

  // ---- 食事 ----------------------------------------------------------------

  void _feed(FoodKind kind) {
    if (_eating) return;
    if (_isEgg) {
      setState(() => _current.lastEvent = 'まだデジタマのようです');
      return;
    }
    if (kind == FoodKind.meat && _current.hunger >= maxHearts) {
      setState(() {
        _menuIndex = -1;
        _current.lastEvent = 'おなかがいっぱいのようです';
      });
      return;
    }
    if (kind == FoodKind.protein && _current.strength >= maxHearts) {
      setState(() {
        _menuIndex = -1;
        _current.lastEvent = 'これ以上は飲みたくないようです';
      });
      return;
    }
    setState(() {
      _menuIndex = -1;
      _eating = true;
      _eatFrame = 0;
      _eatingFood = kind;
      _current.lastEvent =
          kind == FoodKind.meat ? 'おにくを食べています…' : 'プロテインを飲んでいます…';
    });
    _eatTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        _eatFrame++;
        if (_eatFrame >= 8) {
          timer.cancel();
          _eatTimer = null;
          _eating = false;
          if (_eatingFood == FoodKind.meat) {
            _current.hunger =
                (_current.hunger + 1).clamp(0, maxHearts);
            _current.lastEvent = 'おにくを食べました';
          } else {
            _current.strength =
                (_current.strength + 1).clamp(0, maxHearts);
            _current.lastEvent = 'プロテインを飲みました';
          }
          _eatingFood = null;
        }
      });
    });
  }

  // ---- A / B / C ボタン ------------------------------------------------------

  void _pressA() {
    if (_eating) return;
    setState(() {
      _menuIndex = (_menuIndex + 1) % 2;
      _current.lastEvent =
          _menuIndex == 0 ? '「ごはん」を選択中（Bで決定）' : '「プロテイン」を選択中（Bで決定）';
    });
  }

  void _pressB() {
    if (_eating) return;
    if (_menuIndex < 0) {
      setState(() => _current.lastEvent = 'Aボタンでメニューを選んでください');
      return;
    }
    _feed(_menuIndex == 0 ? FoodKind.meat : FoodKind.protein);
  }

  void _pressC() {
    if (_eating) return;
    if (_menuIndex >= 0) {
      setState(() {
        _menuIndex = -1;
        _current.lastEvent = 'キャンセルしました';
      });
    }
  }

  // ---- デバッグ ---------------------------------------------------------------

  void _skipTime(Duration delta, String label) {
    setState(() {
      _current.startedAt = _current.startedAt.subtract(delta);
      _current.nextHungerDecayAt = _current.nextHungerDecayAt.subtract(delta);
      _current.nextStrengthDecayAt =
          _current.nextStrengthDecayAt.subtract(delta);
      _current.lastEvent = '$label 時間を進めました';
      _updateStageByTime();
      _updateNeedsByTime();
    });
  }

  void _resetTime() {
    setState(() {
      _eatTimer?.cancel();
      _eatTimer = null;
      _eating = false;
      _eatingFood = null;
      _menuIndex = -1;
      final now = DateTime.now();
      _current.startedAt = now;
      _current.stage = milestones.first.stage;
      _current.hunger = maxHearts;
      _current.strength = maxHearts;
      _current.nextHungerDecayAt = now.add(hungerDecayInterval);
      _current.nextStrengthDecayAt = now.add(strengthDecayInterval);
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
    if (!_isEgg && _current.hunger == 0) return 'おなかがすいています！';
    if (!_isEgg && _current.strength == 0) return '元気がありません！';
    if (_isFinalStage) return '最終段階に到達しました';
    final remaining = _current.nextEvolutionAt.difference(DateTime.now());
    return '次の進化まで ${formatRemaining(remaining)}';
  }

  String? get _menuLabel {
    if (_menuIndex == 0) return '▶ ごはん';
    if (_menuIndex == 1) return '▶ プロテイン';
    return null;
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
                    _DeviceBody(
                      stage: _current.stage,
                      idleShift: _idleShift,
                      eating: _eating,
                      eatFrame: _eatFrame,
                      eatingFood: _eatingFood,
                      menuLabel: _menuLabel,
                      needsCare: !_isEgg &&
                          (_current.hunger == 0 || _current.strength == 0),
                      onPressA: _pressA,
                      onPressB: _pressB,
                      onPressC: _pressC,
                    ),
                    const SizedBox(height: 14),
                    _InfoPanel(
                      visible: _panelVisible,
                      stage: _current.stage,
                      hunger: _current.hunger,
                      strength: _current.strength,
                      isEgg: _isEgg,
                      remainingText: _remainingText,
                      onToggle: () => setState(() => _panelVisible = !_panelVisible),
                      onFeedMeat: () => _feed(FoodKind.meat),
                      onFeedProtein: () => _feed(FoodKind.protein),
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
  const _DeviceBody({
    required this.stage,
    required this.idleShift,
    required this.eating,
    required this.eatFrame,
    required this.eatingFood,
    required this.menuLabel,
    required this.needsCare,
    required this.onPressA,
    required this.onPressB,
    required this.onPressC,
  });

  final String stage;
  final bool idleShift;
  final bool eating;
  final int eatFrame;
  final FoodKind? eatingFood;
  final String? menuLabel;
  final bool needsCare;
  final VoidCallback onPressA;
  final VoidCallback onPressB;
  final VoidCallback onPressC;

  @override
  Widget build(BuildContext context) {
    final (:sprite, :offsetX, :offsetY) = spriteForStage(stage);

    Widget screen;
    if (eating && eatingFood != null) {
      // 食事シーン: 左に食べ物、右にデジモン（縮小表示）。
      // 専用の食事ドット絵が無いため、デジモン本体を1ドット分
      // 前後（食べ物側とその逆）に往復させて食べている様子を表現する。
      final foodStage = (eatFrame ~/ 3).clamp(0, 2);
      final foodSprite = eatingFood == FoodKind.meat
          ? meatSprites[foodStage]
          : proteinSprites[foodStage];
      final sway = eatFrame.isOdd ? -8 : 0; // 1ドット（8px）食べ物側へ
      screen = Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: SpritePainter(
                sprite: foodSprite,
                offsetX: 4,
                offsetY: 124,
                dotSize: 8,
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: SpritePainter(
                sprite: sprite,
                offsetX: 66 + sway,
                offsetY: 58,
                dotSize: 8,
              ),
            ),
          ),
        ],
      );
    } else {
      // 通常シーン: 1秒ごとに1ドット分左右へ揺れて生きている様子を表現する。
      final shift = (!eating && stage != 'Digitama' && idleShift) ? 11 : 0;
      screen = CustomPaint(
        size: const Size(200, 200),
        painter: SpritePainter(
          sprite: sprite,
          offsetX: offsetX + shift,
          offsetY: offsetY,
        ),
      );
    }

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
                  child: Stack(
                    children: [
                      SizedBox.expand(child: screen),
                      if (menuLabel != null)
                        Positioned(
                          top: 6,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              color: const Color(0xFF111827),
                              child: Text(
                                menuLabel!,
                                style: const TextStyle(
                                  color: Color(0xFFEEE7E0),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (needsCare)
                        const Positioned(
                          top: 4,
                          right: 6,
                          child: Text(
                            '!',
                            style: TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                    ],
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
                _LegacyButton(label: 'A', hint: 'えらぶ', onPressed: onPressA),
                const SizedBox(width: 8),
                _LegacyButton(label: 'B', hint: 'けってい', onPressed: onPressB),
                const SizedBox(width: 8),
                _LegacyButton(label: 'C', hint: 'キャンセル', onPressed: onPressC),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegacyButton extends StatelessWidget {
  const _LegacyButton({
    required this.label,
    required this.hint,
    required this.onPressed,
  });
  final String label;
  final String hint;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: hint,
      child: GestureDetector(
        onTap: onPressed,
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
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.visible,
    required this.stage,
    required this.hunger,
    required this.strength,
    required this.isEgg,
    required this.remainingText,
    required this.onToggle,
    required this.onFeedMeat,
    required this.onFeedProtein,
    required this.onSkip10s,
    required this.onSkip10m,
    required this.onSkip6h,
    required this.onReset,
  });

  final bool visible;
  final String stage;
  final int hunger;
  final int strength;
  final bool isEgg;
  final String remainingText;
  final VoidCallback onToggle;
  final VoidCallback onFeedMeat;
  final VoidCallback onFeedProtein;
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
              '時間の経過にあわせて進化していくデジモンを育てられます。'
              'おなかがすいたら「ごはん」、元気がなくなったら「プロテイン」をあげましょう。'
              '本体のAボタンでメニューを選び、Bボタンで決定、Cボタンでキャンセルできます。',
              style: TextStyle(
                color: Color(0xFF0F172A),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            _StatusCards(
              stage: stage,
              hunger: hunger,
              strength: strength,
              isEgg: isEgg,
              remainingText: remainingText,
            ),
            const SizedBox(height: 14),
            const Text(
              'お世話',
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
                _SecondaryButton(label: 'ごはん（おにく）', onPressed: onFeedMeat),
                _SecondaryButton(label: 'プロテイン', onPressed: onFeedProtein),
              ],
            ),
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
  const _StatusCards({
    required this.stage,
    required this.hunger,
    required this.strength,
    required this.isEgg,
    required this.remainingText,
  });
  final String stage;
  final int hunger;
  final int strength;
  final bool isEgg;
  final String remainingText;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _StatusCard(label: '成長段階', value: stage),
        _StatusCard(label: '満腹度', value: isEgg ? '−' : heartsText(hunger)),
        _StatusCard(label: '体力', value: isEgg ? '−' : heartsText(strength)),
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
    this.dotSize = 11,
  });

  final List<List<int>> sprite;
  final int offsetX;
  final int offsetY;
  final double dotSize;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF111827);
    for (var y = 0; y < sprite.length; y++) {
      for (var x = 0; x < sprite[y].length; x++) {
        if (sprite[y][x] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              offsetX + x * dotSize,
              offsetY + y * dotSize,
              dotSize - 1,
              dotSize - 1,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(SpritePainter old) =>
      old.sprite != sprite ||
      old.offsetX != offsetX ||
      old.offsetY != offsetY ||
      old.dotSize != dotSize;
}
