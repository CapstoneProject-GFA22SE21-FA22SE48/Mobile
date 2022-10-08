import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/Answer.dart';
import 'package:vnrdn_tai/models/Question.dart';
import 'package:vnrdn_tai/services/QuestionService.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class QuestionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late GlobalController gc;
  final questionService = QuestionSerivce();

  late Animation _animation;
  Animation get animation => _animation;

  late PageController _pageController;
  PageController get pageController => this._pageController;

  bool _isAnswered = false;
  bool get isAnswered => this._isAnswered;

  late List<Question> _answeredQuestions = [];
  List<Question> get answeredQuestions => this._answeredQuestions;

  late List<dynamic> _answeredAttempt = [];
  List<dynamic> get answeredAttempts => this._answeredAttempt;

  late Answer _correctAns;
  Answer get correctAns => this._correctAns;

  late Answer _selectedAns;
  Answer get selectedAns => this._selectedAns;

  RxInt _quesntionNumber = 1.obs;
  RxInt get questionNumber => this._quesntionNumber;

  int _numberOfCorrectAns = 0;
  int get numberOfCorrectAns => this._numberOfCorrectAns;

  @override
  void onInit() {
    gc = Get.put(GlobalController());
    _animationController = AnimationController(
        vsync: this, duration: const Duration(seconds: quizTime));
    _pageController = PageController();
    super.onInit();
  }

  @override
  dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void runTimer() {
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animation.addListener(() {
      update();
    });
    _animationController.forward();
  }

  void stopTimer() {
    _animationController.stop(canceled: true);
  }

  void checkAns(Question question, int selectedIndex) {
    if (_answeredQuestions.firstWhereOrNull((element) => element == question) ==
            null) {
      _isAnswered = true;
      _correctAns =
          question.answers.firstWhere((element) => element.isCorrect == true);
      _selectedAns = question.answers[selectedIndex];

      _answeredQuestions.add(question);
      _answeredAttempt.add({
        'question': question,
        'isAnswered': true,
        'correctAns': _correctAns,
        'selectedAns': _selectedAns,
        'isCorrect': _correctAns == _selectedAns
      });
    } else {
      dynamic q = _answeredAttempt
          .firstWhere((element) => element['question'] == question);
      q!['selectedAns'] = question.answers[selectedIndex];
      q!['isCorrect'] = question.answers.firstWhere((element) => element.isCorrect == true) == question.answers[selectedIndex];
    }

    if (gc.test_mode.value == TEST_TYPE.TEST) {
      if (_correctAns == _selectedAns) {
        ++_numberOfCorrectAns;
      }
    }
    // _animationController.stop();
    update();
  }

  void nextQuestion() {
    _isAnswered = false;
    _pageController.nextPage(
        duration: Duration(microseconds: 250), curve: Curves.ease);
    _animationController.reset();
    _animationController.forward();
  }
}
