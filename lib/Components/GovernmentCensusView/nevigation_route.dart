import 'package:flutter/material.dart';
import 'Controller/main_controller.dart';
import 'Steps/census_eighth_view.dart';
import 'Steps/census_fifth_view.dart';
import 'Steps/census_fourth_view.dart';
import 'Steps/census_seventh_view.dart';
import 'Steps/census_sixth_view.dart';
import 'Steps/start.dart';
import 'Steps/survey_cts.dart';
import 'Steps/survey_information.dart';

class SurveyStepWidget extends StatefulWidget {
  final int currentStep;
  final int currentSubStep;
  final GovernmentCensusController mainController;

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
        return CensusFourthView(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 4:
        return CensusFifthView(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 5:
        return CensusSixthView(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 6:
        return CensusSeventhView(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 7:
        return CensusEighthView(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 8:
        return PersonalInfoStep(
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