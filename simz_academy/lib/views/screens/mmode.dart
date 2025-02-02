import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Model class for the 'live' table
class MLive {
  final int id;
  final String createdAt;
  final String liveClass;
  final String mentor;
  final String course;
  final String dayOfThat;

  MLive({
    required this.id,
    required this.createdAt,
    required this.liveClass,
    required this.mentor,
    required this.course,
    required this.dayOfThat,
  });

  factory MLive.fromJson(Map<String, dynamic> json) {
    return MLive(
      id: json['id'],
      createdAt: json['created_at'],
      liveClass: json['live_class'],
      mentor: json['mentor'],
      course: json['course'],
      dayOfThat: json['day_of_that'],
    );
  }
}

class MMode extends StatefulWidget {
  const MMode({super.key});

  @override
  State<MMode> createState() => _MModeState();
}

class _MModeState extends State<MMode> {
  bool isSwitched = false;
  final mModeController = TextEditingController();
  List<MLive> classes = [];
  bool isLoading = true;

  // Get Supabase client instance
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    loadLiveClasses();
  }

  Future<void> loadLiveClasses() async {
    try {
      final response = await supabase
          .from('live')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        classes = (response as List)
            .map((data) => MLive.fromJson(data))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading live classes: $e');
      setState(() {
        isLoading = false;
      });
      // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    mModeController.clear();
    return Scaffold(
      backgroundColor: const Color(0xffE8E0C4),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            isSwitched
                ? showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: mModeController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              if (mModeController.text
                                  .toString()
                                  .toLowerCase() ==
                                  'mischief managed') {
                                setState(() {
                                  isSwitched = false;
                                });
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            },
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  );
                })
                : Navigator.pop(context);
          },
        ),
        title: isSwitched
            ? const Text(
          'Marauders Mode',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        )
            : const Text(''),
        backgroundColor: const Color(0xffE8E0C4),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isSwitched)
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'All classes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                      itemCount: classes.length,
                      itemBuilder: (context, index) {
                        final liveClass = classes[index];
                        return Card(
                          color: const Color(0xffFDF5E6),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Class: ${liveClass.liveClass}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Mentor: ${liveClass.mentor}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Course: ${liveClass.course}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Date: ${liveClass.dayOfThat}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: mModeController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (mModeController.text
                            .toString()
                            .toLowerCase() ==
                            'i solemnly swear that i am up to no good') {
                          setState(() {
                            isSwitched = true;
                          });
                        }
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}