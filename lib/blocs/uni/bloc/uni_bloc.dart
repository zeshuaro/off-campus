import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:offcampus/repos/uni/uni_repo.dart';

part 'uni_event.dart';
part 'uni_state.dart';

class UniBloc extends Bloc<UniEvent, UniState> {
  final UniRepo _uniRepo;

  UniBloc(this._uniRepo) : super(UniState.initial());

  @override
  Stream<UniState> mapEventToState(UniEvent event) async* {
    if (event is FetchUnis) {
      yield* _mapFetchUnisToState(event);
    }
  }

  Stream<UniState> _mapFetchUnisToState(FetchUnis event) async* {
    final currState = state;
    if (currState.status == UniStatus.initial) {
      try {
        final unis = await _uniRepo.fetchUnis();
        yield UniState.succeed(unis);
      } catch (_) {
        yield UniState.failed();
      }
    }
  }
}
