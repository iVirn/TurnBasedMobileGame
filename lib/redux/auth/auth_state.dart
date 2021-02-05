import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:turn_based_game/model/user_profile.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  static const initState = AuthState(NotLoggedUser());

  const factory AuthState(UserProfile user) = _AuthState;
}