import 'dart:async';
import 'dart:io' as io;
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/shared/snippets.dart';
import 'package:yaml/yaml.dart';

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

  late String? _imagePath = "";
  String? get imagePath => this._imagePath;

  late List<List<dynamic>> _boxes = [];
  List<List<dynamic>> get boxes => this._boxes;

  late YamlMap? _mapData = null;
  YamlMap? get mapData => this._mapData;

  @override
  onInit() async {
    var data = await rootBundle.loadString('assets/ml/custom.yaml');
    var d = loadYaml(data);
    _mapData = d['names'];
    initCamera();
    super.onInit();
  }

  initCamera() {
    List<CameraDescription> cameras = gc.cameras;
    _cameraController =
        CameraController(cameras[0], ResolutionPreset.low, enableAudio: false);
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
    _cameraController.setFlashMode(FlashMode.off);
    final xFile = await _cameraController.takePicture();
    final path = xFile.path;
    _imagePath = path;
    io.File file = io.File(xFile.path);
    final res = await upload(file, cont: _isDetecting);
    print(res);
    if (res != "[]") {
      _imagePath = path;
    }
    return res != "[]" && !res.contains('Error') ? res : "[]";
  }

  void startTimer() {
    // _boxes.clear();
    _timer = Timer.periodic(Duration(milliseconds: 50), (Timer t) async {
      _timer!.cancel();
      if (!_isDetecting) {
        t.cancel();
      }
      await Future.delayed(Duration(milliseconds: 50));
      final stopwatch = Stopwatch()..start();
      var res = await takePicAndDetect();
      print(res);
      print('executed in ${stopwatch.elapsed}');
      stopwatch.stop();

      // _detected = res;
      List<List<dynamic>> b = [];
      if (res != "[]") {
        res = res
            .replaceAll("[", "")
            .replaceAll("]", "")
            .replaceAll(",,", " ")
            .trim();

        var detectedSignsAsString = res.split(", ");

        var arrForPreprocess = [];
        for (var i = 0; i < detectedSignsAsString.length / 6; i++) {
          arrForPreprocess.add([]);
          for (var i2 = 0 + 6 * i; i2 < 6 + 6 * i; i2++) {
            arrForPreprocess[i].add(detectedSignsAsString[i2]);
          }
        }
        for (var element in arrForPreprocess) {
          b.add(element);
        }
      }
      _boxes = b;
      // update();
      // stopImageStream();

      if (b.isNotEmpty) {
        // stopImageStream();
      }
      update();
      if (_isDetecting) {
        startTimer();
      }
    });
  }

  Future<void> startImageStream() async {
    _imagePath = "";
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
    //     // await yoloOnFrame(image);
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
    _cameraController.dispose();
    super.dispose();
  }
}
