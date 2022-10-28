import 'dart:async';
import 'dart:io' as io;
import 'package:camera/camera.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/search/sign/search_sign_screen.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class AnalysisController extends GetxController {
  GlobalController gc = Get.find<GlobalController>();

  late FlutterVision vision;

  late bool _isLoaded = false;
  bool get isLoaded => this._isLoaded;

  late bool _isDetecting = false;
  bool get isDetecting => this._isDetecting;

  late List<Map<String, dynamic>> _modelResults;
  List<Map<String, dynamic>> get modelResults => this._modelResults;

  late CameraImage _cameraImage;
  CameraImage get cameraImage => this._cameraImage;

  late CameraController _cameraController;
  CameraController get cameraController => this._cameraController;

  late List<dynamic>? _recognitionsList;
  List<dynamic>? get recognitionsList => this._recognitionsList;

  late Timer? _timer;
  Timer? get timer => this._timer;

  late String? _detected = "[]";
  String? get detected => this._detected;

  late List<int>? _detectedSigns = [];
  List<int>? get detectedSigns => this._detectedSigns;

  @override
  onInit() {
    initCamera();
    super.onInit();
  }

  initCamera() {
    List<CameraDescription> cameras = gc.cameras;
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    _cameraController.initialize().then((_) {
      // vision = FlutterVision();
      // loadYoloModel().then((value) {
      _isLoaded = true;
      _isDetecting = false;
      // _modelResults = [];
      update();
      // });
    });
  }

  // Future<void> loadYoloModel() async {
  //   final responseHandler = await vision.loadYoloModel(
  //       labels: 'assets/ml/best-fp16.txt',
  //       modelPath: 'assets/ml/exp33.tflite',
  //       numThreads: 8,
  //       useGpu: false);
  //   if (responseHandler.type == 'success') {
  //     _isLoaded = true;
  //     update();
  //   }
  // }

  Future<String> takePicAndDetect() async {
    final xFile = await _cameraController.takePicture();
    final path = xFile.path;
    io.File file = io.File(xFile.path);
    final res = await upload(file);
    return res != "[]" ? res : "[]";
  }

  // void startTimer() {
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
  //     _timer!.cancel();
  //     await Future.delayed(Duration(seconds: 5));
  //     final xFile = await _cameraController.takePicture();
  //     final path = xFile.path;
  //     io.File file = io.File(xFile.path);
  //     final res = await upload(file);
  //     if (res != null) {
  //       _isDetecting = false;
  //       // return res;
  //     }
  //     print(_isDetecting);
  //     if (_isDetecting) {
  //       startTimer();
  //     }
  //     print(res);
  //     update();
  //   });
  // }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      print("lets wait for 5 seconds");
      _timer!.cancel();
      await Future.delayed(Duration(seconds: 5));
      var res = await takePicAndDetect();
      _detected = res;
      if (res != "[]") {
        res = res.replaceAll(new RegExp(r"\p{P}", unicode: true), "").trim();
        var detectedSignsAsString = res.split(" ");
        List<int> detectedSignsAsNumber = [];
        detectedSignsAsString.forEach((element) {
          detectedSignsAsNumber.add(int.parse(element));
        });
        print(detectedSignsAsNumber);
        stopImageStream();
      }
      if (_isDetecting) {
        startTimer();
      }
    });
  }

  Future<void> startImageStream() async {
    if (!_cameraController.value.isInitialized) {
      print('controller not initialized');
      return;
    }
    _isDetecting = true;

    startTimer();
    // await _cameraController.startImageStream((image) async {
    //   print("Running! ");
    //   if (_isDetecting) {
    //     return;
    //   }
    //   try {
    //     await yoloOnFrame(image);
    //     // await _cameraController.stopImageStream();
    //   } catch (e) {
    //     throw Exception(e);
    //   } finally {}
    // });
    update();
  }

  Future<void> stopImageStream() async {
    if (!_cameraController.value.isInitialized) {
      print('controller not initialized');
      return;
    }
    // _timer!.cancel();
    // if (_cameraController.value.isStreamingImages) {
    //   await _cameraController.stopImageStream();
    // }
    _isDetecting = false;
    // _modelResults.clear();
    update();
  }

  // Future<void> yoloOnFrame(CameraImage cameraImage) async {
  //   _isDetecting = true;

  //   final result = await vision.yoloOnFrame(
  //       bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
  //       imageHeight: cameraImage.height,
  //       imageWidth: cameraImage.width,
  //       iouThreshold: 0.6,
  //       confThreshold: 0.01);

  //   // _modelResults = result.data as List<Map<String, dynamic>>;
  //   print(result.type);
  //   _isDetecting = false;
  // }

  // Future<void> yoloOnFrame(CameraImage cameraImage) async {
  //   _isDetecting = true;
  //   print('owo');

  //   final result = await vision.yoloOnFrame(
  //       bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
  //       imageHeight: cameraImage.height,
  //       imageWidth: cameraImage.width,
  //       iouThreshold: 0.6,
  //       confThreshold: 0.01);

  //   // _modelResults = result.data as List<Map<String, dynamic>>;
  //   print(result.type);
  //   _isDetecting = false;
  // }

  runModel() async {
    // updateCameraImage(cameraImage);
  }

  updateCameraImage(val) {
    _cameraImage = val;
  }

  @override
  void dispose() async {
    // await vision.closeYoloModel();
    _cameraController.stopImageStream();
    super.dispose();
  }
}
