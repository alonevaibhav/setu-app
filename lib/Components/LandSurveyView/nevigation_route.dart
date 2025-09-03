import 'package:flutter/material.dart';
import 'Controller/main_controller.dart';
import 'Steps/land_survey_preview.dart';
import 'Steps/start.dart';
import 'Steps/step_four_view.dart';
import 'Steps/survey_cts.dart';
import 'Steps/survey_eight_view.dart';
import 'Steps/survey_fifth_view.dart';
import 'Steps/survey_information.dart';
import 'Steps/survey_seventh_view.dart';
import 'Steps/survey_sixth_view.dart';

class SurveyStepWidget extends StatefulWidget {
  final int currentStep;
  final int currentSubStep;
  final MainSurveyController mainController;

  const SurveyStepWidget({
    Key? key,
    required this.currentStep,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  @override
  State<SurveyStepWidget> createState() => _SurveyStepWidgetState();
}

class _SurveyStepWidgetState extends State<SurveyStepWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.currentStep) {
      case 0:
        return PersonalInfoStep(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 1:
        return SurveyCTSStep(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 2:
        return CalculationInformation(
          currentSubStep: widget.currentSubStep,
          controller: widget.mainController,
        );
      case 3:
        return StepFourView(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 4:
        return SurveyFifthView(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 5:
        return SurveySixthView(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 6:
        return SurveySeventhView(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 7:
        return SurveyEightView(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 8:
        return SurveyPreviewStep(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 9:
        return PersonalInfoStep(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );

      default:
        return PersonalInfoStep(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
    }
  }
}