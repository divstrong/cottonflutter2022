
// import 'package:cotton_natural/main/utils/common.dart';
// import 'package:cotton_natural/shopHop/api/MyResponse.dart';
// import 'package:cotton_natural/shopHop/controllers/AuthController.dart';
// import 'package:cotton_natural/shopHop/controllers/WishController.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:cotton_natural/main/utils/AppWidget.dart';
// import 'package:cotton_natural/shopHop/models/ShProduct.dart';
// import 'package:cotton_natural/shopHop/utils/ShColors.dart';
// import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
// import 'package:cotton_natural/shopHop/utils/ShStrings.dart';
// import 'package:flutter_wp_woocommerce/models/products.dart';
// import 'package:nb_utils/nb_utils.dart';

// import 'ShProductDetail.dart';

// class ShWishlistFragment extends StatefulWidget {
//   static String tag = '/ShProfileFragment';

//   @override
//   ShWishlistFragmentState createState() => ShWishlistFragmentState();
// }

// class ShWishlistFragmentState extends State<ShWishlistFragment> {
//   List<WooProduct> list = [];
//   bool isLoadingMoreData = false;


//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   fetchData() async {
//     isLoadingMoreData = true;
//     if(await AuthController.isLoginUser()) {

//       List<WooProduct>? products;
//       MyResponse<List<WooProduct>> myResponse = await WishController
//           .getWishProducts();

//       if (myResponse.success) {
//         products = myResponse.data;
//       } else {
//         toasty(context, myResponse.errorText);
//       }

//       setState(() {
//         list.clear();
//         list.addAll(products!);
//         isLoadingMoreData = false;
//       });
//     }
//     else{
//       setState(() {
//         isLoadingMoreData = false;
//       });
//     }
//   }
  
//   _removeFromWish(int? productId) async{

//     MyResponse myResponse = await WishController.removeWish(productId);

//     if (myResponse.success) {
//       toasty(context, myResponse.data);
//     } else {
//       toasty(context, myResponse.errorText);
//     }

//     setState(() {
//       list.removeWhere((element) {
//         return element.id == productId;
//       });
//     });
//   }

//   @override
//   void setState(fn) {
//     if (mounted) super.setState(fn);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: (isLoadingMoreData)?Container():(list.length > 0)
//           ? ListView.builder(
//               scrollDirection: Axis.vertical,
//               physics:BouncingScrollPhysics(),
//               itemCount: list.length,
//               shrinkWrap: true,
//               padding: EdgeInsets.only(bottom: 70),
//               itemBuilder: (context, index) {
//                 return Container(
//                   color: sh_itemText_background,
//                   margin: EdgeInsets.only(
//                       left: spacing_standard_new,
//                       right: spacing_standard_new,
//                       top: spacing_standard_new),
//                   child: IntrinsicHeight(
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: <Widget>[
//                         InkWell(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         ShProductDetail(product: list[index])));
//                           },
//                           child: networkCachedImage(
//                             list[index].images![0],
//                             aWidth: width * 0.25,
//                             aHeight: width * 0.3,
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                         Expanded(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               SizedBox(
//                                 height: spacing_standard,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 16.0),
//                                 child: text(list[index].name,
//                                     textColor: sh_textColorPrimary,
//                                     fontSize: textSizeLargeMedium,
//                                     fontFamily: fontMedium),
//                               ),
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(bottom: 12),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: <Widget>[
//                                       Expanded(
//                                         child: Row(
//                                           children: <Widget>[
//                                             // Icon(
//                                             //   Icons.add_shopping_cart,
//                                             //   color: sh_textColorPrimary,
//                                             //   size: 16,
//                                             // ),
//                                             // text(sh_lbl_move_to_cart,
//                                             //     textColor: sh_textColorPrimary,
//                                             //     fontSize: textSizeSMedium)
//                                           ],
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: InkWell(
//                                           onTap: () {
//                                             _removeFromWish(list[index].id);
//                                           },
//                                           child: Row(
//                                             children: <Widget>[
//                                               Icon(
//                                                 Icons.delete_outline,
//                                                 color: sh_textColorPrimary,
//                                                 size: 16,
//                                               ),
//                                               text(sh_lbl_remove,
//                                                   textColor:
//                                                       sh_textColorPrimary,
//                                                   fontSize: textSizeSMedium)
//                                             ],
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//                 // return Chats(mListings[index], index);
//               })
//           : Center(
//               child: Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(horizontal: 25),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Text(
//                       'Your wishlist is empty',
//                       style: TextStyle(
//                           color: sh_textColorPrimary,
//                           fontFamily: fontSemibold,
//                           fontSize: textSizeNormal),
//                     ),

//                     SizedBox(
//                       height: 80,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
