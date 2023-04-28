import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haberifyapp/features/presentation/addnews/add_news_view.dart';
import 'package:haberifyapp/features/presentation/discovery/discovery_view.dart';
import 'package:haberifyapp/features/presentation/views/home/home_view.dart';
import 'package:haberifyapp/features/presentation/live/live_view.dart';
import 'package:haberifyapp/features/presentation/profile/profile_view.dart';
import 'package:haberifyapp/features/widgets/blur_background.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomeView(),
    DiscoveryView(),
    AddNewsView(),
    const LiveView(),
    const ProfileView(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _children[_currentIndex],
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 30,
                    spreadRadius: -5,
                    color: Colors.black.withOpacity(0.25),
                  )
                ],
              ),
              child: BlurBackgroundWidget(
                blur: 20,
                opacity: .1,
                borderRadius: 100,
                child: BottomNavigationBar(
                  backgroundColor: Colors.black.withOpacity(0.4),
                  elevation: 0,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.grey,
                  onTap: onTabTapped,
                  currentIndex: _currentIndex,
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: '',
                      activeIcon: Icon(Icons.home),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      label: '',
                      activeIcon: Icon(Icons.search),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add),
                      label: '',
                      activeIcon: Icon(Icons.add_box),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.live_tv_rounded),
                      label: '',
                      activeIcon: Icon(Icons.live_tv_rounded),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      label: '',
                      activeIcon: Icon(Icons.person),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
