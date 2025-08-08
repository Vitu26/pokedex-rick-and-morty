
class Validators {

  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }


  static bool isValidId(int? id) {
    return id != null && id > 0;
  }


  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }


  static bool isValidStatus(String? status) {
    if (status == null) return false;
    final validStatuses = ['Alive', 'Dead', 'unknown'];
    return validStatuses.contains(status);
  }


  static bool isValidSpecies(String? species) {
    return isNotEmpty(species);
  }


  static bool isValidGender(String? gender) {
    if (gender == null) return false;
    final validGenders = ['Male', 'Female', 'Genderless', 'unknown'];
    return validGenders.contains(gender);
  }


  static bool isValidCharacter(Map<String, dynamic> json) {
    return isNotEmpty(json['name']?.toString()) &&
        isValidId(json['id']) &&
        isValidStatus(json['status']?.toString()) &&
        isValidSpecies(json['species']?.toString()) &&
        isValidGender(json['gender']?.toString()) &&
        isValidUrl(json['image']?.toString());
  }
}
