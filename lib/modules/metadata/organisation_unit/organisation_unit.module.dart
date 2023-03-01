import 'package:d2_remote/modules/metadata/organisation_unit/queries/organisation_unit.query.dart';

class OrganisationUnitModule {
  static createTables() async {
    return await OrganisationUnitQuery().createTable();
  }

  OrganisationUnitQuery get organisationUnit => OrganisationUnitQuery();
}
