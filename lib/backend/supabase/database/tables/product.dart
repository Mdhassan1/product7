import '../database.dart';

class ProductTable extends SupabaseTable<ProductRow> {
  @override
  String get tableName => 'product';

  @override
  ProductRow createRow(Map<String, dynamic> data) => ProductRow(data);
}

class ProductRow extends SupabaseDataRow {
  ProductRow(super.data);

  @override
  SupabaseTable get table => ProductTable();

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get category => getField<String>('category')!;
  set category(String value) => setField<String>('category', value);

  int get purchaseValue => getField<int>('purchase_value')!;
  set purchaseValue(int value) => setField<int>('purchase_value', value);

  List<String> get productPhoto => getListField<String>('product_photo');
  set productPhoto(List<String> value) =>
      setListField<String>('product_photo', value);

  List<String> get productBill => getListField<String>('product_bill');
  set productBill(List<String> value) =>
      setListField<String>('product_bill', value);

  List<String> get wcardPhoto => getListField<String>('wcard_photo');
  set wcardPhoto(List<String> value) =>
      setListField<String>('wcard_photo', value);

  String get description => getField<String>('description')!;
  set description(String value) => setField<String>('description', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime? get purchaseDate => getField<DateTime>('purchase_date');
  set purchaseDate(DateTime? value) =>
      setField<DateTime>('purchase_date', value);

  DateTime? get validityDate => getField<DateTime>('validity_date');
  set validityDate(DateTime? value) =>
      setField<DateTime>('validity_date', value);
}


