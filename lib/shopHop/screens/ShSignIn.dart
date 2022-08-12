import 'package:cached_network_image/cached_network_image.dart';
import 'package:cotton_natural/shopHop/api/MyResponse.dart';
import 'package:cotton_natural/shopHop/controllers/AuthController.dart';
import 'package:cotton_natural/shopHop/providers/OrdersProvider.dart';
import 'package:cotton_natural/shopHop/utils/Validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/shopHop/screens/ShHomeScreen.dart';
import 'package:cotton_natural/shopHop/screens/ShSignUp.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShImages.dart';
import 'package:cotton_natural/shopHop/utils/ShStrings.dart';
import 'package:provider/provider.dart';

class ShSignIn extends StatefulWidget {
  static String tag = '/ShSignIn';

  @override
  ShSignInState createState() => ShSignInState();
}

class ShSignInState extends State<ShSignIn> {
  var emailCont = TextEditingController();
  var passwordCont = TextEditingController();
  final formKey = GlobalKey<FormState>();


  bool isInProgress = false;

  @override
  void initState() {
    super.initState();
    _checkUserLoginOrNot();
    emailCont = TextEditingController();
    passwordCont = TextEditingController();
  }


  _handleLogin() async {
    String email = emailCont.text;
    String password = passwordCont.text;


    if (email.isEmpty) {
      toasty(context,'Please fill email');
    } else if (Validator.isEmail(email)) {
      toasty(context,'Please fill email proper');
    } else if (password.isEmpty) {
      toasty(context,'Please fill password');
    } else {

      setState(() {
        isInProgress = true;
      });

      MyResponse response =  await AuthController.loginUser(email, password);

      setState(() {
        isInProgress = false;
      });

      if(response.success){
        Provider.of<OrdersProvider>(context,listen: false).isLoggedIn = true;
        ShHomeScreen().launch(context);
      }else {
        // ApiUtil.checkRedirectNavigation(context, response.responseCode);
        toasty(context,'${response.errorText}');
      }

    }
  }


  _checkUserLoginOrNot() async {

    setState(() {
      isInProgress = true;
    });
    if(await AuthController.isLoginUser()){
      Provider.of<OrdersProvider>(context,listen: false).isLoggedIn = true;
      ShHomeScreen().launch(context);
    }

    setState(() {
      isInProgress = false;
    });
  }

  @override
  void dispose() {
    emailCont.dispose();
    passwordCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: isInProgress
          ? Center(child: CircularProgressIndicator()) //loading widget goes here
          :Container(
            height: height,
            color: sh_background_color,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
              SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      ic_app_icon,
                      width: width * 0.22,
                    ),
                    SizedBox(
                      height: spacing_xlarge,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      controller: emailCont,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(color: sh_textColorPrimary, fontFamily: fontRegular, fontSize: textSizeMedium),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: sh_editText_background,
                          focusColor: sh_editText_background_active,
                          hintText: sh_hint_Email,
                          hintStyle: TextStyle(color: sh_textColorSecondary, fontFamily: fontRegular, fontSize: textSizeMedium),
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: sh_colorPrimary, width: 0.5)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.transparent, style: BorderStyle.none, width: 0))),
                    ),
                    SizedBox(
                      height: spacing_standard_new,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      obscureText: true,
                      style: TextStyle(color: sh_textColorPrimary, fontFamily: fontRegular, fontSize: textSizeMedium),
                      controller: passwordCont,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: sh_editText_background,
                          focusColor: sh_editText_background_active,
                          hintStyle: TextStyle(color: sh_textColorSecondary, fontFamily: fontRegular, fontSize: textSizeMedium),
                          hintText: sh_hint_password,
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: sh_colorPrimary, width: 0.5)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.transparent, style: BorderStyle.none, width: 0))),
                    ),
                    SizedBox(
                      height: spacing_xlarge,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      // height: double.infinity,
                      child: MaterialButton(
                        padding: EdgeInsets.all(spacing_standard),
                        child: text(sh_lbl_sign_in, fontSize: textSizeNormal, fontFamily: fontMedium, textColor: sh_white),
                        textColor: sh_white,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
                        color: sh_colorPrimary,
                        onPressed: () async{
                          // ShHomeScreen().launch(context),
                          await _handleLogin();
                        },
                      ),
                    ),
                    SizedBox(height: spacing_standard_new),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      // height: double.infinity,
                      child: MaterialButton(
                        padding: EdgeInsets.all(spacing_standard),
                        child: text(sh_lbl_sign_up, fontSize: textSizeNormal, fontFamily: fontMedium, textColor: sh_colorPrimary),
                        textColor: sh_white,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0), side: BorderSide(color: sh_colorPrimary, width: 1)),
                        color: sh_white,
                        onPressed: () => {ShSignUp().launch(context)},
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


}
