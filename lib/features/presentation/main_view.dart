import 'package:flutter/material.dart';
import 'package:habery/features/presentation/addnews/add_news_view.dart';
import 'package:habery/features/presentation/corner_post/corner_post_view.dart';
import 'package:habery/features/presentation/discovery/discovery_view.dart';
import 'package:habery/features/presentation/home/home_view.dart';
import 'package:habery/features/presentation/profile/profile_view.dart';

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
    const CornerPostView(),
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
      resizeToAvoidBottomInset: false,
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white70,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        elevation: 0,
        iconSize: 28,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rounded_corner),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}
// Positioned(
//             bottom: 12,
//             left: 12,
//             right: 12,
//             child: Container(
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     blurRadius: 30,
//                     spreadRadius: -5,
//                     color: Colors.black.withOpacity(0.25),
//                   )
//                 ],
//               ),
//               child: BlurBackgroundWidget(
//                 blur: 20,
//                 opacity: .1,
//                 borderRadius: 100,
//                 child: BottomNavigationBar(
//                   backgroundColor: Colors.black.withOpacity(0.4),
//                   elevation: 0,
//                   selectedItemColor: Colors.white,
//                   unselectedItemColor: Colors.white,
//                   onTap: onTabTapped,
//                   currentIndex: _currentIndex,
//                   type: BottomNavigationBarType.fixed,
//                   showSelectedLabels: false,
//                   showUnselectedLabels: false,
//                   items: [
//                     BottomNavigationBarItem(
//                       icon: const Icon(Icons.newspaper),
//                       label: '',
//                       activeIcon: Container(
//                         padding: const EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                             color: const Color(0xffff0000),
//                             borderRadius: BorderRadius.circular(50)),
//                         child: const Icon(Icons.newspaper, size: 20),
//                       ),
//                     ),
//                     BottomNavigationBarItem(
//                       icon: const Icon(Icons.search),
//                       label: '',
//                       activeIcon: Container(
//                         padding: const EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                             color: const Color(0xffff0000),
//                             borderRadius: BorderRadius.circular(50)),
//                         child: const Icon(Icons.search, size: 20),
//                       ),
//                     ),
//                     BottomNavigationBarItem(
//                       icon: const Icon(Icons.add_box),
//                       label: '',
//                       activeIcon: Container(
//                         padding: const EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                             color: const Color(0xffff0000),
//                             borderRadius: BorderRadius.circular(50)),
//                         child: const Icon(Icons.add, size: 20),
//                       ),
//                     ),
//                     BottomNavigationBarItem(
//                       icon: const Icon(Icons.live_tv_rounded),
//                       label: '',
//                       activeIcon: Container(
//                         padding: const EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                             color: const Color(0xffff0000),
//                             borderRadius: BorderRadius.circular(50)),
//                         child: const Icon(Icons.live_tv_rounded, size: 20),
//                       ),
//                     ),
//                     BottomNavigationBarItem(
//                       icon: const Icon(Icons.person_outline),
//                       label: '',
//                       activeIcon: Container(
//                         padding: const EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                             color: const Color(0xffff0000),
//                             borderRadius: BorderRadius.circular(50)),
//                         child: const Icon(Icons.person_outline, size: 20),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),