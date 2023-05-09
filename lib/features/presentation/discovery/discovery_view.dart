import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:haberifyapp/features/data/repositories/news_repository.dart';
import 'package:haberifyapp/features/data/repositories/tag_repository.dart';
import 'package:haberifyapp/features/presentation/discovery/cubit/discovery_cubit.dart';
import 'package:haberifyapp/features/presentation/newslist/news_list_view.dart';
import 'package:haberifyapp/features/widgets/custom_textformfield.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
              title: const CustomTextFormField(
                borderRadius: 30,
                labelText: "Ara",
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
      return Center(
        child: LoadingAnimationWidget.prograssiveDots(
            color: const Color(0xffff0000), size: 40),
      );
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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NewsListView(tagName: tag.tag),
                ));
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
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(
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
