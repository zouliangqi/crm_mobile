import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class FunnelState extends Equatable {
  const FunnelState();

  @override
  List<Object> get props => [];
}

class FunnelInitialState extends FunnelState {}

class FunnelLoadingState extends FunnelState {}

class FunnelsuccessState extends FunnelState {
  final List success;
  final Map success2;
  const FunnelsuccessState({@required this.success,@required this.success2,});
  @override
  List<Object> get props => [success,success2];
  @override
  String toString() => 'FunnelsuccessState  }';
}

class FunnelFailState extends FunnelState {
  final String error;
  const FunnelFailState({@required this.error,});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'FunnelFailState { error: $error }';
}