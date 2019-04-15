class Categories {
  int _catId;
  String _catName;

  void setCatId(int id) {
    this._catId = id;
  }

  int getCatId() {
    return this._catId;
  }

  void setCatName(String catName) {
    this._catName = catName;
  }

  String getCatName() {
    return this._catName;
  }

  Categories(int id, String catName) {
    this.setCatId(id);
    this.setCatName(catName);
  }
}
