class Filter {
  Filter([this.containsText = "", this.matchesDate]);

  String containsText = "";
  DateTime? matchesDate;
}