import 'dart:convert';
import 'package:clean_architecture_reso/core/error/exceptions.dart';
import 'package:clean_architecture_reso/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTrivia> getConcreteNumberTrivia(int number);
  Future<NumberTrivia> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTrivia> getRandomNumberTrivia() =>
      _getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  // Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     return NumberTriviaModel.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw ServerException();
  //   }
  // }
}
