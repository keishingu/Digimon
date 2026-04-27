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
  EvolutionMilestone('Zurumon', Duration(seconds: 10)),
  EvolutionMilestone('Pagumon', Duration(minutes: 10, seconds: 10)),
  EvolutionMilestone('Gazimon', Duration(hours: 6, minutes: 10, seconds: 10)),
  EvolutionMilestone('DarkTyrannomon', Duration(hours: 30, minutes: 10, seconds: 10)),
  EvolutionMilestone('MetalTyrannomon', Duration(hours: 66, minutes: 10, seconds: 10)),
];

const List<List<int>> digitamaSprite = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0],[0,0,0,0,0,1,1,0,1,0,1,0,0,0,0,0],[0,0,0,0,1,0,1,0,1,1,0,1,0,0,0,0],[0,0,0,1,0,1,1,0,0,1,0,0,1,0,0,0],[0,0,0,1,0,1,0,0,0,1,1,0,1,0,0,0],[0,0,1,0,0,1,0,0,1,1,1,0,0,1,0,0],[0,0,1,0,1,1,0,0,1,0,1,1,0,1,0,0],[0,0,1,0,1,0,0,0,1,0,0,1,0,1,0,0],[0,0,1,0,1,0,0,0,1,0,0,1,0,1,0,0],[0,0,0,1,1,0,0,1,0,0,1,1,1,0,0,0],[0,0,0,0,1,1,1,1,0,0,1,1,0,0,0,0],[0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0]];
const List<List<int>> zurumonSprite = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,1,0,1,1,0,0,0,0,0],[0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0],[0,0,0,0,0,1,1,0,1,1,1,1,0,0,0,0],[0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0]];
const List<List<int>> pagumonSprite = [[0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0],[0,0,1,0,1,1,1,1,1,1,0,0,1,1,0,0],[0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0],[1,0,1,0,0,0,0,0,0,0,1,0,0,0,0,1],[1,0,1,0,1,0,0,0,1,0,0,1,0,0,0,1],[1,0,1,0,1,0,0,0,1,0,0,0,1,0,0,1],[0,1,1,0,0,0,1,0,0,0,0,0,0,1,1,0],[0,0,1,0,0,1,0,1,0,0,0,0,0,1,0,0],[0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0]];
const List<List<int>> gazimonSprite = [[0,0,0,0,1,1,1,1,1,1,0,1,1,0,0,0],[0,0,0,1,1,1,1,1,1,1,1,0,1,0,0,0],[0,0,0,1,1,1,1,0,0,1,1,1,0,0,0,0],[0,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0],[1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0],[1,1,1,1,1,0,1,1,1,1,1,1,1,0,0,0],[0,1,0,0,0,0,0,1,1,1,1,1,1,1,1,0],[0,0,1,1,1,1,1,1,1,1,1,1,1,0,1,0],[0,0,0,0,0,1,1,1,0,0,1,1,1,1,1,0],[0,0,1,0,1,1,1,0,1,1,1,1,1,1,0,0],[0,1,1,0,1,1,1,0,1,1,1,1,0,1,0,1],[0,1,1,0,1,1,1,1,0,0,0,0,1,1,1,1],[0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1],[0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0],[0,1,0,1,1,1,1,1,1,1,0,1,0,1,0,1],[0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1]];
const List<List<int>> darkTyrannomonSprite = [[0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0],[0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0],[0,1,0,0,0,0,1,1,0,0,0,0,1,0,0,0],[1,0,0,0,0,1,0,1,1,0,0,0,0,1,0,0],[1,0,0,0,0,0,1,1,1,0,0,0,0,1,0,0],[0,1,1,1,1,0,0,0,0,0,1,0,0,1,0,0],[0,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0],[0,0,1,1,1,1,0,0,1,1,0,0,1,0,0,0],[0,1,0,0,1,0,0,1,0,0,0,0,0,1,0,0],[0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1],[0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1],[0,0,1,1,1,1,0,0,0,1,0,0,1,0,1,0],[0,1,0,1,0,1,1,1,1,0,1,0,0,1,0,0],[0,1,1,1,1,1,1,0,1,1,1,1,1,1,0,0]];
const List<List<int>> metalTyrannomonSprite = [[0,0,0,0,1,1,1,1,1,1,0,1,1,0,0,0],[0,0,0,1,1,1,1,0,0,1,1,0,1,0,0,0],[0,1,1,1,1,1,0,0,1,1,1,1,0,0,0,0],[1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0],[1,1,1,1,1,0,1,1,1,1,0,1,0,1,0,0],[0,1,0,0,0,0,0,1,1,1,0,1,1,0,0,0],[0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,0],[0,0,0,0,1,0,1,1,0,1,0,1,1,0,1,0],[0,0,0,1,0,0,1,1,0,0,1,1,1,1,1,0],[0,1,0,1,1,0,0,0,1,1,1,1,0,1,0,0],[1,1,0,1,1,1,0,0,1,1,1,1,0,1,0,1],[1,1,0,1,1,0,0,0,0,0,0,0,1,1,1,1],[0,0,0,0,1,1,0,1,0,1,1,0,0,0,1,1],[0,1,1,1,0,1,1,0,1,1,1,1,1,1,1,0],[1,0,1,1,1,0,1,1,1,1,0,1,0,1,0,1],[1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1]];

String formatRemaining(Duration duration) {
  if (duration.isNegative) return 'まもなく';
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  if (hours > 0) return '${hours}時間${minutes}分';
  if (minutes > 0) return '${minutes}分${seconds}秒';
  return '${seconds}秒';
}

void main() {
  final status = querySelector('#dart-status');
  final toggleButton = querySelector('#dart-toggle') as ButtonElement?;
  final plus10s = querySelector('#debug-plus-10s') as ButtonElement?;
  final plus10m = querySelector('#debug-plus-10m') as ButtonElement?;
  final plus6h = querySelector('#debug-plus-6h') as ButtonElement?;
  final resetTime = querySelector('#debug-reset-time') as ButtonElement?;
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

  final initialStart = DateTime.now();
  final current = MonsterState(
    stage: milestones.first.stage,
    startedAt: initialStart,
    nextEvolutionAt: initialStart.add(milestones[1].elapsed),
    mode: 'observe',
    lastEvent: '誕生しました',
  );

  int frame = 0;

  void drawSprite(List<List<int>> dots, {int offsetX = 0, int offsetY = 0}) {
    if (ctx == null) return;
    ctx.fillStyle = '#111827';
    for (var y = 0; y < dots.length; y++) {
      for (var x = 0; x < dots[y].length; x++) {
        if (dots[y][x] == 1) {
          ctx.fillRect(offsetX + x * 11, offsetY + y * 11, 10, 10);
        }
      }
    }
  }

  void renderCurrentFrame() {
    if (ctx == null) return;
    ctx.clearRect(0, 0, 200, 200);
    switch (current.stage) {
      case 'Digitama':
        drawSprite(digitamaSprite, offsetX: 18, offsetY: 18);
        break;
      case 'Zurumon':
        drawSprite(zurumonSprite, offsetX: 12, offsetY: 18);
        break;
      case 'Pagumon':
        drawSprite(pagumonSprite, offsetX: 12, offsetY: 18);
        break;
      case 'Gazimon':
        drawSprite(gazimonSprite, offsetX: 8, offsetY: 18);
        break;
      case 'DarkTyrannomon':
        drawSprite(darkTyrannomonSprite, offsetX: 8, offsetY: 18);
        break;
      case 'MetalTyrannomon':
        drawSprite(metalTyrannomonSprite, offsetX: 8, offsetY: 18);
        break;
      default:
        drawSprite(digitamaSprite, offsetX: 18, offsetY: 18);
        break;
    }
    frame += 1;
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
    mode?.text = current.stage == milestones.last.stage ? '最終段階' : formatRemaining(remaining);
    final summary = current.stage == milestones.last.stage
        ? '最終段階に到達しました'
        : '次の進化まで ${formatRemaining(remaining)}';
    status?.text = prefix == null ? '${current.lastEvent} / $summary' : '$prefix / $summary';
  }

  void skipTime(Duration delta, String label) {
    current.startedAt = current.startedAt.subtract(delta);
    current.lastEvent = '$label 時間を進めました';
    renderState(current.lastEvent);
    renderCurrentFrame();
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

  plus10s?.onClick.listen((_) => skipTime(const Duration(seconds: 10), '+10秒'));
  plus10m?.onClick.listen((_) => skipTime(const Duration(minutes: 10), '+10分'));
  plus6h?.onClick.listen((_) => skipTime(const Duration(hours: 6), '+6時間'));
  resetTime?.onClick.listen((_) {
    current.startedAt = DateTime.now();
    current.stage = milestones.first.stage;
    current.lastEvent = '時間をリセットしました';
    renderState(current.lastEvent);
    renderCurrentFrame();
  });

  Timer.periodic(const Duration(seconds: 1), (_) {
    renderState();
    renderCurrentFrame();
  });

  renderState('観察を開始しました');
  renderCurrentFrame();
}
