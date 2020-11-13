class CartItem {
  int id;
  String name;
  bool checked;

  CartItem(this.id, this.name, this.checked);

  @override
  String toString() {
    return "$id: $name: $checked";
  }
}