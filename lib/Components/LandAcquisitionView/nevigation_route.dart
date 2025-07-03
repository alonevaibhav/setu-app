// import 'package:flutter/material.dart';
// import '../../Controller/land_survey_controller.dart';
// import 'Controller/main_controller.dart';
// import 'Steps/applicant_information.dart';
// import 'Steps/calculation_information.dart';
// import 'Steps/coowner_information.dart';
// import 'Steps/document_upload.dart';
// import 'Steps/information_about.dart';
// import 'Steps/payment.dart';
// import 'Steps/preview.dart';
// import 'Steps/start.dart';
// import 'Steps/survey_cts.dart';
// import 'Steps/survey_information.dart';
//
// class SurveyStepWidget extends StatefulWidget {
//   final int currentStep;
//   final int currentSubStep;
//   final MainSurveyController controller;
//
//   const SurveyStepWidget({
//     Key? key,
//     required this.currentStep,
//     required this.currentSubStep,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   State<SurveyStepWidget> createState() => _SurveyStepWidgetState();
// }
//
// class _SurveyStepWidgetState extends State<SurveyStepWidget> {
//   @override
//   Widget build(BuildContext context) {
//     switch (widget.currentStep) {
//       case 0:
//         return PersonalInfoStep(
//           currentSubStep: widget.currentSubStep,
//           controller: widget.controller,
//         );
//       case 1:
//         return SurveyCTSStep(
//           currentSubStep: widget.currentSubStep,
//           controller: widget.controller,
//         );
//       case 2:
//         return PersonalInfoStep(
//           currentSubStep: widget.currentSubStep,
//           controller: widget.controller,
//         );
//       case 3:
//         return PersonalInfoStep(
//           currentSubStep: widget.currentSubStep,
//           controller: widget.controller,
//         );
//       case 4:
//         return PersonalInfoStep(
//           currentSubStep: widget.currentSubStep,
//           controller: widget.controller,
//         );
//       case 5:
//         return PersonalInfoStep(
//           currentSubStep: widget.currentSubStep,
//           controller: widget.controller,
//         );
//       case 6:
//         return PersonalInfoStep(
//           currentSubStep: widget.currentSubStep,
//           controller: widget.controller,
//         );
//       case 7:
//         return PersonalInfoStep(
//           currentSubStep: widget.currentSubStep,
//           controller: widget.controller,
//         );
//       case 8:
//         return PersonalInfoStep(
//           currentSubStep: widget.currentSubStep,
//           controller: widget.controller,
//         );
//       case 9:
//         return PersonalInfoStep(
//           currentSubStep: widget.currentSubStep,
//           controller: widget.controller,
//         );
//
//       default:
//         return PersonalInfoStep(
//           currentSubStep: widget.currentSubStep,
//           controller: widget.controller,
//         );
//     }
//   }
// }
import 'package:flutter/material.dart';
import '../../Controller/land_survey_controller.dart';
import 'Controller/main_controller.dart';
import 'Steps/applicant_information.dart';
import 'Steps/coowner_information.dart';
import 'Steps/document_upload.dart';
import 'Steps/information_about.dart';
import 'Steps/payment.dart';
import 'Steps/preview.dart';
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
        return PersonalInfoStep(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 4:
        return PersonalInfoStep(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 5:
        return PersonalInfoStep(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 6:
        return PersonalInfoStep(
          currentSubStep: widget.currentSubStep,
          mainController: widget.mainController,
        );
      case 7:
        return PersonalInfoStep(
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