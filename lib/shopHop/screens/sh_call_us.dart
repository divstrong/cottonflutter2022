import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../utils/ShColors.dart';
import '../utils/ShConstant.dart';
import '../utils/ShImages.dart';

class CallUs extends StatelessWidget {
  const CallUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: sh_colorPrimary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                sh_ic_call,
                color: sh_white,
              ),
              TextButton(
                onPressed: () => UrlLauncher.launch("tel://21213123123"),
                child: text(
                  'Call Us Now',
                  textColor: sh_white,
                  fontSize: textSizeLargeMedium,
                  fontFamily: fontBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
