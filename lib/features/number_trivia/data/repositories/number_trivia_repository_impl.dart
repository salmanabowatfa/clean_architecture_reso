import 'package:clean_architecture_reso/core/error/exceptions.dart';
import 'package:clean_architecture_reso/core/error/failure.dart';
import 'package:clean_architecture_reso/core/platform/network_info.dart';
import 'package:clean_architecture_reso/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_reso/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_reso/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_reso/features/number_trivia/domain/repositories/number_trivia_reopsitory.dart';
import 'package:dartz/dartz.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTrivia> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaReopsitory {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

//we make this function to dont rewrite the same cofe for two previous functions threre was just one differ between him (getConcrete(number)     or getRandom() لتصغير الكود وعدم تكراره)

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia as NumberTriviaModel);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      final localTrivia = await localDataSource.getLastNumberTrivia();
      return Right(localTrivia);
    }
  }
}
