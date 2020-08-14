import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';

import 'oaRecord3_event.dart';
import 'oaRecord3_reps.dart';
import 'oaRecord3_state.dart';
import 'oaRecord3_page.dart';
class OaRecord3Bloc extends Bloc<OaRecord3Event, OaRecord3State> {
  final OaRecord3Repository oaRecord3Repository;

  OaRecord3Bloc({
    @required this.oaRecord3Repository,

  }) : assert(oaRecord3Repository != null);// : assert(registerRepository != null)

  @override
  OaRecord3State get initialState => OaRecord3InitialState();

  @override
  Stream<OaRecord3State> mapEventToState(OaRecord3Event event) async* {
    final currentState = state;//
    if(event is OaRecord3ListEvent) {
      if(event.pageIndex==null){
        if(currentState is OaRecord3ListSuccessState){
          int index=currentState.pageIndex+1;

          var rec= await oaRecord3Repository.getOaRecordPageList3(index);
          if (rec["code"] == 0) {
            if(rec["data"]["list"]==null){
              yield OaRecord3ListSuccessState(success: currentState.success, pageIndex: index, hasReachedMax: true);

            }
            else {
              yield OaRecord3ListSuccessState(
                  success: currentState.success + rec["data"]["list"],
                  pageIndex: index,
                  hasReachedMax: false);
            }
          }
        }
      }else {
        var rec = await oaRecord3Repository.getOaRecordPageList3(event.pageIndex);
        if (rec["code"] == 0) {
          yield OaRecord3ListSuccessState(success: rec["data"]["list"], pageIndex: 1, hasReachedMax: false);
        }
        else {
          yield OaRecord3ListFailState(error: rec["msg"].toString());
        }
      }

    }

  }
}