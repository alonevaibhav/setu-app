
// Address Popup Widget
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../LandSurveyView/Steps/survey_ui_utils.dart';

class AddressPopup extends StatelessWidget {
  final int entryIndex;
  final Map<String, TextEditingController> controllers;
  final VoidCallback onSave;

  const AddressPopup({
    Key? key,
    required this.entryIndex,
    required this.controllers,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF52B788),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Account Holder Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SurveyUIUtils.buildTextFormField(
                      controller: controllers['plotNoController']!,
                      label: 'Plot No./House No./Flat No.',
                      icon: Icons.home_outlined,
                      hint: 'Enter plot/house/flat number',
                    ),
                    SizedBox(height: 16),
                    SurveyUIUtils.buildTextFormField(
                      controller: controllers['addressController']!,
                      label: 'Address *',
                      icon: Icons.location_on_outlined,
                      maxLines: 3,
                      hint: 'Enter full address',
                    ),
                    SizedBox(height: 16),
                    SurveyUIUtils.buildTextFormField(
                      controller: controllers['mobileNumberController']!,
                      label: 'Mobile Number *',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      hint: 'Enter mobile number',

                    ),
                    SizedBox(height: 16),
                    SurveyUIUtils.buildTextFormField(
                      controller: controllers['emailController']!,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      hint: 'Enter email address',
                    ),
                    SizedBox(height: 16),
                    SurveyUIUtils.buildTextFormField(
                      controller: controllers['pincodeController']!,
                      label: 'Pincode *',
                      icon: Icons.pin_drop_outlined,
                      keyboardType: TextInputType.number,
                      hint: 'Enter pincode',
                    ),
                    SizedBox(height: 16),
                    SurveyUIUtils.buildTextFormField(
                      controller: controllers['districtController']!,
                      label: 'District',
                      icon: Icons.location_city_outlined,
                      hint: 'Enter district',
                    ),
                    SizedBox(height: 16),
                    SurveyUIUtils.buildTextFormField(
                      controller: controllers['villageController']!,
                      label: 'Village *',
                      icon: Icons.landscape_outlined,
                      hint: 'Enter village name',
                    ),
                    SizedBox(height: 16),
                    SurveyUIUtils.buildTextFormField(
                      controller: controllers['postOfficeController']!,
                      label: 'Post Office *',
                      icon: Icons.local_post_office_outlined,
                      hint: 'Enter post office name',
                    ),
                  ],
                ),
              ),
            ),

            // Footer buttons
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF52B788),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Save Address',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}