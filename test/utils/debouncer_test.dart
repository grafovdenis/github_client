import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/utils/debouncer.dart';
import 'package:mocktail/mocktail.dart';

abstract class _Callback {
  const _Callback();

  void callback();
}

class MockCallback extends Mock implements _Callback {}

void main() {
  group('Debouncer', () {
    late Debouncer debouncer;
    late MockCallback mockCallback;

    setUp(() {
      debouncer = Debouncer(delay: const Duration(milliseconds: 500));
      mockCallback = MockCallback();
    });

    test('should not call callback', () {
      fakeAsync((async) {
        debouncer.call(mockCallback.callback);
        async.elapse(const Duration(milliseconds: 499));
        verifyNever(mockCallback.callback);
      });
    });

    test('should call callback', () {
      fakeAsync((async) {
        debouncer.call(mockCallback.callback);
        async.elapse(const Duration(milliseconds: 500));
        verify(mockCallback.callback);
      });
    });

    test('should call callback once', () {
      fakeAsync((async) {
        debouncer.call(mockCallback.callback);
        async.elapse(const Duration(milliseconds: 100));
        debouncer.call(mockCallback.callback);
        async.elapse(const Duration(milliseconds: 500));
        verify(mockCallback.callback).called(1);
      });
    });

    test('should call callback twice', () {
      fakeAsync((async) {
        debouncer.call(mockCallback.callback);
        async.elapse(const Duration(milliseconds: 500));
        debouncer.call(mockCallback.callback);
        async.elapse(const Duration(milliseconds: 500));
        verify(mockCallback.callback).called(2);
      });
    });

    test('should cancel the callback on dispose', () {
      fakeAsync((async) {
        debouncer.call(mockCallback.callback);
        async.elapse(const Duration(milliseconds: 100));
        debouncer.dispose();
        async.elapse(const Duration(milliseconds: 400));
        verifyNever(mockCallback.callback);
      });
    });
  });
}
