import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/models/Answer.dart';
import 'package:vnrdn_tai/models/Question.dart';
import 'package:vnrdn_tai/services/QuestionService.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class QuestionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final questionService = QuestionSerivce();

  late Animation _animation;
  Animation get animation => _animation;

  late PageController _pageController;
  PageController get pageController => this._pageController;

  bool _isAnswered = false;
  bool get isAnswered => this._isAnswered;

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
    _animationController = AnimationController(
        vsync: this, duration: const Duration(seconds: quizTime));
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animation.addListener(() {
      update();
    });
    _animationController.forward();

    _pageController = PageController();
    super.onInit();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void checkAns(Question question, int selectedIndex) {
    _isAnswered = true;
    _correctAns =
        question.answers.firstWhere((element) => element.isCorrect == true);
    _selectedAns = question.answers[selectedIndex];

    if (_correctAns == _selectedAns) ++_numberOfCorrectAns;

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
