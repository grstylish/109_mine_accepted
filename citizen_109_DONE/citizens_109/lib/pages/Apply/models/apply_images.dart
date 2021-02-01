class ApplyImages {
  final int id;
  final String name;
  final String image;
  final String namekz;

  ApplyImages({this.id, this.name, this.image, this.namekz});

  factory ApplyImages.parseMap(Map object) {
    return ApplyImages(
        id: object['id'],
        name: object['name'],
        image: object['image'],
        namekz: object['name_kz']);
  }

  static List<ApplyImages> parseList(List objectList) {
    List<ApplyImages> list = [];
    for (Map item in objectList) list.add(ApplyImages.parseMap(item));
    return list;
  }
}
