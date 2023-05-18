import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:habery/features/data/repositories/news_repository.dart';
import 'package:habery/features/data/repositories/tag_repository.dart';
import 'package:habery/features/presentation/discovery/cubit/discovery_cubit.dart';
import 'package:habery/features/presentation/newslist/news_list_view.dart';
import 'package:habery/features/presentation/search/search_view.dart';
import 'package:habery/features/widgets/custom_textformfield.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class DiscoveryView extends StatelessWidget {
  DiscoveryView({super.key});
  final TagRepository _tagRepository = TagRepository();
  final NewsRepository _newsRepository = NewsRepository();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiscoveryCubit>(
      create: (context) => DiscoveryCubit(
        tagRepository: _tagRepository,
        newsRepository: _newsRepository,
      ),
      child: BlocBuilder<DiscoveryCubit, DiscoveryState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              toolbarHeight: 60,
              title: Hero(
                tag: "search_discovery",
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: CustomTextFormField(
                      borderRadius: 30,
                      labelText: "Ara",
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchView(),
                        ));
                      },
                    ),
                  ),
                ),
              ),
            ),
            body: DiscoveryWidget(state: state),
          );
        },
      ),
    );
  }
}

class DiscoveryWidget extends StatelessWidget {
  final DiscoveryState state;
  const DiscoveryWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state.status == DiscoveryStatus.LOADING) {
      return const ShimmerEffect();
    } else if (state.status == DiscoveryStatus.LOADED) {
      return GridView.custom(
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.fast),
        gridDelegate: SliverQuiltedGridDelegate(
          // crossAxisSpacing: 4,
          // mainAxisSpacing: 4,
          crossAxisCount: 9,
          repeatPattern: QuiltedGridRepeatPattern.inverted,
          pattern: const [
            // QuiltedGridTile(12, 6),
            // QuiltedGridTile(12, 6),
            // QuiltedGridTile(4, 8),
            // QuiltedGridTile(8, 8),
            // QuiltedGridTile(8, 8),
            // QuiltedGridTile(8, 12),
            // QuiltedGridTile(12, 10),
            // QuiltedGridTile(8, 10),
            // QuiltedGridTile(4, 10),
            QuiltedGridTile(5, 3),
            QuiltedGridTile(5, 3),
            QuiltedGridTile(5, 3),
          ],
        ),
        childrenDelegate: SliverChildBuilderDelegate(
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          addSemanticIndexes: true,
          childCount:
              !state.hasReachedMax ? state.tags.length : state.tags.length,
          (context, index) {
            if (index >= state.tags.length - 1) {
              if (!state.hasReachedMax) {
                context.read<DiscoveryCubit>().getAllTag();
                return Center(
                    child: LoadingAnimationWidget.inkDrop(
                  color: Colors.black,
                  size: 16,
                ));
              }
            }
            final images = [];
            final tag = state.tags[index];
            // state.tagNewsImageMap.keys.;
            if (state.tagNewsImageMap.isNotEmpty) {
              for (var value in state.tagNewsImageMap.values) {
                images.add(value);
              }
            }
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return NewsListView(tagName: tag.tag);
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
              child: Padding(
                padding: const EdgeInsets.all(.5),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        images[index],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black87,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          '#${tag.tag}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
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
      child: GridView.custom(
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.fast),
        gridDelegate: SliverQuiltedGridDelegate(
          // crossAxisSpacing: 4,
          // mainAxisSpacing: 4,
          crossAxisCount: 9,
          repeatPattern: QuiltedGridRepeatPattern.inverted,
          pattern: const [
            // QuiltedGridTile(12, 6),
            // QuiltedGridTile(12, 6),
            // QuiltedGridTile(4, 8),
            // QuiltedGridTile(8, 8),
            // QuiltedGridTile(8, 8),
            // QuiltedGridTile(8, 12),
            // QuiltedGridTile(12, 10),
            // QuiltedGridTile(8, 10),
            // QuiltedGridTile(4, 10),
            QuiltedGridTile(5, 3),
            QuiltedGridTile(5, 3),
            QuiltedGridTile(5, 3),
          ],
        ),
        childrenDelegate: SliverChildBuilderDelegate(
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          addSemanticIndexes: true,
          childCount: 9,
          (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.1,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
