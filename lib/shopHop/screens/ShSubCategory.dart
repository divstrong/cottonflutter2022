import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/shopHop/controllers/CategoryController.dart';
import 'package:cotton_natural/shopHop/controllers/ProductController.dart';
import 'package:cotton_natural/shopHop/screens/ShSearchScreen.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wp_woocommerce/woocommerce.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'ShViewAllProducts.dart';

// ignore: must_be_immutable
class ShSubCategory extends StatefulWidget {
  static String tag = '/ShSubCategory';
  WooProductCategory? category;

  ShSubCategory({this.category});

  @override
  ShSubCategoryState createState() => ShSubCategoryState();
}

class ShSubCategoryState extends State<ShSubCategory> {
  late WooProductCategory? category = widget.category;
  List<WooProductCategory> subCategoryList = [];

  Map<int, List<WooProduct>> subCatWooProducts = {};
  String subCatSlug = 'all';
  int limit = 10;

  bool isBusy = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    isBusy = true;
    setState(() {});

    subCategoryList = Provider.of<CategoryController>(context, listen: false)
        .fetchSubCategory(category!.id);

    subCatWooProducts =
        await Provider.of<ProductController>(context, listen: false)
            .getCategoryProducts(subCategoryList: subCategoryList);

    isBusy = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              ShSearchScreen().launch(context);
            },
          )
        ],
        title: text(
          widget.category!.name,
          textColor: sh_textColorPrimary,
          fontFamily: fontBold,
          fontSize: textSizeNormal,
        ),
      ),
      body: (isBusy)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 150.0,
                    margin: EdgeInsets.only(top: spacing_standard_new),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.topLeft,
                    child: ListView.builder(
                      itemCount: subCategoryList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(
                        left: spacing_standard,
                        right: spacing_standard,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShViewAllProductScreen(
                                  subCatId: subCategoryList[index].id,
                                  subCatName: subCategoryList[index].name,
                                  mProductModel: subCatWooProducts[
                                      subCategoryList[index].id]!,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: spacing_standard,
                              right: spacing_standard,
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(spacing_middle),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    'images/shophop/sub_cat/${widget.category!.slug}/${subCategoryList[index].slug}.png',
                                    width: 60,
                                  ),
                                ),
                                SizedBox(height: spacing_control),
                                text(
                                  subCategoryList[index].name,
                                  textColor: Colors.black87,
                                  fontFamily: fontMedium,
                                )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            for (int i = 0; i < subCategoryList.length; i++) ...{
              horizontalHeading(
                subCategoryList[i].name,
                callback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShViewAllProductScreen(
                        subCatId: subCategoryList[i].id,
                        subCatName: subCategoryList[i].name,
                        mProductModel:
                            subCatWooProducts[subCategoryList[i].id]!,
                      ),
                    ),
                  );
                },
              ),
              ProductHorizontalList(subCatWooProducts[subCategoryList[i].id]!),
              SizedBox(height: spacing_xlarge),
            }
          ],
        ),
      ),
    );
  }
}
