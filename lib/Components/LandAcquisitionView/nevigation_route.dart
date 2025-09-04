import 'package:flutter/material.dart';
import '../../Controller/land_survey_controller.dart';
import 'Controller/main_controller.dart';
import 'Steps/land_fifth_view.dart';
import 'Steps/land_fouth_view.dart';
import 'Steps/land_preview_view.dart';
import 'Steps/land_seventh_view.dart';
import 'Steps/land_sixth_view.dart';
import 'Steps/start.dart';
import 'Steps/survey_cts.dart';
import 'Steps/survey_information.dart';

class SurveyStepWidget extends StatefulWidget {
  final int currentStep;
  final int currentSubStep;
  final MainLandAcquisitionController mainController;

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
        return LandSecondView(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 2:
        return CalculationInformation(
          currentSubStep: widget.currentSubStep,
          controller: widget.mainController,
        );
      case 3:
        return LandFouthView(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 4:
        return LandFifthView(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 5:
        return LandSixthView(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 6:
        return LandSeventhView(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 7:
        return LandAcquisitionPreviewStep(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      // case 8:
      //   return PersonalInfoStep(
      //     currentSubStep: widget.currentSubStep,
      //     mainController: widget.mainController,
      //   );
      // case 9:
      //   return PersonalInfoStep(
      //     currentSubStep: widget.currentSubStep,
      //     mainController: widget.mainController,
      //   );

      default:
        return PersonalInfoStep(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
    }
  }
}