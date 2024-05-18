import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_1/models.dart';
import 'package:responsive_1/widgets.dart';
import 'package:split_view/split_view.dart';

import 'reader_widget.dart';
// import 'package:universal_html/html.dart' as my_html;

void main() => runApp(const ProviderScope(child: MyApp()));

// class _EagerInitialization extends ConsumerWidget {
//   const _EagerInitialization({required this.child});
//   final Widget child;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     double width = MediaQuery.of(context).size.width;
//     ref.read(isMobileProvider.notifier).init(width);
//     ref.watch(isMobileProvider);
//     return child;
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Productivity App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: "Poppins",
        ),
        home: ReaderScreen(Article(
          title: "The Article Title",
          description:
              "Some long article description Some long article description Some long article description Some long article description Some long article description ",
          url: "http://abc.xyz",
          dateTimeAdded: DateTime(2023, 2, 21),
          priority: Priority.high,
          tags: ["UI/UX", "Business", "IT", "Graphics"],
          estCompletionTime: const Duration(minutes: 155),
          folderPath: ["Important", "Notes", "2022"],
          progress: 39,
        ))
        //const MyHomePage(title: 'Productivity'),
        );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    // ref.watch(isMobileProvider.notifier).init(screenWidth);
    // var data = generateArticles(5);

    void changeTab(int index) {
      setState(() {
        currentIndex = index;
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 56),
        child: isMobile
            ? MobileAppBar(title: widget.title)
            : DesktopAppBar(title: widget.title),
      ),
      extendBodyBehindAppBar: isMobile,
      extendBody: isMobile,
      bottomNavigationBar: isMobile
          ? MobileBottomNavBar(
              currentIndex: currentIndex, onTap: (index) => changeTab(index))
          : null,
      body: AnimateGradient(
        primaryBegin: Alignment.bottomRight,
        primaryEnd: Alignment.topRight,
        secondaryBegin: Alignment.topRight,
        secondaryEnd: Alignment.bottomLeft,
        primaryColors: const [
          Color(0xffff7f50),
          Color.fromARGB(255, 194, 129, 255),
        ],
        secondaryColors: const [
          Color(0xff00ffff),
          Color.fromARGB(255, 54, 190, 165),
        ],
        duration: const Duration(seconds: 10),
        child: isMobile
            ? MobileView(
                currentIndex: currentIndex,
              )
            : const PartitionedWebView(),
      ),
    );
  }
}

class MobileView extends StatelessWidget {
  MobileView({super.key, required this.currentIndex});
  final int currentIndex;
  final List<Widget> pageContents = [
    //Article list
    const MobileSplitContainer(
      heading: "Article List",
      iconData: CupertinoIcons.list_bullet_below_rectangle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [FilterSortButtons(), SizedBox(width: 7)],
      ),
      container: ScrollableExpansionArticleList(),
    ),
    //Folder view
    MobileSplitContainer(
      heading: "Folder View",
      iconData: CupertinoIcons.folder,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 27,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 0.5, color: Colors.blue[200]!),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                backgroundColor: Colors.white70,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              onPressed: null,
              icon: const Icon(
                CupertinoIcons.add,
                color: Colors.deepPurple,
                size: 16,
              ),
              label: const Text(
                "Create new",
                style: TextStyle(color: Colors.deepPurple, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 7)
        ],
      ),
      container: const FolderViewEmptyWidget(),
    ),

    //Priority View
    const MobileSplitContainer(
      heading: "Priority View",
      iconData: CupertinoIcons.text_badge_checkmark,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(width: 7), //7 is right padding for any buttons made here
        ],
      ),
      container: PriorityViewEmptyWidget(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint("rebuilding MobileVIew with child index $currentIndex");
    double topMargin = Scaffold.of(context).appBarMaxHeight!;
    double bottomMargin = kBottomNavigationBarHeight;
    return Padding(
      padding: EdgeInsets.only(
          top: topMargin, bottom: bottomMargin, left: 0, right: 0),
      child: pageContents[currentIndex],
    );
  }
}

class PartitionedWebView extends StatelessWidget {
  const PartitionedWebView({super.key});

//made for priority section stock image and text differentiation with folder section.
  Alignment priorityStockImageAlignment(
      double width, double height, bool isImage) {
    late Alignment image, text;
    //height based alignment
    if (isImage) {
      if (height > 200) {
        image = const Alignment(-0.35, 0);
      } else {
        image = const Alignment(-0.25, 0);
      }
    } else {
      if (height > 200) {
        text = const Alignment(0.35, 0);
      } else {
        text = const Alignment(0.25, 0);
      }
    }
    //width based alignment

    return isImage ? image : text;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.02,
        right: screenWidth * 0.02,
        top: screenHeight * 0.025,
        bottom: 5,
      ),
      child: GlassContainer(
        child: SplitView(
          gripColor: Colors.white70,
          gripColorActive: Colors.white,
          gripSize: 2,
          viewMode: SplitViewMode.Horizontal,
          indicator: const SplitIndicator(
            viewMode: SplitViewMode.Horizontal,
          ),
          activeIndicator: const SplitIndicator(
            viewMode: SplitViewMode.Horizontal,
          ),
          controller: SplitViewController(weights: [
            0.45,
            0.55
          ], limits: [
            WeightLimit(min: 0.3, max: 0.6),
            WeightLimit(min: 0.3, max: 0.75),
            // WeightLimit(max: 0.5, min: 0.2),
          ]),
          onWeightChanged: (w) {
            // print("Vertical $w");
          },
          children: [
            const ArticleListContainerWebView(),
            SplitView(
              gripColor: Colors.white70,
              gripColorActive: Colors.white,
              gripSize: 2,
              viewMode: SplitViewMode.Vertical,
              controller: SplitViewController(limits: [
                WeightLimit(min: 0.25, max: 0.8),
                WeightLimit(min: 0.25, max: 0.8),
                // WeightLimit(max: 0.5, min: 0.2),
              ]),
              indicator: const SplitIndicator(viewMode: SplitViewMode.Vertical),
              activeIndicator: const SplitIndicator(
                viewMode: SplitViewMode.Vertical,
                isActive: true,
              ),
              children: [
                SplitContainer(
                  heading: SplitScreenTitle(
                    iconData: CupertinoIcons.folder,
                    text: "Folder View",
                    trailing: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 0.5, color: Colors.blue[200]!),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        backgroundColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.add,
                        color: Colors.deepPurple,
                        size: 16,
                      ),
                      label: const Text(
                        "Create new",
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 13),
                      ),
                    ),
                  ),
                  // IconAndLabel(
                  //   icon: Icon(
                  //     CupertinoIcons.list_bullet,
                  //     color: Colors.blue[400],
                  //     // size: 20,
                  //   ),
                  //   gap: 12,
                  //   label: Text(
                  //     "Folder view",
                  //     style: TextStyle(color: Colors.grey[800], fontSize: 17),
                  //   ),
                  // ),
                  container: const FolderViewEmptyWidget(),
                  containerLeftMargin: 5,
                  containerRightMargin: 15,
                ),
                const SplitContainer(
                  heading: SplitScreenTitle(
                      text: "Priority View",
                      iconData: CupertinoIcons.text_badge_checkmark),
                  container: PriorityViewEmptyWidget(),
                  containerLeftMargin: 5,
                  containerRightMargin: 15,
                ),
              ],
              // onWeightChanged: (w) => print("Horizon: $w"),
            ),
          ],
        ),
      ),
    );
  }
}
