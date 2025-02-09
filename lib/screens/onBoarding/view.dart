import 'package:stock_management/headers.dart';

final OnBoardcontroller = Get.find<OnboardingController>();

class onboardingBody extends StatefulWidget {
  const onboardingBody({super.key});

  @override
  State<onboardingBody> createState() => _onboardingBodyState();
}

class _onboardingBodyState extends State<onboardingBody> {
  late Material materialButton;
  final activePainter = Paint();
  final inactivePainter = Paint();

  final onboardingPagesList = [
    DecoratedBox(
      decoration: Decorations.pageModelDecoration,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            SubWidgets.pageModelChild1(assets.onBoard1),
            SubWidgets.pageModelChild2(Texts.onBoardTitle1),
            SubWidgets.pageModelChild3(Texts.onBoardText11),
            SubWidgets.pageModelChild3(Texts.onBoardText12),
          ],
        ),
      ),
    ),
    DecoratedBox(
      decoration: Decorations.pageModelDecoration,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            SubWidgets.pageModelChild1(assets.onBoard2),
            SubWidgets.pageModelChild2(Texts.onBoardTitle2),
            SubWidgets.pageModelChild3(Texts.onBoardText21),
            SubWidgets.pageModelChild3(Texts.onBoardText22),
            SubWidgets.pageModelChild3(Texts.onBoardText23),
          ],
        ),
      ),
    ),
    DecoratedBox(
      decoration: Decorations.pageModelDecoration,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            SubWidgets.pageModelChild1(assets.onBoard3),
            SubWidgets.pageModelChild2(Texts.onBoardTitle3),
            SubWidgets.pageModelChild3(Texts.onBoardText31),
            SubWidgets.pageModelChild3(Texts.onBoardText32),
            SubWidgets.pageModelChild3(Texts.onBoardText33),
          ],
        ),
      ),
    ),
    DecoratedBox(
      decoration: Decorations.pageModelDecoration,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            SubWidgets.pageModelChild1(assets.onBoard4),
            SubWidgets.pageModelChild2(Texts.onBoardTitle4),
            SubWidgets.pageModelChild3(Texts.onBoardText41),
            SubWidgets.pageModelChild3(Texts.onBoardText42),
            SubWidgets.pageModelChild3(Texts.onBoardText43),
          ],
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();

    activePainter.color = primaryColor.withOpacity(0.2);
    activePainter.strokeWidth = 2;
    activePainter.strokeCap = StrokeCap.round;
    activePainter.style = PaintingStyle.stroke;

    inactivePainter.color = primaryColor;
    inactivePainter.strokeWidth = 2;
    inactivePainter.strokeCap = StrokeCap.round;
    inactivePainter.style = PaintingStyle.fill;
  }

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: primaryColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (setIndex != null) {
            OnBoardcontroller.setPageIndex(3); // Update the page index
            setIndex(3);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.butHorPad, vertical: Sizes.butVerPad),
          child: Text(
            'Skip',
            style: TextWidgets.bodyTextStyle(secondaryColor),
          ),
        ),
      ),
    );
  }

  Material get _signupButton {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: primaryColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.offAndToNamed(MyGet.singup);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.butHorPad, vertical: Sizes.butVerPad),
          child: Text(
            'Sign up',
            style: TextWidgets.bodyTextStyle(secondaryColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        body: GetBuilder<OnboardingController>(
          init: OnBoardcontroller,
          builder: (controller) {
            return Onboarding(
              startIndex: 0,
              onPageChanges: (_, __, currentIndex, sd) {
                controller
                    .setPageIndex(currentIndex); // Update the current index
              },
              swipeableBody: onboardingPagesList,
              buildFooter: (context, dragDistance, pagesLength, currentIndex,
                  setIndex, sd) {
                return DecoratedBox(
                  decoration: Decorations.pageModelDecoration,
                  child: ColoredBox(
                    color: secondaryColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Sizes.padh1, vertical: Sizes.padv),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Indicator<LinePainter>(
                            painter: LinePainter(
                              currentPageIndex: currentIndex,
                              pagesLength: pagesLength,
                              netDragPercent: dragDistance,
                              activePainter: activePainter,
                              inactivePainter: inactivePainter,
                              slideDirection: sd,
                              lineWidth: 20,
                            ),
                          ),
                          controller.currentIndex.value == pagesLength - 1
                              ? _signupButton
                              : _skipButton(setIndex: setIndex)
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
