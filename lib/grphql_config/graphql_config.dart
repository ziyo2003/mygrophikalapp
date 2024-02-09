import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  final httplink = HttpLink('https://graphql.anilist.co');//->Graphql_api

GraphQLClient client() => GraphQLClient(
  cache: GraphQLCache(),
  link: httplink,
);

}