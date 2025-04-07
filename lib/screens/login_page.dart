import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/authentication_controller.dart';
import '../controllers/loading_controller.dart';
import '../widgets/loading_widget.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final authenticationController = Get.put(AuthenticationController());
  final loadingController = Get.put(LoadingController());

  static const accentColor = Color(0xFFF5C518);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient and wave
          Container(
            decoration: const BoxDecoration(
              color: accentColor,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 300),
              painter: WavePainter(color: Colors.black.withOpacity(0.05)),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 300),
              painter: WavePainter(color: Colors.black.withOpacity(0.03)),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 1),
                  // Title and Subtitle
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Clubs&\nEvents.',
                        style: TextStyle(
                          fontSize: 48,
                          height: 1.1,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Find all clubs and events in\none place.',
                        style: TextStyle(
                          fontSize: 20,
                          height: 1.3,
                          color: Colors.black.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  const Spacer(flex: 2),
                  // Login Section
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'You can login using your Google\naccount to continue',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.3,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        // Google Sign In Button
                        InkWell(
                          onTap: () async {
                            loadingController.toggleLoading();
                            final result = await authenticationController.authenticate(context);
                            loadingController.toggleLoading();
                            result['status'] == 'error'
                                ? CustomSnackBar.show(context,
                                    message: result['message'], color: Colors.red)
                                : CustomSnackBar.show(context,
                                    message: result['message'], color: Colors.green);
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.55,
                            ),
                            child: Image.asset(
                              'assets/android_light_rd_ctn@4x.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
          
          // Loading Overlay
          Obx(() {
            return loadingController.isLoading.value
                ? LoadingWidget()
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final Color color;

  WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Starting point
    path.moveTo(0, size.height * 0.3);
    
    // First wave
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.3,
    );
    
    // Second wave
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.4,
      size.width,
      size.height * 0.3,
    );
    
    // Third wave (smaller)
    path.lineTo(size.width, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.45,
      size.width * 0.5,
      size.height * 0.5,
    );
    
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.55,
      0,
      size.height * 0.5,
    );
    
    // Complete the path
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
