class PlantationFermeModel {
  final String id_plantation;
  final String id_ferme;
  //final DateTime createdAt;
  final String name;
  final String prenom;
  final String fonction;
  final String avatar;

  PlantationFermeModel({this.id_plantation, this.id_ferme, this.name, this.prenom,  this.fonction, this.avatar});

  factory PlantationFermeModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return PlantationFermeModel(
      id_plantation: json["id_plantation"],
      id_ferme: json["id_elevage"],
      //createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      name: json["nom_personne"],
      prenom: json["prenom_personne"],
      fonction: json["nom_fonction"],
      avatar: json["images"],
    );
  }

  static List<PlantationFermeModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => PlantationFermeModel.fromJson(item)).toList();
  }

}