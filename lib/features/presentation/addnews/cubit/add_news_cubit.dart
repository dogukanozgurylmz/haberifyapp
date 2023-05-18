import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habery/features/data/datasouce/local/user_local_datasource.dart';
import 'package:habery/features/data/models/city_model.dart';
import 'package:habery/features/data/models/news_model.dart';
import 'package:habery/features/data/models/tag_model.dart';
import 'package:habery/features/data/repositories/city_repository.dart';
import 'package:habery/features/data/repositories/news_repository.dart';
import 'package:habery/features/data/repositories/tag_repository.dart';
import 'package:image_picker/image_picker.dart';

part 'add_news_state.dart';

class AddNewsCubit extends Cubit<AddNewsState> {
  AddNewsCubit({
    required CityRepository cityRepository,
    required TagRepository tagRepository,
    required NewsRepository newsRepository,
    required UserLocalDatasource userLocalDatasource,
  })  : _cityRepository = cityRepository,
        _tagRepository = tagRepository,
        _newsRepository = newsRepository,
        _userLocalDatasource = userLocalDatasource,
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
  final UserLocalDatasource _userLocalDatasource;

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
      await updateOrCreateTags(); //create tag
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

  // Future<void> createTag() async {
  //   for (var tagName in tagNameList) {
  //     TagModel tagModel = await _tagRepository.getTagByTagName(tagName);
  //     if (tagModel.id.isNotEmpty) {
  //       int count = tagModel.count + 1;
  //       TagModel model = TagModel(
  //         id: tagModel.id,
  //         newsIds: [...tagModel.newsIds, state.newsId],
  //         tag: tagName,
  //         count: count,
  //       );
  //       await _tagRepository.update(model);
  //     } else {
  //       TagModel model = TagModel(
  //         id: '',
  //         newsIds: [state.newsId],
  //         tag: tagName.trim().toLowerCase(),
  //         count: 1,
  //       );
  //       await _tagRepository.create(model);
  //     }
  //   }
  //   emit(state.copyWith(newsId: ''));
  // }

  Future<void> updateOrCreateTags() async {
    // Firebase veritabanından gerekli tagleri al
    List<TagModel> tags = await _tagRepository.getTagsByTagName(tagNameList);

    for (String tagName in tagNameList) {
      // Etiketler listesinde tagModel'i ara
      TagModel tagModel = tags.firstWhere(
        (tag) => tag.tag == tagName.trim().toLowerCase(),
        orElse: () => TagModel(id: '', newsIds: [], tag: '', count: 0),
      );

      if (tagModel.id.isNotEmpty) {
        // Etiket veritabanında varsa, sayısını ve haber kimliklerini güncelle
        int count = tagModel.count + 1;
        TagModel model = TagModel(
          id: tagModel.id,
          newsIds: [...tagModel.newsIds, state.newsId],
          tag: tagName.trim().toLowerCase(),
          count: count,
        );
        await _tagRepository.update(model);
      } else {
        // Etiket veritabanında yoksa, count=1 ve newsIds=[state.newsId] olan yeni bir etiket oluştur
        TagModel model = TagModel(
          id: '',
          newsIds: [state.newsId],
          tag: tagName.trim().toLowerCase(),
          count: 1,
        );
        await _tagRepository.create(model);
      }
    }
  }

  Future<void> createNews() async {
    int createdAt = DateTime.now().millisecondsSinceEpoch;
    CityModel city = await checkCity();
    var userModel = await _userLocalDatasource.getUser();
    NewsModel newsModel = NewsModel(
      id: '',
      username: userModel.username,
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
    await _newsRepository
        .createNews(newsModel)
        .then((value) async => await getNewsByUsername(newsModel.username));

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
