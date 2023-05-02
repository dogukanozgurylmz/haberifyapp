import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:haberifyapp/features/data/models/city_model.dart';
import 'package:haberifyapp/features/data/models/news_model.dart';
import 'package:haberifyapp/features/data/models/tag_model.dart';
import 'package:haberifyapp/features/data/repositories/city_repository.dart';
import 'package:haberifyapp/features/data/repositories/news_repository.dart';
import 'package:haberifyapp/features/data/repositories/tag_repository.dart';
import 'package:image_picker/image_picker.dart';

part 'add_news_state.dart';

class AddNewsCubit extends Cubit<AddNewsState> {
  AddNewsCubit({
    required CityRepository cityRepository,
    required TagRepository tagRepository,
    required NewsRepository newsRepository,
  })  : _cityRepository = cityRepository,
        _tagRepository = tagRepository,
        _newsRepository = newsRepository,
        super(
          AddNewsState(
            status: AddNewsStatus.INITIAL,
            cityModel: CityModel(id: '', countryId: '', city: ''),
            cities: const [],
            selectCity: '',
            tagsName: const [],
            images: const [],
            newsId: '',
          ),
        ) {
    getAllCity();
  }

  final CityRepository _cityRepository;
  final TagRepository _tagRepository;
  final NewsRepository _newsRepository;
  final List<String> tagNameList = [];
  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController contentTextController = TextEditingController();
  final TextEditingController tagTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<String> _downloadURLs = [];

  Future<void> getAllCity() async {
    try {
      final cities = await _cityRepository.getAll();
      if (cities.length.isNaN) {
        emit(state.copyWith(status: AddNewsStatus.ERROR));
      } else {
        emit(state.copyWith(cities: cities));
      }
    } catch (e) {
      emit(state.copyWith(status: AddNewsStatus.ERROR));
    }
  }

  Future<void> sendNews() async {
    if (state.selectCity.isEmpty ||
        state.images.isEmpty ||
        state.tagsName.isEmpty) {
      emit(state.copyWith(status: AddNewsStatus.ERROR));
    } else {
      await uploadImage(); //upload image to storage
      await downloadImages(); //download images storage
      await createNews(); //create new news
      await createTag(); //create tag
      _downloadURLs.clear();
      tagNameList.clear();
      titleTextController.clear();
      contentTextController.clear();
      tagTextController.clear();
      emit(state.copyWith(
        status: AddNewsStatus.LOADED,
        images: [],
        newsId: '',
        selectCity: '',
        tagsName: [],
      ));
    }
  }

  Future<void> createTag() async {
    for (var tagName in tagNameList) {
      TagModel tagModel = await _tagRepository.getTagByTagName(tagName);
      if (tagModel.id.isNotEmpty) {
        int count = tagModel.count + 1;
        TagModel model = TagModel(
          id: tagModel.id,
          newsIds: [...tagModel.newsIds, state.newsId],
          tag: tagName,
          count: count,
        );
        await _tagRepository.update(model);
      } else {
        TagModel model = TagModel(
          id: '',
          newsIds: [state.newsId],
          tag: tagName.trim().toLowerCase(),
          count: 1,
        );
        await _tagRepository.create(model);
      }
    }
    emit(state.copyWith(newsId: ''));
  }

  Future<void> createNews() async {
    int createdAt = DateTime.now().millisecondsSinceEpoch;
    CityModel city = await checkCity();
    NewsModel newsModel = NewsModel(
      id: '',
      username: 'dogukanozgurylmz',
      newsPhotoIds: _downloadURLs,
      newsVideoIds: [],
      likes: [],
      viewsCount: 0,
      content: contentTextController.text.trim(),
      title: titleTextController.text.trim(),
      cityId: city.id,
      createdAt: createdAt,
      isSecure: false,
      isAnonymous: false,
    );
    await _newsRepository.createNews(newsModel);
    await getNewsByUsername(newsModel.username);
    emit(state.copyWith(status: AddNewsStatus.SENDLOADED));
  }

  Future<CityModel> checkCity() async {
    CityModel firstWhere =
        state.cities.firstWhere((element) => element.city == state.selectCity);
    return firstWhere;
  }

  Future<void> getNewsByUsername(String username) async {
    NewsModel newsModel = await _newsRepository.getNewsByUsername(username);
    emit(state.copyWith(newsId: newsModel.id));
  }

  Future<void> uploadImage() async {
    emit(state.copyWith(status: AddNewsStatus.SENDLOADING));
    try {
      await _newsRepository.uploadImage(images: state.images);
    } catch (e) {
      emit(state.copyWith(status: AddNewsStatus.ERROR));
    }
  }

  Future<void> downloadImages() async {
    _downloadURLs = [];
    _downloadURLs = _newsRepository.getDownloadImages();
  }

  Future<void> getImageFromCameraOrGallery(
      {required ImageSource source}) async {
    emit(state.copyWith(images: []));
    try {
      final List<XFile> images = await _picker.pickMultiImage(imageQuality: 50);
      List<File> files = [];
      if (images.isNotEmpty) {
        for (var image in images) {
          File file = File(image.path);
          files.add(file);
        }
        emit(state.copyWith(images: files));
      }
    } catch (e) {
      emit(state.copyWith(status: AddNewsStatus.ERROR));
    }
  }

  void changeValue(String value) {
    emit(state.copyWith(selectCity: value));
  }

  void addTag(String value) {
    emit(state.copyWith(status: AddNewsStatus.LOADING));
    if (value.isNotEmpty || value != "") {
      tagNameList.add(value);
      emit(state.copyWith(tagsName: tagNameList));
    }
    emit(state.copyWith(status: AddNewsStatus.LOADED));
  }

  void deleteTag(String value) {
    emit(state.copyWith(status: AddNewsStatus.LOADING));
    tagNameList.remove(value);
    emit(state.copyWith(tagsName: tagNameList));
    emit(state.copyWith(status: AddNewsStatus.LOADED));
  }
}
