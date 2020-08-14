import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:miscrm/login/pages/data.dart';
import 'the_event.dart';
import 'the_reps.dart';
import 'the_state.dart';
class FunnelBloc extends Bloc<FunnelEvent, FunnelState> {
  final FunnelRepository funnelRepository;

  FunnelBloc({
    @required this.funnelRepository,

  }) : assert(funnelRepository != null);

  @override
  FunnelState get initialState => FunnelInitialState();

  @override
  Stream<FunnelState> mapEventToState(FunnelEvent event) async* {
    if(event is FunnelInitEvent) {
      try {
        var rec = await funnelRepository.queryBusinessStatusOptions();


        if (rec["code"] == 0) {
          var rec2;
          if(event.id==-1)
            rec2 = await funnelRepository.queryBusiness(rec["data"][0]["typeId"]);
          else
            rec2 = await funnelRepository.queryBusiness(event.id);
          if(rec2["code"]==0)
              yield FunnelsuccessState(success: rec["data"], success2: rec2["data"]);
          else
            yield FunnelFailState(error: "失败");
        }
        else {
          yield FunnelFailState(error: "失败");
        }
      }
      catch(e){
        print(e);
        yield FunnelFailState(error: e);
      }
      //yield ShangjiLoading();

    }
  }
}