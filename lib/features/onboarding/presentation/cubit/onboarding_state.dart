part of 'onboarding_cubit.dart';

class OnBoardingState {
  final int currentIndex;

  const OnBoardingState({
    this.currentIndex = 0,
  });

  OnBoardingState copyWith({
    int? currentIndex,
  }) {
    return OnBoardingState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}