import 'dart:async';
import 'dart:html';
import 'dart:js_util' as js_util;

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

  Object? digimonApp() => js_util.getProperty<Object?>(window, 'digimonApp');

  Map<String, dynamic>? getState() {
    final app = digimonApp();
    if (app == null) return null;
    final state = js_util.callMethod<Object?>(app, 'getState', []);
    if (state == null) return null;
    return {
      'stage': js_util.getProperty(state, 'stage'),
      'hunger': js_util.getProperty(state, 'hunger'),
      'vitality': js_util.getProperty(state, 'vitality'),
      'mode': js_util.getProperty(state, 'mode'),
      'lastAction': js_util.getProperty(state, 'lastAction'),
    };
  }

  void renderState([String? prefix]) {
    final current = getState();
    if (current == null) {
      status?.text = 'digimonApp not ready';
      return;
    }

    stage?.text = '${current['stage']}';
    hunger?.text = '${current['hunger']} / 4';
    vitality?.text = '${current['vitality']} / 4';
    mode?.text = '${current['mode']}';

    status?.text = prefix == null
        ? 'Dart ready ✅ / last: ${current['lastAction']}'
        : '$prefix / last: ${current['lastAction']}';
  }

  void callApp(String method, String message) {
    final app = digimonApp();
    if (app != null) {
      js_util.callMethod(app, method, []);
      renderState(message);
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

  feedButton?.onClick.listen((_) => callApp('showFeed', 'Dart triggered feed animation 🍖'));

  legacyFeed?.onClick.listen((_) => Future.microtask(() => renderState('Legacy button A / Feed')));
  legacyWait?.onClick.listen((_) => Future.microtask(() => renderState('Legacy button B / Wait')));
  legacyShout?.onClick.listen((_) => Future.microtask(() => renderState('Legacy button C / Shout')));

  var panelVisible = true;
  toggleButton?.onClick.listen((_) {
    panelVisible = !panelVisible;
    panel?.classes.toggle('collapsed', !panelVisible);
    toggleButton.text = panelVisible ? 'Dart表示 ON/OFF' : 'Dart表示を戻す';
    renderState(panelVisible ? 'Dart panel visible' : 'Dart panel hidden');
  });

  Timer.periodic(const Duration(seconds: 2), (_) => renderState());
  renderState('Dart ready ✅');
}
