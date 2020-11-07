class SubCategory {
  int id;
  String name;
  String type;
  int categoryId;
  int checked;

  SubCategory({this.id, this.name, this.categoryId, this.type, this.checked});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      categoryId: json['category_id'] as int,
      type: json['type'] as String,
      checked: json['checked'] as int,
    );
  }
}
