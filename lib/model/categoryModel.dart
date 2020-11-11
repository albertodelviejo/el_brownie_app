

class CategoryModel {
  String category;
  String image;
  bool isChecked;

  CategoryModel(
    this.category,
    this.image,
    this.isChecked
  );

  void check() {
    this.isChecked = true;
  }

  void uncheck() {
    this.isChecked = false;
  }
}