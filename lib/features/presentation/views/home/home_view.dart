import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haberifyapp/features/data/repositories/city_repository.dart';
import 'package:haberifyapp/features/data/repositories/news_repository.dart';
import 'package:haberifyapp/features/data/repositories/user_repository.dart';
import 'package:haberifyapp/features/presentation/blocs/city_cubit.dart';
import 'package:haberifyapp/features/presentation/blocs/user_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:story_view/story_view.dart';

import '../../../data/models/news_model.dart';
import '../../blocs/news_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    int index = 0;
    final NewsRepository newsRepository = NewsRepository();
    final CityRepository cityRepository = CityRepository();
    final UserRepository userRepository = UserRepository();
    var size = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // StatusBar rengi
      statusBarIconBrightness: Brightness.light, // StatusBar ikonlarının rengi
    ));
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<NewsBloc>(
            create: (context) => NewsBloc(newsRepository: newsRepository)
              ..add(
                NewsGetAll(),
              ),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(userRepository: userRepository),
          ),
          BlocProvider<CityCubit>(
            create: (context) => CityCubit(cityRepository: cityRepository),
          ),
        ],
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsLoading) {
              return Center(
                child: LoadingAnimationWidget.prograssiveDots(
                  color: const Color(0xffff0000),
                  size: 60,
                ),
              );
            } else if (state is NewsLoaded) {
              final cityCubit = context.read<CityCubit>();
              final userBloc = context.read<UserBloc>();
              final newsBloc = context.read<NewsBloc>();
              return Stack(
                children: [
                  PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: state.newsList.length,
                    onPageChanged: (value) => index = value,
                    itemBuilder: (BuildContext context, int index) {
                      final cityId = state.newsList[index].cityId;
                      final username = state.newsList[index].username;
                      cityCubit.getCityById(cityId);
                      userBloc.add(GetUserByUsername(username));
                      return PageBuild(
                        size: size,
                        newsModel: state.newsList[index],
                        newsBloc: newsBloc,
                      );
                    },
                  ),
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: HomeAppBar(),
                  ),
                ],
              );
            } else if (state is NewsError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            // Colors.black,
            Colors.black.withOpacity(0.8),
            // Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.4),
            // Colors.black.withOpacity(0.2),
            Colors.transparent
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0, left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'the haberify',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              BlocBuilder<CityCubit, CityState>(
                builder: (context, state) {
                  if (state is CityLoaded) {
                    return Text(
                      state.city.city,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    );
                  } else if (state is CityLoading) {
                    return const CircularProgressIndicator(
                      color: Colors.transparent,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PageBuild extends StatelessWidget {
  const PageBuild({
    super.key,
    required this.size,
    required this.newsModel,
    required this.newsBloc,
  });

  final Size size;
  final NewsModel newsModel;
  final NewsBloc newsBloc;

  // bool readMore = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   setState(() {
      //     readMore = false;
      //   });
      // },
      // onDoubleTap: () => likeChange(),
      onLongPress: () async {
        _newsAssetsSlider(context);
      },
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(newsModel.newsPhotoIds[0]),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12.0),
              height:
                  newsModel.content.length < 300 ? null : size.height * 0.35,
              width: size.width * 0.96,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        newsBloc.timeConvert(newsModel),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          newsModel.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          newsModel.content,
                          // maxLines: 2,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: GestureDetector(
                      //     // onTap: () {
                      //     //   readMoreChange();
                      //     // },
                      //     child: newsModel.content.length > 300
                      //         ? const Text(
                      //             "Daha az görüntüle",
                      //             style: TextStyle(color: Colors.grey),
                      //           )
                      //         : const Text(
                      //             "Daha fazla görüntüle",
                      //             style: TextStyle(color: Colors.grey),
                      //           ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                width: size.width * 0.96,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black.withOpacity(0.8),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      newsModel.username,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 24,
                    ),
                    Text(
                      newsModel.likes.length.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.comment,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                  ],
                )),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Future<String?> _newsAssetsSlider(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.all(8),
        content: Dismissible(
          key: const Key("1"),
          direction: DismissDirection.down,
          onDismissed: (_) => Navigator.of(context).pop(),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PageView(
              physics: const BouncingScrollPhysics(),
              children: [
                for (var photo in newsModel.newsPhotoIds)
                  PinchZoom(
                    resetDuration: const Duration(milliseconds: 100),
                    maxScale: 2.5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: photo,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: LoadingAnimationWidget.beat(
                            color: Colors.red,
                            size: 100,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// showModalBottomSheet(
//               context: context,
//               builder: (BuildContext context) {
//                 return Container(
//                   height: 200.0,
//                   child: Center(
//                     child: Text('This is a bottom sheet'),
//                   ),
//                 );
//               },
//             );