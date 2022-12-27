import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/shopHop/controllers/AuthController.dart';
import 'package:cotton_natural/shopHop/models/Account.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShImages.dart';
import 'package:cotton_natural/shopHop/utils/ShStrings.dart';
import 'package:flutter/material.dart';

class ShProfileFragment extends StatefulWidget {
  static String tag = '/ShProfileFragment';

  @override
  ShProfileFragmentState createState() => ShProfileFragmentState();
}

class ShProfileFragmentState extends State<ShProfileFragment> {
  var nameCont = TextEditingController();
  var emailCont = TextEditingController();
  var phoneCont = TextEditingController();
  var passwordCont = TextEditingController();
  var confirmPasswordCont = TextEditingController();

  Account userAccount = Account(null, '', '', '');
  late bool isInProgress;

  @override
  void initState() {
    super.initState();
    isInProgress = false;
    _getUserAccount();
  }

  _getUserAccount() async {
    if (mounted) {
      setState(() {
        isInProgress = true;
      });
    }

    userAccount = await AuthController.getAccount();
    nameCont = TextEditingController(text: userAccount.name);
    emailCont = TextEditingController(text: userAccount.email);

    if (mounted) {
      setState(() {
        isInProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text(sh_lbl_account,
            textColor: sh_textColorPrimary,
            fontSize: textSizeNormal,
            fontFamily: fontMedium),
        iconTheme: IconThemeData(color: sh_textColorPrimary),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(spacing_standard_new),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(spacing_standard_new),
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: spacing_standard,
                        margin: EdgeInsets.all(spacing_control),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(ic_user),
                            radius: 55,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                autofocus: false,
                controller: nameCont,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(
                    color: sh_textColorPrimary,
                    fontFamily: fontRegular,
                    fontSize: textSizeMedium),
                decoration: InputDecoration(
                  filled: false,
                  hintText: sh_hint_first_name,
                  hintStyle: TextStyle(
                      color: sh_textColorSecondary,
                      fontFamily: fontRegular,
                      fontSize: textSizeMedium),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5), width: 0.5)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5), width: 0)),
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
                    fontSize: textSizeMedium),
                decoration: InputDecoration(
                  filled: false,
                  hintText: sh_hint_Email,
                  hintStyle: TextStyle(
                      color: sh_textColorSecondary,
                      fontFamily: fontRegular,
                      fontSize: textSizeMedium),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5), width: 0.5)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5), width: 0)),
                ),
              ),
              SizedBox(height: spacing_standard_new),
              TextFormField(
                keyboardType: TextInputType.text,
                autofocus: false,
                controller: phoneCont,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(
                    color: sh_textColorPrimary,
                    fontFamily: fontRegular,
                    fontSize: textSizeMedium),
                decoration: InputDecoration(
                  filled: false,
                  hintText: sh_hint_phone,
                  hintStyle: TextStyle(
                      color: sh_textColorSecondary,
                      fontFamily: fontRegular,
                      fontSize: textSizeMedium),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5), width: 0.5)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5), width: 0)),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                // height: double.infinity,
                child: MaterialButton(
                  padding: EdgeInsets.all(spacing_standard),
                  child: text(sh_lbl_save_profile,
                      fontSize: textSizeNormal,
                      fontFamily: fontMedium,
                      textColor: sh_white),
                  textColor: sh_white,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(40.0)),
                  color: sh_colorPrimary,
                  onPressed: () => {},
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
                  child: text(sh_lbl_change_pswd,
                      fontSize: textSizeNormal,
                      fontFamily: fontMedium,
                      textColor: sh_colorPrimary),
                  textColor: sh_white,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(40.0),
                      side: BorderSide(color: sh_colorPrimary, width: 1)),
                  color: sh_white,
                  onPressed: () => {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
