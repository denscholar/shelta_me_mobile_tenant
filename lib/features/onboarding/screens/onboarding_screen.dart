import 'package:flutter/material.dart';
import 'package:sheltame_tenant_app/core/widgets/primary_button.dart';
import 'package:sheltame_tenant_app/features/onboarding/data/onboarding_data.dart';
import 'package:sheltame_tenant_app/features/onboarding/services/onboarding_storage.dart';
import 'package:sheltame_tenant_app/features/onboarding/widgets/onboarding_logo.dart';
import 'package:sheltame_tenant_app/features/onboarding/widgets/onboarding_page.dart';
import 'package:sheltame_tenant_app/features/onboarding/widgets/page_indicator.dart';

import 'package:go_router/go_router.dart';
import 'package:sheltame_tenant_app/routes/app_route_names.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int currentIndex = 0;

  Future<void> _completeOnboarding() async {
    await OnboardingStorage.markAsSeen();

    if (!mounted) return;

    context.goNamed(AppRouteNames.login);
  }

  void _handleContinue() {
    final isLastPage = currentIndex == onboardingItems.length - 1;

    if (isLastPage) {
      _completeOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentIndex == onboardingItems.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // const SizedBox(height: 20),
              const OnboardingLogo(),
              const SizedBox(height: 28),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,

                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },

                  itemCount: onboardingItems.length,

                  itemBuilder: (context, index) {
                    return OnboardingPage(
                      item: onboardingItems[index],
                      index: index,
                    );
                  },
                ),
              ),

              OnboardingIndicator(
                currentIndex: currentIndex,
                total: onboardingItems.length,
              ),

              const SizedBox(height: 20),

              PrimaryButton(
                // label: currentIndex == 2 ? 'Get Started' : 'Continue',
                label: isLastPage ? 'Get Started' : 'Continue',

                trailing: const Icon(Icons.arrow_forward, color: Colors.white),

                onPressed: _handleContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
