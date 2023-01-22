import 'package:cotton_natural/main.dart' as app;
import 'package:cotton_natural/main.dart';
import 'package:cotton_natural/main/utils/AppConstant.dart';
import 'package:cotton_natural/main/utils/AppTheme.dart';
import 'package:cotton_natural/shopHop/controllers/CategoryController.dart';
import 'package:cotton_natural/shopHop/controllers/ProductController.dart';
import 'package:cotton_natural/shopHop/providers/OrdersProvider.dart';
import 'package:cotton_natural/shopHop/screens/ShHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  await app.initPrefs();

  group(
    'Test Home Screen',
        () {
      testWidgets(
        'Given the app is on home screen '
            'when user starts the app '
            'then app shows the first screen',
            (tester) async {
          await tester.pumpWidget(
            getMaterialAppChild(home: ShHomeScreen()),
          );

          expect(find.byKey(keyHomeAppBar), findsOneWidget);
        },
      );
    },
  );
}

Widget getMaterialAppChild({required Widget home}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => OrdersProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => CategoryController(),
      ),
      ChangeNotifierProvider(
        create: (_) => ProductController(),
      ),
    ],
    child: Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: home,
        theme: !appStore.isDarkModeOn
            ? AppThemeData.lightTheme
            : AppThemeData.darkTheme,
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguageCode),
      ),
    ),
  );
}
