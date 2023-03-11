import 'package:d2_remote/modules/data/tracker/entities/event_data_value.entity.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:sqflite/sqflite.dart';

class EventDataValueQuery extends BaseQuery<EventDataValue> {
  EventDataValueQuery({Database? database}) : super(database: database);
  String? event;
  String? dataElement;

  EventDataValueQuery byEventAndDataElement(String event, String dataElement) {
    this.event = event;
    this.dataElement = dataElement;
    this.where(attribute: 'event', value: event);
    this.where(attribute: 'dataElement', value: dataElement);
    return this;
  }
}
