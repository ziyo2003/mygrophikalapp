import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mygrophikalapp/wrefresh.dart';
import 'package:smartrefresh/smartrefresh.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/animemodel2.dart';

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
              query  {
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
  Media {
    id
    idMal
    type
    format
    status
    description
    
     
    season
    seasonYear
    
    episodes
    duration
    chapters
    volumes
    countryOfOrigin
    isLicensed
    source
    hashtag
    trailer {
      thumbnail
      site
      id
    }
    updatedAt
    coverImage {
      large
    }
    bannerImage
    genres
    synonyms
    averageScore
    meanScore
    popularity
    isLocked
    trending
    favourites
    isFavourite
    isFavouriteBlocked
    isAdult
    siteUrl
    autoCreateForumThread
    isRecommendationBlocked
    isReviewBlocked
    modNotes
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
                  final media = medias[index]; // Assuming `medias` is a list of your GraphQL data objects.

                  return Card( // Use Card for better UI structuring.
                    margin: EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      title: Text('${media.title?.english ?? ""} - ${media.title?.native ?? ""}'),
                      subtitle: Text(media.format ?? ""),
                      leading: media.coverImage?.large != null ? Image.network(media.coverImage!.large!) : null,
                      children: <Widget>[
                        ListTile(
                          title: Text("Description"),
                          subtitle: Text(media.description ?? "No description available."),
                        ),
                        ListTile(
                          title: Text("Details"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Type: ${media.type ?? "N/A"}"),
                              Text("Format: ${media.format ?? "N/A"}"),
                              Text("Status: ${media.status ?? "N/A"}"),
                              Text("Season: ${media.season ?? "N/A"}, ${media.seasonYear ?? ""}"),
                              Text("Episodes: ${media.episodes ?? "N/A"}"),
                              Text("Duration: ${media.duration ?? "N/A"} min"),
                              // Add more fields as needed
                            ],
                          ),
                        ),
                        ListTile(
                          title: Text("Genres"),
                          subtitle: Text(media.genres?.join(', ') ?? "No genres available."),
                        ),
                        if (media.siteUrl != null)
                          ListTile(
                            title: Text("Website"),
                            subtitle: InkWell(
                              child: Text(media.siteUrl!, style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                              onTap: () async {
                                if (await canLaunchUrl(Uri.parse(media.siteUrl!))) {
                                  await launchUrl(Uri.parse(media.siteUrl!));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not launch ${media.siteUrl}')));
                                }
                              },
                            ),
                          ),
                        // Consider adding more ListTiles for additional fields as needed.
                      ],
                    ),
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