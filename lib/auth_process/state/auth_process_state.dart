import 'package:flutter/cupertino.dart';
import 'package:turn_based_game/model/network/network_response.dart';
import 'package:turn_based_game/model/network/user_auth_data.dart';
import 'package:turn_based_game/model/user_profile/user_profile.dart';
import 'package:turn_based_game/network/network_service.dart';
import 'package:turn_based_game/redux/app_state.dart';

import 'package:redux/redux.dart';
import 'package:turn_based_game/redux/auth/auth_action.dart';

class AuthProcessState with ChangeNotifier {
  final Store<AppState> _store;
  final NetworkService _networkService;

  bool _isLoginLoading = false;
  bool get isLoginLoading => _isLoginLoading;
  bool get isLoginEnabled => !_isLoginLoading && _userName.length >= 3 && _password.isNotEmpty ;

  bool _isRegisterLoading = false;
  bool get isRegisterLoading => _isRegisterLoading;
  bool get isRegisterEnabled => !_isRegisterLoading && _newUserName.length >= 3 && _newPassword.isNotEmpty ;

  String _newUserName = "";
  String get newUserName => _newUserName;

  String _newPassword = "";
  String get newPassword => _newPassword;

  String _userName = "";
  String get userName => _userName;

  String _password = "";
  String get password => _password;

  AuthProcessState(
    this._store,
    this._networkService
  );

  void setUsername(String value) {
    bool oldValue = isLoginEnabled;

    _userName = value;
    bool newValue = isLoginEnabled;

    if (newValue != oldValue) {
      notifyListeners();
    }     
  }

  void setPassword(String value) {
    bool oldValue = isLoginEnabled;

    _password = value;
    bool newValue = isLoginEnabled;

    if (newValue != oldValue) {
      notifyListeners();
    }
  }

  void setNewUsername(String value) {
    bool oldValue = isRegisterEnabled;

    _newUserName = value;
    bool newValue = isRegisterEnabled;

    if (newValue != oldValue) {
      notifyListeners();
    }     
  }

  void setNewPassword(String value) {
    bool oldValue = isRegisterEnabled;

    _newPassword = value;
    bool newValue = isRegisterEnabled;

    if (newValue != oldValue) {
      notifyListeners();
    }
  }

  void tryToLogin() async {
    _isLoginLoading = true;
    notifyListeners();

    UserAuthData data = UserAuthData(_userName, _password);    
    NetworkResponse<UserProfile> response = await _networkService.loginUser(data);

    if (response.success) {      
      _store.dispatch(LogUserInAction(response.result));
    } else {
      _isLoginLoading = false;      
      notifyListeners();
    }
  }

  void tryToRegister() async {
    _isRegisterLoading = true;
    notifyListeners();

    UserAuthData data = UserAuthData(_userName, _password);    
    NetworkResponse<UserProfile> response = await _networkService.registerUser(data);

    if (response.success) {      
      _store.dispatch(LogUserInAction(response.result));
    } else {
      _isRegisterLoading = false;      
      notifyListeners();
    }
  }

}