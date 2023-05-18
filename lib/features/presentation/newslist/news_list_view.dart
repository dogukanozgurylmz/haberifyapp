import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habery/features/data/repositories/city_repository.dart';
import 'package:habery/features/data/repositories/news_repository.dart';
import 'package:habery/features/data/repositories/user_repository.dart';
import 'package:habery/features/presentation/newslist/cubit/news_list_cubit.dart';
import 'package:habery/features/presentation/other_profile/other_profile_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../data/models/news_model.dart';
import '../../data/repositories/tag_repository.dart';

class NewsListView extends StatelessWidget {
  final String tagName;

  const NewsListView({
    super.key,
    required this.tagName,
  });

  @override
  Widget build(BuildContext context) {
    final NewsRepository newsRepository = NewsRepository();
    final CityRepository cityRepository = CityRepository();
    final UserRepository userRepository = UserRepository();
    final TagRepository tagRepository = TagRepository();

    final controller = PageController(initialPage: 0);
    var size = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // StatusBar rengi
      statusBarIconBrightness: Brightness.light, // StatusBar ikonlarının rengi
    ));

    return BlocProvider(
      create: (context) => NewsListCubit(
        newsRepository: newsRepository,
        cityRepository: cityRepository,
        userRepository: userRepository,
        tagRepository: tagRepository,
      )
        ..getTag(tagName)
        ..getUser(),
      child: Scaffold(
        body: BlocBuilder<NewsListCubit, NewsListState>(
          builder: (context, state) {
            var cubit = context.read<NewsListCubit>();

            if (state.status == NewsListStatus.LOADING) {
              return const ShimmerEffect();
            } else if (state.status == NewsListStatus.LOADED) {
              return Stack(
                children: [
                  PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: state.newsList.length,
                    onPageChanged: (value) {
                      var news = state.newsList[value];
                      cubit.getCityById(news.cityId);
                      cubit.getUserByUsername(news.username);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      var news = state.newsList[index];
                      return PageBuild(
                        size: size,
                        newsModel: news,
                        cubit: cubit,
                        state: state,
                      );
                    },
                    controller: controller,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: HomeAppBar(
                      state: state,
                      tagName: tagName,
                    ),
                  ),
                ],
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

class HomeAppBar extends StatefulWidget {
  final NewsListState state;
  final String tagName;
  const HomeAppBar({
    super.key,
    required this.state,
    required this.tagName,
  });

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  void firstUpload() {
    var cubit = context.read<NewsListCubit>();
    var state = context.read<NewsListCubit>().state;
    if (state.newsList.isNotEmpty) {
      if (cubit.state.status == NewsListStatus.LOADED) {
        cubit.getCityById(state.newsList[0].cityId);
        cubit.getUserByUsername(state.newsList[0].username);
      }
    }
  }

  @override
  void initState() {
    firstUpload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.4),
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
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              Text(
                "#${widget.tagName}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Text(
                widget.state.city.city,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
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
    required this.cubit,
    required this.state,
  });

  final Size size;
  final NewsModel newsModel;
  final NewsListCubit cubit;
  final NewsListState state;

  // bool readMore = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   setState(() {
      //     readMore = false;
      //   });
      // },
      onDoubleTap: () => cubit.like(newsModel),
      onLongPress: () async {
        await _newsAssetsSlider(context);
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: newsModel.newsPhotoIds.first,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return const ShimmerEffect();
            },
            height: size.height,
            width: size.width,
          ),
          Positioned(
            bottom: 52,
            left: 8,
            right: 8,
            top: newsModel.content.length < 300 ? null : size.height * 0.55,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              height:
                  newsModel.content.length < 300 ? null : size.height * 0.35,
              width: size.width * 0.96,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cubit.timeConvert(newsModel),
                      style: const TextStyle(
                        color: Colors.grey,
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
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            left: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              width: size.width * 0.96,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.6),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration:
                              const Duration(milliseconds: 1000),
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return OtherProfileView(
                                username: newsModel.username);
                          },
                          transitionsBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child) {
                            return Align(
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      state.userModel.username,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      await cubit.like(newsModel);
                      // cubit.getUser();
                    },
                    child: state.isLike
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 24,
                          )
                        : Icon(
                            Icons.favorite,
                            color: newsModel.likes.contains(cubit.username)
                                ? const Color(0xffff0000)
                                : Colors.white,
                            size: 24,
                          ),
                  ),
                  Text(
                    state.isLike
                        ? newsModel.likes.length.toString()
                        : newsModel.likes.length.toString(),
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
              ),
            ),
          ),
        ],
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

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      interval: const Duration(seconds: 0),
      color: Colors.grey,
      colorOpacity: 0.4,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
