import 'package:flutter/material.dart';
import '../../Controller/land_survey_controller.dart';
import 'Steps/personal_info_step.dart';
import 'Steps/survey_cts_step.dart';
import 'Steps/survey_info_step.dart';

class SurveyStepWidget extends StatefulWidget {
  final int currentStep;
  final int currentSubStep;
  final SurveyController controller;

  const SurveyStepWidget({
    Key? key,
    required this.currentStep,
    required this.currentSubStep,
    required this.controller,
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
          controller: widget.controller,
        );
      case 1:
        return SurveyCTSStep(
          currentSubStep: widget.currentSubStep,
          controller: widget.controller,
        );
      case 2:
        return SurveyInfoStep(
          currentSubStep: widget.currentSubStep,
          controller: widget.controller,
        );
      default:
        return PersonalInfoStep(
          currentSubStep: widget.currentSubStep,
          controller: widget.controller,
        );
    }
  }
}
