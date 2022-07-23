import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImageDown extends StatefulWidget {
  const ImageDown({Key? key}) : super(key: key);

  @override
  State<ImageDown> createState() => _ImageDownState();
}

class _ImageDownState extends State<ImageDown> {
  final imageUrl = "https://images.pexels.com/photos/240040/pexels-photo-240040.jpeg?auto=compress";
  bool downloading = false;
  var progressString = "";
  var file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          downloadFile(imageUrl);
        },
        child: Icon(Icons.file_download),
      ),
      appBar: AppBar(title: Text("large file example"),),
      body: Center(
        child: downloading ? Container(
          height: 120,
          width: 120,
          child: Card(
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20.0,),
                Text("파일은 다운로드 중입니다 : $progressString",style: TextStyle(
                  color: Colors.white,
                ),),
              ],
            ),
          ),
        ) : FutureBuilder(
          builder: (context,AsyncSnapshot snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
              print("none");
              return Text("데이터 없음");
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.active:
              return CircularProgressIndicator();
            case ConnectionState.done:
              print('done');
              if(snapshot.hasData && !snapshot.hasError){
                return snapshot.data;
              }
          }
          return Text("데이터없음");
        },future: downloadWidget(file ?? ""),)
      ),
    );
  }
  Future<void> downloadFile(String filePath)async{
    Dio dio = Dio();
    try{
      final dir = await getApplicationDocumentsDirectory();
      await dio.download(imageUrl, '${dir.path}/myimage.jpg',
      onReceiveProgress: (rec,total){
        //rec == 지금까지 내려받은 데이터, total == 파일의 전체크기
        file = '${dir.path}/myimage.jpg';
        print("rec: $rec ,total : $total");
        setState((){
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      }
      );
    }catch(e){
      print(e);
    }setState((){
      downloading = false;
      progressString = "completed";
    });
    print("download completed");
  }
  Future<Widget> downloadWidget(String filePath)async{
    File file = File(filePath);
    bool exist = await file.exists();
    new FileImage(file).evict(); //캐시 초기화 캐시에 같은 이미지가 있어도 이미지 갱신
    if(exist){
      return Center(child: Column(children: [Image.file(File(filePath))],),);
    }else{
      return Text("no data");
    }
  }
}
