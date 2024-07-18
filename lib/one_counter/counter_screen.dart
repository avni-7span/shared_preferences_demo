import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final _instance = SharedPreferences.getInstance();
  late Future<int> counter;

  Future<void> incrementCounter() async {
    final prefInstance = await _instance;
    int count = (prefInstance.getInt('count') ?? 0) + 1;
    setState(() {
      counter = prefInstance.setInt('count', count).then((bool success) {
        if (kDebugMode) {
          print("success bool : $success");
        }
        return count;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    counter = _instance.then((pref) {
      return pref.getInt('count') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App / Shared Preferences'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pressed button this many times : ',
              style: TextStyle(fontSize: 20, color: Colors.lightBlueAccent),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: counter,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return Text(
                      snapshot.data.toString(),
                      style: const TextStyle(
                          fontSize: 20, color: Colors.lightBlueAccent),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
