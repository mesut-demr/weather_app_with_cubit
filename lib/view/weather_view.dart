import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app_with_cubit/cubit/weather_cubit.dart';
import 'package:weather_app_with_cubit/cubit/weather_state.dart';
import 'package:weather_app_with_cubit/model/weather_model.dart';
import 'package:weather_app_with_cubit/widget/weaher_card.dart';
import 'package:weather_app_with_cubit/widget/weather_property_text.dart';

class WeatherView extends StatelessWidget {
  WeatherView({super.key});

  TextEditingController cityTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentTime = TimeOfDay.now();
    final isDayTime = currentTime.hour > 6 && currentTime.hour < 20;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: isDayTime
                    ? const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 17, 192, 245),
                          Color(0xFF146DF3),
                        ],
                      )
                    : const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 36, 37, 37),
                          Color.fromARGB(255, 44, 78, 110),
                        ],
                      ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 12.w),
                child: Center(
                  child: BlocBuilder<WeatherCubit, WeatherState>(
                    builder: (context, state) {
                      if (state.status == WeatherStatus.loading) {
                        return const CircularProgressIndicator();
                      } else if (state.status == WeatherStatus.completed) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           WeatherPropertyText(title: context.read<WeatherCubit>().getGreetingsMessage(),
                           fontSize: 18.sp,
                           ),
                            SizedBox(height: 6.h),
                            WeatherPropertyText(
                            title: ' ${state.weatherModel?.city ?? ''}',
                            fontSize: 52.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1,
                            ),
                            SizedBox(height: 12.h),
                            WeatherPropertyText(
                            title: ' ${WeatherModel.conditions[state.weatherModel?.condition ?? ''] ?? ''}',
                            fontSize: 20.sp,
                            ),
                            SizedBox(height: 12.h),
                            WeatherPropertyText(title: ' ${state.weatherModel?.temperature ?? ''}°C',
                            fontSize: 110.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[300],
                            ),
                            Image.asset(WeatherModel.getConditionGif(state.weatherModel?.condition ?? ''),
                            ),
                            Divider(
                                height: 1.h,
                                thickness: 0.5,
                                color: Colors.grey),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WeatherCard(title: 'Hissedilen Sıcaklık: ${state.weatherModel?.feelslike_c ?? ''}°C',),
                                SizedBox(height: 12.h),
                               WeatherCard(title:  'Rüzgar: ${state.weatherModel?.wind_kph ?? ''} kph',),
                                SizedBox(height: 12.h),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WeatherCard(title:'Nem: ${state.weatherModel?.humidity ?? ''}%',),
                               WeatherCard(title: 'UV: ${state.weatherModel?.uv ?? ''}',),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               WeatherCard(title: 'Görüş: ${state.weatherModel?.vis_km ?? ''}km',),
                               WeatherCard(title: 'Bulut: ${state.weatherModel?.cloud ?? ''}',),
                              ],
                            ),
                          SizedBox(height: 12.h),
                         WeatherPropertyText(
                          title: ' ${state.weatherModel?.last_updated ?? ''}',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w300,
                         ),
                          ],
                        );
                      } else if (state.status == WeatherStatus.errorMessage) {
                        return Text('Error: ${state.errorMessage}');
                      } else {
                        return const Text('Press the buttons to fetch weather data.');
                      }
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0.04.sh,
              left: 0.01.sw,
              right: 0.01.sw,
              child: SizedBox(
                height: 0.6.sh,
                child: BlocBuilder<WeatherCubit, WeatherState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        TextField(
                          scrollPadding: EdgeInsets.zero,
                          controller: cityTextController,
                          onTap: () {
                            context.read<WeatherCubit>().setSearchButtonClicked(true);
                          },
                          onChanged: (value) {
                            context.read<WeatherCubit>().filterCitites(value);
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            filled: true,
                            fillColor: Colors.white54,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.r),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.r),
                              ),
                            ),
                            labelText: 'Şehir Ara',
                            prefixIcon: const Icon(Icons.search),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        context.read<WeatherCubit>().isSearchClicked
                            ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 0.h),
                              child: Container(
                                padding: EdgeInsets.zero,
                                decoration: const BoxDecoration(
                                  color: Colors.white54,
                                ),
                                height: 0.2.sh,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemCount: state.filteredCityList!.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        style: ListTileStyle.list,
                                        contentPadding: EdgeInsets.symmetric(vertical: 0.h,horizontal: 10.w),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r),),
                                        title: Text(state.filteredCityList![index]),
                                        onTap: () {
                                          final selectedCity =state.filteredCityList![index];
                                          context.read<WeatherCubit>().selectCity(selectedCity);
                                          context.read<WeatherCubit>().fetchWeatherForCity(selectedCity);
                                          context.read<WeatherCubit>().setSearchButtonClicked(false);
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          print('ffffffffff ${state.filteredCityList![index]}');
                                        },
                                      );
                                    },
                                  ),
                              ),
                            )
                            : const SizedBox(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
