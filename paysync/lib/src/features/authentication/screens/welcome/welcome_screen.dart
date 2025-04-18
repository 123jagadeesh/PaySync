import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysync/src/constants/colors.dart';
import 'package:paysync/src/constants/image_strings.dart';
import 'package:paysync/src/constants/sizes.dart';
import 'package:paysync/src/constants/text_strings.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? tSecondaryColor : tPrimaryColor,
      body: Container(
        padding: EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: AssetImage(tSplashImage), height: height * 0.5),
            Column(
              children: [
                Text(tAppTagLine,
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.toNamed('/login'),
                    child: Text(tLogin.toUpperCase()),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.toNamed('/signup'),
                    child: Text(tSignup.toUpperCase()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
