class Match {
  String? tbakey;
  String? matchtypeid;
  String? number;

  Match({this.tbakey, this.matchtypeid, this.number});

  Match.fromJson(Map<String, dynamic> json) {
    tbakey = json['tbakey'];
    matchtypeid = json['matchtypeid'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tbakey'] = tbakey;
    data['matchtypeid'] = matchtypeid;
    data['number'] = number;
    return data;
  }
}
