import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haberifyapp/features/data/models/city_model.dart';
import 'package:haberifyapp/features/data/repositories/city_repository.dart';
import 'package:haberifyapp/features/data/repositories/news_repository.dart';
import 'package:haberifyapp/features/data/repositories/tag_repository.dart';
import 'package:haberifyapp/features/presentation/addnews/cubit/add_news_cubit.dart';
import 'package:haberifyapp/features/widgets/custom_textformfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddNewsView extends StatelessWidget {
  final CityRepository _cityRepository = CityRepository();
  final TagRepository _tagRepository = TagRepository();
  final NewsRepository _newsRepository = NewsRepository();
  AddNewsView({super.key});

  @override
  Widget build(BuildContext context) {
    SizedBox sizedBox = const SizedBox(height: 8);
    return BlocProvider<AddNewsCubit>(
      create: (context) => AddNewsCubit(
        cityRepository: _cityRepository,
        newsRepository: _newsRepository,
        tagRepository: _tagRepository,
      )..getAllCity(),
      child: BlocBuilder<AddNewsCubit, AddNewsState>(
        builder: (context, state) {
          var cubit = context.read<AddNewsCubit>();
          List<Widget> images = state.images.map((file) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 100,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(4),
                child: Image.file(
                  file,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList();
          return Scaffold(
            body: SafeArea(
              child: Form(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      sizedBox,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async =>
                                  await cubit.getImageFromCameraOrGallery(
                                      source: ImageSource.gallery),
                              child: const SizedBox(
                                width: 100,
                                height: 200,
                                child: Icon(Icons.add_a_photo_outlined),
                              ),
                            ),
                            if (state.images.isEmpty)
                              const SizedBox.shrink()
                            else
                              ...List<Widget>.from(images),
                          ],
                        ),
                      ),
                      sizedBox,
                      CustomTextFormField(
                        labelText: 'Başlık',
                        controller: cubit.titleTextController,
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "Bu alan boş bırakılamaz";
                          }
                          if (value.length < 8) {
                            return 'Metin en az 8 karakterden oluşmalıdır.';
                          }
                          return null;
                        },
                        textInputType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                      ),
                      sizedBox,
                      CustomTextFormField(
                        controller: cubit.contentTextController,
                        labelText: 'İçerik',
                        textInputType: TextInputType.multiline,
                        textInputAction: TextInputAction.next,
                        maxLine: 12,
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "Bu alan boş bırakılamaz";
                          }
                          if (value.length < 120) {
                            return 'Metin en az 120 karakterden oluşmalıdır.';
                          }
                          if (value.length > 1200) {
                            return 'Metin en fazla 1200 karakterden oluşmalıdır.';
                          }
                          return null;
                        },
                      ),
                      sizedBox,
                      DropdownButtonFormField<String>(
                        focusColor: Colors.white,
                        decoration: InputDecoration(
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) =>
                            value == null ? "Şehir seç" : null,
                        dropdownColor: Colors.white,
                        value: state.selectCity.isNotEmpty
                            ? state.selectCity
                            : null,
                        onChanged: (value) {
                          cubit.changeValue(value!);
                        },
                        items: state.cities
                            .map<DropdownMenuItem<String>>((CityModel model) {
                          return DropdownMenuItem<String>(
                            value: model.city,
                            child: Text(model.city),
                          );
                        }).toList(),
                      ),
                      sizedBox,
                      CustomTextFormField(
                        controller: cubit.tagTextController,
                        labelText: 'Etiket ekle',
                        suffixIcon: IconButton(
                          splashColor: Colors.transparent,
                          onPressed: () {
                            if (cubit.tagTextController.text.isNotEmpty) {
                              cubit.addTag(cubit.tagTextController.text
                                  .trim()
                                  .toLowerCase());
                              cubit.tagTextController.clear();
                            }
                          },
                          icon: const Icon(Icons.add),
                        ),
                        onChanged: (text) {
                          if (text.contains(" ")) {
                            cubit.addTag(cubit.tagTextController.text
                                .trim()
                                .toLowerCase());
                            cubit.tagTextController.clear();
                          }
                        },
                        onFieldSubmitted: (value) {
                          cubit.tagTextController.text = value;
                          if (value.isNotEmpty) {
                            cubit.addTag(value);
                          }
                          cubit.tagTextController.clear();
                        },
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.go,
                      ),
                      state.status == AddNewsStatus.LOADING
                          ? const CircularProgressIndicator()
                          : Wrap(
                              spacing: 8,
                              children: state.tagsName.map((tag) {
                                return Chip(
                                  label: Text("#$tag"),
                                  onDeleted: () => cubit.deleteTag(tag),
                                  autofocus: true,
                                );
                              }).toList(),
                            ),
                      sizedBox,
                      state.status == AddNewsStatus.SENDLOADING
                          ? LoadingAnimationWidget.prograssiveDots(
                              color: const Color(0xffff0000),
                              size: 50,
                            )
                          : TextButton(
                              onPressed: () async {
                                await cubit.sendNews();
                              },
                              child: const Text('Gönder'),
                            ),
                      state.status == AddNewsStatus.ERROR
                          ? const Text(
                              'Boş bırakmayınız',
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 64),
                    ],
                  ),
                ),
              )),
            ),
          );
        },
      ),
    );
  }
}
