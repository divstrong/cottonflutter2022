
import 'package:cotton_natural/shopHop/api/MyResponse.dart';
import 'package:cotton_natural/shopHop/controllers/CategoryController.dart';
import 'package:cotton_natural/shopHop/controllers/ProductController.dart';
import 'package:cotton_natural/shopHop/screens/ShSearchScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotton_natural/shopHop/models/ShCategory.dart';
import 'package:cotton_natural/shopHop/models/ShProduct.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShWidget.dart';
import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';

import 'ShViewAllProducts.dart';

// ignore: must_be_immutable
class ShSubCategory extends StatefulWidget {
  static String tag = '/ShSubCategory';
  ShCategory? category;

  ShSubCategory({this.category});

  @override
  ShSubCategoryState createState() => ShSubCategoryState();
}

class ShSubCategoryState extends State<ShSubCategory> {

  List<ShCategory> list = [];
  Map<String,List<ShProduct>> subCatProducts = {};
  String subCatSlug = 'all';
  int limit = 10;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {


    MyResponse<List<ShCategory>> myResponse = await CategoryController.getSubCategory(widget.category!.slug);
    if (myResponse.success) {
      list.clear();
      list = myResponse.data;
    } else {
      toasty(context, myResponse.errorText);
    }


    MyResponse<Map<String,List<ShProduct>>> myResponse2 = await ProductController.getSubCatProduct(widget.category!.slug,subCatSlug,limit);
    if (myResponse2.success) {
      subCatProducts.clear();
      subCatProducts = myResponse2.data;
    } else {
      toasty(context, myResponse2.errorText);
    }
    setState(() { });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        actions: <Widget>[IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            ShSearchScreen().launch(context);
          },
        )],
        title: text(widget.category!.name, textColor: sh_textColorPrimary, fontFamily: fontBold, fontSize: textSizeNormal),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Container(
              height: 120,
              margin: EdgeInsets.only(top: spacing_standard_new),
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.topLeft,
              child: ListView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: spacing_standard, right: spacing_standard),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShViewAllProductScreen(
                            mainCat: widget.category!.slug,
                            subCatSlug: list[index].slug,
                            subCatName: list[index].name,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: spacing_standard, right: spacing_standard),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(spacing_middle),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black87),
                            child: Image.asset('images/shophop/sub_cat/${widget.category!.slug}/${list[index].slug}.png', width: 25, color: sh_white),
                          ),
                          SizedBox(height: spacing_control),
                          text(list[index].name, textColor: Colors.black87, fontFamily: fontMedium)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),


            for(int i = 0 ; i < list.length ; i++)...{
              horizontalHeading(
                list[i].name,
                callback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShViewAllProductScreen(
                        mainCat: widget.category!.slug,
                        subCatSlug: list[i].slug,
                        subCatName: list[i].name,
                      ),
                    ),
                  );
                }
              ),
              ProductHorizontalList(subCatProducts[list[i].slug]!),
              SizedBox(height: spacing_standard_new),
            }


          ],
        ),
      ),
    );
  }

}
