import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  late FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    driver.close();
  });

  group('Counter App', () {
    final counterTextFinder = find.byValueKey('counter');
    final buttonFinder = find.byValueKey('increment');

    test('starts at 0', () async {
      expect(await driver.getText(counterTextFinder), "0");
    });

    test('increments the counter', () async {
      await driver.tap(buttonFinder);
      expect(await driver.getText(counterTextFinder), "1");
    });

    test('increments the counter during animation', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(buttonFinder);
        expect(await driver.getText(counterTextFinder), "2");
      });
    });
  });

  group('your module', () {
    final counterTextFinder = find.byValueKey('counter');
    test('starts at 0', () async {
      expect(await driver.getText(counterTextFinder), "0");
    });

    test('starts at 1', () async {
      expect(await driver.getText(counterTextFinder), "0");
    }, skip: 'test skip demo', tags: 'TAG1');
    print(testOutputsDirectory);
  }, tags: 'G-1', retry: 2);
}
