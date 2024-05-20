import 'package:d2_remote/d2_remote.dart';
import 'package:d2_remote/modules/auth/user/entities/user.entity.dart';
import 'package:d2_remote/modules/auth/user/queries/user.query.dart';
import 'package:d2_remote/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:d2_remote/modules/metadata/organisation_unit/queries/organisation_unit.query.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'orgunit_sync_test.reflectable.dart';
import '../sample/org_unit.sample.dart';
import '../sample/current_user.sample.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  initializeReflectable();
  sqfliteFfiInit();

  var databaseFactory = databaseFactoryFfi;

  await D2Remote.initialize(
      databaseFactory: databaseFactoryFfi, databaseName: 'flutter_test');

  var db = await databaseFactory.openDatabase(inMemoryDatabasePath);

  UserQuery userQuery = UserQuery(database: db);

  userData['password'] = 'district';
  userData['isLoggedIn'] = true;
  userData['username'] = 'admin';
  userData['baseUrl'] = 'https://play.dhis2.org/2.35.11';
  final user = User.fromApi(userData);

  await userQuery.setData(user).save();
  final organisationUnitQuery = OrganisationUnitQuery(database: db);

  final dhisOrganisationUnits = sampleOrganisationUnits;

  final dio = Dio(BaseOptions());
  final dioAdapter = DioAdapter(dio: dio);

  dioAdapter.onGet(
    'https://play.dhis2.org/2.35.11/api/organisationUnits.json?filter=path:ilike:ImspTQPwCqd&rootJunction=OR&fields=id,dirty,lastUpdated,created,name,displayName,shortName,code,level,path,externalAccess,openingDate,geometry,parent,ancestors[id,name,displayName,level,path,openingDate],closedDate,programs&userOnly=true&paging=false',
    (server) => server.reply(200, dhisOrganisationUnits),
  );

  await organisationUnitQuery.download((progress, complete) {
    print(progress.message);
  }, dioTestClient: dio);

  List<OrganisationUnit> orgUnits =
      await D2Remote.organisationUnitModule.organisationUnit.get();

  test('should store all incoming organisation unit metadata', () {
    expect(orgUnits.length, 50);
  });

  OrganisationUnit? childOrgUnit = await OrganisationUnitQuery()
      .where(attribute: 'parent', value: 'qtr8GGlm4gg')
      .getOne();

  test('should return result given parent id is passed where clause', () {
    expect(childOrgUnit?.parent, 'qtr8GGlm4gg');
  });
}
