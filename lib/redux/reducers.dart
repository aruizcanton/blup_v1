import 'package:blupv1/model/CartItem.dart';
import 'package:blupv1/redux/actions.dart';

List<CartItem> appReducers (List<CartItem> items, dynamic action) {
  if (action is AddItemAction) {
    return addItem (items, action);
  } else if (action is ToggleItemStateAction) {
    return toggleItemState (items, action);
  }
  return items;
}

List<CartItem> addItem (List<CartItem> items, AddItemAction action) {
  return new List.from(items)..add(action.item);
}

List<CartItem> toggleItemState (List<CartItem> items, ToggleItemStateAction action) {
  List<CartItem> itemsNew = items
      .map((item) =>
          item.id == action.item.id ? action.item : item)
      .toList();
  return itemsNew;
}