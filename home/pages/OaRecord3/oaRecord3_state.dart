import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OaRecord3State extends Equatable {
  const OaRecord3State();

  @override
  List<Object> get props => [];
}

class OaRecord3InitialState extends OaRecord3State {}

class OaRecord3LoadingState extends OaRecord3State {}



class OaRecord3ListSuccessState extends OaRecord3State {
  final List success;
  final int pageIndex;
  final bool hasReachedMax;
  const OaRecord3ListSuccessState({@required this.success,@required this.pageIndex,@required this.hasReachedMax,});
  @override
  List<Object> get props => [success,pageIndex,hasReachedMax];
  @override
  String toString() => 'OaRecord3successState { success: $success }';
}

class OaRecord3ListFailState extends OaRecord3State {
  final String error;
  const OaRecord3ListFailState({@required this.error,});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'OaRecord3FailState { error: $error }';
}


