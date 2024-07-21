import 'package:clean_architecture_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_reso/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture_reso/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:clean_architecture_reso/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:clean_architecture_reso/features/number_trivia/presentation/widgets/trivia_controls.dart';
import 'package:clean_architecture_reso/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade800,
        title: const Text(
          'Number Trivia',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return const MessageDisplay(message: 'start searching!');
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(numberTrivia: state.trivia);
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  }
                  return Container();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}



class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaDisplay({
    super.key,
    required this.numberTrivia,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          children: [
            Text(
              numberTrivia.number.toString(),
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    numberTrivia.text,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
