import 'package:carrot_market_sample/page/detail.dart';
import 'package:carrot_market_sample/repository/contents_repository.dart';
import 'package:carrot_market_sample/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyFavoriteContents extends StatefulWidget {
  const MyFavoriteContents({Key? key}) : super(key: key);

  @override
  _MyFavoriteContentsState createState() => _MyFavoriteContentsState();
}

class _MyFavoriteContentsState extends State<MyFavoriteContents> {

  final ContentsRepository contentsRepository = ContentsRepository();

  @override
  void initState() {
    super.initState();
  }

  AppBar _appbarWidget() {
    return AppBar(
      title: Text(
        '관심 목록',
        style: TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _bodyWidget(){
    return FutureBuilder(
      future: _loadMyFavorContentList(),
      builder: (context, snapshot) {

        if(snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator(),);
        }

        if(snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(child: Text('데이터 오류'),);
        }

        if((snapshot.data as List<dynamic>).isEmpty) {
          return Center(
            child: Text('관심 목록에 데이터가 없습니다.'),
          );
        }

        if(snapshot.hasData) {
          return _makeDataList(snapshot.data as List<dynamic>);
        }

        return Center(
          child: Text('관심 목록에 데이터가 없습니다.'),
        );
      },
    );
  }

  Future<List<dynamic>?> _loadMyFavorContentList() async {
    return await contentsRepository.loadFavoriteContents();
  }

  Widget _makeDataList(List<dynamic> datas) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbarWidget(),
        body: _bodyWidget(),
    );
  }
}
