import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/main/utils/common.dart';
import 'package:cotton_natural/shopHop/controllers/AuthController.dart';
import 'package:cotton_natural/shopHop/models/ShReview.dart';
import 'package:cotton_natural/shopHop/providers/OrdersProvider.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShStrings.dart';
import 'package:cotton_natural/shopHop/utils/ShWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wp_woocommerce/woocommerce.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../controllers/ProductController.dart';

// ignore: must_be_immutable
class ShProductDetail extends StatefulWidget {
  static String tag = '/ShProductDetail';
  WooProduct? product;

  ShProductDetail({this.product});

  @override
  ShProductDetailState createState() => ShProductDetailState();
}

class ShProductDetailState extends State<ShProductDetail> {
  var position = 0;
  bool isExpanded = false;
  var selectedColor = -1;
  int selectedSize = -1;
  List<ShReview> list = [];
  bool autoValidate = false;
  TextEditingController controller = TextEditingController();
  bool isWished = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    changeStatusColor(Colors.white);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.transparent);

    var width = MediaQuery.of(context).size.width;

    var sliderImages = Container(
      // height: 380,
      constraints: BoxConstraints(
        minHeight: 380,
        maxHeight: 580,
      ),
      child: PageView.builder(
        itemCount: widget.product!.images.length,
        itemBuilder: (context, index) {
          return networkCachedImage(
            widget.product!.images[index].src,
            aWidth: width,
            aHeight: width * 1.05,
            fit: BoxFit.cover,
          );
        },
        onPageChanged: (index) {
          position = index;
          setState(() {});
        },
      ),
    );

    var productInfo = Padding(
      padding: EdgeInsets.all(14),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              text(
                widget.product!.name,
                textColor: sh_textColorPrimary,
                fontFamily: fontMedium,
                fontSize: textSizeXNormal,
              ),
            ],
          ),
          // SizedBox(height: spacing_standard),
        ],
      ),
    );

    // ToDo return Sizes
    var sizes = ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.product!.attributes[0].options?.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            selectedSize = index;
            setState(() {});
          },
          child: Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.only(right: spacing_control),
            // padding: EdgeInsets.all(spacing_control),
            decoration: selectedSize == index
                ? BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: sh_textColorPrimary, width: 0.5),
                    color: sh_colorPrimary,
                  )
                : BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: sh_textColorPrimary, width: 1),
                    // color: sh_colorPrimary,
                  ),
            child: Center(
              child: text(
                ProductController.getSizeTypeText(
                  widget.product!.attributes[0].options![index],
                ),
                textColor:
                    selectedSize == index ? sh_white : sh_textColorPrimary,
                fontSize: textSizeLargeMedium,
                fontFamily: fontMedium,
              ),
            ),
          ),
        );
      },
    );

    var descriptionTab = SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: spacing_standard_new),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                text(
                  parseHtmlString(widget.product!.description),
                  maxLine: 15,
                  // isLongText: isExpanded,
                  fontSize: 16.0,
                ),
              ],
            ),
            SizedBox(height: spacing_large),
            widget.product!.attributes[0].options!.isNotEmpty
                ? text(
                    sh_lbl_size,
                    textAllCaps: true,
                    textColor: sh_textColorPrimary,
                    fontFamily: fontMedium,
                    fontSize: textSizeLargeMedium,
                  )
                : SizedBox(),
            Container(
              height: 50,
              child: sizes,
            )
          ],
        ),
      ),
    );

    var bottomButtons = Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 50,
      color: sh_white,
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () async {
              if (Provider.of<OrdersProvider>(context, listen: false)
                      .isLoggedIn ==
                  false) {
                Provider.of<OrdersProvider>(context, listen: false).isLoggedIn =
                    await AuthController.isLoginUser();
              }
              if (selectedSize < 0) {
                toasty(context, 'Please Select A Size');
              } else {
                String? size =
                    widget.product!.attributes[0].options![selectedSize];
                Provider.of<OrdersProvider>(context, listen: false)
                    .addItemToBasket(product: widget.product, size: size);
                toasty(context, 'Product Added To Cart');
              }
            },
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 300,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: Offset(3, 1),
                  )
                ],
                color: widget.product!.attributes[0].options!.isNotEmpty &&
                        selectedSize < 0
                    ? Colors.grey
                    : sh_colorPrimary,
              ),
              child: text(
                sh_lbl_add_to_cart,
                textColor: sh_white,
                fontSize: textSizeLargeMedium,
                fontFamily: fontMedium,
              ),
              // color: sh_colorPrimary,
              alignment: Alignment.center,
              height: double.infinity,
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          DefaultTabController(
            length: 1,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                changeStatusColor(
                  innerBoxIsScrolled ? Colors.white : Colors.transparent,
                );
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 620,
                    floating: false,
                    pinned: true,
                    titleSpacing: 0,
                    backgroundColor: sh_white,
                    iconTheme: IconThemeData(color: sh_textColorPrimary),
                    actionsIconTheme: IconThemeData(color: sh_textColorPrimary),
                    actions: <Widget>[
                      cartIcon(
                        context,
                        Provider.of<OrdersProvider>(context, listen: true)
                            .getOrderCount(),
                      ),
                    ],
                    title: text(
                      innerBoxIsScrolled ? widget.product!.name : "",
                      textColor: sh_textColorPrimary,
                      fontSize: textSizeNormal,
                      fontFamily: fontMedium,
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        children: <Widget>[
                          sliderImages,
                          productInfo,
                        ],
                      ),
                      collapseMode: CollapseMode.pin,
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  descriptionTab,
                ],
              ),
            ),
          ),
          bottomButtons
        ],
      ),
    );
  }
}

// ignore: unused_element
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return new Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      color: sh_white,
      child: Container(child: _tabBar),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
