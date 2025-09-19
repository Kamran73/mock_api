import 'package:flutter/material.dart';
import 'package:mock_api/api_client/api_client.dart';
import 'package:mock_api/api_client/network_client/network_client.dart';
import 'package:mock_api/extensions/context_ext.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mock API Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dioClient = ApiClient();
  late final networkClient = NetworkClient(dioClient.dio);

  late Future<List<Joke>> getJokes = networkClient.getJokes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                getJokes = networkClient.getJokes();
              });
            },
            icon: Icon(Icons.refresh),
          ),
        ],
        centerTitle: true,
        title: Text('Mock Api Test', style: context.textTheme.headlineMedium),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: FutureBuilder<List<Joke>>(
          future: getJokes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              debugPrint('error is ${snapshot.error}');
              return Center(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      getJokes = networkClient.getJokes();
                    });
                  },
                  icon: Icon(Icons.refresh),
                ),
              );
            }

            if (snapshot.hasData) {
              final jokes = [...?snapshot.data];
              return ListView.builder(
                itemCount: jokes.length,
                itemBuilder: (_, index) {
                  final joke = jokes[index];
                  return Card(
                    child: ListTile(
                      title: Text(joke.setup),
                      subtitle: Text(joke.punchline),
                    ),
                  );
                },
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
