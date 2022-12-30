import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../utils/ShColors.dart';
import '../utils/ShConstant.dart';

class CallUs extends StatelessWidget {
  const CallUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextButton(
          onPressed: () => UrlLauncher.launch("tel://21213123123"),
          child: text(
            'Call Us Now',
            textColor: sh_colorPrimary,
            fontSize: textSizeLargeMedium,
            fontFamily: fontBold,
          ),
        ),
      ),
    );
  }
}
