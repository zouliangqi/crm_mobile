import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OaRecord3Event extends Equatable {
  const OaRecord3Event();
}


class OaRecord3InitEvent extends OaRecord3Event{
  final int id;

  const OaRecord3InitEvent({@required this.id});

  @override
  List<Object> get props =>[id];
}

//查询日志列表
class OaRecord3ListEvent extends OaRecord3Event{
  final int pageIndex;
  const OaRecord3ListEvent({@required this.pageIndex});

  @override
  List<Object> get props =>[pageIndex];
}




