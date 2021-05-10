import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:heydoc/screens/wrapper.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => Wrapper()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset('assets/onboard/$assetName.png',
              width: 250.0, height: 350),
        ),
      ),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Find Doctors",
          body:
              "Doctors and other medical facilities near you or in any other city are just a tap away!",
          image: _buildImage('find_docs'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Appointments 24*7",
          body:
              "Book online/offline appointments easily anytime, anywhere with easy cancellation and rescheduling.",
          image: _buildImage('appointment'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Report and Meds",
          body:
              "Keep track of your medical reports, prescriptions and medicines at one place, and take them anywhere!",
          image: _buildImage('report'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
