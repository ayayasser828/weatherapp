import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'UI/screens/add_city.dart';
import 'UI/screens/current_location_screen.dart';
import 'UI/screens/home_screen.dart';
import 'UI/screens/login_screen.dart';
import 'UI/screens/singup_screen.dart';
import 'UI/screens/weather_screen.dart';
import 'bussiness_logic/register/register_cubit.dart';
import 'bussiness_logic/weather/weather_cubit.dart';
import 'constant/strings.dart';
import 'controls/control_flow.dart';
class AppRouter {
  Route? generateRouts(RouteSettings settings) {
    switch (settings.name) {
      case start:
        return MaterialPageRoute(builder: (_) =>
        const ControlFlow());
      case login:
        return MaterialPageRoute(builder: (_) =>
            BlocProvider(
              create: (context) => RegisterCubit(),
              child: LoginScreen(),
            ));
      case signup:
        return MaterialPageRoute(builder: (_) =>
            BlocProvider(
              create: (context) => RegisterCubit(),
              child: SignupScreen(),
            ));
      case home:
        final acc = settings.arguments;
        return MaterialPageRoute(builder: (_) =>
            BlocProvider(
              create: (context) => RegisterCubit(),
              child: HomeScreen(acc: acc),
            ));
      case map:
        return MaterialPageRoute(builder: (_) =>
        const CurrentLocationScreen());
      case city:
        return MaterialPageRoute(builder: (_) => AddCityScreen());
      case weather:
        final city = settings.arguments;
        return MaterialPageRoute(builder: (_) =>
            BlocProvider(
              create: (context) => WeatherCubit(),
              child: WeatherScreen(city: city,),
            ));
    }
  }
}