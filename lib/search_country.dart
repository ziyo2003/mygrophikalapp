import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mygrophikalapp/models/countrymodel.dart';

class SearchCountry extends StatefulWidget {
  const SearchCountry({super.key});

  @override
  State<SearchCountry> createState() => _SearchCountryState();
}

class _SearchCountryState extends State<SearchCountry> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.all(30.0),
            child: TextField(controller: controller,
            onEditingComplete: (){
              setState(() {

              });
            },
            ),
          ),
          Query(
            options: QueryOptions(document:  gql('''
            query Query {
                  country(code: "${controller.text}") {
                    name
                    native
                    capital
                    emoji
                    currency
                    languages {
                      code
                      name
                    }
                  }
                }
            ''')),
            builder: (result, {refetch,fetchMore}){
              if(result.hasException){
                return const Expanded(
                  child: Center(
                    child: Text(
                        "nimadur hato ketdi"
                    ),
                  ),
                );
              }
              if(result.isLoading){
                return const Expanded(
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              }
              print(result.data);
              final data = CountryClass.fromJson(result.data?['country'] ?? {});
              return Expanded(child: Text('$data'));
            }
          ),
        ],
      ),
    );
  }
}
