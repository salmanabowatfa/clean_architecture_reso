import 'package:clean_architecture_reso/core/error/failure.dart';
import 'package:clean_architecture_reso/core/usecases/usecase.dart';
import 'package:clean_architecture_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_reso/features/number_trivia/domain/repositories/number_trivia_reopsitory.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTrivia extends Usecase<NumberTrivia, NoParams> {
  final NumberTriviaReopsitory reopsitory;

  GetRandomNumberTrivia(this.reopsitory);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await reopsitory.getRandomNumberTrivia();
  }
}
