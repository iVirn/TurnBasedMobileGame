import 'package:flutter/material.dart';
import 'package:turn_based_game/common/states/auth_state.dart';
import 'package:turn_based_game/network/user_repository.dart';

class LoginScreenState with ChangeNotifier {
  final UserRepository _userRepository;
  final AuthState _authState;

  String _name = "";
  String _password = "";
  bool _requestInProgress = false;

  String get name => _name;
  String get password => _password;
  bool get loginButtonEnabled => _dataIsValid() && !_requestInProgress;
  bool get requestInProgress => _requestInProgress;

  LoginScreenState(
    this._userRepository,
    this._authState
  );

  void setName(String newName) {
    _name = newName.trim();    
    notifyListeners();
  }

  void setPassword(String newPassword) {
    _password = newPassword.trim();    
    notifyListeners();
  }

  void tryLogin() {    
    _requestInProgress = true;
    notifyListeners();

    _userRepository.tryLoginUser(_name, _password)
      .then((requestResult) { 
        print("Success : ${requestResult.success}");
        print("Success : ${requestResult.result}");

        _requestInProgress = false;
        notifyListeners();        

        if (requestResult.success) {
          _authState.loginUser(requestResult.result);
        }        
      })
      .catchError((error) {
        print(error);

        _requestInProgress = false;
        notifyListeners();
      }
    );    
  }

  bool _dataIsValid() {
    return (_name.length >= 4 && _password.length >= 4);
  }
}