import 'package:clean_architecture_reso/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    super.key,
  });

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  late String inputStr;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            inputStr = value;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: ElevatedButton(
              onPressed: disPatchConcrete,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800),
              child: const Text(
                'Search',
                style: TextStyle(color: Colors.white),
              ),
            )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: ElevatedButton(
              onPressed: disPatchRandom,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800),
              child: const Text(
                'Get random trivia',
                style: TextStyle(color: Colors.white),
              ),
            ))
          ],
        )
      ],
    );
  }

  void disPatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputStr));
  }

  void disPatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
