import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OaRecord1Event extends Equatable {
  const OaRecord1Event();
}


class OaRecord1InitEvent extends OaRecord1Event{
  final int id;

  const OaRecord1InitEvent({@required this.id});

  @override
  List<Object> get props =>[id];
}

//查询日志列表
class OaRecord1ListEvent extends OaRecord1Event{
  final int pageIndex;
  const OaRecord1ListEvent({@required this.pageIndex});

  @override
  List<Object> get props =>[pageIndex];
}




