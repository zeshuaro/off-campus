part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'AuthUserChanged: { uid: ${user?.uid} }';
}

class AuthSignOutRequested extends AuthEvent {}

class UpdateProfile extends AuthEvent {
  final String userId;
  final File image;
  final String summary;

  UpdateProfile(this.userId, this.image, this.summary);

  @override
  List<Object> get props => [userId, image, summary];

  @override
  String toString() =>
      'UpdateProfile: { userId: $userId, image: ${image.path}, summary: $summary}';
}
