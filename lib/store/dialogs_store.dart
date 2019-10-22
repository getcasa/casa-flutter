import 'package:mobx/mobx.dart';

class DialogsStore with Store {
  @observable
  List<dynamic> options;

  @computed
  bool getValue(String name) {
    var i = options.indexWhere((_option) => _option['name'] == name);
    return options[i] == 1 ? true : false;
  }

  @action
  void setOptions(List<dynamic> _options) {
    options = _options;
  }
  void setValue(String name, bool value) {
    var i = options.indexWhere((_option) => _option['name'] == name);
    options[i]['value'] = value == true ? 1 : 0;
  }
}