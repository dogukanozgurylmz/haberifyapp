import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

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
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(45)),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          !_isVisible
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Icon(
                                          Icons.settings,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
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
                                  borderRadius: BorderRadius.circular(45),
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      "https://picsum.photos/1200/1200",
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
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Icon(
                                          Icons.local_post_office_rounded,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
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
                        children: const [
                          Text(
                            "Doğukan Özgür Yılmaz",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "@dogukanozgurylmz",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "RİZE",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "111",
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "10",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  "Takip",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "3",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
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
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:
                            MediaQuery.of(context).size.width * .5,
                        mainAxisExtent: 220,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              child: Image.network(
                                "https://picsum.photos/1400/2000",
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
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
                            const Positioned(
                              bottom: 8,
                              left: 8,
                              right: 8,
                              child: Text(
                                "dsfgsdsada dadada daddsfsf sfsff dsfsvsvsdv sdvsdf sdfdsf sdfdsf sdfsdbsdfbd sdf",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
  }
}
