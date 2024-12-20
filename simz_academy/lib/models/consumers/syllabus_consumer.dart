import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simz_academy/views/UIHelper/home_ui_helper.dart';
import 'package:simz_academy/models/providers/syllabus_provider.dart';

import '../../controllers/functions/show_alert.dart';

/// A consumer widget that displays the syllabus data fetched from the [syllabusProvider].
///
/// This widget uses the [ConsumerWidget] from Riverpod to watch the [syllabusProvider]
/// and rebuild the UI when the data changes.
///
/// Example:
/// ```dart
/// SyllabusConsumer();
/// ```
class SyllabusConsumer extends ConsumerWidget {
  const SyllabusConsumer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watch the [syllabusProvider] and get the async value.
    final syllabusAsyncValue = ref.watch(syllabusProvider);

    return Scaffold(
      body: Center(
        child: syllabusAsyncValue.when(
          /// When the data is available, display the syllabus list.
          data: (syllabus) {
            if (syllabus.isEmpty) {
              return Text("No Data");
            }
            return ListView.builder(
              itemCount: syllabus.length,
              itemBuilder: (context, index) {
                final s = syllabus[index];
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, bottom: 4.0, left: 12, right: 12),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(196, 220, 243, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                          'lib/assets/images/keys_illustration.png'),
                      title: HomeUiHelper().customText('${s['name']}', 24,
                          FontWeight.w700, Color.fromRGBO(27, 71, 113, 1)),
                      trailing: InkWell(
                        onTap: () {
                          showAlertBox(context, '${s['url']}');  // showAlertBox is a custom function
                        },
                        child: HomeUiHelper().customText('Get', 20,
                            FontWeight.w600, Color.fromRGBO(27, 71, 113, 1)),
                      ),
                    ),
                  ),
                );
              },
            );
          },

          /// When an error occurs, display the error message.
          error: (error, stack) => Text('Error: $error'),

          /// When the data is loading, display a circular progress indicator.
          loading: () => CircularProgressIndicator(),
        ),
      ),
    );
  }
}
