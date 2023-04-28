import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haberifyapp/features/data/repositories/news_repository.dart';
import 'package:haberifyapp/features/data/repositories/tag_repository.dart';
import 'package:haberifyapp/features/presentation/discovery/cubit/discovery_cubit.dart';
import 'package:haberifyapp/features/widgets/blur_background.dart';
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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 60,
              title: const CustomTextFormField(
                borderRadius: 30,
                labelText: "Ara",
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TagsWidget(state: state),
                  const SizedBox(width: 4),
                  Expanded(
                    flex: 15,
                    child: state.newsList.isEmpty
                        ? const SizedBox.shrink()
                        : ListView.builder(
                            itemCount: state.newsList.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    height: 160,
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(8),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          state.newsList[index].newsPhotoIds
                                              .first,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        BlurBackgroundWidget(
                                          blur: 10,
                                          opacity: 0.5,
                                          borderRadius: 30,
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: const Text(
                                              "Lorem Ipsum",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8)
                                ],
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container _discoveryNews(BuildContext context) {
    return Container(
      height: 160,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: const DecorationImage(
          image: NetworkImage("https://picsum.photos/1200/1200"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BlurBackgroundWidget(
            blur: 10,
            opacity: 0.5,
            borderRadius: 30,
            child: Container(
              padding: const EdgeInsets.all(12),
              width: MediaQuery.of(context).size.width,
              child: const Text(
                "Lorem Ipsum",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TagsWidget extends StatelessWidget {
  final DiscoveryState state;
  TagsWidget({
    super.key,
    required this.state,
  });

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (state.status == DiscoveryStatus.TAGLOADING) {
      return Center(
        child: LoadingAnimationWidget.prograssiveDots(
            color: const Color(0xffff0000), size: 40),
      );
    } else {
      return Expanded(
        flex: 1,
        child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount:
              state.hasReachedMax ? state.tags.length : state.tags.length + 1,
          itemBuilder: (context, index) {
            if (index >= state.tags.length) {
              context.read<DiscoveryCubit>().getAllTag();
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final tag = state.tags[index];
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Chip(
                padding: const EdgeInsets.all(4),
                label: Text(
                  "#${tag.tag}",
                  style: TextStyle(color: Colors.grey[300]),
                ),
                backgroundColor: const Color(0xff0A0E11),
              ),
            );
          },
        ),
      );
    }
  }
}
