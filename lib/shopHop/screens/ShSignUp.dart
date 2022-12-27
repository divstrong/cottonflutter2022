import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/shopHop/api/MyResponse.dart';
import 'package:cotton_natural/shopHop/controllers/AuthController.dart';
import 'package:cotton_natural/shopHop/screens/ShSignIn.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShImages.dart';
import 'package:cotton_natural/shopHop/utils/ShStrings.dart';
import 'package:cotton_natural/shopHop/utils/Validator.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ShSignUp extends StatefulWidget {
  static String tag = '/ShSignUp';

  @override
  ShSignUpState createState() => ShSignUpState();
}

class ShSignUpState extends State<ShSignUp> {
  var nameCont = TextEditingController();
  var emailCont = TextEditingController();
  var passwordCont = TextEditingController();
  var confirmPasswordCont = TextEditingController();
  bool isInProgress = false;

  bool validateInputs() {
    if (nameCont.text.trim() == '') {
      toasty(context, 'name is empty');
      return false;
    } else if (emailCont.text.trim() == '') {
      toasty(context, 'email is empty');
      return false;
    } else if (passwordCont.text.trim() == '') {
      toasty(context, 'password is empty');
      return false;
    } else if (passwordCont.text.trim().length < 4) {
      toasty(context, 'password must be more than 4 character');
      return false;
    } else if (passwordCont.text.trim() != confirmPasswordCont.text.trim()) {
      toasty(context, 'Password and confirm password are not match');
      return false;
    } else if (Validator.isEmail(emailCont.text.trim())) {
      toasty(context, 'wrong email format');
      return false;
    }
    return true;
  }

  registerUser() async {
    setState(() {
      isInProgress = true;
    });

    MyResponse myResponse = await AuthController.registerUser(
      nameCont.text.trim(),
      emailCont.text.trim(),
      passwordCont.text.trim(),
    );

    setState(() {
      isInProgress = false;
    });

    if (myResponse.success) {
      toasty(context, 'user successfully created');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ShSignIn(),
        ),
      );
    } else {
      myResponse.errors.forEach((element) {
        toasty(context, element);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          color: sh_background_color,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Padding(
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
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              autofocus: false,
                              controller: nameCont,
                              textCapitalization: TextCapitalization.words,
                              style: TextStyle(
                                color: sh_textColorPrimary,
                                fontFamily: fontRegular,
                                fontSize: textSizeMedium,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: sh_editText_background,
                                focusColor: sh_editText_background_active,
                                hintText: sh_hint_first_name,
                                hintStyle: TextStyle(
                                  color: sh_textColorSecondary,
                                  fontFamily: fontRegular,
                                  fontSize: textSizeMedium,
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                  borderSide: BorderSide(
                                    color: sh_colorPrimary,
                                    width: 0.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    style: BorderStyle.none,
                                    width: 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: spacing_standard_new,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      controller: emailCont,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                        color: sh_textColorPrimary,
                        fontFamily: fontRegular,
                        fontSize: textSizeMedium,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: sh_editText_background,
                        focusColor: sh_editText_background_active,
                        hintText: sh_hint_Email,
                        hintStyle: TextStyle(
                          color: sh_textColorSecondary,
                          fontFamily: fontRegular,
                          fontSize: textSizeMedium,
                        ),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide:
                              BorderSide(color: sh_colorPrimary, width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            style: BorderStyle.none,
                            width: 0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: spacing_standard_new,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      obscureText: true,
                      style: TextStyle(
                        color: sh_textColorPrimary,
                        fontFamily: fontRegular,
                        fontSize: textSizeMedium,
                      ),
                      controller: passwordCont,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: sh_editText_background,
                        focusColor: sh_editText_background_active,
                        hintStyle: TextStyle(
                          color: sh_textColorSecondary,
                          fontFamily: fontRegular,
                          fontSize: textSizeMedium,
                        ),
                        hintText: sh_hint_password,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide:
                              BorderSide(color: sh_colorPrimary, width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            style: BorderStyle.none,
                            width: 0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: spacing_standard_new,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      obscureText: true,
                      style: TextStyle(
                        color: sh_textColorPrimary,
                        fontFamily: fontRegular,
                        fontSize: textSizeMedium,
                      ),
                      controller: confirmPasswordCont,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: sh_editText_background,
                        focusColor: sh_editText_background_active,
                        hintStyle: TextStyle(
                          color: sh_textColorSecondary,
                          fontFamily: fontRegular,
                          fontSize: textSizeMedium,
                        ),
                        hintText: sh_hint_confirm_password,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide:
                              BorderSide(color: sh_colorPrimary, width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            style: BorderStyle.none,
                            width: 0,
                          ),
                        ),
                      ),
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
                        child: text(
                          sh_lbl_sign_up,
                          fontSize: textSizeNormal,
                          fontFamily: fontMedium,
                          textColor: sh_white,
                        ),
                        textColor: sh_white,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(40.0),
                        ),
                        color: sh_colorPrimary,
                        onPressed: () async {
                          if (validateInputs()) {
                            await registerUser();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: spacing_standard_new,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      // height: double.infinity,
                      child: MaterialButton(
                        padding: EdgeInsets.all(spacing_standard),
                        child: text(
                          sh_lbl_sign_in,
                          fontSize: textSizeNormal,
                          fontFamily: fontMedium,
                          textColor: sh_colorPrimary,
                        ),
                        textColor: sh_white,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(40.0),
                          side: BorderSide(color: sh_colorPrimary, width: 1),
                        ),
                        color: sh_white,
                        onPressed: () => {finish(context)},
                      ),
                    )
                  ],
                ),
              ),
              isInProgress
                  ? Center(
                      child: CircularProgressIndicator(),
                    ) //loading widget goes here
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
