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

  void setStatus(String message) {
    final digimonApp = js_util.getProperty<Object?>(window, 'digimonApp');
    final mode = digimonApp == null
        ? null
        : js_util.callMethod<String>(digimonApp, 'getCurrentMode', []);
    status?.text = mode == null ? message : '$message / mode: $mode';
  }

  void callApp(String method, String message) {
    final digimonApp = js_util.getProperty<Object?>(window, 'digimonApp');
    if (digimonApp != null) {
      js_util.callMethod(digimonApp, method, []);
      setStatus(message);
    } else {
      status?.text = 'digimonApp not ready';
    }
  }

  status?.text = 'Dart ready ✅';

  legacyFeed?.text = 'A';
  legacyWait?.text = 'B';
  legacyShout?.text = 'C';

  legacyFeed?.title = 'Feed';
  legacyWait?.title = 'Wait';
  legacyShout?.title = 'Shout';

  feedButton?.onClick.listen((_) => callApp('showFeed', 'Dart triggered feed animation 🍖'));

  legacyFeed?.onClick.listen((_) => setStatus('Legacy button A / Feed'));
  legacyWait?.onClick.listen((_) => setStatus('Legacy button B / Wait'));
  legacyShout?.onClick.listen((_) => setStatus('Legacy button C / Shout'));

  var panelVisible = true;
  toggleButton?.onClick.listen((_) {
    panelVisible = !panelVisible;
    panel?.classes.toggle('collapsed', !panelVisible);
    toggleButton.text = panelVisible ? 'Dart表示 ON/OFF' : 'Dart表示を戻す';
    setStatus(panelVisible ? 'Dart panel visible' : 'Dart panel hidden');
  });

  setStatus('Dart ready ✅');
}
