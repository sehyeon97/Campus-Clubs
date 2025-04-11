class Timeslot {
  String day;
  int hours1;
  int minutes1;
  int hours2;
  int minutes2;

  Timeslot(this.day, this.hours1, this.minutes1, this.hours2, this.minutes2);

  Timeslot.fromString(String str)
      : day = str[0],
        hours1 = int.parse(str.substring(2, 4)),
        minutes1 = int.parse(str.substring(5, 7)),
        hours2 = int.parse(str.substring(8, 10)),
        minutes2 = int.parse(str.substring(11, 13)) {
    if (str.length > 13) {
      String suffix = str.substring(13);
      if (suffix == 'PM') {
        if (hours1 != 12) hours1 += 12;
        if (hours2 != 12) hours2 += 12;
      }
    }
  }

  @override
  String toString() {
    String format(int value) => value < 10 ? '0$value' : '$value';

    return '$day ${format(hours1)}:${format(minutes1)}-${format(hours2)}:${format(minutes2)}';
  }
}