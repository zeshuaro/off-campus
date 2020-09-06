part of 'uni_bloc.dart';

abstract class UniEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUnis extends UniEvent {}
