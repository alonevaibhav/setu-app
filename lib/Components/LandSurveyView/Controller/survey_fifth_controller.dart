import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../Controller/main_controller.dart';

class SurveyFifthController extends GetxController with StepValidationMixin, StepDataMixin {
  // Observable list of applicant entries
  final applicantEntries = <Map<String, dynamic>>[].obs;

  // Loading states
  final isLoading = false.obs;

  // Validation errors
  final validationErrors = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with one entry
    addApplicantEntry();
  }

  // Add new applicant entry
  void addApplicantEntry() {
    final newEntry = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'agreementController': TextEditingController(),
      'accountHolderNameController': TextEditingController(),
      'accountNumberController': TextEditingController(),
      'mobileNumberController': TextEditingController(),
      'serverNumberController': TextEditingController(),
      'areaController': TextEditingController(),
      'potkaharabaAreaController': TextEditingController(),
      'totalAreaController': TextEditingController(),
      // Address fields
      'address': <String, dynamic>{
        'plotNo': '',
        'address': '',
        'mobileNumber': '',
        'email': '',
        'pincode': '',
        'district': '',
        'village': '',
        'postOffice': '',
      }.obs,
      // Controllers for address popup
      'addressControllers': {
        'plotNoController': TextEditingController(),
        'addressController': TextEditingController(),
        'mobileNumberController': TextEditingController(),
        'emailController': TextEditingController(),
        'pincodeController': TextEditingController(),
        'districtController': TextEditingController(),
        'villageController': TextEditingController(),
        'postOfficeController': TextEditingController(),
      },
    };
    applicantEntries.add(newEntry);
  }

  // Remove applicant entry
  void removeApplicantEntry(int index) {
    if (applicantEntries.length > 1) {
      // Dispose controllers
      final entry = applicantEntries[index];
      entry['agreementController']?.dispose();
      entry['accountHolderNameController']?.dispose();
      entry['accountNumberController']?.dispose();
      entry['mobileNumberController']?.dispose();
      entry['serverNumberController']?.dispose();
      entry['areaController']?.dispose();
      entry['potkaharabaAreaController']?.dispose();
      entry['totalAreaController']?.dispose();

      // Dispose address controllers
      final addressControllers = entry['addressControllers'] as Map<String, TextEditingController>;
      addressControllers.values.forEach((controller) => controller.dispose());

      applicantEntries.removeAt(index);
    }
  }

  // Update applicant entry field
  void updateApplicantEntry(int index, String field, String value) {
    if (index < applicantEntries.length) {
      // Clear validation error for this field
      validationErrors.remove('${index}_$field');
    }
  }

  // Show address popup
  Future<void> showAddressPopup(BuildContext context, int entryIndex) async {
    final entry = applicantEntries[entryIndex];
    final addressControllers = entry['addressControllers'] as Map<String, TextEditingController>;
    final addressData = entry['address'] as RxMap<String, dynamic>;

    // Pre-fill controllers with existing data
    addressControllers['plotNoController']!.text = addressData['plotNo'] ?? '';
    addressControllers['addressController']!.text = addressData['address'] ?? '';
    addressControllers['mobileNumberController']!.text = addressData['mobileNumber'] ?? '';
    addressControllers['emailController']!.text = addressData['email'] ?? '';
    addressControllers['pincodeController']!.text = addressData['pincode'] ?? '';
    addressControllers['districtController']!.text = addressData['district'] ?? '';
    addressControllers['villageController']!.text = addressData['village'] ?? '';
    addressControllers['postOfficeController']!.text = addressData['postOffice'] ?? '';

    final result = await Get.dialog<bool>(
      AddressPopup(
        entryIndex: entryIndex,
        controllers: addressControllers,
        onSave: () {
          _saveAddressData(entryIndex, addressControllers);
          Get.back(result: true);
        },
      ),
      barrierDismissible: false,
    );
  }

  // Save address data
  void _saveAddressData(int entryIndex, Map<String, TextEditingController> controllers) {
    final entry = applicantEntries[entryIndex];
    final addressData = entry['address'] as RxMap<String, dynamic>;

    addressData.addAll({
      'plotNo': controllers['plotNoController']!.text,
      'address': controllers['addressController']!.text,
      'mobileNumber': controllers['mobileNumberController']!.text,
      'email': controllers['emailController']!.text,
      'pincode': controllers['pincodeController']!.text,
      'district': controllers['districtController']!.text,
      'village': controllers['villageController']!.text,
      'postOffice': controllers['postOfficeController']!.text,
    });
  }

  // Get formatted address string
  String getFormattedAddress(int entryIndex) {
    if (entryIndex >= applicantEntries.length) return 'Click to add address';

    final addressData = applicantEntries[entryIndex]['address'] as RxMap<String, dynamic>;
    final plotNo = addressData['plotNo'] ?? '';
    final address = addressData['address'] ?? '';
    final village = addressData['village'] ?? '';

    if (plotNo.isEmpty && address.isEmpty && village.isEmpty) {
      return 'Click to add address';
    }

    return [plotNo, address, village].where((s) => s.isNotEmpty).join(', ');
  }

  // Validation methods
  @override
  bool validateCurrentSubStep(String field) {
    switch (field) {
      case 'government_survey':
        return true; // Temporarily return true to bypass validation
      default:
        return true;
    }
  }
  // bool validateCurrentSubStep(String field) {
  //   validationErrors.clear();
  //   bool isValid = true;
  //
  //   for (int i = 0; i < applicantEntries.length; i++) {
  //     final entry = applicantEntries[i];
  //
  //     // Check required fields
  //     if ((entry['agreementController'] as TextEditingController).text.isEmpty) {
  //       validationErrors['${i}_agreement'] = 'Agreement is required';
  //       isValid = false;
  //     }
  //
  //     if ((entry['accountHolderNameController'] as TextEditingController).text.isEmpty) {
  //       validationErrors['${i}_accountHolderName'] = 'Account holder name is required';
  //       isValid = false;
  //     }
  //
  //     if ((entry['accountNumberController'] as TextEditingController).text.isEmpty) {
  //       validationErrors['${i}_accountNumber'] = 'Account number is required';
  //       isValid = false;
  //     }
  //
  //     if ((entry['mobileNumberController'] as TextEditingController).text.isEmpty) {
  //       validationErrors['${i}_mobileNumber'] = 'Mobile number is required';
  //       isValid = false;
  //     }
  //
  //     // Validate address data
  //     final addressData = entry['address'] as RxMap<String, dynamic>;
  //     if ((addressData['address'] ?? '').isEmpty) {
  //       validationErrors['${i}_address'] = 'Address is required';
  //       isValid = false;
  //     }
  //
  //     if ((addressData['pincode'] ?? '').isEmpty) {
  //       validationErrors['${i}_pincode'] = 'Pincode is required';
  //       isValid = false;
  //     }
  //
  //     if ((addressData['village'] ?? '').isEmpty) {
  //       validationErrors['${i}_village'] = 'Village is required';
  //       isValid = false;
  //     }
  //
  //     if ((addressData['postOffice'] ?? '').isEmpty) {
  //       validationErrors['${i}_postOffice'] = 'Post Office is required';
  //       isValid = false;
  //     }
  //   }
  //
  //   return isValid;
  // }

  @override
  bool isStepCompleted(List<String> fields) {
    return validateCurrentSubStep('');
  }

  @override
  String getFieldError(String field) {
    return validationErrors[field] ?? 'This field is required';
  }

  @override
  Map<String, dynamic> getStepData() {
    final data = <String, dynamic>{};

    for (int i = 0; i < applicantEntries.length; i++) {
      final entry = applicantEntries[i];
      final addressData = entry['address'] as RxMap<String, dynamic>;

      data['applicant_$i'] = {
        'agreement': (entry['agreementController'] as TextEditingController).text,
        'accountHolderName': (entry['accountHolderNameController'] as TextEditingController).text,
        'accountNumber': (entry['accountNumberController'] as TextEditingController).text,
        'mobileNumber': (entry['mobileNumberController'] as TextEditingController).text,
        'serverNumber': (entry['serverNumberController'] as TextEditingController).text,
        'area': (entry['areaController'] as TextEditingController).text,
        'potkaharabaArea': (entry['potkaharabaAreaController'] as TextEditingController).text,
        'totalArea': (entry['totalAreaController'] as TextEditingController).text,
        'address': Map<String, dynamic>.from(addressData),
      };
    }

    data['applicantCount'] = applicantEntries.length;
    return data;
  }

  @override
  void onClose() {
    // Dispose all controllers
    for (final entry in applicantEntries) {
      entry['agreementController']?.dispose();
      entry['accountHolderNameController']?.dispose();
      entry['accountNumberController']?.dispose();
      entry['mobileNumberController']?.dispose();
      entry['serverNumberController']?.dispose();
      entry['areaController']?.dispose();
      entry['potkaharabaAreaController']?.dispose();
      entry['totalAreaController']?.dispose();

      final addressControllers = entry['addressControllers'] as Map<String, TextEditingController>;
      addressControllers.values.forEach((controller) => controller.dispose());
    }
    super.onClose();
  }
}

// Address Popup Widget
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
                    _buildTextField(
                      controller: controllers['plotNoController']!,
                      label: 'Plot No./House No./Flat No.',
                      icon: Icons.home_outlined,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: controllers['addressController']!,
                      label: 'Address *',
                      icon: Icons.location_on_outlined,
                      maxLines: 3,
                      required: true,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: controllers['mobileNumberController']!,
                      label: 'Mobile Number *',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      required: true,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: controllers['emailController']!,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: controllers['pincodeController']!,
                      label: 'Pincode *',
                      icon: Icons.pin_drop_outlined,
                      keyboardType: TextInputType.number,
                      required: true,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: controllers['districtController']!,
                      label: 'District',
                      icon: Icons.location_city_outlined,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: controllers['villageController']!,
                      label: 'Village *',
                      icon: Icons.landscape_outlined,
                      required: true,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: controllers['postOfficeController']!,
                      label: 'Post Office *',
                      icon: Icons.local_post_office_outlined,
                      required: true,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF52B788)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF52B788), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}