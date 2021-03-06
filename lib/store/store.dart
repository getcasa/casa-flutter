import 'package:mobx/mobx.dart';
import 'package:casa/structs.dart';

class CasaStore with Store {
  static final CasaStore _singleton = CasaStore._internal();

  factory CasaStore() {
    return _singleton;
  }

  CasaStore._internal();

  @observable
  User user;

  @computed
  String get getUsername => (user != null) ? user.firstname : '';

  @action
  void setUser(User _user) {
    user = _user;
  }

  @action
  void updateProfil(String firstname, String lastname) {
    user.firstname = firstname;
    user.lastname = lastname;
  }
}
