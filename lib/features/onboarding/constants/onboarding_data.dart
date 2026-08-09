
import 'package:etmaan/features/onboarding/data/model/onboarding_model.dart';

class OnBoardingData {
  static const List<OnBoardingModel> pages = [
    OnBoardingModel(
      image: 'assets/images/onboarding1.png',
      title: 'رحلة يومية نحو الطمأنينة',
      description:
          'اقرأ القرآن الكريم وتتبع تقدمك يوماً بعد يوم.',
    ),
    OnBoardingModel(
      image: 'assets/images/onboarding2.png',
      title: 'اذكر الله في أي وقت',
      description:
          'سبحة إلكترونية وأذكار يومية بطريقة سهلة ومريحة.',
    ),
    OnBoardingModel(
      image: 'assets/images/onboarding2.png',
      title: 'اصنع عادات تدوم',
      description:
          'حدد أهدافك اليومية واستقبل تذكيرات تحفزك على الاستمرار.',
    ),
  ];
}