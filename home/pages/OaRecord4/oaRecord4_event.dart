import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OaRecord4Event extends Equatable {
  const OaRecord4Event();
}


class OaRecord4InitEvent extends OaRecord4Event{
  final int id;

  const OaRecord4InitEvent({@required this.id});

  @override
  List<Object> get props =>[id];
}

//查询日志列表
class OaRecord4ListEvent extends OaRecord4Event{
  final int pageIndex;
  const OaRecord4ListEvent({@required this.pageIndex});

  @override
  List<Object> get props =>[pageIndex];
}




