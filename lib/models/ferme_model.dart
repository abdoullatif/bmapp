class fermeModel {
  final String id;
  //final DateTime createdAt;
  final String name;
  final String prenom;
  final String fonction;
  final String avatar;

  fermeModel({this.id, this.name, this.prenom,  this.fonction, this.avatar});

  factory fermeModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return fermeModel(
      id: json["id_elevage"],
      //createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      name: json["nom_personne"],
      prenom: json["prenom_personne"],
      fonction: json["nom_fonction"],
      avatar: json["images"],
    );
  }

  static List<fermeModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => fermeModel.fromJson(item)).toList();
  }

}