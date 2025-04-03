import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:paysync/src/constants/colors.dart';
import 'package:paysync/src/constants/image_strings.dart';
import 'package:paysync/src/constants/sizes.dart';
import 'package:paysync/src/constants/text_strings.dart';
import 'package:paysync/src/features/authentication/controllers/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
    SplashScreen ({super.key});
  
    final splashController = Get.put(SplashScreenController());
    @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var width = mediaQuery.size.width;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    splashController.startAnimation();
    return Scaffold(
     backgroundColor: isDarkMode ? tSecondaryColor : tPrimaryColor, // Add background color
      body: Stack(
        children: [
          Obx( ()=>AnimatedPositioned(
             duration: const Duration(milliseconds: 1600),
              top: splashController.animate.value?0:-30,
              left: splashController.animate.value?0:-30,
               child: Image (image: AssetImage(tSplashTopIcon),height: height * 0.2,), 
              ),
              ),// 
           Obx(()=>AnimatedPositioned (
              duration: const Duration(milliseconds: 1600),
              top: height * 0.2,  // Positioned at 20% from top
              left: splashController.animate.value? tDefaultSize:-80,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1600),
                opacity: splashController.animate.value?1:0,
                child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  Text(tAppName,style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: tPrimaryColor,
                              fontSize: 40,
                            ),),
                  Text(tAppTagLine,style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),),         
                  ],
                  ),
              ),
           ),),
           Obx(()=>AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              bottom: height * 0.15, 
              left: width * 0.1,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1600),
                opacity: splashController.animate.value?1:0,
              child: Image (image: AssetImage(tSplashImage),
              height: height * 0.4,  // 40% of screen height
                    width: width * 0.8,    // 80% of screen width
                    fit: BoxFit.contain,), 
              ),
           ),),
          Obx(()=> AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              bottom: 40,
              right:tDefaultSize,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1600),
                opacity: splashController.animate.value?1:0,
              child: Container (
                width: tSplashContainerSize,
                height: tSplashContainerSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromARGB(255, 0, 179, 255),
                  boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                ),
              ), 
              ),
              ),),
         ],
       ),
     );
    }

}