import 'package:carrot_market_sample/page/detail.dart';
import 'package:carrot_market_sample/repository/contents_repository.dart';
import 'package:carrot_market_sample/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _currentLocation = "";
  final ContentsRepository contentsRepository = ContentsRepository();

  final Map<String, String> locationTypeToString = {
    "ara" : "아라동",
    "ora" : "오라동",
    "donam" : "도남동"
  };

  @override
  void initState() {
    super.initState();
    _currentLocation = "ara";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }

  AppBar _appbarWidget() {
    return AppBar(
      title: GestureDetector(
        onTap: (){
          print('click');
        },
        child: PopupMenuButton<String>(
          offset: const Offset(
            0, 25,
          ),
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            1
          ),
          onSelected: (where){
            setState(() {
              _currentLocation = where;
            });
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem(
                value: 'ara',
                child: Text('아라동'),
              ),
              PopupMenuItem(
                value: 'ora',
                child: Text('오라동'),
              ),
              PopupMenuItem(
                value: 'donam',
                child: Text('도남동'),
              ),
            ];
          },
          child: Row(
            children: [
              Text(locationTypeToString[_currentLocation].toString()),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
      elevation: 1,
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.search)),
        IconButton(onPressed: (){}, icon: Icon(Icons.tune)),
        IconButton(
            onPressed: (){},
            icon: SvgPicture.asset("svg/bell.svg"),
            iconSize: 22.0
        ),
      ],
    );
  }

  Widget _bodyWidget(){
    return FutureBuilder(
      future: _loadContents(),
      builder: (context, snapshot) {

        if(snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator(),);
        }

        if(snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(child: Text('데이터 오류'),);
        }

        if(snapshot.hasData) {
          return _makeDataList(snapshot.data as List<Map<String, String>>);
        }

        return Center(
          child: Text('해당 지역에 데이터가 없습니다.'),
        );

      },
    );
  }

  _loadContents(){
    return contentsRepository.loadContentFromLocation(_currentLocation);
  }

  Widget _makeDataList(List<Map<String, String>> data) {
    List<Map<String, String>> datas = data;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context){
                return DetailContentView(data: datas[index]);
              })
            );
          },
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Hero(
                      tag: datas[index]['cid'].toString(),
                      child: Image.asset(
                        datas[index]['image'].toString(),
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            datas[index]['title'].toString(),
                            style: TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            datas[index]['location'].toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            DataUtils.calcStringToWon(datas[index]['price'].toString()),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SvgPicture.asset("svg/heart_off.svg", width: 13, height: 13,),
                                SizedBox(width: 5,),
                                Text(datas[index]['likes'].toString()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
          ),
        );
      },
      separatorBuilder: (context, index){
        return Container(
          height: 1,
          color: Colors.black.withOpacity(0.2),
        );
      },
      itemCount: datas.length,
    );
  }
}
