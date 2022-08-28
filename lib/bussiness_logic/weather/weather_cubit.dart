import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../constant/endpoints.dart';
import '../../data/models/weather_model.dart';
import '../../helpers/dio_helper.dart';
part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());

  GetWeatherModel? getWeatherModel;

  void getWeather(String city){
    emit(WeatherLoading());
    DioHelper.getData(url: getWeatherURL+city).then((value) {
      print(value.data);
      getWeatherModel = GetWeatherModel.fromJson(value.data);
      print(getWeatherModel);
      emit(WeatherSuccess());
    }).catchError((e){
      emit(WeatherError(e.toString()));
    });
  }

}
