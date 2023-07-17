import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoapp/ui/pages/about.dart';
import '../../providers/export_providers.dart';

class BackLayerPage extends StatelessWidget {
  const BackLayerPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: Theme.of(context).colorScheme.secondary, width: 2)
            // color: Theme.of(context).primaryColor,
            ),
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: ListView(
          shrinkWrap: true,
          children: [
            Consumer(
              builder: (context, ref, _) {
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  activeColor: Colors.white,
                  secondary: const Icon(CarbonIcons.asleep),
                  value: ref.watch(isDarkProvider).getTheme(),
                  onChanged: (bool value) {
                    ref.read(isDarkProvider.notifier).toggleTheme();
                  },
                );
              },
            ),

            ListTile(
              focusColor: Colors.red,
              leading: const Icon(CarbonIcons.information),
              title: const Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const About(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
