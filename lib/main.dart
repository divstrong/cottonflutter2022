import 'package:cotton_natural/main/utils/AppTheme.dart';
import 'package:cotton_natural/shopHop/models/ShAddress.dart';
import 'package:cotton_natural/shopHop/providers/OrdersProvider.dart';
import 'package:cotton_natural/shopHop/screens/ShSplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'main/store/AppStore.dart';
import 'shopHop/utils/ShStrings.dart';

AppStore appStore = AppStore();

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ShAddressModelAdapter());

  await Hive.openBox(sh_cached_data);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ShSplashScreen(),
        theme: !appStore.isDarkModeOn
            ? AppThemeData.lightTheme
            : AppThemeData.darkTheme,
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguageCode),
      ),
    );
  }
}
