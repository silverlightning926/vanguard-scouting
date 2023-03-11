class Competition {
  String? tbakey;
  String? name;
  String? startdate;

  Competition({this.tbakey, this.name, this.startdate});

  Competition.fromJson(Map<String, dynamic> json) {
    tbakey = json['tbakey'];
    name = json['name'];
    startdate = json['startdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tbakey'] = tbakey;
    data['name'] = name;
    data['startdate'] = startdate;
    return data;
  }
}
