import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';

import 'oaRecord1_event.dart';
import 'oaRecord1_reps.dart';
import 'oaRecord1_state.dart';
import 'oaRecord1_page.dart';
class OaRecord1Bloc extends Bloc<OaRecord1Event, OaRecord1State> {
  final OaRecord1Repository oaRecord1Repository;

  OaRecord1Bloc({
    @required this.oaRecord1Repository,

  }) : assert(oaRecord1Repository != null);// : assert(registerRepository != null)

  @override
  OaRecord1State get initialState => OaRecord1InitialState();

  @override
  Stream<OaRecord1State> mapEventToState(OaRecord1Event event) async* {
    final currentState = state;//
    if(event is OaRecord1ListEvent) {
      if(event.pageIndex==null){
        if(currentState is OaRecord1ListSuccessState){
          int index=currentState.pageIndex+1;

          var rec= await oaRecord1Repository.getOaRecordPageList1(index);
          if (rec["code"] == 0) {
            if(rec["data"]["list"]==null){
              yield OaRecord1ListSuccessState(success: currentState.success, pageIndex: index, hasReachedMax: true);

            }
            else {
              yield OaRecord1ListSuccessState(
                  success: currentState.success + rec["data"]["list"],
                  pageIndex: index,
                  hasReachedMax: false);
            }
          }

        }
      }else {
        var rec = await oaRecord1Repository.getOaRecordPageList1(event.pageIndex);
        if (rec["code"] == 0) {
          yield OaRecord1ListSuccessState(success: rec["data"]["list"], pageIndex: 1, hasReachedMax: false);
        }
        else {
          yield OaRecord1ListFailState(error: rec["msg"].toString());
        }
      }

    }

  }
}