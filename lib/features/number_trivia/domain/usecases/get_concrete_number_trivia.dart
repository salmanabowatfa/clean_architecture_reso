import 'package:clean_architecture_reso/core/error/failure.dart';
import 'package:clean_architecture_reso/core/usecases/usecase.dart';
import 'package:clean_architecture_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_reso/features/number_trivia/domain/repositories/number_trivia_reopsitory.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetConcreteNumberTrivia extends Usecase<NumberTrivia, Params> {
  final NumberTriviaReopsitory reopsitory;

  GetConcreteNumberTrivia(this.reopsitory);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await reopsitory.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({required this.number});

  @override
  List<Object?> get props => [number];
}
