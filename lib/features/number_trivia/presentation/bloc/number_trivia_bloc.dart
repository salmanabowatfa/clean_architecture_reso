import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clean_architecture_reso/core/error/failure.dart';
import 'package:clean_architecture_reso/core/usecases/usecase.dart';
import 'package:clean_architecture_reso/core/util/input_converter.dart';
import 'package:clean_architecture_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_reso/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_reso/features/number_trivia/domain/usecases/get_rendom_number_trivia.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - the number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(_getTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_getTriviaForRandomNumber);
  }

  // الكال باك بتاخد يوس كيس
  //بالبلوك بعمل لوجيك الستيت

  Future<void> _getTriviaForConcreteNumber(
      GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) async {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);
    await inputEither.fold(
      (failure) async {
        emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));
      },
      (integer) async {
        emit(Loading());
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        emit(_mapFailureOrTriviaToState(failureOrTrivia));
      },
    );
    // emit(_mapFailureOrTriviaToState(inputEither));
  }

  Future<void> _getTriviaForRandomNumber(
      GetTriviaForRandomNumber event, Emitter<NumberTriviaState> emit) async {
    emit(Loading());
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    emit(_mapFailureOrTriviaToState(failureOrTrivia));
  }

  NumberTriviaState _mapFailureOrTriviaToState(
      Either<Failure, NumberTrivia> either) {
    return either.fold(
        (failure) => Error(message: _MapFailureToMessage(failure)),
        (trivia) => Loaded(trivia: trivia));
  }

  String _MapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE;
      default:
        return "UnExpected Error";
    }
  }
}
