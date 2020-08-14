import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';

import 'oaRecord4_event.dart';
import 'oaRecord4_reps.dart';
import 'oaRecord4_state.dart';
import 'oaRecord4_page.dart';
class OaRecord4Bloc extends Bloc<OaRecord4Event, OaRecord4State> {
  final OaRecord4Repository oaRecord4Repository;

  OaRecord4Bloc({
    @required this.oaRecord4Repository,

  }) : assert(oaRecord4Repository != null);// : assert(registerRepository != null)

  @override
  OaRecord4State get initialState => OaRecord4InitialState();

  @override
  Stream<OaRecord4State> mapEventToState(OaRecord4Event event) async* {
    final currentState = state;//
    if(event is OaRecord4ListEvent) {
      if(event.pageIndex==null){
        if(currentState is OaRecord4ListSuccessState){
          int index=currentState.pageIndex+1;

          var rec= await oaRecord4Repository.getOaRecordPageList4(index);
          if (rec["code"] == 0) {
            if(rec["data"]["list"]==null){
              yield OaRecord4ListSuccessState(success: currentState.success, pageIndex: index, hasReachedMax: true);

            }
            else {
              yield OaRecord4ListSuccessState(
                  success: currentState.success + rec["data"]["list"],
                  pageIndex: index,
                  hasReachedMax: false);
            }
          }

        }
      }else {
        var rec = await oaRecord4Repository.getOaRecordPageList4(event.pageIndex);
        if (rec["code"] == 0) {
          yield OaRecord4ListSuccessState(success: rec["data"]["list"], pageIndex: 1, hasReachedMax: false);
        }
        else {
          yield OaRecord4ListFailState(error: rec["msg"].toString());
        }
      }

    }

  }
}