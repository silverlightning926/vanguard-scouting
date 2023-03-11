class Robot {
  int? robotinmatchid;
  String? tbakey;
  String? number;
  String? name;

  Robot({this.robotinmatchid, this.tbakey, this.number, this.name});

  Robot.fromJson(Map<String, dynamic> json) {
    robotinmatchid = json['robotinmatchid'];
    tbakey = json['tbakey'];
    number = json['number'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['robotinmatchid'] = robotinmatchid;
    data['tbakey'] = tbakey;
    data['number'] = number;
    data['name'] = name;
    return data;
  }
}
