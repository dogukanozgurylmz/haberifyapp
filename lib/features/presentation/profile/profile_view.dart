import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haberifyapp/features/data/repositories/auth_repository.dart';
import 'package:haberifyapp/features/data/repositories/city_repository.dart';
import 'package:haberifyapp/features/data/repositories/follow_repository.dart';
import 'package:haberifyapp/features/presentation/profile/cubit/profile_cubit.dart';
import 'package:haberifyapp/features/presentation/sign_in/sign_in_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../data/datasouce/local/user_local_datasource.dart';
import '../../data/repositories/follower_repository.dart';
import '../../data/repositories/news_repository.dart';
import '../../data/repositories/user_repository.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  final ScrollController _gridScrollerController = ScrollController();
  late TabController _tabController;
  bool _isVisible = true;
  final UserRepository userRepository = UserRepository();
  final NewsRepository newsRepository = NewsRepository();
  final CityRepository cityRepository = CityRepository();
  final UserLocalDatasource userLocalDatasource = UserLocalDatasource();
  final AuthRepository authRepository = AuthRepository();
  final FollowRepository followRepository = FollowRepository();
  final FollowerRepository followerRepository = FollowerRepository();

  Future<void> scrollControle() async {
    _gridScrollerController.addListener(() {
      if (_gridScrollerController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      } else {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xff0A0E11), // Durum çubuğu arka plan rengi
      statusBarIconBrightness: Brightness.light, // Durum çubuğu ikon rengi
    ));
    _tabController = TabController(vsync: this, length: 2);
    scrollControle();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        userRepository: userRepository,
        cityRepository: cityRepository,
        newsRepository: newsRepository,
        userLocalDatasource: userLocalDatasource,
        authRepository: authRepository,
        followRepository: followRepository,
        followerRepository: followerRepository,
      ),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.LOADED) {
            var cubit = context.read<ProfileCubit>();
            return Scaffold(
              body: Center(
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            bottom: 20, top: 12, left: 12, right: 12),
                        // height: 360,
                        width: MediaQuery.of(context).size.width,
                        height: !_isVisible ? 1 : null,
                        decoration: const BoxDecoration(
                          color: Color(0xff0A0E11),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(45)),
                        ),
                        child: SafeArea(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  !_isVisible
                                      ? const SizedBox.shrink()
                                      : Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: InkWell(
                                                onTap: () async {
                                                  var signOut = cubit.signOut();
                                                  await signOut.then((value) =>
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SignInView(),
                                                      )));
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: Icon(
                                                    Icons.settings,
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Icon(
                                                  Icons.security_rounded,
                                                  size: 24,
                                                  color: Colors.green[900],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  Column(
                                    children: [
                                      Container(
                                        width: 112,
                                        height: 112,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              state.userModel.profilePhotoUrl,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  !_isVisible
                                      ? const SizedBox.shrink()
                                      : Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: Icon(
                                                  Icons
                                                      .local_post_office_rounded,
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Column(
                                children: [
                                  Text(
                                    "${state.userModel.firstname} ${state.userModel.lastname}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "@${state.userModel.username}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  // const SizedBox(height: 8),
                                  // const Text(
                                  //   "RİZE",
                                  //   style: TextStyle(
                                  //     fontSize: 16,
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                height: 64,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${state.followerUsernames.length}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Text(
                                          "Takipçi",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${state.followUsernames.length}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        const Text(
                                          "Takip",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${state.newsList.length}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        const Text(
                                          "Gönderi",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.label,
                        dividerColor: const Color(0xff0A0E11),
                        labelColor: const Color(0xff0A0E11),
                        indicatorColor: const Color(0xff0A0E11),
                        tabs: const <Widget>[
                          Tab(
                            text: "Haberler",
                          ),
                          Tab(
                            text: "Yazılar",
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            GridView.builder(
                              controller: _gridScrollerController,
                              padding: const EdgeInsets.all(12.0),
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent:
                                    MediaQuery.of(context).size.width * .5,
                                mainAxisExtent: 220,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: state.newsList.length,
                              itemBuilder: (context, index) {
                                var news = state.newsList[index];
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                        bottomRight: Radius.circular(30),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: news.newsPhotoIds.first,
                                        fit: BoxFit.cover,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        placeholder: (context, url) => Center(
                                          child: LoadingAnimationWidget
                                              .twoRotatingArc(
                                                  color:
                                                      const Color(0xffff0000),
                                                  size: 40),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                        ),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0),
                                            Colors.black.withOpacity(1),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      left: 8,
                                      right: 8,
                                      child: Text(
                                        news.title,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                            const Center(
                              child: Text("Köşe yazısı bulunmamaktadır."),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (state.status == ProfileStatus.LOADING) {
            return Center(
              child: LoadingAnimationWidget.prograssiveDots(
                  color: const Color(0xffff0000), size: 60),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
