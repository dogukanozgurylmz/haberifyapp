part of '../blocs/city_cubit.dart';

abstract class CityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CityInitial extends CityState {}

class CityLoading extends CityState {}

class CityLoaded extends CityState {
  final CityModel city;
  CityLoaded({required this.city});
  @override
  List<Object?> get props => [city];
}

class CitiesLoaded extends CityState {
  final List<CityModel> cities;

  CitiesLoaded({required this.cities});
  @override
  List<Object?> get props => [cities];
}

class CityError extends CityState {
  final String message;
  CityError({required this.message});
  @override
  List<Object?> get props => [message];
}
