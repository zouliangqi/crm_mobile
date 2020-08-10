//
//import 'dart:async';
//import 'dart:io';
//
//import 'package:camera/camera.dart';
//import 'package:flutter/material.dart';
//import 'package:path_provider/path_provider.dart';
//
//import 'main.dart';
//import 'package:miscrm/customized_widgets/customized_widgets.dart';
//
//
//import 'package:bot_toast/bot_toast.dart';
//import 'package:dio/dio.dart';
//import 'package:flutter/cupertino.dart';
//
//
//
//import 'package:shared_preferences/shared_preferences.dart';
//
//
//class CameraExampleHome extends StatefulWidget {
//  @override
//  _CameraExampleHomeState createState() {
//    return _CameraExampleHomeState();
//  }
//}
//
///// 返回按钮图标
//IconData getCameraLensIcon(CameraLensDirection direction) {
//  switch (direction) {
//    case CameraLensDirection.back:
//      return Icons.camera_rear;
//    case CameraLensDirection.front:
//      return Icons.camera_front;
//    case CameraLensDirection.external:
//      return Icons.camera;
//  }
//  throw ArgumentError('Unknown lens direction');
//}
//
//void logError(String code, String message) =>
//    print('Error: $code\nError Message: $message');
//
//class _CameraExampleHomeState extends State<CameraExampleHome>
//    with WidgetsBindingObserver {
//  CameraController controller;
//  String imagePath;
//
//  VoidCallback videoPlayerListener;
//  bool isDetecting = false;
//
//  Timer timer;
//  @override
//  void initState() {
//    super.initState();
//    int flag=0;
//    controller = CameraController(cameras[1], ResolutionPreset.medium,enableAudio: true);
//    controller.initialize().then((_) async{
//      if (!mounted) {
//        return;
//      }
////      controller.startImageStream((CameraImage img) async{
////        if(flag%50==0){
////          var i=img.format.group;
////          var a=await _upLoadimg(i);
////          print("a=${a}");
////          if (a=="smile" ) {
////            print("smile");
////            controller.stopImageStream();
////          }
////          if (a=="nomal" ) {
////            print("nomal");
////            controller.stopImageStream();
////          }
////
////          else{
////            print("no smile");
////          }
////        }
////        if(flag==500)
////          controller.stopImageStream();
////        flag=flag+1;
////      });
//
//
//      timer = Timer.periodic(Duration(seconds: 3), (Timer t) => onTakePictureButtonPressed());
//      setState(() {});
//    });
//
//
//    WidgetsBinding.instance.addObserver(this);
//  }
//
//  @override
//  void dispose() {
//    WidgetsBinding.instance.removeObserver(this);
//    timer?.cancel();
//    super.dispose();
//  }
//
//  @override
//  void didChangeAppLifecycleState(AppLifecycleState state) {
//
//    if (controller == null || !controller.value.isInitialized) {
//      return;
//    }
//    if (state == AppLifecycleState.inactive) {
//      controller?.dispose();
//    } else if (state == AppLifecycleState.resumed) {
//      if (controller != null) {
//        onNewCameraSelected(controller.description);
//      }
//    }
//  }
//
//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//
//  Future<String> _upLoadimg(filebytes) async{
//    //showMyLoadingDialog(context,hintText: "正在上传",);
//
//    var name = "file.png";
//    try{
//      FormData d = new FormData.fromMap({
//        "file": await MultipartFile.fromFile(filebytes, filename: name)
//      });
//      Dio dio = new Dio(); //
//      // dio.options.connectTimeout = 5000;
//      var baseUrl = "http://ip/upload";
//      dio.options.contentType = Headers.formUrlEncodedContentType;
//      //SharedPreferences preferences = await SharedPreferences.getInstance();
//      var response;
//      response = await dio.post(
//        baseUrl,
//        data: d,
//      );
//      print(response.data);
//      return response.data;
//    }catch(e){
//      print(e);
//      return "error";
//    }
//  }
//
//  Future<String> _upLoadimg2(path) async{
//
//    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
//    try{
//      FormData d = new FormData.fromMap({
//        "file": await MultipartFile.fromFile(path, filename: name)
//      });
//      Dio dio = new Dio(); //
//      var baseUrl = "http://ip/upload";
//      dio.options.contentType = Headers.formUrlEncodedContentType;
//
//      var response;
//      response = await dio.post(
//        baseUrl,
//        data: d,
//      );
//      print(response.data);
//      if(response.data=="smile")
//        BotToast.showText(text: "笑脸",align: Alignment.center);
//      else if(response.data=="normal")
//        BotToast.showText(text: "没笑",align: Alignment.center);
//      else
//        BotToast.showText(text: response.data,align: Alignment.center);
//    }catch(e){
//      print(e);
//      BotToast.showText(text: e,align: Alignment.center);
//      return "error";
//    }
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      key: _scaffoldKey,
//      appBar: AppBar(
//        title: Text('笑脸检测'),
//        centerTitle: true,
//        backgroundColor: Colors.white,
//        elevation: 0,
//      ),
//      body: Container(
//        color: Colors.white,
//        child: Column(
//          children: <Widget>[
//
//               Container(
//                 margin: EdgeInsets.only(top: 10),
////                width:  MediaQuery.of(context).size.width,
////                height: MediaQuery.of(context).size.width,
//                padding: EdgeInsets.only(top: 20,bottom: 20,left: 50,right: 50),
//                child:
//
//                Center(
//                    child: ClipOval(
//                      child: AspectRatio(
//                        aspectRatio: 3/5,
//                        child: CameraPreview(controller),
//                      ),
//                    )
//                ),
//
//                  color: Colors.white,
//
//              ),
//
//            Container(
//                color: Colors.white,
//                child: _captureControlRowWidget()),
//            //_toggleAudioWidget(),
//            Container(
//              color: Colors.white,
//              padding: const EdgeInsets.all(5.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.start,
//                children: <Widget>[
//                  _cameraTogglesRowWidget(),
//                  _thumbnailWidget(),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  /// Display the preview from the camera (or a message if the preview is not available).
//  Widget _cameraPreviewWidget() {
//    if (controller == null || !controller.value.isInitialized) {
//
//      return const Text(
//        'Tap a camera',
//        style: TextStyle(
//          color: Colors.white,
//          fontSize: 24.0,
//          fontWeight: FontWeight.w900,
//        ),
//      );
//    } else {
//      return Stack(
//        children: <Widget>[
//        ClipOval(
//           child: AspectRatio(
//              aspectRatio: controller.value.aspectRatio,
//              child: CameraPreview(controller),
//            ),
//          )
//
////          Center(
////            child: Container(
////              color:Colors.white,
////
////            ),
////          )
//        ],
//      );
//
//
//    }
//
//  }
//
//
//  /// 右下角展示照片
//  Widget _thumbnailWidget() {
//    return Expanded(
//      child: Align(
//        alignment: Alignment.centerRight,
//        child: Row(
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            imagePath == null
//                ? Container()
//                : SizedBox(
//              child: Image.file(File(imagePath)),
//
//              width: 64.0,
//              height: 64.0,
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  /// 拍照
//  Widget _captureControlRowWidget() {
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//      mainAxisSize: MainAxisSize.max,
//      children: <Widget>[
//        IconButton(
//          icon: const Icon(Icons.camera_alt),
//          color: Colors.blue,
//          onPressed: controller != null &&
//              controller.value.isInitialized
//              ? onTakePictureButtonPressed
//              : null,
//        ),
//
//      ],
//    );
//  }
//
//  /// Display a row of toggle to select the camera (or a message if no camera is available).
//  Widget _cameraTogglesRowWidget() {
//    final List<Widget> toggles = <Widget>[];
//
//    if (cameras.isEmpty) {
//      return const Text('没有找到相机');
//    } else {
//      for (CameraDescription cameraDescription in cameras) {
//        toggles.add(
//          SizedBox(
//            width: 90.0,
//            child: RadioListTile<CameraDescription>(
//              title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
//              groupValue: controller?.description,
//              value: cameraDescription,
//              onChanged: controller != null && controller.value.isRecordingVideo
//                  ? null
//                  : onNewCameraSelected,
//            ),
//          ),
//        );
//      }
//    }
//
//    return Row(children: toggles);
//  }
//
//  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
//
//  void showInSnackBar(String message) {
//    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
//  }
//
//  void onNewCameraSelected(CameraDescription cameraDescription) async {
//    if (controller != null) {
//      await controller.dispose();
//    }
//    controller = CameraController(
//      cameraDescription,
//      ResolutionPreset.medium,
//
//    );
//
//
//    controller.addListener(() {
//      if (mounted) setState(() {});
//      if (controller.value.hasError) {
//        showInSnackBar('Camera error ${controller.value.errorDescription}');
//      }
//    });
//
//    try {
//      await controller.initialize();
//    } on CameraException catch (e) {
//      _showCameraException(e);
//    }
//
//    if (mounted) {
//      setState(() {});
//    }
//  }
//
//  void onTakePictureButtonPressed() {
//    takePicture().then((String filePath) {
//      if (mounted) {
//        setState(() {
//          imagePath = filePath;
//        });
//       // if (filePath != null) showInSnackBar('Picture saved to $filePath');
//      }
//    });
//  }
//
//
//  Future<String> takePicture() async {
//    if (!controller.value.isInitialized) {
//      showInSnackBar('Error: select a camera first.');
//      return null;
//    }
//    final Directory extDir = await getApplicationDocumentsDirectory();
//    final String dirPath = '${extDir.path}/Pictures/flutter_test';
//    await Directory(dirPath).create(recursive: true);
//    final String filePath = '$dirPath/${timestamp()}.png';
//
//    if (controller.value.isTakingPicture) {
//      // A capture is already pending, do nothing.
//      return null;
//    }
//
//    try {
//      await controller.takePicture(filePath);
//      _upLoadimg2(filePath);
//    } on CameraException catch (e) {
//      _showCameraException(e);
//      return null;
//    }
//    return filePath;
//  }
//
//  void _showCameraException(CameraException e) {
//    logError(e.code, e.description);
//    showInSnackBar('Error: ${e.code}\n${e.description}');
//  }
//}
//
