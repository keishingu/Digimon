import 'dart:html';

void main() {
  final app = querySelector('#app');
  if (app != null) {
    app.text = 'Dart is running ✅';
  }
}
