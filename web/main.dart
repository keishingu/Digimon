import 'dart:html';

class MonsterState {
  MonsterState({
    required this.stage,
    required this.hunger,
    required this.vitality,
    required this.mode,
    required this.lastAction,
    required this.actionCount,
  });

  String stage;
  int hunger;
  int vitality;
  String mode;
  String lastAction;
  int actionCount;
}

const List<List<List<int>>> meetDots = [
  [
    [0, 1, 1, 1, 0, 0, 0, 0],
    [1, 1, 1, 0, 1, 0, 0, 0],
    [1, 1, 1, 1, 0, 1, 0, 0],
    [1, 1, 1, 1, 1, 1, 0, 0],
    [0, 1, 1, 1, 0, 1, 0, 0],
    [0, 0, 1, 1, 1, 0, 1, 1],
    [0, 0, 0, 0, 0, 1, 0, 1],
    [0, 0, 0, 0, 0, 1, 1, 0],
  ],
  [
    [0, 1, 1, 0, 0, 0, 0, 0],
    [1, 0, 1, 1, 0, 0, 0, 0],
    [1, 1, 1, 1, 1, 1, 0, 0],
    [0, 1, 1, 1, 1, 1, 0, 0],
    [0, 1, 1, 1, 0, 1, 0, 0],
    [0, 0, 1, 1, 1, 0, 1, 1],
    [0, 0, 0, 0, 0, 1, 0, 1],
    [0, 0, 0, 0, 0, 1, 1, 0],
  ],
  [
    [0, 1, 1, 0, 0, 0, 0, 0],
    [1, 0, 1, 0, 0, 0, 0, 0],
    [1, 1, 0, 1, 0, 0, 0, 0],
    [0, 0, 1, 0, 1, 0, 0, 0],
    [0, 0, 0, 1, 0, 1, 0, 0],
    [0, 0, 0, 0, 1, 0, 1, 1],
    [0, 0, 0, 0, 0, 1, 0, 1],
    [0, 0, 0, 0, 0, 1, 1, 0],
  ],
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

const List<List<List<int>>> zurumonEatingDots = [
  [
    [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  ],
  [
    [0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  ],
];

void main() {
  final status = querySelector('#dart-status');
  final feedButton = querySelector('#dart-feed') as ButtonElement?;
  final toggleButton = querySelector('#dart-toggle') as ButtonElement?;
  final legacyFeed = querySelector('#buttonA') as ButtonElement?;
  final legacyWait = querySelector('#buttonB') as ButtonElement?;
  final legacyShout = querySelector('#buttonC') as ButtonElement?;
  final panel = querySelector('#dart-panel');
  final canvas = querySelector('#sample') as CanvasElement?;
  final ctx = canvas?.context2D;

  final stage = querySelector('#stat-stage');
  final hunger = querySelector('#stat-hunger');
  final vitality = querySelector('#stat-vitality');
  final mode = querySelector('#stat-mode');

  final current = MonsterState(
    stage: 'Digitama',
    hunger: 4,
    vitality: 4,
    mode: 'idle',
    lastAction: 'spawn',
    actionCount: 0,
  );

  int waitingFrame = 0;
  int feedFrame = 0;
  bool showShoutFlash = false;


  void drawDots(List<List<int>> dots, {int startX = 0, int startY = 0}) {
    if (ctx == null) return;
    for (var y = 0; y < dots.length; y++) {
      for (var x = 0; x < dots[y].length; x++) {
        if (dots[y][x] == 1) {
          ctx.fillRect(startX + x * 11, startY + y * 11, 10, 10);
        }
      }
    }
  }

  void renderWaitingFrame() {
    if (ctx == null) return;
    ctx.clearRect(0, 0, 200, 200);
    drawDots(digitamaWaitingDots[waitingFrame % digitamaWaitingDots.length]);
    waitingFrame += 1;
  }

  void renderFeedFrame() {
    if (ctx == null) return;
    ctx.clearRect(0, 0, 200, 200);
    drawDots(meetDots[feedFrame % meetDots.length], startX: 0, startY: 88);
    drawDots(zurumonEatingDots[feedFrame % zurumonEatingDots.length], startX: 66, startY: 0);
    feedFrame += 1;
  }

  void renderShoutFrame() {
    if (ctx == null) return;
    ctx.clearRect(0, 0, 200, 200);
    renderWaitingFrame();
    ctx
      ..fillStyle = showShoutFlash ? '#ef4444' : '#f59e0b'
      ..font = 'bold 28px sans-serif'
      ..fillText('!', 150, 40);
    showShoutFlash = !showShoutFlash;
  }


  void updateEvolution() {
    if (current.stage == 'Digitama' && current.actionCount >= 3) {
      current.stage = 'Zurumon';
      current.lastAction = 'evolve';
    }
  }

  void renderState([String? prefix]) {
    stage?.text = current.stage;
    hunger?.text = '${current.hunger} / 4';
    vitality?.text = '${current.vitality} / 4';
    mode?.text = '${current.mode}';

    status?.text = prefix == null
        ? '準備完了 / last: ${current.lastAction}'
        : '$prefix / last: ${current.lastAction}';
  }

  void applyAction(String action, String message) {
    switch (action) {
      case 'feed':
        current.mode = 'feed';
        current.hunger = current.hunger > 0 ? current.hunger - 1 : 0;
        current.lastAction = 'feed';
        current.actionCount += 1;
        renderFeedFrame();
        break;
      case 'wait':
        current.mode = 'wait';
        current.hunger = current.hunger < 4 ? current.hunger + 1 : 4;
        current.vitality = current.vitality > 0 ? current.vitality - 1 : 0;
        current.lastAction = 'wait';
        current.actionCount += 1;
        renderWaitingFrame();
        break;
      case 'shout':
        current.mode = 'shout';
        current.vitality = current.vitality < 4 ? current.vitality + 1 : 4;
        current.lastAction = 'shout';
        current.actionCount += 1;
        renderShoutFrame();
        break;
    }

    updateEvolution();
    renderState(message);
  }

  legacyFeed?.text = 'A';
  legacyWait?.text = 'B';
  legacyShout?.text = 'C';

  legacyFeed?.title = 'Feed (Dart renderer)';
  legacyWait?.title = 'Wait (Dart renderer)';
  legacyShout?.title = 'Shout (Dart renderer)';

  feedButton?.onClick.listen((_) => applyAction('feed', 'ごはんをあげました'));

  legacyFeed?.onClick.listen((_) => applyAction('feed', 'ごはんをあげました'));
  legacyWait?.onClick.listen((_) => applyAction('wait', 'ようすをみています'));
  legacyShout?.onClick.listen((_) => applyAction('shout', 'げんきを出しました'));

  var panelVisible = true;
  toggleButton?.onClick.listen((_) {
    panelVisible = !panelVisible;
    panel?.classes.toggle('collapsed', !panelVisible);
    toggleButton.text = panelVisible ? '表示切替' : '表示を戻す';
    renderState(panelVisible ? '情報を表示しています' : '情報を非表示にしました');
  });

  renderWaitingFrame();
  renderState('準備完了');
}
