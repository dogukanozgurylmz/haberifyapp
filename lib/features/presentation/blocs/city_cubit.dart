import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:haberifyapp/features/data/repositories/city_repository.dart';

import '../../data/models/city_model.dart';

part '../states/city_state.dart';

class CityCubit extends Cubit<CityState> {
  CityCubit({required CityRepository cityRepository})
      : _cityRepository = cityRepository,
        super(CityInitial()) {
    getAll();
  }

  final CityRepository _cityRepository;

  Future<void> getCityById(String id) async {
    emit(CityLoading());
    try {
      final city = await _cityRepository.getCityById(id);
      if (city.id.isEmpty) {
        emit(CityError(message: "Hata oluştu"));
      } else {
        emit(CityLoaded(city: city));
      }
    } catch (e) {
      emit(CityError(message: "Şehir hatası"));
    }
  }

  Future<void> getAll() async {
    emit(CityLoading());
    try {
      final cities = await _cityRepository.getAll();
      if (cities.length.isNaN) {
        emit(CityError(message: "Hata oluştu"));
      } else {
        emit(CitiesLoaded(cities: cities));
      }
    } catch (e) {
      emit(CityError(message: "Şehir hatası"));
    }
  }
}
