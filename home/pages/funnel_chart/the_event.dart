import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class FunnelEvent extends Equatable {
  const FunnelEvent();
}


class FunnelInitEvent extends FunnelEvent{
  final int id;

  const FunnelInitEvent({@required this.id});

  @override
  List<Object> get props =>[id];
}