part of 'uni_bloc.dart';

enum UniStatus { initial, success, failure }

class UniState extends Equatable {
  final UniStatus status;
  final List<Uni> unis;

  const UniState._({
    this.status = UniStatus.initial,
    this.unis = const <Uni>[],
  });

  const UniState.initial() : this._();

  const UniState.succeed(List<Uni> unis)
      : this._(status: UniStatus.success, unis: unis);

  const UniState.failed() : this._(status: UniStatus.failure);

  @override
  List<Object> get props => [status, unis];
}
