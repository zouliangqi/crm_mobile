import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OaRecord2State extends Equatable {
  const OaRecord2State();

  @override
  List<Object> get props => [];
}

class OaRecord2InitialState extends OaRecord2State {}

class OaRecord2LoadingState extends OaRecord2State {}



class OaRecord2ListSuccessState extends OaRecord2State {
  final List success;
  final int pageIndex;
  final bool hasReachedMax;
  const OaRecord2ListSuccessState({@required this.success,@required this.pageIndex,@required this.hasReachedMax,});
  @override
  List<Object> get props => [success,pageIndex,hasReachedMax];
  @override
  String toString() => 'OaRecord2successState { success: $success }';
}

class OaRecord2ListFailState extends OaRecord2State {
  final String error;
  const OaRecord2ListFailState({@required this.error,});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'OaRecord2FailState { error: $error }';
}


