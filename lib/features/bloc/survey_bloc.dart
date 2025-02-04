import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SurveyEvent extends Equatable {
  const SurveyEvent();
  @override
  List<Object> get props => [];
}

/// Event to initialize the survey with a list of questions.

class InitializeSurvey extends SurveyEvent {
  final List<String> questions;
  const InitializeSurvey({required this.questions});

  @override
  List<Object> get props => [questions];
}

/// Event to update the response for a specific question.

class UpdateResponse extends SurveyEvent {
  final int questionIndex;
  final String response;
  const UpdateResponse({
    required this.questionIndex,
    required this.response,
  });

  @override
  List<Object> get props => [questionIndex, response];
}

/// Event to move to the next question.

class NextQuestion extends SurveyEvent {}

/// Event to move to the previous question.

class PreviousQuestion extends SurveyEvent {}

/// --- SURVEY STATE ---

class SurveyState extends Equatable {
  final List<String?> responses;
  final int currentQuestionIndex;

  const SurveyState({
    required this.responses,
    required this.currentQuestionIndex,
  });

  SurveyState copyWith({
    List<String?>? responses,
    int? currentQuestionIndex,
  }) {
    return SurveyState(
      responses: responses ?? this.responses,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
    );
  }

  @override
  List<Object?> get props => [responses, currentQuestionIndex];
}

/// --- SURVEY BLOC ---

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  SurveyBloc() : super(const SurveyState(responses: [], currentQuestionIndex: 0)) {
    on<InitializeSurvey>((event, emit) {
      // Initialize the responses list with a null for each question.
      
      emit(SurveyState(
        responses: List<String?>.filled(event.questions.length, null),
        currentQuestionIndex: 0,
      ));
    });

    on<UpdateResponse>((event, emit) {
      final newResponses = List<String?>.from(state.responses);
      newResponses[event.questionIndex] = event.response;
      emit(state.copyWith(responses: newResponses));
    });

    on<NextQuestion>((event, emit) {
      if (state.currentQuestionIndex < state.responses.length - 1) {
        emit(state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1));
      }
    });

    on<PreviousQuestion>((event, emit) {
      if (state.currentQuestionIndex > 0) {
        emit(state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1));
      }
    });
  }
}
