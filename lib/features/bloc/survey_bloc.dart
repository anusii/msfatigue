import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  /// Map where each key is a question (String) and its value is the answer (String?)

  final Map<String, String?> responses;

  /// The index (in insertion order) of the currently displayed question.

  final int currentQuestionIndex;

  /// The survey filename generated at startup.

  final String surveyFilename;

  const SurveyState({
    required this.responses,
    required this.currentQuestionIndex,
    required this.surveyFilename,
  });

  SurveyState copyWith({
    Map<String, String?>? responses,
    int? currentQuestionIndex,
    String? surveyFilename,
  }) {
    return SurveyState(
      responses: responses ?? this.responses,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      surveyFilename: surveyFilename ?? this.surveyFilename,
    );
  }

  @override
  List<Object?> get props => [responses, currentQuestionIndex];
}

/// --- SURVEY BLOC ---

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final SharedPreferences sharedPreferences; // Add this
  final String surveyFilename;

  SurveyBloc({required this.surveyFilename, required this.sharedPreferences})
      : super(SurveyState(
            responses: {},
            currentQuestionIndex: 0,
            surveyFilename: surveyFilename)) {
    on<InitializeSurvey>((event, emit) async {
      final Map<String, String?> responses = {
        for (var question in event.questions) question: null,
      };
      // Emit a new state, preserving the filename.

      emit(SurveyState(
        responses: responses,
        currentQuestionIndex: 0,
        surveyFilename: state.surveyFilename,
      ));
    });

    on<UpdateResponse>((event, emit) {
      final newResponses = Map<String, String?>.from(state.responses);
      final questionList = newResponses.keys.toList();
      if (event.questionIndex < questionList.length) {
        final question = questionList[event.questionIndex];
        newResponses[question] = event.response;
        emit(state.copyWith(responses: newResponses));
      }
    });

    on<NextQuestion>((event, emit) {
      if (state.currentQuestionIndex < state.responses.length - 1) {
        emit(state.copyWith(
            currentQuestionIndex: state.currentQuestionIndex + 1));
      }
    });

    on<PreviousQuestion>((event, emit) {
      if (state.currentQuestionIndex > 0) {
        emit(state.copyWith(
            currentQuestionIndex: state.currentQuestionIndex - 1));
      }
    });
  }
}
