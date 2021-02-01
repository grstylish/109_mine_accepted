class GuideImages {
  final int id;
  final String name;
  final String image;
  final String name_kz;

  GuideImages({this.id, this.name, this.image, this.name_kz});

  factory GuideImages.parseMap(Map object) {
    return GuideImages(
      id: object['id'],
      name: object['name'],
      name_kz: object['name_kz'],
      image: object['image'],
    );
  }

  static List<GuideImages> parseList(List objectList) {
    List<GuideImages> list = [];
    for (Map item in objectList) list.add(GuideImages.parseMap(item));
    return list;
  }
}
