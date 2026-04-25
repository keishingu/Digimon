import 'dart:html';
import 'dart:js_util' as js_util;

class MonsterState {
  MonsterState({
    required this.stage,
    required this.hunger,
    required this.vitality,
    required this.mode,
    required this.lastAction,
  });

  String stage;
  int hunger;
  int vitality;
  String mode;
  String lastAction;
}

void main() {
  final status = querySelector('#dart-status');
  final feedButton = querySelector('#dart-feed') as ButtonElement?;
  final toggleButton = querySelector('#dart-toggle') as ButtonElement?;
  final legacyFeed = querySelector('#buttonA') as ButtonElement?;
  final legacyWait = querySelector('#buttonB') as ButtonElement?;
  final legacyShout = querySelector('#buttonC') as ButtonElement?;
  final panel = querySelector('#dart-panel');

  final stage = querySelector('#stat-stage');
  final hunger = querySelector('#stat-hunger');
  final vitality = querySelector('#stat-vitality');
  final mode = querySelector('#stat-mode');

  final current = MonsterState(
    stage: 'Zurumon',
    hunger: 4,
    vitality: 4,
    mode: 'feed',
    lastAction: 'spawn',
  );

  Object? digimonApp() => js_util.getProperty<Object?>(window, 'digimonApp');

  void syncToJs() {
    final app = digimonApp();
    if (app == null) return;

    js_util.callMethod(app, 'setState', [
      js_util.jsify({
        'stage': current.stage,
        'hunger': current.hunger,
        'vitality': current.vitality,
        'mode': current.mode,
        'lastAction': current.lastAction,
      })
    ]);
  }

  void renderState([String? prefix]) {
    stage?.text = current.stage;
    hunger?.text = '${current.hunger} / 4';
    vitality?.text = '${current.vitality} / 4';
    mode?.text = current.mode;

    status?.text = prefix == null
        ? 'Dart ready ✅ / last: ${current.lastAction}'
        : '$prefix / last: ${current.lastAction}';
  }

  void applyAction(String action, String message) {
    switch (action) {
      case 'feed':
        current.mode = 'feed';
        current.hunger = current.hunger > 0 ? current.hunger - 1 : 0;
        current.lastAction = 'feed';
        break;
      case 'wait':
        current.mode = 'wait';
        current.hunger = current.hunger < 4 ? current.hunger + 1 : 4;
        current.vitality = current.vitality > 0 ? current.vitality - 1 : 0;
        current.lastAction = 'wait';
        break;
      case 'shout':
        current.mode = 'shout';
        current.vitality = current.vitality < 4 ? current.vitality + 1 : 4;
        current.lastAction = 'shout';
        break;
    }

    syncToJs();
    renderState(message);
  }

  void callApp(String method, String action, String message) {
    final app = digimonApp();
    if (app != null) {
      js_util.callMethod(app, method, []);
      applyAction(action, message);
    } else {
      status?.text = 'digimonApp not ready';
    }
  }

  legacyFeed?.text = 'A';
  legacyWait?.text = 'B';
  legacyShout?.text = 'C';

  legacyFeed?.title = 'Feed';
  legacyWait?.title = 'Wait';
  legacyShout?.title = 'Shout';

  feedButton?.onClick.listen((_) => callApp('showFeed', 'feed', 'Dart triggered feed animation 🍖'));

  legacyFeed?.onClick.listen((_) => applyAction('feed', 'Legacy button A / Feed'));
  legacyWait?.onClick.listen((_) => applyAction('wait', 'Legacy button B / Wait'));
  legacyShout?.onClick.listen((_) => applyAction('shout', 'Legacy button C / Shout'));

  var panelVisible = true;
  toggleButton?.onClick.listen((_) {
    panelVisible = !panelVisible;
    panel?.classes.toggle('collapsed', !panelVisible);
    toggleButton.text = panelVisible ? 'Dart表示 ON/OFF' : 'Dart表示を戻す';
    renderState(panelVisible ? 'Dart panel visible' : 'Dart panel hidden');
  });

  syncToJs();
  renderState('Dart ready ✅');
}
