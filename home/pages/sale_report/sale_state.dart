import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SaleState extends Equatable {
  const SaleState();

  @override
  List<Object> get props => [];
}

class SaleInitialState extends SaleState {}

class SaleLoadingState extends SaleState {}

class SalesuccessState extends SaleState {
  final Map success;
  const SalesuccessState({@required this.success,});
  @override
  List<Object> get props => [success];
  @override
  String toString() => 'SalesuccessState { success: $success }';
}

class SaleFailState extends SaleState {
  final String error;
  const SaleFailState({@required this.error,});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'SaleFailState { error: $error }';
}