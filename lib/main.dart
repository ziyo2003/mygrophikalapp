import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mygrophikalapp/search_country.dart';

import 'anime.dart';
import 'grphql_config/graphql_config.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  final service = GraphQLService();
  runApp(MyApp(client: ValueNotifier(service.client()),
  ));
}

class MyApp extends StatelessWidget {

  final ValueNotifier<GraphQLClient>? client;

  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnimeListPage(),
      ),
    );
  }
}

