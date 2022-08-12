class HelperWidget {

  int calculateAge(String birthDate) {
    DateTime  currentDate = DateTime.now();

    List<String> splittedDate = birthDate.split('/');
    String birthDateDay = splittedDate[0];
    String birthDateMonth = splittedDate[1];
    String birthDateYear = splittedDate[2];

    int age = currentDate.year - int.parse(birthDateYear);
    int month1 = currentDate.month;
    int month2 = int.parse(birthDateMonth);

    if (int.parse(birthDateMonth) > currentDate.month) {
      age--;
    } else if (month1 == month2) {
      if (int.parse(birthDateDay) > currentDate.day) {
        age--;
      }
    }
    return age;
  }
}