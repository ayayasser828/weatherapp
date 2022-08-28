import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../bussiness_logic/weather/weather_cubit.dart';
import '../../constant/colors.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key, this.city}) : super(key: key);
  final city;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  @override
  void initState() {
    BlocProvider.of<WeatherCubit>(context).getWeather(widget.city);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {
        if(state is WeatherError){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: textColor,
          appBar: AppBar(
            title: const Text("Current Weather"),
            centerTitle: true,
            backgroundColor: textColor,
          ),
          body: ConditionalBuilder(
            condition: BlocProvider.of<WeatherCubit>(context).getWeatherModel != null,
            builder: (context){
              var model = BlocProvider.of<WeatherCubit>(context).getWeatherModel;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 6.h),
                    Center(child: Text(model!.request!.query.toString(),style: TextStyle(color: whiteColor,fontSize: 18.sp),)),
                    SizedBox(height: 4.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Image.network(model.current!.weatherIcons![0].toString()),
                            SizedBox(height: 1.h),
                            Text(model.current!.weatherDescriptions![0].toString(),style: TextStyle(color: whiteColor,fontSize: 18.sp),),
                          ],
                        ),
                        Text("${model.current!.temperature} ْ  C",style: TextStyle(color: whiteColor,fontSize: 22.sp,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text('Wind : ${model.current!.windSpeed} kmph',style: TextStyle(color: whiteColor,fontSize: 14.sp)),
                    Text('Precip : ${model.current!.precip} mm',style: TextStyle(color: whiteColor,fontSize: 14.sp)),
                    Text('Pressure : ${model.current!.pressure} mb',style: TextStyle(color: whiteColor,fontSize: 14.sp)),
                  ],
                ),
              );
            },
            fallback: (context) => const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
