void main() async {
  print(
      'Phugntd: ${DateTime.now()} testtt : ${DateTime.parse("2020-01-10 01:00:00.299871").difference(DateTime.parse("2020-01-09 01:00:00.299871")).inDays}');
  print(
      'Phugntd: ${DateTime.now()} testtt : ${DateTime.parse("2020-01-08 01:00:00.299871").difference(DateTime.parse("2020-01-09 01:00:00.299871")).inDays}');
  print(
      'Phungtd: ${dayDifference(DateTime.parse("2020-01-08 20:00:00.299871"), DateTime.parse("2020-01-09 00:00:00.299871"))}');

  var date1 = DateTime.now();
  var date2 = date1;

  print ('date1.hashCode: ${date1.hashCode} - date2.hashCode: ${date2.hashCode}');
  print('date1 minute: ${date1.minute} - date2 minute: ${date2.minute}');

  date1 = date1.add(Duration(minutes: 5));

  print ('date1.hashCode: ${date1.hashCode} - date2.hashCode: ${date2.hashCode}');
  print('date1 minute: ${date1.minute} - date2 minute: ${date2.minute}');

}

int dayDifference(DateTime current, DateTime other) {
  final startDate = DateTime(current.year, current.month, current.day);
  final endDate = DateTime(other.year, other.month, other.day);

  return startDate.difference(endDate).inDays.abs() + 1;
}
