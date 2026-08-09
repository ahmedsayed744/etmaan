import 'package:etmaan/features/onboarding/constants/onboarding_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'onboarding_state.dart';
class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(const OnBoardingState());
  final PageController pageController = PageController();
  void changePage(int index) {
    emit(state.copyWith(currentIndex: index));
  }
  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ); 
  }
  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
 bool get isLastPage =>
    state.currentIndex == OnBoardingData.pages.length - 1;
  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}