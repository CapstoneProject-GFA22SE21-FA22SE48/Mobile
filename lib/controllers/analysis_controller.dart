import 'dart:async';
import 'dart:io' as io;
import 'package:camera/camera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';
import 'package:yaml/yaml.dart';

class AnalysisController extends GetxController {
  GlobalController gc = Get.find<GlobalController>();

  late FlutterVision vision;

  late bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  late bool _isDetecting = false;
  bool get isDetecting => _isDetecting;

  late List<Map<String, dynamic>> _modelResults;
  List<Map<String, dynamic>> get modelResults => _modelResults;

  late CameraImage _cameraImage;
  CameraImage get cameraImage => _cameraImage;

  late CameraController _cameraController;
  CameraController get cameraController => _cameraController;

  late List<dynamic>? _recognitionsList;
  List<dynamic>? get recognitionsList => _recognitionsList;

  late Timer? _timer;
  Timer? get timer => _timer;

  late Timer? _timerScan;
  Timer? get timerScan => _timerScan;

  late final String _detected = "[]";
  String? get detected => _detected;

  late final List<int> _detectedSigns = [];
  List<int>? get detectedSigns => _detectedSigns;

  late List<List<dynamic>> _boxes = [];
  List<List<dynamic>> get boxes => _boxes;

  late List<List<dynamic>> _suggestBoxes = [];
  List<List<dynamic>> get suggestBoxes => _suggestBoxes;

  late YamlMap? _mapData;
  YamlMap? get mapData => _mapData;

  late bool? _found = false;
  bool? get found => _found;

  late String? _imagePathScan = "";
  String? get imagePathScan => _imagePathScan;

  //Feedback Sign starts here
  late String? _imagePath = "";
  String? get imagePath => _imagePath;

  //Feedback Sign starts here
  late String _aiurl = "";
  String get aiurl => _aiurl;

  late XFile? _image;
  XFile? get image => _image;

  late int _remainTime = TIME_OUT_SCAN;
  int get remainTime => _remainTime;

  late double _zoomLevel = 0.0;
  double get zoomLevel => _zoomLevel;

  late double _maxZoom = 0.0;
  double get maxZoom => _maxZoom;
  late double _minZoom = 0.0;
  double get minZoom => _minZoom;

  @override
  onInit() async {
    var data = await rootBundle.loadString('assets/ml/custom.yaml');
    var d = loadYaml(data);
    _mapData = d['names'];
    initCamera();
    super.onInit();
  }

  void startScanTimer() {
    const oneSec = const Duration(seconds: 1);
    _timerScan = Timer.periodic(
      oneSec,
      (Timer timerSc) {
        if (_remainTime == 0) {
          stopImageStream();
          timerSc.cancel();
          update();
        } else {
          _remainTime--;
          update();
        }
      },
    );
  }

  takeSignContentFeebackImage() async {
    _cameraController.setFlashMode(FlashMode.off);
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
      _cameraController.initialize().then((_) async {
        // vision = FlutterVision();
        // if (gc.modelLoad.value == false) {
        //   loadYoloModel().then((value) {
        //     gc.updateModelLoad(true);
        //   });
        // }
        _maxZoom = await _cameraController.getMaxZoomLevel();
        _minZoom = await _cameraController.getMinZoomLevel();
        _zoomLevel = _minZoom;
        _isDetecting = false;
        _modelResults = [];
        _isLoaded = true;
        update();
      });
    });
  }

  Future<void> loadYoloModel() async {
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
    _cameraController.setFlashMode(FlashMode.off);
    try {
      final xFile = await _cameraController.takePicture();
      final path = xFile.path;
      io.File file = io.File(xFile.path);
      final res = await upload(file, cont: _isDetecting, url: _aiurl);
      if (res != "[]") {
        _imagePathScan = path;
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
    _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer t) async {
      _timer!.cancel();
      if (!_isDetecting) {
        t.cancel();
      }

      await Future.delayed(const Duration(milliseconds: 100));
      final stopwatch = Stopwatch()..start();
      var res = await takePicAndDetect();
      print('executed in ${stopwatch.elapsed}');
      stopwatch.stop();

      // _detected = res;
      List<List<dynamic>> b = [];
      List<List<dynamic>> b2 = [];
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
          if (b2.firstWhereOrNull((e) => e[0] == element[0]) == null) {
            b2.add(element);
          }
        }
      }
      _boxes = b;
      _suggestBoxes = b2;
      // update();
      // stopImageStream();

      if (b.isNotEmpty) {
        _remainTime = TIME_OUT_SCAN;
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
    _imagePathScan = "";
    _found = false;
    _remainTime = TIME_OUT_SCAN;
    if (!_cameraController.value.isInitialized) {
      // print('controller not initialized');
      return;
    }
    _isDetecting = true;
    // var frame = 0;
    // var fps = 1;
    startTimer();
    startScanTimer();
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
      // print('controller not initialized');
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
    // print(cameraImage.height);
    // print(cameraImage.width);

    _boxes = [];
    var stopwatch = Stopwatch()..start();
    final result = await vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.9,
        confThreshold: 0.50);
    print('executed in ${stopwatch.elapsed}');
    // print(result.stackTrace);
    if (result.data != null) {
      // print(result.data);
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

  updateZoomLevel(value) async {
    var zl = double.parse(value.toStringAsFixed(1));
    if (zl > maxZoom) {
      await _cameraController.setZoomLevel(maxZoom);
    } else {
      _zoomLevel = zl;
      await _cameraController.setZoomLevel(zl);
    }
    update();
  }

  @override
  void dispose() async {
    // await vision.closeYoloModel();
    _cameraController.stopImageStream();
    _cameraController.dispose();
    super.dispose();
  }
}
