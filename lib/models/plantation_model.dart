class PlantationModel {
  final String id;
  //final DateTime createdAt;
  final String name;
  final String prenom;
  final String fonction;
  final String avatar;

  PlantationModel({this.id, this.name, this.prenom,  this.fonction, this.avatar});

  factory PlantationModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return PlantationModel(
      id: json["id_plantation"],
      //createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      name: json["nom_personne"],
      prenom: json["prenom_personne"],
      fonction: json["nom_fonction"],
      avatar: json["images"],
    );
  }

  static List<PlantationModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => PlantationModel.fromJson(item)).toList();
  }

  /*
  @override
  String toString() => name;

  @override
  operator ==(o) => o is PlantationModel && o.id == id;

  @override
  int get hashCode => id.hashCode^name.hashCode^createdAt.hashCode;
   */

}