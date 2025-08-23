// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:setuapp/Components/LandSurveyView/Controller/main_controller.dart';
// import '../../Widget/address.dart';
//
// class CensusSixthController extends GetxController with StepValidationMixin, StepDataMixin {
//   // Co-owner entries list - each entry contains controllers and data
//   final coownerEntries = <Map<String, dynamic>>[].obs;
//
//   // Validation errors map
//   final validationErrors = <String, String>{}.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize with one co-owner entry by default
//     addCoownerEntry();
//   }
//
//   @override
//   void onClose() {
//     // Dispose all controllers
//     for (var entry in coownerEntries) {
//       _disposeEntryControllers(entry);
//     }
//     super.onClose();
//   }
//
//   void addCoownerEntry() {
//     final newEntry = _createNewCoownerEntry();
//     coownerEntries.add(newEntry);
//     clearValidationErrors();
//     update(); // Trigger UI update
//   }
//
//   void removeCoownerEntry(int index) {
//     if (index < coownerEntries.length && coownerEntries.length > 1) {
//       final entry = coownerEntries[index];
//       _disposeEntryControllers(entry);
//       coownerEntries.removeAt(index);
//       clearValidationErrors();
//       update(); // Trigger UI update
//     }
//   }
//
//   Map<String, dynamic> _createNewCoownerEntry() {
//     return {
//       // Basic fields
//       'nameController': TextEditingController(),
//       'mobileNumberController': TextEditingController(),
//       'serverNumberController': TextEditingController(),
//       'consentController': TextEditingController(),
//
//       // Address controllers - these will be used in the popup
//       'addressControllers': {
//         'plotNoController': TextEditingController(),
//         'addressController': TextEditingController(),
//         'mobileNumberController': TextEditingController(), // For address popup
//         'emailController': TextEditingController(),
//         'pincodeController': TextEditingController(),
//         'districtController': TextEditingController(),
//         'villageController': TextEditingController(),
//         'postOfficeController': TextEditingController(),
//       },
//
//       // Data storage
//       'name': '',
//       'mobileNumber': '',
//       'serverNumber': '',
//       'consent': '',
//       'address': {
//         'plotNo': '',
//         'address': '',
//         'mobileNumber': '',
//         'email': '',
//         'pincode': '',
//         'district': '',
//         'village': '',
//         'postOffice': '',
//       },
//     };
//   }
//
//   void _disposeEntryControllers(Map<String, dynamic> entry) {
//     // Dispose basic controllers
//     (entry['nameController'] as TextEditingController?)?.dispose();
//     (entry['mobileNumberController'] as TextEditingController?)?.dispose();
//     (entry['serverNumberController'] as TextEditingController?)?.dispose();
//     (entry['consentController'] as TextEditingController?)?.dispose();
//
//     // Dispose address controllers
//     final addressControllers = entry['addressControllers'] as Map<String, TextEditingController>?;
//     addressControllers?.values.forEach((controller) => controller.dispose());
//   }
//
//   void updateCoownerEntry(int index, String field, String value) {
//     if (index < coownerEntries.length) {
//       coownerEntries[index][field] = value;
//
//       // Clear validation error for this field
//       validationErrors.remove('${index}_$field');
//
//       // Validate the field
//       _validateField(index, field, value);
//
//       update(); // Trigger UI update
//     }
//   }
//
//   void updateCoownerAddress(int index, Map<String, String> addressData) {
//     if (index < coownerEntries.length) {
//       coownerEntries[index]['address'] = addressData;
//
//       // Clear address validation errors
//       validationErrors.removeWhere((key, value) => key.startsWith('${index}_address'));
//       validationErrors.removeWhere((key, value) => key.startsWith('${index}_pincode'));
//       validationErrors.removeWhere((key, value) => key.startsWith('${index}_village'));
//       validationErrors.removeWhere((key, value) => key.startsWith('${index}_postOffice'));
//
//       // Validate address fields
//       _validateAddressFields(index, addressData);
//
//       update(); // Trigger UI update
//     }
//   }
//
//   void _validateField(int index, String field, String value) {
//     switch (field) {
//       case 'name':
//         if (value.trim().isEmpty) {
//           validationErrors['${index}_$field'] = 'Co-owner name is required';
//         }
//         break;
//       case 'mobileNumber':
//         if (value.trim().isEmpty) {
//           validationErrors['${index}_$field'] = 'Mobile number is required';
//         } else if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
//           validationErrors['${index}_$field'] = 'Enter valid 10-digit mobile number';
//         }
//         break;
//       case 'consent':
//         if (value.trim().isEmpty) {
//           validationErrors['${index}_$field'] = 'Consent information is required';
//         }
//         break;
//     }
//   }
//
//   void _validateAddressFields(int index, Map<String, String> addressData) {
//     if (addressData['address']?.trim().isEmpty ?? true) {
//       validationErrors['${index}_address'] = 'Address is required';
//     }
//     if (addressData['pincode']?.trim().isEmpty ?? true) {
//       validationErrors['${index}_pincode'] = 'Pincode is required';
//     }
//     if (addressData['village']?.trim().isEmpty ?? true) {
//       validationErrors['${index}_village'] = 'Village is required';
//     }
//     if (addressData['postOffice']?.trim().isEmpty ?? true) {
//       validationErrors['${index}_postOffice'] = 'Post Office is required';
//     }
//   }
//
//   void clearValidationErrors() {
//     validationErrors.clear();
//   }
//
//   // Get formatted address for display
//   String getFormattedAddress(int index) {
//     if (index >= coownerEntries.length) return 'Click to add address';
//
//     final address = coownerEntries[index]['address'] as Map<String, String>;
//     final parts = <String>[];
//
//     if (address['plotNo']?.isNotEmpty == true) parts.add(address['plotNo']!);
//     if (address['address']?.isNotEmpty == true) parts.add(address['address']!);
//     if (address['village']?.isNotEmpty == true) parts.add(address['village']!);
//     if (address['postOffice']?.isNotEmpty == true) parts.add(address['postOffice']!);
//     if (address['pincode']?.isNotEmpty == true) parts.add(address['pincode']!);
//
//     return parts.isEmpty ? 'Click to add address' : parts.join(', ');
//   }
//
//   // Show address popup
//   void showAddressPopup(BuildContext context, int index) {
//     if (index >= coownerEntries.length) return;
//
//     final addressControllers = coownerEntries[index]['addressControllers'] as Map<String, TextEditingController>;
//     final currentAddress = coownerEntries[index]['address'] as Map<String, String>;
//
//     // Populate controllers with current data
//     addressControllers['plotNoController']!.text = currentAddress['plotNo'] ?? '';
//     addressControllers['addressController']!.text = currentAddress['address'] ?? '';
//     addressControllers['mobileNumberController']!.text = currentAddress['mobileNumber'] ?? '';
//     addressControllers['emailController']!.text = currentAddress['email'] ?? '';
//     addressControllers['pincodeController']!.text = currentAddress['pincode'] ?? '';
//     addressControllers['districtController']!.text = currentAddress['district'] ?? '';
//     addressControllers['villageController']!.text = currentAddress['village'] ?? '';
//     addressControllers['postOfficeController']!.text = currentAddress['postOffice'] ?? '';
//
//     showDialog(
//       context: context,
//       builder: (context) => AddressPopup(
//         entryIndex: index,
//         controllers: addressControllers,
//         onSave: () => _saveAddressFromPopup(index),
//       ),
//     );
//   }
//
//   void _saveAddressFromPopup(int index) {
//     final addressControllers = coownerEntries[index]['addressControllers'] as Map<String, TextEditingController>;
//
//     final addressData = {
//       'plotNo': addressControllers['plotNoController']!.text,
//       'address': addressControllers['addressController']!.text,
//       'mobileNumber': addressControllers['mobileNumberController']!.text,
//       'email': addressControllers['emailController']!.text,
//       'pincode': addressControllers['pincodeController']!.text,
//       'district': addressControllers['districtController']!.text,
//       'village': addressControllers['villageController']!.text,
//       'postOffice': addressControllers['postOfficeController']!.text,
//     };
//
//     updateCoownerAddress(index, addressData);
//     Get.back(); // Close the popup
//   }
//
//   // StepValidationMixin implementation
//   @override
//   bool validateCurrentSubStep(String field) {
//     switch (field) {
//       case 'government_survey':
//         return true; // Temporarily return true to bypass validation
//       default:
//         return true;
//     }
//   }
//   // bool validateCurrentSubStep(String field) {
//   //   clearValidationErrors();
//   //   bool isValid = true;
//   //
//   //   for (int i = 0; i < coownerEntries.length; i++) {
//   //     final entry = coownerEntries[i];
//   //
//   //     // Validate required fields
//   //     final name = (entry['nameController'] as TextEditingController).text;
//   //     final mobileNumber = (entry['mobileNumberController'] as TextEditingController).text;
//   //     final consent = (entry['consentController'] as TextEditingController).text;
//   //     final address = entry['address'] as Map<String, String>;
//   //
//   //     _validateField(i, 'name', name);
//   //     _validateField(i, 'mobileNumber', mobileNumber);
//   //     _validateField(i, 'consent', consent);
//   //     _validateAddressFields(i, address);
//   //
//   //     // Update the entry data
//   //     entry['name'] = name;
//   //     entry['mobileNumber'] = mobileNumber;
//   //     entry['consent'] = consent;
//   //     entry['serverNumber'] = (entry['serverNumberController'] as TextEditingController).text;
//   //   }
//   //
//   //   isValid = validationErrors.isEmpty;
//   //   return isValid;
//   // }
//
//   @override
//   bool isStepCompleted(List<String> fields) {
//     return validateCurrentSubStep('');
//   }
//
//   @override
//   String getFieldError(String field) {
//     if (validationErrors.isNotEmpty) {
//       return validationErrors.values.first;
//     }
//     return 'Please complete all required fields';
//   }
//
//   // StepDataMixin implementation
//   @override
//   Map<String, dynamic> getStepData() {
//     final List<Map<String, dynamic>> coownerData = [];
//
//     for (int i = 0; i < coownerEntries.length; i++) {
//       final entry = coownerEntries[i];
//       coownerData.add({
//         'name': entry['name'] ?? '',
//         'mobileNumber': entry['mobileNumber'] ?? '',
//         'serverNumber': entry['serverNumber'] ?? '',
//         'consent': entry['consent'] ?? '',
//         'address': Map<String, String>.from(entry['address'] as Map? ?? {}),
//       });
//     }
//
//     return {
//       'coowners': coownerData,
//       'coownerCount': coownerEntries.length,
//     };
//   }
// }
//
// // // Address Popup Widget (same as before but imported here for reference)
// // class AddressPopup extends StatelessWidget {
// //   final int entryIndex;
// //   final Map<String, TextEditingController> controllers;
// //   final VoidCallback onSave;
// //
// //   const AddressPopup({
// //     Key? key,
// //     required this.entryIndex,
// //     required this.controllers,
// //     required this.onSave,
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Dialog(
// //       insetPadding: EdgeInsets.all(16),
// //       child: Container(
// //         width: double.infinity,
// //         constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             // Header
// //             Container(
// //               padding: EdgeInsets.all(20),
// //               decoration: BoxDecoration(
// //                 color: Color(0xFF52B788),
// //                 borderRadius: BorderRadius.only(
// //                   topLeft: Radius.circular(12),
// //                   topRight: Radius.circular(12),
// //                 ),
// //               ),
// //               child: Row(
// //                 children: [
// //                   Icon(Icons.location_on, color: Colors.white, size: 24),
// //                   SizedBox(width: 12),
// //                   Expanded(
// //                     child: Text(
// //                       'Co-owner Address',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.w600,
// //                         color: Colors.white,
// //                       ),
// //                     ),
// //                   ),
// //                   IconButton(
// //                     onPressed: () => Get.back(),
// //                     icon: Icon(Icons.close, color: Colors.white),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //
// //             // Content
// //             Flexible(
// //               child: SingleChildScrollView(
// //                 padding: EdgeInsets.all(20),
// //                 child: Column(
// //                   children: [
// //                     _buildTextField(
// //                       controller: controllers['plotNoController']!,
// //                       label: 'Plot No./House No./Flat No.',
// //                       icon: Icons.home_outlined,
// //                     ),
// //                     SizedBox(height: 16),
// //                     _buildTextField(
// //                       controller: controllers['addressController']!,
// //                       label: 'Address *',
// //                       icon: Icons.location_on_outlined,
// //                       maxLines: 3,
// //                       required: true,
// //                     ),
// //                     SizedBox(height: 16),
// //                     _buildTextField(
// //                       controller: controllers['mobileNumberController']!,
// //                       label: 'Mobile Number *',
// //                       icon: Icons.phone_outlined,
// //                       keyboardType: TextInputType.phone,
// //                       required: true,
// //                     ),
// //                     SizedBox(height: 16),
// //                     _buildTextField(
// //                       controller: controllers['emailController']!,
// //                       label: 'Email',
// //                       icon: Icons.email_outlined,
// //                       keyboardType: TextInputType.emailAddress,
// //                     ),
// //                     SizedBox(height: 16),
// //                     _buildTextField(
// //                       controller: controllers['pincodeController']!,
// //                       label: 'Pincode *',
// //                       icon: Icons.pin_drop_outlined,
// //                       keyboardType: TextInputType.number,
// //                       required: true,
// //                     ),
// //                     SizedBox(height: 16),
// //                     _buildTextField(
// //                       controller: controllers['districtController']!,
// //                       label: 'District',
// //                       icon: Icons.location_city_outlined,
// //                     ),
// //                     SizedBox(height: 16),
// //                     _buildTextField(
// //                       controller: controllers['villageController']!,
// //                       label: 'Village *',
// //                       icon: Icons.landscape_outlined,
// //                       required: true,
// //                     ),
// //                     SizedBox(height: 16),
// //                     _buildTextField(
// //                       controller: controllers['postOfficeController']!,
// //                       label: 'Post Office *',
// //                       icon: Icons.local_post_office_outlined,
// //                       required: true,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //
// //             // Footer buttons
// //             Container(
// //               padding: EdgeInsets.all(20),
// //               decoration: BoxDecoration(
// //                 border: Border(top: BorderSide(color: Colors.grey.shade300)),
// //               ),
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     child: OutlinedButton(
// //                       onPressed: () => Get.back(),
// //                       style: OutlinedButton.styleFrom(
// //                         side: BorderSide(color: Colors.grey),
// //                         padding: EdgeInsets.symmetric(vertical: 16),
// //                       ),
// //                       child: Text('Cancel'),
// //                     ),
// //                   ),
// //                   SizedBox(width: 16),
// //                   Expanded(
// //                     child: ElevatedButton(
// //                       onPressed: onSave,
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Color(0xFF52B788),
// //                         padding: EdgeInsets.symmetric(vertical: 16),
// //                       ),
// //                       child: Text(
// //                         'Save Address',
// //                         style: TextStyle(color: Colors.white),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTextField({
// //     required TextEditingController controller,
// //     required String label,
// //     required IconData icon,
// //     TextInputType? keyboardType,
// //     int maxLines = 1,
// //     bool required = false,
// //   }) {
// //     return TextFormField(
// //       controller: controller,
// //       keyboardType: keyboardType,
// //       maxLines: maxLines,
// //       decoration: InputDecoration(
// //         labelText: label,
// //         prefixIcon: Icon(icon, color: Color(0xFF52B788)),
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: Colors.grey.shade300),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: Color(0xFF52B788), width: 2),
// //         ),
// //         enabledBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: Colors.grey.shade300),
// //         ),
// //         filled: true,
// //         fillColor: Colors.grey.shade50,
// //       ),
// //     );
// //   }
// // }


import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:setuapp/Components/GovernmentCensusView/Controller/main_controller.dart';
import '../../Widget/address.dart';

class CensusSixthController extends GetxController with StepValidationMixin, StepDataMixin {
  // Co-owner entries list - each entry contains controllers and data
  final coownerEntries = <Map<String, dynamic>>[].obs;

  // Validation errors map
  final validationErrors = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with one co-owner entry by default
    addCoownerEntry();
  }

  @override
  void onClose() {
    // Dispose all controllers
    for (var entry in coownerEntries) {
      _disposeEntryControllers(entry);
    }
    super.onClose();
  }

  void addCoownerEntry() {
    final newEntry = _createNewCoownerEntry();
    coownerEntries.add(newEntry);
    clearValidationErrors();
    update(); // Trigger UI update
  }

  void removeCoownerEntry(int index) {
    if (index < coownerEntries.length && coownerEntries.length > 1) {
      final entry = coownerEntries[index];
      _disposeEntryControllers(entry);
      coownerEntries.removeAt(index);
      clearValidationErrors();
      update(); // Trigger UI update
    }
  }

  Map<String, dynamic> _createNewCoownerEntry() {
    return {
      // Basic fields
      'nameController': TextEditingController(),
      'mobileNumberController': TextEditingController(),
      'serverNumberController': TextEditingController(),
      'consentController': TextEditingController(),

      // Address controllers - these will be used in the popup
      'addressControllers': <String, TextEditingController>{
        'plotNoController': TextEditingController(),
        'addressController': TextEditingController(),
        'mobileNumberController': TextEditingController(), // For address popup
        'emailController': TextEditingController(),
        'pincodeController': TextEditingController(),
        'districtController': TextEditingController(),
        'villageController': TextEditingController(),
        'postOfficeController': TextEditingController(),
      },

      // Data storage
      'name': '',
      'mobileNumber': '',
      'serverNumber': '',
      'consent': '',
      'address': <String, String>{
        'plotNo': '',
        'address': '',
        'mobileNumber': '',
        'email': '',
        'pincode': '',
        'district': '',
        'village': '',
        'postOffice': '',
      },
    };
  }

  void _disposeEntryControllers(Map<String, dynamic> entry) {
    // Dispose basic controllers safely
    (entry['nameController'] as TextEditingController?)?.dispose();
    (entry['mobileNumberController'] as TextEditingController?)?.dispose();
    (entry['serverNumberController'] as TextEditingController?)?.dispose();
    (entry['consentController'] as TextEditingController?)?.dispose();

    // Dispose address controllers safely
    final addressControllers = entry['addressControllers'] as Map<String, TextEditingController>?;
    addressControllers?.values.forEach((controller) => controller.dispose());
  }

  void updateCoownerEntry(int index, String field, String value) {
    if (index < coownerEntries.length) {
      coownerEntries[index][field] = value;

      // Clear validation error for this field
      validationErrors.remove('${index}_$field');

      // Validate the field
      _validateField(index, field, value);

      update(); // Trigger UI update
    }
  }

  void updateCoownerAddress(int index, Map<String, String> addressData) {
    if (index < coownerEntries.length) {
      coownerEntries[index]['address'] = addressData;

      // Clear address validation errors
      validationErrors.removeWhere((key, value) => key.startsWith('${index}_address'));
      validationErrors.removeWhere((key, value) => key.startsWith('${index}_pincode'));
      validationErrors.removeWhere((key, value) => key.startsWith('${index}_village'));
      validationErrors.removeWhere((key, value) => key.startsWith('${index}_postOffice'));

      // Validate address fields
      _validateAddressFields(index, addressData);

      update(); // Trigger UI update
    }
  }

  void _validateField(int index, String field, String value) {
    switch (field) {
      case 'name':
        if (value.trim().isEmpty) {
          validationErrors['${index}_$field'] = 'Co-owner name is required';
        }
        break;
      case 'mobileNumber':
        if (value.trim().isEmpty) {
          validationErrors['${index}_$field'] = 'Mobile number is required';
        } else if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
          validationErrors['${index}_$field'] = 'Enter valid 10-digit mobile number';
        }
        break;
      case 'consent':
        if (value.trim().isEmpty) {
          validationErrors['${index}_$field'] = 'Consent information is required';
        }
        break;
    }
  }

  void _validateAddressFields(int index, Map<String, String> addressData) {
    if (addressData['address']?.trim().isEmpty ?? true) {
      validationErrors['${index}_address'] = 'Address is required';
    }
    if (addressData['pincode']?.trim().isEmpty ?? true) {
      validationErrors['${index}_pincode'] = 'Pincode is required';
    }
    if (addressData['village']?.trim().isEmpty ?? true) {
      validationErrors['${index}_village'] = 'Village is required';
    }
    if (addressData['postOffice']?.trim().isEmpty ?? true) {
      validationErrors['${index}_postOffice'] = 'Post Office is required';
    }
  }

  void clearValidationErrors() {
    validationErrors.clear();
  }

  // Get formatted address for display
  String getFormattedAddress(int index) {
    if (index >= coownerEntries.length) return 'Click to add address';

    final addressEntry = coownerEntries[index]['address'];
    if (addressEntry == null) return 'Click to add address';

    final address = addressEntry as Map<String, String>;
    final parts = <String>[];

    if (address['plotNo']?.isNotEmpty == true) parts.add(address['plotNo']!);
    if (address['address']?.isNotEmpty == true) parts.add(address['address']!);
    if (address['village']?.isNotEmpty == true) parts.add(address['village']!);
    if (address['postOffice']?.isNotEmpty == true) parts.add(address['postOffice']!);
    if (address['pincode']?.isNotEmpty == true) parts.add(address['pincode']!);

    return parts.isEmpty ? 'Click to add address' : parts.join(', ');
  }

  // Show address popup
  void showAddressPopup(BuildContext context, int index) {
    if (index >= coownerEntries.length) return;

    final addressControllersEntry = coownerEntries[index]['addressControllers'];
    final currentAddressEntry = coownerEntries[index]['address'];

    if (addressControllersEntry == null || currentAddressEntry == null) return;

    final addressControllers = addressControllersEntry as Map<String, TextEditingController>;
    final currentAddress = currentAddressEntry as Map<String, String>;

    // Populate controllers with current data safely
    addressControllers['plotNoController']?.text = currentAddress['plotNo'] ?? '';
    addressControllers['addressController']?.text = currentAddress['address'] ?? '';
    addressControllers['mobileNumberController']?.text = currentAddress['mobileNumber'] ?? '';
    addressControllers['emailController']?.text = currentAddress['email'] ?? '';
    addressControllers['pincodeController']?.text = currentAddress['pincode'] ?? '';
    addressControllers['districtController']?.text = currentAddress['district'] ?? '';
    addressControllers['villageController']?.text = currentAddress['village'] ?? '';
    addressControllers['postOfficeController']?.text = currentAddress['postOffice'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AddressPopup(
        entryIndex: index,
        controllers: addressControllers,
        onSave: () => _saveAddressFromPopup(index),
      ),
    );
  }

  void _saveAddressFromPopup(int index) {
    if (index >= coownerEntries.length) return;

    final addressControllersEntry = coownerEntries[index]['addressControllers'];
    if (addressControllersEntry == null) return;

    final addressControllers = addressControllersEntry as Map<String, TextEditingController>;

    final addressData = <String, String>{
      'plotNo': addressControllers['plotNoController']?.text ?? '',
      'address': addressControllers['addressController']?.text ?? '',
      'mobileNumber': addressControllers['mobileNumberController']?.text ?? '',
      'email': addressControllers['emailController']?.text ?? '',
      'pincode': addressControllers['pincodeController']?.text ?? '',
      'district': addressControllers['districtController']?.text ?? '',
      'village': addressControllers['villageController']?.text ?? '',
      'postOffice': addressControllers['postOfficeController']?.text ?? '',
    };

    updateCoownerAddress(index, addressData);
    Get.back(); // Close the popup
  }

  // StepValidationMixin implementation
  @override
    bool validateCurrentSubStep(String field) {
    clearValidationErrors();
    bool isValid = true;

    for (int i = 0; i < coownerEntries.length; i++) {
      final entry = coownerEntries[i];

      // Validate required fields
      final name = (entry['nameController'] as TextEditingController).text;
      final mobileNumber = (entry['mobileNumberController'] as TextEditingController).text;
      final consent = (entry['consentController'] as TextEditingController).text;
      final address = entry['address'] as Map<String, String>;

      _validateField(i, 'name', name);
      _validateField(i, 'mobileNumber', mobileNumber);
      _validateField(i, 'consent', consent);
      _validateAddressFields(i, address);

      // Update the entry data
      entry['name'] = name;
      entry['mobileNumber'] = mobileNumber;
      entry['consent'] = consent;
      entry['serverNumber'] = (entry['serverNumberController'] as TextEditingController).text;
    }

    isValid = validationErrors.isEmpty;
    return isValid;
  }

  // Complete validation method (commented but fixed for future use)
  bool validateAllFields() {
    clearValidationErrors();
    bool isValid = true;

    for (int i = 0; i < coownerEntries.length; i++) {
      final entry = coownerEntries[i];

      // Validate required fields safely
      final name = (entry['nameController'] as TextEditingController?)?.text ?? '';
      final mobileNumber = (entry['mobileNumberController'] as TextEditingController?)?.text ?? '';
      final consent = (entry['consentController'] as TextEditingController?)?.text ?? '';
      final addressEntry = entry['address'];
      final address = addressEntry != null ? addressEntry as Map<String, String> : <String, String>{};

      _validateField(i, 'name', name);
      _validateField(i, 'mobileNumber', mobileNumber);
      _validateField(i, 'consent', consent);
      _validateAddressFields(i, address);

      // Update the entry data safely
      entry['name'] = name;
      entry['mobileNumber'] = mobileNumber;
      entry['consent'] = consent;
      entry['serverNumber'] = (entry['serverNumberController'] as TextEditingController?)?.text ?? '';
    }

    isValid = validationErrors.isEmpty;
    return isValid;
  }

  @override
  bool isStepCompleted(List<String> fields) {
    return validateCurrentSubStep('');
  }

  @override
  String getFieldError(String field) {
    if (validationErrors.isNotEmpty) {
      return validationErrors.values.first;
    }
    return 'Please complete all required fields';
  }

  // StepDataMixin implementation
  @override
  Map<String, dynamic> getStepData() {
    final List<Map<String, dynamic>> coownerData = [];

    for (int i = 0; i < coownerEntries.length; i++) {
      final entry = coownerEntries[i];
      final addressEntry = entry['address'];

      coownerData.add({
        'name': entry['name'] ?? '',
        'mobileNumber': entry['mobileNumber'] ?? '',
        'serverNumber': entry['serverNumber'] ?? '',
        'consent': entry['consent'] ?? '',
        'address': addressEntry != null
            ? Map<String, String>.from(addressEntry as Map)
            : <String, String>{},
      });
    }

    return {
      'coowners': coownerData,
      'coownerCount': coownerEntries.length,
    };
  }
}