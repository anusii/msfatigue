/// Survey block variables used in the APP.
///
// Time-stamp: <Tuesday 2025-02-18 14:07:18 +1100 Graham Williams>
///
/// Copyright (C) 2025, Software Innovation Institute, ANU
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Graham Williams, Zheyuan Xu
library;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SurveyEvent extends Equatable {
  const SurveyEvent();

  @override
  List<Object> get props => [];
}

class InitializeSurvey extends SurveyEvent {
  final List<String> questions;
  final Map<String, String?>? savedResponses;

  const InitializeSurvey({
    required this.questions,
    this.savedResponses,
  });

  @override
  List<Object> get props => [questions];
}

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

class NextQuestion extends SurveyEvent {}

class PreviousQuestion extends SurveyEvent {}

class ClearSurvey extends SurveyEvent {
  const ClearSurvey();

  @override
  List<Object> get props => [];
}

class SurveyState extends Equatable {
  final Map<String, String?> responses;
  final int currentQuestionIndex;
  final String surveyFilename;

  const SurveyState({
    required this.responses,
    required this.currentQuestionIndex,
    required this.surveyFilename,
  });

  int get firstUnansweredQuestionIndex {
    final questions = responses.keys.toList();
    for (int i = 0; i < questions.length; i++) {
      if (responses[questions[i]] == null) {
        return i;
      }
    }
    return questions.length - 1; // All questions answered, return last question
  }

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
  List<Object?> get props => [responses, currentQuestionIndex, surveyFilename];
}

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final SharedPreferences sharedPreferences;
  final String surveyFilename;

  SurveyBloc({required this.surveyFilename, required this.sharedPreferences})
      : super(SurveyState(
          responses: {},
          currentQuestionIndex: 0,
          surveyFilename: surveyFilename,
        )) {
    on<InitializeSurvey>((event, emit) {
      // Create a map with questions, using saved responses if available.

      final Map<String, String?> responses = {
        for (var question in event.questions)
          question: event.savedResponses?[question],
      };

      // Find the first unanswered question.

      int startIndex = 0;
      for (var i = 0; i < event.questions.length; i++) {
        if (responses[event.questions[i]] == null) {
          startIndex = i;
          break;
        }
      }

      emit(SurveyState(
        responses: responses,
        currentQuestionIndex: startIndex,
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

    on<ClearSurvey>((event, emit) {
      emit(SurveyState(
        responses: {},
        currentQuestionIndex: 0,
        surveyFilename: state.surveyFilename,
      ));
    });
  }
}
