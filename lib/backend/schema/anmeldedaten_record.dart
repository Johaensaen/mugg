import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'anmeldedaten_record.g.dart';

abstract class AnmeldedatenRecord
    implements Built<AnmeldedatenRecord, AnmeldedatenRecordBuilder> {
  static Serializer<AnmeldedatenRecord> get serializer =>
      _$anmeldedatenRecordSerializer;

  @nullable
  String get email;

  @nullable
  @BuiltValueField(wireName: 'display_name')
  String get displayName;

  @nullable
  @BuiltValueField(wireName: 'photo_url')
  String get photoUrl;

  @nullable
  String get uid;

  @nullable
  @BuiltValueField(wireName: 'created_time')
  DateTime get createdTime;

  @nullable
  @BuiltValueField(wireName: 'phone_number')
  String get phoneNumber;

  @nullable
  String get ticket;

  @nullable
  double get budget;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(AnmeldedatenRecordBuilder builder) => builder
    ..email = ''
    ..displayName = ''
    ..photoUrl = ''
    ..uid = ''
    ..phoneNumber = ''
    ..ticket = ''
    ..budget = 0.0;

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Anmeldedaten');

  static Stream<AnmeldedatenRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  static Future<AnmeldedatenRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then(
          (s) => serializers.deserializeWith(serializer, serializedData(s)));

  AnmeldedatenRecord._();
  factory AnmeldedatenRecord(
          [void Function(AnmeldedatenRecordBuilder) updates]) =
      _$AnmeldedatenRecord;

  static AnmeldedatenRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createAnmeldedatenRecordData({
  String email,
  String displayName,
  String photoUrl,
  String uid,
  DateTime createdTime,
  String phoneNumber,
  String ticket,
  double budget,
}) =>
    serializers.toFirestore(
        AnmeldedatenRecord.serializer,
        AnmeldedatenRecord((a) => a
          ..email = email
          ..displayName = displayName
          ..photoUrl = photoUrl
          ..uid = uid
          ..createdTime = createdTime
          ..phoneNumber = phoneNumber
          ..ticket = ticket
          ..budget = budget));
