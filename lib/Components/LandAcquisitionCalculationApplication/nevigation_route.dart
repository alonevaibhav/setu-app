import 'package:flutter/material.dart';
import '../../Controller/land_survey_controller.dart';
import 'Steps/applicant_information.dart';
import 'Steps/calculation_information.dart';
import 'Steps/coowner_information.dart';
import 'Steps/document_upload.dart';
import 'Steps/information_about.dart';
import 'Steps/payment.dart';
import 'Steps/preview.dart';
import 'Steps/start.dart';
import 'Steps/survey_cts.dart';
import 'Steps/survey_information.dart';
import 'land_acquisition_calculation_controller.dart';

class LandAcquisitionWidget extends StatefulWidget {
  final int currentStep;
  final int currentSubStep;
  final LandAcquisitionController controller;

  const LandAcquisitionWidget({
    Key? key,
    required this.currentStep,
    required this.currentSubStep,
    required this.controller,
  }) : super(key: key);

  @override
  State<LandAcquisitionWidget> createState() => _LandAcquisitionWidgetState();
}

class _LandAcquisitionWidgetState extends State<LandAcquisitionWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.currentStep) {
      case 0:
        return ZeroInfoStep(
          currentSubStep: widget.currentSubStep,
          controller: widget.controller,
        );
      case 1:
        return OneInfoStep(
          currentSubStep: widget.currentSubStep,
          controller: widget.controller,
        );
      case 2:
        return ZeroInfoStep(
          currentSubStep: widget.currentSubStep,
          controller: widget.controller,
        );
      case 3:
        return ZeroInfoStep(
          currentSubStep: widget.currentSubStep,
          controller: widget.controller,
        );
      case 4:
        return ZeroInfoStep(
          currentSubStep: widget.currentSubStep,
          controller: widget.controller,
        );
      case 5:
        return ZeroInfoStep(
          currentSubStep: widget.currentSubStep,
          controller: widget.controller,
        );
      case 6:
        return ZeroInfoStep(
          currentSubStep: widget.currentSubStep,
          controller: widget.controller,
        );
      case 7:
        return ZeroInfoStep(
          currentSubStep: widget.currentSubStep,
          controller: widget.controller,
        );
      case 8:
        return ZeroInfoStep(
          currentSubStep: widget.currentSubStep,
          controller: widget.controller,
        );
      case 9:
        return ZeroInfoStep(
          currentSubStep: widget.currentSubStep,
          controller: widget.controller,
        );

      default:
        return ZeroInfoStep(
          currentSubStep: widget.currentSubStep,
          controller: widget.controller,
        );
    }
  }
}
