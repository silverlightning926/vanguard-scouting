class TeamStats {
  String? teamNumber;
  String? teamName;
  String? aVGHighCones;
  String? aVGMiddleCones;
  String? aVGLowCones;
  String? aVGHighCubes;
  String? aVGMiddleCubes;
  String? aVGLowCubes;

  TeamStats(
      {this.teamNumber,
      this.teamName,
      this.aVGHighCones,
      this.aVGMiddleCones,
      this.aVGLowCones,
      this.aVGHighCubes,
      this.aVGMiddleCubes,
      this.aVGLowCubes});

  TeamStats.fromJson(Map<String, dynamic> json) {
    teamNumber = json['Team Number'];
    teamName = json['Team Name'];
    aVGHighCones = json['AVG High Cones'];
    aVGMiddleCones = json['AVG Middle Cones'];
    aVGLowCones = json['AVG Low Cones'];
    aVGHighCubes = json['AVG High Cubes'];
    aVGMiddleCubes = json['AVG Middle Cubes'];
    aVGLowCubes = json['AVG Low Cubes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Team Number'] = this.teamNumber;
    data['Team Name'] = this.teamName;
    data['AVG High Cones'] = this.aVGHighCones;
    data['AVG Middle Cones'] = this.aVGMiddleCones;
    data['AVG Low Cones'] = this.aVGLowCones;
    data['AVG High Cubes'] = this.aVGHighCubes;
    data['AVG Middle Cubes'] = this.aVGMiddleCubes;
    data['AVG Low Cubes'] = this.aVGLowCubes;
    return data;
  }
}
