import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlider extends StatefulWidget {
  BannerSlider({
    Key? key,
  }) : super(key: key);

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController();

  bool isJump = false;

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),
    ).then((value) => _pageController.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.ease));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: Stack(
        children: [
          PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: _pageController,
            onPageChanged: (value) {
              isJump
                  ? Future.delayed(
                      const Duration(seconds: 3),
                    ).then((value) {
                      _pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                      isJump = false;
                    })
                  : Future.delayed(
                      const Duration(seconds: 3),
                    ).then((value) => _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease));
            },
            itemCount: 3,
            itemBuilder: (context, index) {
              index == 2 ? isJump = true : false;
              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    'assets/images/b${index + 1}.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 4,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.deepPurple,
                ),
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  axisDirection: Axis.horizontal,
                  effect: WormEffect(
                    spacing: 4.0,
                    radius: 4.0,
                    dotWidth: 20.0,
                    dotHeight: 3.0,
                    paintStyle: PaintingStyle.fill,
                    strokeWidth: 1.5,
                    dotColor: Colors.grey.shade400,
                    activeDotColor: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
