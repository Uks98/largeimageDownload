//
//
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
//
// class DownLoadImage{
//   final imageUrl = "https://images.pexels.com/photos/240040/pexels-photo-240040.jpeg?auto=compress";
//   bool downloading = false;
//   var progressString = "";
//   var file;
//   Future<void> downloadFile()async{
//     Dio dio = Dio();
//     try{
//       final dir = await getApplicationDocumentsDirectory();
//       await dio.download(imageUrl, "${dir.path}/myimage.jpg",
//           onReceiveProgress: (rec,total){
//             //rec == 지금까지 내려받은 데이터, total == 파일의 전체크기
//             print("rec: $rec ,total : $total");
//             setState((){
//               downloading = true;
//               progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
//             });
//           }
//       );
//     }catch(e){
//       print(e);
//     }setState((){
//       downloading = false;
//       progressString = "completed";
//     });
//     print("download completed");
//   }
// }