import 'package:flutter/material.dart';

class OnboardingLogo extends StatelessWidget {
  const OnboardingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/shelta_logo.png', height: 42),

        const SizedBox(width: 5.0),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SheltaMe', style: Theme.of(context).textTheme.titleLarge),
            Text(
              'Fine Home, Feel Safe',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
    );
  }
}
