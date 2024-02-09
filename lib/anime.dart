import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mygrophikalapp/wrefresh.dart';
import 'package:smartrefresh/smartrefresh.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/animemodel.dart';

class AnimeListPage extends StatefulWidget {
  const AnimeListPage({super.key});

  @override
  State<AnimeListPage> createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  var animeList = <Media>[];
  final controller = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Cartoon'),
      ),
      body: Wrefresher(
        controller: controller,
        onRefresh: () {
          setState(() {

          });
          controller.refreshCompleted();
        },
        child: Query(
            options: QueryOptions(
              document: gql('''
              {
                  Page {
                    media {
                      siteUrl
                      title {
                        english
                        native
                      }
                      description
                    }
                  }
                }

              '''),
            ),
            builder: (result, {refetch, fetchMore}) {
              if (result.hasException) {
                return Center(
                  child: Text("Nimadir hato berdi!"),
                );
              }
              if (result.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              print(result.data);
              final medias = (result.data?['Page']['media'] as List?)
                  ?.map(
                    (media) => Media.fromJson(
                  media ?? {},
                ),
              ).toList() ?? [];
              return ListView.separated(
                itemBuilder: (_, index) {
                  return ExpansionTile(
                    title: Text('${medias[index].title?.english} - ${medias[index].title?.native}'),
                    children: [
                      Row(
                        children: [
                          Text("Website"),
                          GestureDetector(
                            onTap: () async {
                              final url = medias[index].siteUrl!;
                              if (await canLaunchUrl(Uri.parse(url))) { // Ensure the URL is non-null and correctly parsed
                                await launchUrl(Uri.parse(url));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Could not launch $url')),
                                );
                              }
                            },
                            child: Text(
                              ' ${medias[index].siteUrl} ',
                              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        "${medias[index].description}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                      ),
                    ],
                  );
                },

                separatorBuilder: (_, __) => SizedBox(
                  height: 12,
                ),
                itemCount: medias.length,
              );
            }),
      ),
    );
  }
}