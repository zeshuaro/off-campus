part of 'uni_bloc.dart';

abstract class UniState extends Equatable {
  const UniState();

  @override
  List<Object> get props => [];
}

class UniInitial extends UniState {}

class UniFailure extends UniState {}

class UniSuccess extends UniState {
  final List<Uni> unis;

  UniSuccess(this.unis);

  @override
  List<Object> get props => [unis];
}
