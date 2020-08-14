import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OaRecord2Event extends Equatable {
  const OaRecord2Event();
}


class OaRecord2InitEvent extends OaRecord2Event{
  final int id;

  const OaRecord2InitEvent({@required this.id});

  @override
  List<Object> get props =>[id];
}

//查询日志列表
class OaRecord2ListEvent extends OaRecord2Event{
  final int pageIndex;
  const OaRecord2ListEvent({@required this.pageIndex});

  @override
  List<Object> get props =>[pageIndex];
}




