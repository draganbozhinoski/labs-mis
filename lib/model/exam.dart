class Exam {
  final String id;
  final String predmet;
  final String sesija;
  final DateTime dateTime;
  final String? userId;
  final double latitude;
  final double longitude;
  Exam({required this.id,required this.predmet,required this.sesija,required this.dateTime,required this.userId,required this.latitude,required this.longitude});
  @override
  String toString() {
    return predmet;
  }
}