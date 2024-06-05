import 'package:flutter/material.dart';
import 'package:water_report/Controllers/auth_controller.dart';
import '../Configs/constant.dart';
import '../Configs/router.dart';


class SplashScreen extends StatelessWidget {

  final AuthController authController = AuthController();

  SplashScreen({super.key});


  @override
  Widget build(BuildContext context) {
    _checkLoginStatus(context);

    return Container(
      color: Colors.white,
      child: const Center(
        child: Image(
          image: AssetImage(imageLogo),
          width: 250,
        ),
      ),
    );
  }

  void _checkLoginStatus(BuildContext context) async {

    bool checkToken = await authController.checkToken();
    print(checkToken);
    if (!context.mounted) return;
    if (checkToken) {
      await authController.getMeasuringPoint();
      if (!context.mounted) return;

      Navigator.pushNamedAndRemoveUntil(context, RouteApp.home, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, RouteApp.login, (route) => false);
    }
  }

}


// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//     _checkAuthStatus();
//   }
//
//   Future<void> _checkAuthStatus() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     await authProvider.checkToken();
//     if (!context.mounted) return;
//
//     if (authProvider.token == null) {
//       Navigator.pushNamedAndRemoveUntil(context, RouteApp.login, (route) => false);
//       return;
//     }
//
//     Navigator.pushNamedAndRemoveUntil(context, RouteApp.home, (route) => false);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: const Center(
//         child: Image(
//           image: AssetImage(imageLogo),
//           width: 250,
//         ),
//       ),
//     );
//   }
// }