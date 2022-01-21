import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'bluetooth_record.g.dart';

abstract class BluetoothRecord
    implements Built<BluetoothRecord, BluetoothRecordBuilder> {
  static Serializer<BluetoothRecord> get serializer =>
      _$bluetoothRecordSerializer;

  @nullable
  @BuiltValueField(wireName: 'device_name')
  String get deviceName;

  @nullable
  double get distance;

  @nullable
  @BuiltValueField(wireName: 'distance_color')
  String get distanceColor;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(BluetoothRecordBuilder builder) => builder
    ..deviceName = ''
    ..distance = 0.0
    ..distanceColor = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('bluetooth');

  static Stream<BluetoothRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  static Future<BluetoothRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s)));

  BluetoothRecord._();
  factory BluetoothRecord([void Function(BluetoothRecordBuilder) updates]) =
      _$BluetoothRecord;

  static BluetoothRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createBluetoothRecordData({
  String deviceName,
  double distance,
  String distanceColor,
}) =>
    serializers.toFirestore(
        BluetoothRecord.serializer,
        BluetoothRecord((b) => b
          ..deviceName = deviceName
          ..distance = distance
          ..distanceColor = distanceColor));
