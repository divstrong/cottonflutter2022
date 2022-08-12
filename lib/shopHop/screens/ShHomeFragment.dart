import 'package:cotton_natural/shopHop/api/MyResponse.dart';
import 'package:cotton_natural/shopHop/controllers/CategoryController.dart';
import 'package:cotton_natural/shopHop/utils/ColorUtils.dart';
import 'package:cotton_natural/shopHop/utils/ShExtension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/shopHop/models/ShCategory.dart';
import 'package:cotton_natural/shopHop/models/ShProduct.dart';
import 'package:cotton_natural/shopHop/screens/ShSubCategory.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';

class ShHomeFragment extends StatefulWidget {
  static String tag = '/ShHomeFragment';

  @override
  ShHomeFragmentState createState() => ShHomeFragmentState();
}

class ShHomeFragmentState extends State<ShHomeFragment> {
  List<ShCategory> list = [];
  List<ShProduct> newestProducts = [];
  List<ShProduct> featuredProducts = [];
  var position = 0;
  var colors = [sh_cat_1, sh_cat_2, sh_cat_3, sh_cat_4, sh_cat_5];

  //todo
  ShCategory menCategory = ShCategory(
    id: 45,
    name: 'Men',
    slug: 'men',
  );
  ShCategory womenCategory = ShCategory(
    id: 18,
    name: 'Women',
    slug: 'women',
  );

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {


    MyResponse<List<ShCategory>> myResponse = await CategoryController.getMainCategories();

    if (myResponse.success) {
      list.clear();
      list = myResponse.data;

    } else {
      toasty(context, myResponse.errorText);
    }
    setState(() { });

    List<ShProduct> products = await loadProducts();
    List<ShProduct> featured = [];
    products.forEach((product) {
      if (product.featured==1) {
        featured.add(product);
      }
    });


    setState(() {
      newestProducts.clear();
      featuredProducts.clear();
      newestProducts.addAll(products);
      featuredProducts.addAll(featured);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.width;

    return Scaffold(
      body: newestProducts.isNotEmpty
          ? SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(bottom: 30),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: height * 0.55,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Image.asset('images/shophop/bg-home.jpg',fit: BoxFit.fitWidth,)
                        ],
                      ),
                    ),
                    Container(
                      height: 80,
                      margin: EdgeInsets.only(top: spacing_standard_new),
                      alignment: Alignment.topLeft,
                      child: ListView.builder(
                        itemCount: list.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: spacing_standard, right: spacing_standard),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ShSubCategory(category: list[index])));
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: spacing_standard, right: spacing_standard),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(spacing_middle),
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: sh_textColorPrimary),
                                    child: Image.asset('images/shophop/cat/${list[index].slug}.png', width: 25, color: sh_white),
                                  ),
                                  SizedBox(height: spacing_control),
                                  text(list[index].name, textColor:  sh_textColorPrimary, fontFamily: fontMedium)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 250,
                      margin: EdgeInsets.only(top: spacing_standard_new),
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                      child: InkWell(
                        onTap: (){
                          ShSubCategory(category: womenCategory).launch(context);
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: Image.asset('images/shophop/for-her.jpg',fit: BoxFit.fitWidth,),
                            ),
                            Positioned(
                              child: text('Hers', textColor:  sh_textColorPrimary, fontFamily: fontMedium),
                              bottom: 10,
                              left: 10,
                            )
                          ]
                        ),
                      ),
                    ),
                    Container(
                      height: 250,
                      margin: EdgeInsets.only(top: spacing_standard_new),
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                      child: InkWell(
                        onTap: (){
                          ShSubCategory(category: menCategory).launch(context);
                        },
                        child: Stack(
                          children:[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: Image.asset('images/shophop/for-him.jpg',fit: BoxFit.fitWidth,),
                            ),
                            Positioned(
                              child: text('His', textColor:  sh_textColorPrimary, fontFamily: fontMedium),
                              bottom: 10,
                              left: 10,
                            )
                          ] ,
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}
