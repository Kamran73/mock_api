import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'network_client.g.dart';

@RestApi()
abstract class NetworkClient {
  factory NetworkClient(Dio dio, {String? baseUrl}) = _NetworkClient;

  @GET('/jokes/ten')
  Future<List<Joke>> getJokes();
}

@JsonSerializable()
class Joke {
  const Joke({
    required this.id,
    required this.type,
    required this.setup,
    required this.punchline,
  });

  factory Joke.fromJson(Map<String, dynamic> json) => _$JokeFromJson(json);

  final int id;
  final String type;
  final String setup;
  final String punchline;

  Map<String, dynamic> toJson() => _$JokeToJson(this);
}
