import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';

import 'oaRecord2_event.dart';
import 'oaRecord2_reps.dart';
import 'oaRecord2_state.dart';
import 'oaRecord2_page.dart';
class OaRecord2Bloc extends Bloc<OaRecord2Event, OaRecord2State> {
  final OaRecord2Repository oaRecord2Repository;

  OaRecord2Bloc({
    @required this.oaRecord2Repository,

  }) : assert(oaRecord2Repository != null);// : assert(registerRepository != null)

  @override
  OaRecord2State get initialState => OaRecord2InitialState();

  @override
  Stream<OaRecord2State> mapEventToState(OaRecord2Event event) async* {
    final currentState = state;//
    if(event is OaRecord2ListEvent) {
      if(event.pageIndex==null){
        if(currentState is OaRecord2ListSuccessState){
          int index=currentState.pageIndex+1;

          var rec= await oaRecord2Repository.getOaRecordPageList2(index);
          if (rec["code"] == 0) {
            if(rec["data"]["list"]==null){
              yield OaRecord2ListSuccessState(success: currentState.success, pageIndex: index, hasReachedMax: true);

            }
            else {
              yield OaRecord2ListSuccessState(
                  success: currentState.success + rec["data"]["list"],
                  pageIndex: index,
                  hasReachedMax: false);
            }
          }

        }
      }else {
        var rec = await oaRecord2Repository.getOaRecordPageList2(event.pageIndex);
        if (rec["code"] == 0) {
          yield OaRecord2ListSuccessState(success: rec["data"]["list"], pageIndex: 1, hasReachedMax: false);
        }
        else {
          yield OaRecord2ListFailState(error: rec["msg"].toString());
        }
      }

    }

  }
}