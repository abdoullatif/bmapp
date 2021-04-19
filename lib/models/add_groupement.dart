class addgroupModel {
  final String id;
  //final DateTime createdAt;
  final String name;
  final String prenom;
  final String fonction;
  final String avatar;

  addgroupModel({this.id, this.name, this.prenom,  this.fonction, this.avatar});

  factory addgroupModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return addgroupModel(
      id: json["id_personne"],
      //createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      name: json["nom_personne"],
      prenom: json["prenom_personne"],
      fonction: json["nom_fonction"],
      avatar: json["images"],
    );
  }

  static List<addgroupModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => addgroupModel.fromJson(item)).toList();
  }

/*
  @override
  String toString() => name;

  @override
  operator ==(o) => o is chefgroupModel && o.id == id;

  @override
  int get hashCode => id.hashCode^name.hashCode^createdAt.hashCode;
   */

}