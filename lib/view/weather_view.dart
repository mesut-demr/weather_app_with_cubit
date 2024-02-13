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
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                           WeatherPropertyText(title: context.read<WeatherCubit>().getGreetingsMessage(),
                           fontSize: 18.sp,
                           ),
                            WeatherPropertyText(
                            title: ' ${state.weatherModel?.city ?? ''}',
                            fontSize: 50.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1,
                            ),
                            WeatherPropertyText(
                            title: ' ${WeatherModel.conditions[state.weatherModel?.condition ?? ''] ?? ''}',
                            fontSize: 20.sp,
                            ),
                            WeatherPropertyText(title: ' ${state.weatherModel?.temperature ?? ''}°C',
                            fontSize: 100.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[300],
                            letterSpacing: -6,
                            ),
                           isDayTime ? Image.asset(WeatherModel.getConditionGif(state.weatherModel?.condition ?? ''),
                            ):Image.asset(WeatherModel.getNightConditionGif(state.weatherModel?.condition ?? ''),),
                            Divider(
                                height: 0.h,
                                thickness: 0.5,
                                color: Colors.grey),
                                SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                              WeatherCard(title: 'Hissedilen Sıcaklık', subTitle: '${state.weatherModel?.feelslike_c ?? ''}°C',icon: Icons.thermostat_rounded),
                               WeatherCard(title: 'Rüzgar', subTitle:'${state.weatherModel?.wind_kph ?? ''} kph',icon: Icons.wind_power),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                WeatherCard(title: 'Nem', subTitle:'${state.weatherModel?.humidity ?? ''}%',icon: Icons.water_drop_rounded),
                               WeatherCard(title: 'UV', subTitle: '${state.weatherModel?.uv ?? ''}',icon: Icons.sunny,),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                               WeatherCard(title: 'Görüş', subTitle:'${state.weatherModel?.vis_km ?? ''}km',icon: Icons.foggy),
                               WeatherCard(title: 'Bulut', subTitle:'${state.weatherModel?.cloud ?? ''}',icon: Icons.cloud),
                              ],
                            ),
                            SizedBox(height: 28.h),
                         WeatherPropertyText(
                          title: ' ${state.weatherModel?.last_updated ?? ''}',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w300,
                         ),
                         SizedBox(height: 28.h),
                          ],
                        );
                      } else if (state.status == WeatherStatus.errorMessage) {
                        return Text('Hata: ${state.errorMessage}');
                      } else {
                        return const Text('');
                      }
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0.03.sh,
              left: 0.01.sw,
              right: 0.01.sw,
              child: SizedBox(
                height: 0.6.sh,
                child: BlocBuilder<WeatherCubit, WeatherState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: TextField(
                            scrollPadding: EdgeInsets.zero,
                            controller: cityTextController,
                            onTap: () {
                              context.read<WeatherCubit>().setSearchButtonClicked(true);
                            },
                            onChanged: (value) {
                              context.read<WeatherCubit>().filterCitites(value);
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 26.w,vertical: 0.h),
                              filled: true,
                              fillColor: Colors.white54,
                              enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white70),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.r),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white70),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.r),
                                ),
                              ),
                              labelText: 'Şehir Ara',
                              prefixIcon: const Icon(Icons.search),
                            ),
                          ),
                        ),
                        context.read<WeatherCubit>().isSearchClicked
                            ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 0.h),
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


