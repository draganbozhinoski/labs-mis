class Exam {
  final String id;
  final String predmet;
  final String sesija;
  final DateTime dateTime;
  final String? userId;
  Exam({required this.id,required this.predmet,required this.sesija,required this.dateTime,required this.userId});
  @override
  String toString() {
    return predmet;
  }
}