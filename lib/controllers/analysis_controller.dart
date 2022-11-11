import 'dart:async';
import 'dart:developer';
import 'dart:io' as io;
import 'package:camera/camera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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

  late bool _isDetecting;
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

  late List<List<dynamic>> _boxes = [];
  List<List<dynamic>> get boxes => this._boxes;

  late YamlMap? _mapData = null;
  YamlMap? get mapData => this._mapData;

  late bool? _found = false;
  bool? get found => this._found;

  //Feedback Sign starts here
  late String? _imagePath = "";
  String? get imagePath => this._imagePath;

  //Feedback Sign starts here
  late String _aiurl = "";
  String get aiurl => this._aiurl;

  late XFile? _image = null;
  XFile? get image => this._image;

  @override
  onInit() async {
    var data = await rootBundle.loadString('assets/ml/custom.yaml');
    var d = loadYaml(data);
    _mapData = d['names'];
    initCamera();
    super.onInit();
  }

  takeSignContentFeebackImage() async {
    _cameraController.setFlashMode(FlashMode.auto);
    final xFile = await _cameraController.takePicture();
    _image = xFile;
    final path = xFile.path;
    _imagePath = path;
    update();
  }

  clearFeedbackImage() {
    _image = null;
    _imagePath = "";
    update();
  }

  initCamera() {
    DatabaseReference firebaseDatabase =
        FirebaseDatabase.instance.ref('ai_url');
    firebaseDatabase.onValue.listen((DatabaseEvent event) {
      _aiurl = event.snapshot.value.toString();
      // updateStarCount(data);
      GlobalController gc = Get.find<GlobalController>();
      List<CameraDescription> cameras = gc.cameras;
      _cameraController = CameraController(cameras[0], ResolutionPreset.max,
          enableAudio: false);
      _cameraController.initialize().then((_) {
        // vision = FlutterVision();
        // if (gc.modelLoad.value == false) {
        //   loadYoloModel().then((value) {
        //     gc.updateModelLoad(true);
        //   });
        // }
        _isDetecting = false;
        _modelResults = [];
        _isLoaded = true;
        update();
      });
    });
  }

  Future<void> loadYoloModel() async {
    print('loading');
    final responseHandler = await vision.loadYoloModel(
        labels: 'assets/ml/best-fp16.txt',
        modelPath: 'assets/ml/exp33.tflite',
        numThreads: 1,
        useGpu: false);
    if (responseHandler.type == 'success') {
      update();
    }
  }

  Future<String> takePicAndDetect() async {
    _cameraController.setFlashMode(FlashMode.auto);
    try {
      final xFile = await _cameraController.takePicture();
      final path = xFile.path;
      // _imagePath = path;
      io.File file = io.File(xFile.path);
      print(file.lengthSync());
      final res = await upload(file, cont: _isDetecting, url: _aiurl);
      print(res);
      if (res != "[]") {
        _imagePath = path;
      }
      if (res != null) {
        return res != "[]" && !res.contains('Error') ? res : "[]";
      }
    } on Exception catch (ex) {
      print(ex);
    }
    return "";
  }

  void startTimer() {
    // _boxes.clear();
    _timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) async {
      _timer!.cancel();
      if (!_isDetecting) {
        t.cancel();
      }
      await Future.delayed(Duration(milliseconds: 100));
      final stopwatch = Stopwatch()..start();
      var res = await takePicAndDetect();
      print('executed in ${stopwatch.elapsed}');
      stopwatch.stop();

      // _detected = res;
      List<List<dynamic>> b = [];
      if (res != "[]" && res != "") {
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
    _found = false;
    if (!_cameraController.value.isInitialized) {
      print('controller not initialized');
      return;
    }
    _isDetecting = true;
    var frame = 0;
    var fps = 1;
    startTimer();
    // await _cameraController.startImageStream((image) async {
    //   if (!_isDetecting) {
    //     return;
    //   }
    //   frame++;
    //   if (frame % (30 / fps) == 0) {
    //     try {
    //       frame = 0;

    //       await yoloOnFrame(image);
    //       await _cameraController.stopImageStream();
    //     } catch (e) {
    //       throw Exception(e);
    //     } finally {}
    //   }
    // });
    update();
  }

  Future<void> stopImageStream() async {
    if (!_cameraController.value.isInitialized) {
      print('controller not initialized');
      return;
    }
    // _timer!.cancel();
    if (_cameraController.value.isStreamingImages) {
      await _cameraController.stopImageStream();
    }
    _isDetecting = false;
    update();
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    print(cameraImage.height);
    print(cameraImage.width);

    _boxes = [];
    var stopwatch = Stopwatch()..start();
    final result = await vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.9,
        confThreshold: 0.50);
    print('executed in ${stopwatch.elapsed}');
    print(result.stackTrace);
    if (result.data != null) {
      print(result.data);
      _modelResults = result.data as List<Map<String, dynamic>>;
      if (_modelResults.isNotEmpty) {
        _modelResults.forEach((element) {
          _boxes.add([
            element['tag'],
            element['box']['x1'],
            element['box']['y1'],
            element['box']['x2'],
            element['box']['y2']
          ]);
        });
        _found = true;
      }
    }
    // debugger();
    // _isDetecting = false;
    // stopImageStream();
    update();
  }

  runModel() async {
    // updateCameraImage(cameraImage);
  }

  updateCameraImage(val) {
    _cameraImage = val;
  }

  @override
  void dispose() async {
    await vision.closeYoloModel();
    _cameraController.stopImageStream();
    _cameraController.dispose();
    super.dispose();
  }
}
