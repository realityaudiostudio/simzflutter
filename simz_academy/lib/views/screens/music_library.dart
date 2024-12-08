import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../UIHelper/home_ui_helper.dart';
import 'bottom_nav.dart';

class TestSearchScreen extends StatefulWidget {
  const TestSearchScreen({super.key});

  @override
  State<TestSearchScreen> createState() => _TestSearchScreenState();
}

class _TestSearchScreenState extends State<TestSearchScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _videoData = [];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _fetchVideos();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
      _fetchVideos();
    });
  }

  Future<void> _fetchVideos() async {
    try {
      final response = await _supabase
          .from('test_video_player')
          .select('*')
          .ilike('video_name', _searchText.isEmpty ? '%' : '%$_searchText%');

      setState(() {
        _videoData = response;
      });
    } catch (e) {
      debugPrint('Error fetching videos: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          icon: const Icon(Iconsax.arrow_square_left,
              color: Color.fromRGBO(56, 15, 67, 1)),
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return BottomNav();
            }));
          },
        ),
        title: Center(
            child: HomeUiHelper().customText('Recorded Classes', 24,
                FontWeight.w400, Color.fromRGBO(56, 15, 67, 1))),
        actions:const  [
          SizedBox(
            width: 60,
            height: 40,
          )
        ],
        //backgroundColor: Color.fromRGBO(246, 235, 252, 1),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Search TextField
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(246, 235, 252, 1), // Background color
                          borderRadius: BorderRadius.circular(17), // Border radius
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search Videos',
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(205, 140, 230, 1),
                            ),
                            prefixIcon: const Icon(
                              Iconsax.search_normal,
                              color: Color.fromRGBO(205, 140, 230, 1),
                            ),
                            border: InputBorder.none, // Removes the border
                            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Container(
                          width: 365,
                          height: 101,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(17),
                            gradient: RadialGradient(
                              colors: const [
                                Color.fromRGBO(129, 50, 153, 1),
                                Color.fromRGBO(205, 140, 230, 1),
                              ],
                              center: Alignment.center,
                              radius: 3,
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Image.asset('lib/assets/images/Saly-13.png'),
                              SizedBox(
                                width: 30,
                              ),
                              HomeUiHelper().customText(
                                'Unleash Your Musical\nTalent Anytime, \nAnywhere!',
                                20,
                                FontWeight.w600,
                                Color(0xFFFBF6FD),
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Color.fromRGBO(181, 95, 214, 1),
                        indent: 90,
                        endIndent: 90,
                        thickness: 3,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: HomeUiHelper().customText(
                            'Play and Learn', 20, FontWeight.w600, Color(0xFF380F43)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                // Search Results
                StreamBuilder<List<dynamic>>(
                  stream: Stream.value(_videoData),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error fetching data'),
                      );
                    } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No videos found'),
                      );
                    } else {
                      final videoData = snapshot.data!;
                      return Center(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: videoData.length,
                          itemBuilder: (context, index) {
                            final video = videoData[index];
                            final videoCover = video['video_cover'] ?? '';
                            final videoName = video['video_name'] ?? 'Unknown';
                            final videoDescription =
                                video['video_description'] ?? 'No description';
                            final videoUrl = video['video_url'] ?? '';

                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return VideoPlayerScreen(
                                        videoUrl: videoUrl,
                                        videoDesc: videoDescription,
                                      );
                                    }));
                              },
                              child: Padding(
                                padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Stack(
                                  children: [
                                    // Video Thumbnail
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        width: 363,
                                        height: 224,
                                        decoration: const BoxDecoration(),
                                        child: Image.network(
                                          videoCover,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Center(
                                                child: Icon(Icons.error));
                                          },
                                        ),
                                      ),
                                    ),
                                    // Video Info Overlay
                                    Positioned(
                                      bottom: 0.00,
                                      child: Container(
                                        width: 363,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 0.7),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, top: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                videoName,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF380F43),
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                videoDescription,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF380F43),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatelessWidget {
  final String videoUrl;
  final String videoDesc;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.videoDesc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Video URL: $videoUrl'),
            const SizedBox(height: 10),
            Text('Description: $videoDesc'),
          ],
        ),
      ),
    );
  }
}
