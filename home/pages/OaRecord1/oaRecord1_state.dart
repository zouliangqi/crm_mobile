import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OaRecord1State extends Equatable {
  const OaRecord1State();

  @override
  List<Object> get props => [];
}

class OaRecord1InitialState extends OaRecord1State {}

class OaRecord1LoadingState extends OaRecord1State {}



class OaRecord1ListSuccessState extends OaRecord1State {
  final List success;
  final int pageIndex;
  final bool hasReachedMax;
  const OaRecord1ListSuccessState({@required this.success,@required this.pageIndex,@required this.hasReachedMax,});
  @override
  List<Object> get props => [success,pageIndex,hasReachedMax];
  @override
  String toString() => 'OaRecord1successState { success: $success }';
}

class OaRecord1ListFailState extends OaRecord1State {
  final String error;
  const OaRecord1ListFailState({@required this.error,});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'OaRecord1FailState { error: $error }';
}


