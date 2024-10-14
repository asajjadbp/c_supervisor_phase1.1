
import 'package:c_supervisor/provider/license_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Screens/license/license.dart';
import 'Screens/splash/splash_screen.dart';
import 'Screens/utills/app_colors_new.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: LicenseProvider())],
      child: Consumer<LicenseProvider>(builder: (context, auth, _) {
        return MaterialApp(
            title: 'C-Supervisor',
            theme: ThemeData(
              primaryColor: AppColors.primaryColor,
              appBarTheme: const AppBarTheme(color: AppColors.primaryColor),
              indicatorColor: AppColors.primaryColor,
              cardColor: Colors.white
            ),
            debugShowCheckedModeBanner: false,
            home: auth.isLicenseGet
                ? const SplashScreen()
                : FutureBuilder(
                    future: auth.fetchLicenseAtLocal(),
                    builder: (ctx, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? Scaffold(
                              body: Container(
                                child: const Center(child: Text("Please wait...")),
                              ),
                            )
                          : const MyLicense();
                    })

            );
      }),
    );
  }
}
