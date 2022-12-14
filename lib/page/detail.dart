import 'package:carousel_slider/carousel_slider.dart';
import 'package:carrot_market_sample/components/manor_temperature_widget.dart';
import 'package:carrot_market_sample/repository/contents_repository.dart';
import 'package:carrot_market_sample/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailContentView extends StatefulWidget {
  Map<String, String> data;

  DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView>
    with SingleTickerProviderStateMixin {
  late Size size;
  late List<Map<String, String>> imgList;
  late int _current;
  late ScrollController _controller;
  late double scrollPositionToAplpha;
  late AnimationController _animationController;
  late Animation _colorTween;
  late bool isMyFavoriteContent;
  final ContentsRepository contentsRepository = ContentsRepository();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);
    _controller = ScrollController();
    scrollPositionToAplpha = 0.0;
    _controller.addListener(() {
      setState(() {
        if (_controller.offset > 255) {
          scrollPositionToAplpha = 255;
        } else {
          scrollPositionToAplpha = _controller.offset;
        }

        _animationController.value = scrollPositionToAplpha / 255;
      });
    });

    isMyFavoriteContent = false;
    _loadMyFavoriteContentState();
  }

  _loadMyFavoriteContentState() async {
    bool ck = await contentsRepository.isMyFavoriteContents(widget.data["cid"].toString());

    setState(() {
      isMyFavoriteContent = ck;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    imgList = [
      {"id": "0", "url": widget.data["image"].toString()},
      {"id": "1", "url": widget.data["image"].toString()},
      {"id": "2", "url": widget.data["image"].toString()},
      {"id": "3", "url": widget.data["image"].toString()},
      {"id": "4", "url": widget.data["image"].toString()},
    ];
    _current = 0;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => Icon(
        icon,
        color: _colorTween.value,
      ),
    );
  }

  AppBar _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.white.withAlpha(scrollPositionToAplpha.toInt()),
      //0 - 255
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: _makeIcon(Icons.arrow_back),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.share)),
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.more_vert)),
      ],
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            _makeSliderImage(),
            _sellerSimpleInfo(),
            _line(),
            _contentDetail(),
            _line(),
            _makeReport(),
            _line(),
            _otherCellContents(),
          ]),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //??? ?????? ??????
              mainAxisSpacing: 10, //????????? ??????
              crossAxisSpacing: 10, //?????? ??????
            ),
            delegate: SliverChildListDelegate(List.generate(20, (index) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        color: Colors.grey,
                        height: 120,
                      ),
                    ),
                    Text(
                      "?????? ??????",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      "??????",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList()),
          ),
        ),
      ],
    );
  }

  Widget _makeSliderImage() {
    return Container(
      child: Stack(
        children: [
          Hero(
            tag: widget.data["cid"].toString(),
            child: CarouselSlider(
              items: imgList.map((map) {
                return Image.asset(
                  map["url"].toString(),
                  width: size.width,
                  fit: BoxFit.fill,
                );
              }).toList(),
              // carouselController: _controller,
              options: CarouselOptions(
                  height: size.width,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0, //left 0, right 0?????? ?????? ?????? ??????
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.map((map) {
                return GestureDetector(
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == int.parse(map["id"].toString())
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _sellerSimpleInfo() {
    return Padding(
      padding: EdgeInsets.all(
        15.0,
      ),
      child: Row(
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(30),
          //   child:
          // )
          CircleAvatar(
            radius: 25,
            backgroundImage: Image.asset(
              "images/user.png",
            ).image,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "???????????? ??????",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text("????????? ?????????"),
            ],
          ),
          Expanded(
            child: ManorTemperatureWidget(manorTemp: 37.5),
          ),
        ],
      ),
    );
  }

  Widget _contentDetail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Text(
            widget.data["title"].toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            "?????????/?????? ??? 22?????? ???",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            "???????????? ??? ????????????\n?????? ??????????????? ????????????.\n????????? ???????????? ????????????.",
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            "?????? 3 ??? ?????? 17 ??? 22?????? ???",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  Widget _makeReport() {
    return Container(
      width: size.width,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15.0,
          ),
          GestureDetector(
            onTap: () {
              print('report button click');
            },
            child: Container(
              width: size.width,
              child: Text(
                '??? ????????? ????????????',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  Widget _otherCellContents() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '??????????????? ?????? ??????',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '?????? ??????',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget _line() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _bottomBarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      width: size.width,
      height: 55,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              if(isMyFavoriteContent) {
                await contentsRepository.deleteMyFavoriteContent(widget.data["cid"].toString());
              }
              else {
                await contentsRepository.addMyFavoriteContent(widget.data);
              }
              setState(() {
                isMyFavoriteContent = !isMyFavoriteContent;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(microseconds: 1000),
                  content: isMyFavoriteContent
                      ? Text('?????? ????????? ?????????????????????.')
                      : Text('?????? ????????? ?????????????????????.'),
                ),
              );
            },
            child: SvgPicture.asset(
              "svg/heart${isMyFavoriteContent ? "_on" : "_off"}.svg",
              width: 25,
              height: 25,
              color: Color(0xfff08f4f),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10),
            width: 1,
            height: 40,
            color: Colors.grey.withOpacity(0.5),
          ),
          Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                DataUtils.calcStringToWon(widget.data["price"].toString()),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Text(
                "?????? ?????? ??????",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                  color: Colors.orangeAccent,
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xfff08f4f),
                  ),
                  child: const Text(
                    '???????????? ????????????',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      //?????????????????? ????????? ??????????????? ??????
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }
}
