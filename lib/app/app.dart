import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_prompts/routes/app_routes.dart';

import '../controllers/network_controller.dart';
import '../core/theme/app_theme.dart';
import '../routes/app_pages.dart';
import '../core/utils/app_bindings.dart';

class App extends StatelessWidget {
  const App({super.key, required this.firebaseReady});

  final bool firebaseReady;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chitra AI',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      initialBinding: AppBindings(firebaseReady: firebaseReady),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      builder: (context, child) {
        final body = child ?? const SizedBox.shrink();
        if (!Get.isRegistered<NetworkController>()) {
          return body;
        }
        final network = Get.find<NetworkController>();
        return Obx(() {
          if (network.isOnline.value) return body;
          return Scaffold(
            body: Stack(
              children: [
                body,
                Positioned.fill(
                  child: ColoredBox(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.wifi_off_rounded, size: 56),
                            const SizedBox(height: 12),
                            Text(
                              'No Internet Connection',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Please turn on internet and tap retry.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: network.refreshStatus,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
