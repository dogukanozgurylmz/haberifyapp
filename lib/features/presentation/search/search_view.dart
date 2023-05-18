import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habery/features/data/repositories/news_repository.dart';
import 'package:habery/features/data/repositories/tag_repository.dart';
import 'package:habery/features/data/repositories/user_repository.dart';
import 'package:habery/features/presentation/search/cubit/search_cubit.dart';

import '../../widgets/custom_textformfield.dart';

class SearchView extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();
  final TagRepository _tagRepository = TagRepository();
  final NewsRepository _newsRepository = NewsRepository();

  SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(
          newsRepository: _newsRepository,
          userRepository: _userRepository,
          tagRepository: _tagRepository),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          var cubit = context.read<SearchCubit>();
          return Scaffold(
            appBar: AppBar(
              leading: const SizedBox.shrink(),
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                )
              ],
              leadingWidth: 0,
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
                      controller: cubit.searchTextController,
                      // onEditingComplete: () {
                      //   cubit.searchNews(query)
                      // },
                      // onFieldSubmitted: (value) async {
                      //   await cubit.searchNews();
                      // },
                      onChanged: (text) {
                        cubit.searchNews();
                      },
                    ),
                  ),
                ),
              ),
            ),
            body: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.black,
                    indicatorColor: Color(0xffff0000),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    tabs: [
                      Tab(child: Text("Haberler")),
                      Tab(child: Text("Etiketler")),
                      Tab(child: Text("Kullanıcılar")),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      SearchTabBar(cubit: cubit, state: state),
                      SearchTabBar(cubit: cubit, state: state),
                      SearchTabBar(cubit: cubit, state: state),
                    ]),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchTabBar extends StatelessWidget {
  const SearchTabBar({
    super.key,
    required this.cubit,
    required this.state,
  });
  final SearchCubit cubit;
  final SearchState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == SearchStatus.LOADING) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state.status == SearchStatus.LOADED) {
      return ListView.builder(
        itemCount: state.newsList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                  state.newsList[index].newsPhotoIds.first),
              // NetworkImage(state.newsList[index].newsPhotoIds.first),
              backgroundColor: const Color(0xffff0000),
            ),
            title: Text(
              state.newsList[index].title,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              state.newsList[index].content,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
