import 'dart:async';
import 'dart:html';

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
  EvolutionMilestone('Baby I', Duration(seconds: 10)),
  EvolutionMilestone('Baby II', Duration(minutes: 10, seconds: 10)),
  EvolutionMilestone('Child', Duration(hours: 6, minutes: 10, seconds: 10)),
  EvolutionMilestone('Adult', Duration(hours: 30, minutes: 10, seconds: 10)),
  EvolutionMilestone('Perfect', Duration(hours: 66, minutes: 10, seconds: 10)),
];

const List<List<List<int>>> digitamaWaitingDots = [
  [
    [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0],
    [0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0],
    [0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0],
    [0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0],
    [0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0],
    [0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0],
    [0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0],
    [0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  ],
  [
    [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0],
    [0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1, 0, 0],
    [0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0],
    [0, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0],
    [0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0],
    [0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0],
    [0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0],
    [0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  ],
];

String formatRemaining(Duration duration) {
  if (duration.isNegative) return 'まもなく';
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  if (hours > 0) {
    return '${hours}時間${minutes}分';
  }
  if (minutes > 0) {
    return '${minutes}分${seconds}秒';
  }
  return '${seconds}秒';
}

void main() {
  final status = querySelector('#dart-status');
  final toggleButton = querySelector('#dart-toggle') as ButtonElement?;
  final legacyFeed = querySelector('#buttonA') as ButtonElement?;
  final legacyWait = querySelector('#buttonB') as ButtonElement?;
  final legacyShout = querySelector('#buttonC') as ButtonElement?;
  final panel = querySelector('#dart-panel');
  final canvas = querySelector('#sample') as CanvasElement?;
  final ctx = canvas?.context2D;

  final stageLabel = querySelector('#stat-stage');
  final hunger = querySelector('#stat-hunger');
  final vitality = querySelector('#stat-vitality');
  final mode = querySelector('#stat-mode');

  final now = DateTime.now();
  final current = MonsterState(
    stage: milestones.first.stage,
    startedAt: now,
    nextEvolutionAt: now.add(milestones[1].elapsed),
    mode: 'observe',
    lastEvent: '誕生しました',
  );

  int waitingFrame = 0;

  void drawDots(List<List<int>> dots, {int startX = 0, int startY = 0}) {
    if (ctx == null) return;
    ctx.fillStyle = '#111827';
    for (var y = 0; y < dots.length; y++) {
      for (var x = 0; x < dots[y].length; x++) {
        if (dots[y][x] == 1) {
          ctx.fillRect(startX + x * 11, startY + y * 11, 10, 10);
        }
      }
    }
  }

  void renderCurrentFrame() {
    if (ctx == null) return;
    ctx.clearRect(0, 0, 200, 200);
    drawDots(digitamaWaitingDots[waitingFrame % digitamaWaitingDots.length]);
    waitingFrame += 1;
  }

  void updateStageByTime() {
    final elapsed = DateTime.now().difference(current.startedAt);
    for (var i = milestones.length - 1; i >= 0; i--) {
      if (elapsed >= milestones[i].elapsed) {
        if (current.stage != milestones[i].stage) {
          current.stage = milestones[i].stage;
          current.lastEvent = '${milestones[i].stage}に進化しました';
        }
        final nextIndex = i + 1;
        if (nextIndex < milestones.length) {
          current.nextEvolutionAt = current.startedAt.add(milestones[nextIndex].elapsed);
        } else {
          current.nextEvolutionAt = current.startedAt.add(milestones.last.elapsed);
        }
        return;
      }
    }
  }

  void renderState([String? prefix]) {
    updateStageByTime();
    final remaining = current.nextEvolutionAt.difference(DateTime.now());
    stageLabel?.text = current.stage;
    hunger?.text = 'なし';
    vitality?.text = 'なし';
    mode?.text = formatRemaining(remaining);

    status?.text = prefix == null
        ? '${current.lastEvent} / 次の進化まで ${formatRemaining(remaining)}'
        : '$prefix / 次の進化まで ${formatRemaining(remaining)}';
  }

  legacyFeed
    ?..text = 'A'
    ..disabled = true
    ..title = '今回は観察モードです';
  legacyWait
    ?..text = 'B'
    ..disabled = true
    ..title = '今回は観察モードです';
  legacyShout
    ?..text = 'C'
    ..disabled = true
    ..title = '今回は観察モードです';

  var panelVisible = true;
  toggleButton?.onClick.listen((_) {
    panelVisible = !panelVisible;
    panel?.classes.toggle('collapsed', !panelVisible);
    toggleButton.text = panelVisible ? '表示切替' : '表示を戻す';
    renderState(panelVisible ? '情報を表示しています' : '情報を非表示にしました');
  });

  Timer.periodic(const Duration(seconds: 1), (_) {
    renderCurrentFrame();
    renderState();
  });

  renderCurrentFrame();
  renderState('観察を開始しました');
}
