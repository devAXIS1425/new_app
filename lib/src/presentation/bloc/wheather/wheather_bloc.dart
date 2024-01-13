import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/src/core/apis.dart';
import 'package:news_app/src/core/service_locator.dart';
import 'package:news_app/src/domain/model/location_model/lat_lang.dart';
import 'package:news_app/src/domain/model/wheather_model/name_model/whather_model.dart';

part 'wheather_event.dart';

part 'wheather_state.dart';

class WheatherBloc extends Bloc<WheatherEvent, WheatherState> {
  WheatherBloc() : super(WheatherInitial()) {
    on<WheatherBlocEvent>(_wheatherGet);
  }

  void _wheatherGet(WheatherBlocEvent event, Emitter emit) async {
    emit(WheatherLoading());

    List<LatLang> data = [];
    List<WhatherModel> wz = [];
    final d = DateTime.now();

    Map<String, String> getLocationQuery = {
      "q": event.title,
      "limit": "1",
      "appid": "b3a4e5ad58628b1a96b83f1add25bf16",
    };

    data.addAll(await repository.fetchLatLang(getLocationQuery));
    final lat = data[0].lat;
    final long = data[0].lon;
    Map<String, String> query = {
      "lat": "$lat",
      "lon": "$long",
      "appid": "b3a4e5ad58628b1a96b83f1add25bf16",
    };
    wz.addAll(await repository.fetchWheather(query));
    final String title = wz[0].main;
    final String desc = wz[0].description;

   emit(WheatherSuccess(name: event.title,title: title,desc: desc));
  }
}