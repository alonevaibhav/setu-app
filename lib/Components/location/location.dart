import 'package:get/get.dart';
import '../../API Service/api_service.dart';
import '../../Constants/api_constant.dart';

class LocationController extends GetxController {
  // Observable variables for state management
  var isLoading = false.obs;
  var states = <StateModel>[].obs; // Adjust the model type as needed
  var errorMessage = ''.obs;


  @override
  void onInit() {
    super.onInit();
    // Optionally fetch states when controller initializes
    fetchStates();
  }

  /// Fetch states from API
  Future<void> fetchStates() async {
    try {
      // Set loading state
      isLoading.value = true;
      errorMessage.value = '';

      // Make the API call
      final response = await ApiService.get<List<StateModel>>(
        endpoint: stateGet,
        fromJson: (data) {
          // Handle the response data conversion
          if (data is Map<String, dynamic> && data.containsKey('data')) {
            final List<dynamic> statesList = data['data'] as List<dynamic>;
            return statesList.map((item) => StateModel.fromJson(item)).toList();
          } else {
            throw Exception('Unexpected response format');
          }
        },
        includeToken: true, // Set to false if this endpoint doesn't require authentication
      );

      if (response.success && response.data != null) {
        // Update states list
        states.value = response.data!;

        // Optional: Show success message
        Get.snackbar(
          'Success',
          'States loaded successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Handle error
        errorMessage.value = response.errorMessage ?? 'Failed to fetch states';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      // Handle any exceptions
      errorMessage.value = 'An error occurred: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  

  /// Clear states data
  void clearStates() {
    states.clear();
    errorMessage.value = '';
  }
}

class StateModel {
  final int id;
  final String name;
  final String code;
  final DateTime createdAt;
  final DateTime updatedAt;

  StateModel({
    required this.id,
    required this.name,
    required this.code,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'StateModel(id: $id, name: $name, code: $code)';
  }
}

