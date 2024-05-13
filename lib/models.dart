import 'dart:math';
import 'package:flutter/material.dart';

class Article {
  final String title, description, url;
  DateTime dateTimeAdded;

  final String favIconLink;
  final List<String> tags;
  final Priority priority;
  final Duration estCompletionTime;
  late final String currentStatus;
  bool isFavouite = false;
  bool isExpanded = false;
  final int progress;
  final List<String>? folderPath;

  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.dateTimeAdded,
    required this.priority,
    required this.tags,
    required this.estCompletionTime,
    this.progress = 0,
    this.folderPath,
  }) : favIconLink =
            // "https://t2.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://$url&size=40";
            samplefavs[rnd.nextInt(samplefavs.length - 1)] {
    if (progress == 0) {
      currentStatus = "Not Started";
    } else if (progress == 100) {
      currentStatus = "Completed!";
    } else {
      currentStatus = "In Progress";
    }
  }
}

enum SortType {
  dateNewestFirst,
  dateOldestFirst,
  priorityHighestFirst,
  priorityLowestFirst
}

enum FilterType { none, byTagName, starred }

enum Priority { low, mediumLow, normal, high, veryHigh }

Map<Priority, Color> priorityColor = {
  Priority.low: Colors.grey,
  Priority.mediumLow: Colors.orangeAccent.shade700,
  Priority.normal: Colors.blue,
  Priority.high: Colors.redAccent.shade400,
  Priority.veryHigh: Colors.red.shade900,
};
Map<Priority, String> priorityLabel = {
  Priority.low: "Low Priority",
  Priority.mediumLow: "Medium Priority",
  Priority.normal: "Normal Priority",
  Priority.high: "High Priority",
  Priority.veryHigh: "Very High Priority",
};
String getFormattedDuration(Duration duration) {
  if (duration.inSeconds < 60) {
    return "${duration.inSeconds} sec";
  } else if (duration.inMinutes < 60) {
    return "${duration.inMinutes} min";
  } else {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes hrs";
  }
}

Color getProgressColor(int progress) => progress <= 30
    ? Colors.red[400]!
    : (progress < 75)
        ? Colors.blue
        : Colors.green[700]!;
var rnd = Random();
List<String> samplefavs = [
  "assets/images/favs/businessinsider-fav.png",
  "assets/images/favs/dailymotion-fav.png",
  "assets/images/favs/forbes-fav.png",
  "assets/images/favs/gpt-fav.png",
  "assets/images/favs/reddit-fav.png",
  "assets/images/favs/twitch-fav.png",
  "assets/images/favs/yt-fav.png"
];
List<String> allUrls = [
  "https://www.youtube.com/watch?v=dQw4w9WgXcQ", // Video: Rick Astley - Never Gonna Give You Up
  "https://www.nytimes.com/2024/04/16/science/space-spacecraft-photographs-earth.html", // Article: New York Times - Spacecraft Photographs Earth
  "https://vimeo.com/123456789", // Video: Example Vimeo video
  "https://www.bbc.com/news/world-68819853", // Article: BBC News - Asia
  "https://www.netflix.com/title/80100172", // Video: Example Netflix title
  "https://www.theverge.com/2024/4/16/22384928/apple-spring-event-2024-what-to-expect-date-time", // Article: The Verge - Apple's Spring Event
  "https://www.dailymotion.com/video/x12ab34", // Video: Example Dailymotion video
  "https://www.nationalgeographic.com/science/article/life-likely-planet-discovered-most-extreme-exoplanet", // Article: National Geographic - Life-Likely Planet Discovered
  "https://www.twitch.tv/riotgames", // Video: Twitch - Riot Games channel
  "https://www.forbes.com/sites/forbestechcouncil/2024/04/16/embracing-data-ethics-the-recipe-for-ethical-ai/?sh=123456789", // Article: Forbes - Embracing Data Ethics: The Recipe for Ethical AI
];
List<String> allTags = [
  "Marketing",
  "Development",
  "UI/UX",
  "Advertising",
  "CRM",
  "IT",
  "Payroll management",
  "Feedback handling"
];
int progressGenerator() {
  var numb = rnd.nextInt(3);
  if (numb == 1) {
    return rnd.nextInt(99) + 1;
  } else if (numb == 2) {
    return 100;
  } else {
    return 0;
  }
}

DateTime dateTimeGenerator() {
  DateTime start = DateTime(2023, 2, 1), end = DateTime(2024, 4, 29);
  var minMilliseconds = start.millisecondsSinceEpoch.abs();
  var maxMilliseconds = end.millisecondsSinceEpoch.abs();
  var randomMilliseconds = minMilliseconds +
      rnd.nextInt((maxMilliseconds / 10 - minMilliseconds / 10).toInt());
  int month = rnd.nextInt(11) + 1;
  int day = rnd.nextInt(27) + 1;
  List<int> years = [2022, 2023, 2024];
  int year = years[rnd.nextInt(years.length - 1)];
  return DateTime.fromMillisecondsSinceEpoch(randomMilliseconds)
      .copyWith(day: day, month: month, year: year);
}

Duration completionTimeGenerator() => Duration(minutes: rnd.nextInt(150) + 5);

List<String> folderPathGenerator() {
  int length = rnd.nextInt(6);
  List<String> path = [];
  List<String> sampleFolderNames = [
    "Folder X",
    "Folder Y",
    "Folder Z",
    "Folder A",
    "Folder B",
    "Folder C"
  ];
  for (var i = 0; i <= length; i++) {
    int nextIndex = rnd.nextInt(sampleFolderNames.length - 1);
    path.add(sampleFolderNames[nextIndex]);
  }
  return path;
}

//data
List<Article> generateArticles(int numberOfItems) {
  return List<Article>.generate(numberOfItems, (int index) {
    var priorities = Priority.values;
    var randomPriority = priorities[rnd.nextInt(priorities.length)];
    var rndTagLength = rnd.nextInt(allTags.length - 1);
    List<String> randomTags = [];
    List<int> usedIndexes = [];
    var url = allUrls[rnd.nextInt(allUrls.length - 1)];
    for (var i = 0; i < rndTagLength; i++) {
      var randomIndex = rnd.nextInt(allTags.length - 1);
      var ok = false;
      while (!ok) {
        if (!usedIndexes.contains(randomIndex)) {
          usedIndexes.add(randomIndex);
          randomTags.add(allTags[randomIndex]);
          ok = true;
        } else {
          randomIndex = (randomIndex + 1) % allTags.length;
        }
      }
    }
    return Article(
      title:
          "Title of Article ${index + 1} extending to next line being a possibility.",
      description:
          "Description of article containing some long text information and the number definitely $index; depicting the index of data.",
      dateTimeAdded: dateTimeGenerator(),
      priority: randomPriority,
      tags: randomTags,
      url: url,
      progress: progressGenerator(),
      estCompletionTime: completionTimeGenerator(),
      folderPath: folderPathGenerator(),
    );
  });
}

// List<Article> sampleData = [
//   Article(
//       title: "How to design a great UI/UX",
//       description:
//           "Description of article containing some long text information specific to the saved page.",
//       url: allUrls[0],
//       dateTimeAdded: DateTime(2023,09,15),
      
//       priority: Priority.mediumLow,
//       tags: [],
//       estCompletionTime: estCompletionTime)
// ];
