/// Represents a data element in DHIS2.
///
/// Data elements are the atomic units of data in DHIS2. They represent the
/// smallest piece of data that can be collected or reported on. Each data
/// element has a unique identifier and is associated with a data set.
///
/// This class provides methods to interact with data elements in DHIS2, such
/// as retrieving information about a specific data element or updating its
/// properties.
///
import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/shared/entities/identifiable.entity.dart';

@AnnotationReflectable
@Entity(tableName: 'dataelement', apiResourceName: 'dataElements')
class DataElement extends IdentifiableEntity {
  /// The name of the form where this data element is collected.
  /// This property is optional.
  ///
  @Column(type: ColumnType.TEXT, nullable: true)
  String? formName;

  /// The type of value that this data element represents.
  /// Examples TEXT, LONG_TEXT, LETTER, PHONE_NUMBER, EMAIL, BOOLEAN, TRUE_ONLY, DATE, DATETIME, TIME, NUMBER, UNIT_INTERVAL, PERCENTAGE, INTEGER, INTEGER_POSITIVE, INTEGER_NEGATIVE, INTEGER_ZERO_OR_POSITIVE, TRACKER_ASSOCIATE, USERNAME, COORDINATE, ORGANISATION_UNIT, REFERENCE, AGE, URL, FILE_RESOURCE, IMAGE, GEOJSON
  @Column(type: ColumnType.TEXT, length: 50)
  String valueType;

  /// The type of aggregation that is used for this data element.
  @Column(type: ColumnType.TEXT, length: 50)
  String aggregationType;

  /// A description of the data element.
  @Column(type: ColumnType.TEXT, nullable: true)
  String? description;

  /// The option set that is associated with this data element.
  // NMC
  @Column(type: ColumnType.TEXT, nullable: true, length: 11)
  String? optionSet;

  @Column(type: ColumnType.TEXT, nullable: true)
  String? fieldMask;

  DataElement(
      {required String id,
      String? created,
      String? lastUpdated,
      required String name,
      required String shortName,
      String? code,
      String? displayName,
      this.formName,
      required this.aggregationType,
      this.description,
      required this.valueType,
      this.optionSet,
      this.fieldMask,
      required dirty})
      : super(
            id: id,
            name: name,
            shortName: shortName,
            displayName: displayName,
            code: code,
            created: created,
            lastUpdated: lastUpdated,
            dirty: dirty);

  factory DataElement.fromJson(Map<String, dynamic> json) {
    final optionSet = json['optionSet'] != null
        ? json['optionSet'] is String
            ? json['optionSet']
            : json['optionSet']['id'] ?? json['optionSet']
        : null;

    return DataElement(
        id: json['id'],
        name: json['name'],
        created: json['created'],
        shortName: json['shortName'],
        code: json['code'],
        displayName: json['displayName'],
        valueType: json['valueType'],
        aggregationType: json['aggregationType'],
        description: json['description'],
        formName: json['formName'],
        optionSet: optionSet,
        fieldMask: json['fieldMask'],
        dirty: json['dirty']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdated'] = this.lastUpdated;
    data['id'] = this.id;
    data['created'] = this.created;
    data['name'] = this.name;
    data['shortName'] = this.shortName;
    data['code'] = this.code;
    data['displayName'] = this.displayName;
    data['valueType'] = this.valueType;
    data['aggregationType'] = this.aggregationType;
    data['description'] = this.description;
    data['formName'] = this.formName;
    data['optionSet'] = this.optionSet;
    data['fieldMask'] = this.fieldMask;
    data['dirty'] = this.dirty;

    return data;
  }
}
