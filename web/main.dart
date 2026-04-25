import 'dart:html';
import 'dart:js_util' as js_util;

void main() {
  final status = querySelector('#dart-status');
  final feedButton = querySelector('#dart-feed') as ButtonElement?;
  final toggleButton = querySelector('#dart-toggle') as ButtonElement?;
  final panel = querySelector('#dart-panel');

  status?.text = 'Dart ready ✅';

  feedButton?.onClick.listen((_) {
    final digimonApp = js_util.getProperty<Object?>(window, 'digimonApp');
    if (digimonApp != null) {
      js_util.callMethod(digimonApp, 'showFeed', []);
      status?.text = 'Dart triggered feed animation 🍖';
    } else {
      status?.text = 'digimonApp not ready';
    }
  });

  var panelVisible = true;
  toggleButton?.onClick.listen((_) {
    panelVisible = !panelVisible;
    panel?.classes.toggle('collapsed', !panelVisible);
    toggleButton.text = panelVisible ? 'Dart表示 ON/OFF' : 'Dart表示を戻す';
    status?.text = panelVisible ? 'Dart panel visible' : 'Dart panel hidden';
  });
}
