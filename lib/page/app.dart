import 'package:carrot_market_sample/page/favorite.dart';
import 'package:carrot_market_sample/page/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late int _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(String iconName, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: SvgPicture.asset("svg/${iconName}_off.svg", width: 22,),
      ),
      label: label,
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: SvgPicture.asset("svg/${iconName}_on.svg", width: 22,),
      ),
    );
  }

  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      selectedFontSize: 12,
      items: [
        _bottomNavigationBarItem("home", "홈"),
        _bottomNavigationBarItem("notes", "동네 생활"),
        _bottomNavigationBarItem("location", "내 근처"),
        _bottomNavigationBarItem("chat", "채팅"),
        _bottomNavigationBarItem("user", "나의 당근"),
      ],
      currentIndex: _currentPageIndex,
      onTap: (index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
    );
  }

  Widget _bodyWidget() {
    switch (_currentPageIndex){
      case 0 :
        return Home();
        break;
      case 1 :
        return Container();
        break;
      case 2 :
        return Container();
        break;
      case 3 :
        return Container();
        break;
      case 4 :
        return MyFavoriteContents();
        break;
    }

    return Container();
  }

}