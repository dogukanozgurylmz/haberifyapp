import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haberifyapp/features/data/repositories/auth_repository.dart';
import 'package:haberifyapp/features/data/repositories/city_repository.dart';
import 'package:haberifyapp/features/data/repositories/follow_repository.dart';
import 'package:haberifyapp/features/data/repositories/news_repository.dart';
import 'package:haberifyapp/features/data/repositories/user_repository.dart';
import 'package:haberifyapp/features/presentation/newslist/cubit/news_list_cubit.dart';
import 'package:haberifyapp/features/presentation/other_profile/other_profile_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
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
    final AuthRepository authRepository = AuthRepository();
    final FollowRepository followRepository = FollowRepository();
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
        authRepository: authRepository,
        followRepository: followRepository,
        tagRepository: tagRepository,
      )
        ..getTag(tagName)
        ..getUser(),
      child: Scaffold(
        body: BlocBuilder<NewsListCubit, NewsListState>(
          builder: (context, state) {
            var cubit = context.read<NewsListCubit>();

            if (state.status == NewsListStatus.LOADING) {
              return Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: const Color(0xffff0000),
                  size: 60,
                ),
              );
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
                borderRadius: BorderRadius.circular(5),
              ),
              child: Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cubit.timeConvert(newsModel),
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
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  color: Colors.black.withOpacity(0.8),
                ),
                child: Row(
                  children: [
                    // CircleAvatar(backgroundImage: NetworkImage(state.userModel.),)
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              OtherProfileView(username: newsModel.username),
                        ));
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
                )),
            const SizedBox(height: 12),
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
