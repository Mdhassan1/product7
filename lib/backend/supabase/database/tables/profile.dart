import '../database.dart';

class ProfileTable extends SupabaseTable<ProfileRow> {
  @override
  String get tableName => 'profile';

  @override
  ProfileRow createRow(Map<String, dynamic> data) => ProfileRow(data);
}

class ProfileRow extends SupabaseDataRow {
  ProfileRow(super.data);

  @override
  SupabaseTable get table => ProfileTable();

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get phoneNumber => getField<String>('phone_number');
  set phoneNumber(String? value) => setField<String>('phone_number', value);

  String? get emailAddress => getField<String>('email_address');
  set emailAddress(String? value) => setField<String>('email_address', value);

  String? get address => getField<String>('address');
  set address(String? value) => setField<String>('address', value);

  String? get fcmToken => getField<String>('fcm_token');
  set fcmToken(String? value) => setField<String>('fcm_token', value);

}
