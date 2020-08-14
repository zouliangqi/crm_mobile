import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OaRecord4State extends Equatable {
  const OaRecord4State();

  @override
  List<Object> get props => [];
}

class OaRecord4InitialState extends OaRecord4State {}

class OaRecord4LoadingState extends OaRecord4State {}



class OaRecord4ListSuccessState extends OaRecord4State {
  final List success;
  final int pageIndex;
  final bool hasReachedMax;
  const OaRecord4ListSuccessState({@required this.success,@required this.pageIndex,@required this.hasReachedMax,});
  @override
  List<Object> get props => [success,pageIndex,hasReachedMax];
  @override
  String toString() => 'OaRecord4successState { success: $success }';
}

class OaRecord4ListFailState extends OaRecord4State {
  final String error;
  const OaRecord4ListFailState({@required this.error,});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'OaRecord4FailState { error: $error }';
}


