import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:simz_academy/controllers/functions/show_alert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../controllers/MediaPlayers/video_player.dart';
import '../UIHelper/home_ui_helper.dart';
import 'bottom_nav.dart';

class MusicLibraryScreen extends StatefulWidget {
  const MusicLibraryScreen({super.key});

  @override
  State<MusicLibraryScreen> createState() => _MusicLibraryScreenState();
}

class _MusicLibraryScreenState extends State<MusicLibraryScreen> {
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
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;

    // Determine number of columns based on screen width
    if (screenWidth < 600) {
      crossAxisCount = 1;
    } else if (screenWidth < 900) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_square_left,
              color: Color.fromRGBO(56, 15, 67, 1)),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const BottomNav()),
            );
          },
        ),
        title: Center(
          child: HomeUiHelper().customText(
            'Recorded Classes',
            24,
            FontWeight.w400,
            const Color.fromRGBO(56, 15, 67, 1),
          ),
        ),
        actions: const [SizedBox(width: 60, height: 40)],
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(246, 235, 252, 1),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search Videos',
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(205, 140, 230, 1),
                          ),
                          prefixIcon: Icon(
                            Iconsax.search_normal,
                            color: Color.fromRGBO(205, 140, 230, 1),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Container(
                        width: 365,
                        height: 101,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          gradient: const RadialGradient(
                            colors: [
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
                            const SizedBox(width: 30),
                            HomeUiHelper().customText(
                              'Unleash Your Musical\nTalent Anytime, \nAnywhere!',
                              20,
                              FontWeight.w600,
                              const Color(0xFFFBF6FD),
                            )
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      color: Color.fromRGBO(181, 95, 214, 1),
                      indent: 90,
                      endIndent: 90,
                      thickness: 3,
                    ),
                    const SizedBox(height: 5),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text('Play and Learn',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF380F43),
                          )),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              StreamBuilder<List<dynamic>>(
                stream: Stream.value(_videoData),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching data'));
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No videos found'));
                  } else {
                    final videoData = snapshot.data!;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 400 / 400, // Original aspect ratio
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                      ),
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
                            if (videoUrl.contains('youtube.com') ||
                                videoUrl.contains('youtu.be')) {
                              showAlertBox(context, videoUrl);
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VideoPlayerScreen(
                                    videoUrl: videoUrl,
                                    videoDesc: videoDescription,
                                  ),
                                ),
                              );
                            }
                          },
                          child: AspectRatio(
                            aspectRatio: 363 / 224,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    videoCover,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Center(child: Icon(Icons.error)),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width /
                                        crossAxisCount,
                                    height: 70,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 0.7),
                                      borderRadius: BorderRadius.only(
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
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
