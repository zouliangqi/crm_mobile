import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SaleEvent extends Equatable {
  const SaleEvent();
}


class SaleInitEvent extends SaleEvent{
  final int id;

  const SaleInitEvent({@required this.id});

  @override
  List<Object> get props =>[id];
}