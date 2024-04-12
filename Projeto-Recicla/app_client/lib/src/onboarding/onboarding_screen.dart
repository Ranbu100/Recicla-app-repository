import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final List<String> imageAssets = [
    'images/1.png',
    'images/2.png',
    'images/3.png',
    'images/4.png',
    'images/5.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: imageAssets
                .map((asset) => OnboardingPage(imageAsset: asset))
                .toList(),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: DotsIndicator(
              dotsCount: imageAssets.length,
              position: _currentPage.toInt(),
              decorator: DotsDecorator(
                size: Size.square(8.0),
                activeSize: Size.square(10.0),
                color: Colors.grey,
                activeColor: Colors.green,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Modular.to.navigate('/on/t');
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage < imageAssets.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    } else {
                      Modular.to.navigate('/on/t');
                    }
                  },
                  child: Text(
                    _currentPage < imageAssets.length - 1
                        ? 'Avançar'
                        : 'Continuar',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imageAsset;
  OnboardingPage({
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageAsset),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
