import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_book/public.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ts.dart';

class HooksExample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final counter = useLoggedState(0);
    final store = useMemoized(() => null);

    useEffect(() {
      return null;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('HooksExample'),
      ),
      body: Column(children: [
        buildCounter(counter, context),
        buildCustomHook(context),
        buildUseStream(context),
        OutlineButton(onPressed: () {
          AppNavigator.push(context, PopupMenu());
        }),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.value++,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildCounter(counter, context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 120,
      color: Colors.green,
      alignment: Alignment.center,
      child: Text('Button flotingButton ${counter.value} times'),
    );
  }

  Widget buildCustomHook(context) {
    final StreamController<int> countController =
        _useLocalStorageInt('counter');
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 120,
      color: Colors.blue,
      alignment: Alignment.center,
      child: HookBuilder(
        builder: (context) {
          final AsyncSnapshot<int> count = useStream(countController.stream);

          return !count.hasData
              ? const CircularProgressIndicator()
              : GestureDetector(
                  onTap: () => countController.add(count.data + 1),
                  child: Text('You onTap this Widget me ${count.data} times.'),
                );
        },
      ),
    );
  }

  Widget buildUseStream(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 120,
      color: Colors.orangeAccent,
      alignment: Alignment.center,
      child: HookBuilder(
        builder: (context) {
          // First, create and cache a Stream with the `useMemoized` hook.
          // This hook allows you to create an Object (such as a Stream or
          // Future) the first time this builder function is invoked without
          // recreating it on each subsequent build!
          final stream = useMemoized(
            () =>
                Stream<int>.periodic(const Duration(seconds: 1), (i) => i + 1),
          );
          // Next, invoke the `useStream` hook to listen for updates to the
          // Stream. This triggers a rebuild whenever a new value is emitted.
          //
          // Like normal StreamBuilders, it returns the current AsyncSnapshot.
          final snapshot = useStream(stream);

          // Finally, use the data from the Stream to render a text Widget.
          // If no data is available, fallback to a default value.
          return Text(
            '${snapshot.data ?? 0}',
            style: const TextStyle(fontSize: 36),
          );
        },
      ),
    );
  }
}

ValueNotifier<T> useLoggedState<T>([T initialData]) {
  // First, call the useState hook. It will create a ValueNotifier for you that
  // rebuilds the Widget whenever the value changes.
  final result = useState<T>(initialData);

  // Next, call the useValueChanged hook to print the state whenever it changes
  useValueChanged<T, void>(result.value, (_, __) {
    print(result.value);
  });

  return result;
}

StreamController<int> _useLocalStorageInt(
  String key, {
  int defaultValue = 0,
}) {
  // Custom hooks can use additional hooks internally!
  final controller = useStreamController<int>(keys: [key]);

  // Pass a callback to the useEffect hook. This function should be called on
  // first build and every time the controller or key changes
  useEffect(
    () {
      // Listen to the StreamController, and when a value is added, store it
      // using SharedPrefs.
      final sub = controller.stream.listen((data) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(key, data);
      });
      // Unsubscribe when the widget is disposed
      // or on controller/key change
      return sub.cancel;
    },
    // Pass the controller and key to the useEffect hook. This will ensure the
    // useEffect hook is only called the first build or when one of the the
    // values changes.
    [controller, key],
  );

  // Load the initial value from local storage and add it as the initial value
  // to the controller
  useEffect(
    () {
      SharedPreferences.getInstance().then((prefs) async {
        final int valueFromStorage = prefs.getInt(key);
        controller.add(valueFromStorage ?? defaultValue);
      }).catchError(controller.addError);
      return null;
    },
    // Pass the controller and key to the useEffect hook. This will ensure the
    // useEffect hook is only called the first build or when one of the the
    // values changes.
    [controller, key],
  );

  // Finally, return the StreamController. This allows users to add values from
  // the Widget layer and listen to the stream for changes.
  return controller;
}
