import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart'; 

import 'filters.dart';

List<dynamic> allInternships = [];
List<dynamic>? internships;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Video Splash Screen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => VideoSplashScreen(),
        '/internships': (context) => ImageSplashScreen(),
        '/filters': (context) => FiltersPage(),
      },
    );
  }
}

class VideoSplashScreen extends StatefulWidget {
  @override
  _VideoSplashScreenState createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/splash_video.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          Future.delayed(Duration(seconds: 3), () {
            Navigator.pushReplacementNamed(context, '/internships');
          });
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}

class ImageSplashScreen extends StatefulWidget {
  @override
  _ImageSplashScreenState createState() => _ImageSplashScreenState();
}

class _ImageSplashScreenState extends State<ImageSplashScreen> {
  Map<String, String> filters = {};

  @override
  void initState() {
    super.initState();
    // Fetch all internships initially
    fetchAllInternships();
  }

  void fetchAllInternships() async {
    try {
      final response = await http.get(Uri.parse('https://internshala.com/flutter_hiring/search'));
      if (response.statusCode == 200) {
        allInternships = List.from(json.decode(response.body)['internships_meta'].values);
        setState(() {
          internships = allInternships;
        });
      } else {
        throw Exception('Failed to load internships. Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching internships: $e');
      throw Exception('Failed to load internships. Error: $e');
    }
  }

  void _openFiltersPage(BuildContext context) async {
    // Navigate to the filters page and get the selected filters
    final selectedFilters = await Navigator.pushNamed(context, '/filters');

    // Apply selected filters to the list of internships
    if (selectedFilters != null) {
      setState(() {
        filters = Map<String, String>.from(selectedFilters as Map<dynamic, dynamic>);
        internships = _filterInternships(allInternships, filters);
      });
    }
  }

  List<dynamic>? _filterInternships(List<dynamic> internships, Map<String, String> filters) {
    // Implement the logic to filter internships based on the selected filters
    return internships.where((internship) {
      bool filterPassed = true;
      if (filters['profile'] != null && internship['title'] != filters['profile']) {
        filterPassed = false;
      }
      if (filters['city'] != null) {
        bool cityMatched = false;
        for (var location in internship['locations']) {
          if (location['string'] == filters['city']) {
            cityMatched = true;
            break;
          }
        }
        if (!cityMatched) {
          filterPassed = false;
        }
      }
      if (filters['duration'] != null && internship['duration'] != filters['duration']) {
        filterPassed = false;
      }
      return filterPassed;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 28,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.menu),
                  SizedBox(width: 15),
                  Text(
                    'Internships',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 40),
                  Icon(Icons.search),
                ],
              ),
            ),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  _openFiltersPage(context);
                },
                style: OutlinedButton.styleFrom(
                  primary: Colors.blue, // Text color
                  side: BorderSide(color: Colors.blue), // Border color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Rounded corners
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tune),
                    SizedBox(width: 8),
                    Text('Filters'),
                  ],
                ),
              ),
            ),
            if (internships != null)
              FutureBuilder(
                future: Future.value(internships),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    final List<dynamic> internships = snapshot.data as List<dynamic>;
                    if (internships.isEmpty) {
                      return Center(child: Text('No internships match the selected filters.'));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: internships.length,
                      itemBuilder: (context, index) {
                        final internship = internships[index];
                        final bool isRemote = internship['work_from_home'] ?? false;
                        final List<dynamic> locations = internship['locations'] ?? [];

                        return Container(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                  internship['title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(internship['company_name'] ?? 'No Company'),
                                      SizedBox(height: 10,),
                                      isRemote
                                          ? Row(
                                        children: [
                                          Icon(
                                            Icons.home_outlined,
                                            size: 15.0,
                                          ),
                                          SizedBox(width: 5),
                                          Text('Work from Home'),
                                        ],
                                      )
                                          : Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 15.0,
                                          ),
                                          SizedBox(width: 5),
                                          Text(locations.map((location) => location['string']).join(', ')),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Text('${internship['start_date'] ?? 'N/A'}'),
                                          SizedBox(width: 20),
                                          Text('${internship['duration'] ?? 'N/A'}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  
                                },
                              ),
                            ],
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
    );
  }
}
