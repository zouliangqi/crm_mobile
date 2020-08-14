import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:miscrm/home/pages/sale_report/sale_event.dart';
import 'package:miscrm/home/pages/sale_report/sale_reps.dart';
import 'package:miscrm/home/pages/sale_report/sale_state.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  final SaleRepository saleRepository;

  SaleBloc({
    @required this.saleRepository,

  }) : assert(saleRepository != null);// : assert(registerRepository != null)

  @override
  SaleState get initialState => SaleInitialState();

  @override
  Stream<SaleState> mapEventToState(SaleEvent event) async* {
    if(event is SaleInitEvent) {
      var rec= await saleRepository.queryBulletin();
      if(rec["code"]==0 ){
        yield SalesuccessState(success: rec);
      }
      else {
        yield SaleFailState(error: "失败");
      }
      //yield ShangjiLoading();

    }
  }
}