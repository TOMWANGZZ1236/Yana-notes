import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisnotes/View/login_view.dart';
import 'package:hisnotes/View/notes/create_update_note_view.dart';
import 'package:hisnotes/View/notes/notes_view.dart';
import 'package:hisnotes/View/register_view.dart';
import 'package:hisnotes/View/verify_email_view.dart';
import 'package:hisnotes/constants/routes.dart';
import 'package:hisnotes/services/auth/bloc/auth_bloc.dart';
import 'package:hisnotes/services/auth/bloc/auth_event.dart';
import 'package:hisnotes/services/auth/bloc/auth_state.dart';
import 'package:hisnotes/services/auth/firebase_auth_provider.dart';
import 'firebase_options.dart';
import 'dart:developer' as devdart show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NoteView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const NewNoteView(),
      }));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateLoggedIn) {
          return const NoteView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (context) => CounterBloc(),
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Testing Bloc'),
//           ),
//           body: BlocConsumer<CounterBloc, CounterState>(
//             builder: (context, state) {
//               final invalidValue = (state is CounterStateInvalidNumber)
//                   ? state.invalidValue
//                   : '';
//               return Column(
//                 children: [
//                   Text("current state is => ${state.value}"),
//                   Visibility(
//                     child: Text("invalid input: ${invalidValue}"),
//                     visible: state is CounterStateInvalidNumber,
//                   ),
//                   TextField(
//                     controller: _controller,
//                     decoration:
//                         const InputDecoration(hintText: "Enter a number here"),
//                     keyboardType: TextInputType.number,
//                   ),
//                   Row(
//                     children: [
//                       TextButton(
//                           onPressed: () {
//                             context
//                                 .read<CounterBloc>()
//                                 .add(DecrementEvent(_controller.text));
//                           },
//                           child: const Text("-")),
//                       TextButton(
//                           onPressed: () {
//                             context
//                                 .read<CounterBloc>()
//                                 .add(IncrementEvent(_controller.text));
//                           },
//                           child: const Text("+")),
//                     ],
//                   )
//                 ],
//               );
//             },
//             listener: (context, state) {
//               _controller.clear();
//             },
//           ),
//         ));
//   }

//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

// abstract class CounterState {
//   final int value;

//   const CounterState(this.value);
// }

// class CounterStateValidNumber extends CounterState {
//   const CounterStateValidNumber(int value) : super(value);
// }

// class CounterStateInvalidNumber extends CounterState {
//   final String invalidValue;
//   const CounterStateInvalidNumber(
//       {required this.invalidValue, required int previousValue})
//       : super(previousValue);
// }

// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this.value);
// }

// class IncrementEvent extends CounterEvent {
//   const IncrementEvent(String value) : super(value);
// }

// class DecrementEvent extends CounterEvent {
//   const DecrementEvent(String value) : super(value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValidNumber(0)) {
//     on<IncrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(CounterStateInvalidNumber(
//             invalidValue: event.value, previousValue: state.value));
//       } else {
//         emit.call(CounterStateValidNumber(state.value + integer));
//       }
//     });
//     on<DecrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(CounterStateInvalidNumber(
//             invalidValue: event.value, previousValue: state.value));
//       } else {
//         emit(CounterStateValidNumber(state.value - integer));
//       }
//     });
//   }
// }
