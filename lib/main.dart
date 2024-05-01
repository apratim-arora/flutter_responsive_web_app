import 'dart:math';
import 'dart:ui';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:responsive_1/models.dart';
import 'package:responsive_1/my_expansion_panel_widget.dart';
import 'package:responsive_1/providers/data_provider.dart';
import 'package:responsive_1/widgets.dart';
import 'package:split_view/split_view.dart';
import 'package:universal_html/html.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productivity App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Poppins",
      ),
      home: const MyHomePage(title: 'Productivity'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Prevent default event handler
    document.onContextMenu.listen((event) => event.preventDefault());
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(filteredAndSortedArticlesProvider);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    // ref.watch(isMobileProvider.notifier).init(screenWidth);
    // var data = generateArticles(5);

    return Scaffold(
      appBar: appbar(),
      // backgroundColor: const Color(0xfff5f6f8),
      body: AnimateGradient(
        primaryBegin: Alignment.bottomRight,
        primaryEnd: Alignment.topRight,
        secondaryBegin: Alignment.topRight,
        secondaryEnd: Alignment.bottomLeft,
        primaryColors: const [
          Color(0xff00ffff),
          Color.fromARGB(255, 71, 252, 219),
          // Colors.white,
          // Color(0xffd2001a), Color(0xff7462ff)
        ],
        secondaryColors: const [
          // Colors.white,
          // Colors.blueAccent,
          // Colors.blue,
          Color.fromARGB(255, 194, 129, 255), Color(0xffff7f50),
        ],
        duration: const Duration(seconds: 10),
        child: Container(
          padding: EdgeInsets.only(
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            top: screenHeight * 0.03,
            bottom: 5,
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              // color: Colors.grey[200],
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.3),
                ],
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
              ),
              // color: Colors.white.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border.all(
                width: 1.5,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
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
                  SplitContainer(
                    heading: SplitScreenTitle(
                      text: "Article List",
                      iconData: CupertinoIcons.list_bullet_below_rectangle,
                      trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Visibility(
                            visible: ref.watch(selectedFilterTypeProvider) !=
                                FilterType.none,
                            child: SizedBox(
                              height: 27,
                              child: TextButton(
                                onPressed: () {
                                  ref
                                      .read(selectedFilterTypeProvider.notifier)
                                      .updateFilterType(FilterType.none);
                                },
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                ),
                                child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(CupertinoIcons.xmark_octagon,
                                          size: 18),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "Clear Filters",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const FilterSortButtons(),
                        ],
                      ),
                    ),
                    container: SingleChildScrollView(
                      // physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(right: 5),
                      //remove this below column if no need to add filter sort button right above article list as commented in padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                          //   child: FilterSortButtons(),
                          // ),
                          data.when(
                            data: (data) => data.isNotEmpty
                                ? articleListFunction(data)
                                : const Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 250.0),
                                      child: Text(
                                        "Nothing to Show! ;)",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                            error: (error, stackTrace) => Center(
                              child: Text("Error: $error"),
                            ),
                            loading: () => const Padding(
                              padding: EdgeInsets.only(top: 250),
                              child: Center(
                                child: CustomCircularProgress(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                    indicator:
                        const SplitIndicator(viewMode: SplitViewMode.Vertical),
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
                              side: BorderSide(
                                  width: 0.5, color: Colors.blue[200]!),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
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
                              style: TextStyle(
                                  color: Colors.deepPurple, fontSize: 13),
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
                        container: LayoutBuilder(
                          builder: (context, constraints) {
                            double width = constraints.maxWidth;
                            double height = constraints.maxHeight;
                            return Center(
                              child: Opacity(
                                opacity: 0.15,
                                child: Stack(
                                  children: [
                                    // const SizedBox(
                                    //   height: 150,
                                    // ),
                                    Align(
                                      alignment: stockImageAndTextAlignment(
                                          width, height, true),
                                      child: Lottie.asset(
                                        "assets/lottie/folder_animation.json",
                                        repeat: false,
                                        fit: BoxFit.scaleDown,
                                        width: width / 2.5,
                                      ),
                                    ),
                                    Align(
                                      alignment: stockImageAndTextAlignment(
                                          width, height, false),
                                      child: FittedBox(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Organize your Articles\n in folders here...",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue[900],
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "DidactGothic",
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        containerLeftMargin: 5,
                        containerRightMargin: 15,
                      ),
                      SplitContainer(
                        heading: const SplitScreenTitle(
                            text: "Priority View",
                            iconData: CupertinoIcons.text_badge_checkmark),
                        container:
                            LayoutBuilder(builder: (context, constraints) {
                          double width = constraints.maxWidth;
                          double height = constraints.maxHeight;
                          return Opacity(
                            opacity: 0.15,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: stockImageAndTextAlignment(
                                      width, height, true),
                                  child: Lottie.asset(
                                    "assets/lottie/kanban_notes_animation.json",
                                    repeat: false,
                                    fit: BoxFit.scaleDown,
                                    width: width / 1.71,
                                    height: height > 330 ? 300 : null,
                                  ),
                                ),
                                Positioned(
                                  child: Align(
                                    alignment: stockImageAndTextAlignment(
                                        width, height, false),

                                    // width < 550
                                    //     ? (width < 350)
                                    //         ? const Alignment(0, 0.08)
                                    //         : const Alignment(0, 0.15)
                                    //     : const Alignment(0, 0.25),
                                    child: FittedBox(
                                      child: Text(
                                        "Kanban styled\n Priority view...",
                                        style: TextStyle(
                                          color: Colors.blue[900],
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          fontFamily: "DidactGothic",
                                        ),
                                        // AutoSizeText(
                                        //   "Kanban style Priority view...",
                                        //   minFontSize: 9,
                                        //   maxFontSize: 15,
                                        //   maxLines: 1,
                                        //   style: TextStyle(
                                        //     color: Colors.blue[900],
                                        //     fontWeight: FontWeight.w700,
                                        //     fontFamily: "DidactGothic",
                                        //   ),
                                        // ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                        containerLeftMargin: 5,
                        containerRightMargin: 15,
                      ),
                    ],
                    // onWeightChanged: (w) => print("Horizon: $w"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar appbar() {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const SizedBox(width: 5),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white54,
            child: SizedBox(
              height: 32,
              child: Image.asset(
                "assets/images/increase.png",
                semanticLabel: "The Logo",
              ),
            ),
          ),
          const SizedBox(width: 3),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title!,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 35),
                child: Text(
                  "Progress faster...",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white30),
                ),
              )
            ],
          )
        ],
      ),
      // backgroundColor: const Color(0xffe0e1e7),
      actions: [
        AppbarIconButton(
            icon: const Icon(CupertinoIcons.search),
            onPressed: () => debugPrint("on pressed search")),
        AppbarIconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => debugPrint("on pressed notification")),
        AppbarIconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => debugPrint("on pressed settings")),
      ],
      actionsIconTheme: IconThemeData(
        color: Colors.grey.shade100,
        size: 24.5,
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // Color(0xff21d7e7),
              // Color(0xff2386f4)
              Color(0xffAEC6F6),
              Color.fromARGB(255, 115, 161, 254)
            ], //[Color(0xffe0e1e7), Color(0xfff5f6f8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  MyExpansionPanelList articleListFunction(List<Article> data) {
    var selectedTags =
        ref.read(selectedFilterTypeProvider) == FilterType.byTagName
            ? ref
                .read(selectedTagListForFilteringProvider)
                .map((e) => e.value.toString())
                .toList()
            : [];
    return MyExpansionPanelList.radio(
      expansionCallback: (int index, bool isExpanded) {
        // setState(() {
        data[index].isExpanded = isExpanded;
        debugPrint("item $index, exp status: ${data[index].isExpanded}");
        // });
      },
      children: data.map<MyExpansionPanel>((Article article) {
        return expansionPanelRadioWidget(article, selectedTags);
      }).toList(),
    );
  }

  MyExpansionPanelRadio expansionPanelRadioWidget(
      Article article, List<dynamic> selectedtags) {
    AutoSizeGroup autoSizeGroupInstance1 = AutoSizeGroup();
    return MyExpansionPanelRadio(
        value: article,
        hasIcon: false,
        canTapOnHeader: true,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return Listener(
            onPointerDown: _onPointerDown,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(
                color: priorityColor[article.priority]!,
                width: 5,
              ))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //header left side
                  Flexible(
                    flex: 7,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //top side containing icons and labels
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 2, 5, 2),
                                  decoration: BoxDecoration(
                                    color: priorityColor[article.priority]
                                        ?.withAlpha(30),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: priorityColor[article.priority]!,
                                      width: 0.5,
                                    ),
                                  ),
                                  margin:
                                      const EdgeInsets.only(top: 7, left: 5),
                                  child: AutoSizeText(
                                    priorityLabel[article.priority]!,
                                    maxFontSize: 10,
                                    minFontSize: 5,
                                    style: TextStyle(
                                        color: priorityColor[article.priority]),
                                  ),
                                )),
                            //contains another design with circle and corresponding priority label:
                            // IconAndLabel(
                            //     icon: Icon(
                            //       CupertinoIcons.circle_fill,
                            //       color: priorityColor[article.priority],
                            //       size: 12,
                            //     ),
                            //     label: AutoSizeText(
                            //       priorityLabel[article.priority]!,
                            //       group: autoSizeGroupInstance1,
                            //       maxLines: 1,
                            //       maxFontSize: 12,
                            //       minFontSize: 7,
                            //       style: const TextStyle(
                            //         color: Colors.grey,
                            //         fontWeight: FontWeight.w500,
                            //         fontFamily: "DidactGothic",
                            //       ),
                            //     )),
                          ],
                        ),
                        //bottom side containing fav and title
                        Row(
                          children: [
                            //fav icon
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 11, 8, 8),
                                child: ClipRRect(
                                  clipBehavior: Clip.antiAlias,
                                  borderRadius: BorderRadius.circular(7),
                                  child: Image.asset(
                                    width: 40,
                                    height: 40,
                                    article.favIconLink,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ),
                            //title
                            Flexible(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    article.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    minFontSize: 12,
                                    maxFontSize: 15,
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  //header right side
                  Flexible(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FittedBox(
                            child: IconAndLabel(
                              icon: const Icon(
                                CupertinoIcons.calendar,
                                color: Colors.grey,
                                size: 18,
                              ),
                              label: Text(
                                DateFormat('dd MMM, yyyy')
                                    .format(article.dateTimeAdded.toLocal()),
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontFamily: "DidactGothic"),
                              ),
                            ),
                          ),
                          FittedBox(
                            child: IconAndLabel(
                              icon: Icon(
                                article.progress == 100
                                    ? CupertinoIcons.check_mark_circled
                                    : (article.progress == 0
                                        ? CupertinoIcons.minus_circle
                                        : CupertinoIcons.clock),
                                size: 14,
                                color: article.progress == 100
                                    ? const Color(0xff42ff75)
                                    : (article.progress == 0
                                        ? Colors.grey
                                        : Colors.amber),
                              ),
                              label: AutoSizeText(
                                article.currentStatus,
                                style: TextStyle(
                                  fontFamily: "DidactGothic",
                                  // fontSize: 12,
                                  color: article.progress == 100
                                      ? const Color(0xff39ff14)
                                      : (article.progress == 0
                                          ? Colors.grey
                                          : Colors.amber),
                                ),
                                overflow: TextOverflow.ellipsis,
                                group: autoSizeGroupInstance1,
                                wrapWords: true,
                                minFontSize: 5,
                                maxFontSize: 12,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                article.isFavouite = !article.isFavouite;
                              });
                            },
                            icon: article.isFavouite
                                ?
                                // ShaderMask(
                                //     blendMode: BlendMode.srcIn,
                                //     shaderCallback: (bounds) =>
                                //         const RadialGradient(
                                //       center: Alignment.centerLeft,
                                //       stops: [.3, 0.8, 1],
                                //       radius: 0.65,
                                //       colors: [
                                //         // Colors.yellow,
                                //         // Colors.amber,
                                //         Color(0xff5c88e5),
                                //         Color(0xff9176bd),
                                //         Color(0xffbf6b72),
                                //       ],
                                //     ).createShader(bounds),
                                // child:
                                const Icon(
                                    CupertinoIcons.star_fill,
                                    // color: Colors.amber,
                                  )
                                // )
                                : const Icon(CupertinoIcons.star),
                            color:
                                article.isFavouite ? Colors.amber : Colors.grey,
                            iconSize: 20,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExpandedBodyRowItem(
              title: "URL",
              content: InkWell(
                onTap: () => _launchUrl(article.url, context),
                child: Row(
                  children: [
                    Flexible(
                      flex: 100,
                      child: AutoSizeText(
                        article.url.length > 40
                            ? "${article.url.substring(0, 40)}..."
                            : article.url,
                        minFontSize: 12,
                        maxFontSize: 14,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        wrapWords: false,
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontFamily: "DidactGothic",
                        ),
                      ),
                    ),
                    const Flexible(flex: 2, child: SizedBox(width: 5)),
                    Flexible(
                        flex: 5,
                        child: FittedBox(
                          child: Icon(
                            CupertinoIcons.arrow_up_right_square,
                            size: 16,
                            color: Colors.blue[600],
                          ),
                        ))
                  ],
                ),
              ),
            ),
            ExpandedBodyRowItem(
                title: "Description",
                content: AutoSizeText(
                  article.description,
                  minFontSize: 5,
                  maxFontSize: 12,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                )),
            ExpandedBodyRowItem(
              title: "Tags",
              content: article.tags.isNotEmpty
                  ? Wrap(
                      clipBehavior: Clip.antiAlias,
                      spacing: 3,
                      runSpacing: 3,
                      children: article.tags
                          .map((tagName) => Chip(
                                backgroundColor: Colors.primaries[Random()
                                        .nextInt(Colors.primaries.length)]
                                    .withAlpha(15),
                                side: !selectedtags.contains(tagName)
                                    ? BorderSide(
                                        width: 0.2, color: Colors.grey.shade200)
                                    : const BorderSide(
                                        width: 1, color: Colors.blue),
                                label: AutoSizeText(
                                  tagName,
                                  minFontSize: 5,
                                  maxFontSize: 11,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                                clipBehavior: Clip.antiAlias,
                                labelStyle: const TextStyle(),
                              ))
                          .toList(),
                    )
                  : null,
            ),
            ExpandedBodyRowItem(
              title: "Folder path",
              content: (article.folderPath?.isNotEmpty != null &&
                      article.folderPath?.isNotEmpty == true)
                  ? BreadCrumb(
                      items: article.folderPath!
                          .map((folder) => BreadCrumbItem(
                                  content: AutoSizeText(
                                folder,
                                group: breadcrumbGroupAutoSize,
                                softWrap: true,
                                minFontSize: 7,
                                maxFontSize: 12,
                              )))
                          .toList(),
                      divider: const Icon(Icons.chevron_right_rounded),
                    )
                  : null,
            ),
            ExpandedBodyRowItem(
                title: "Progresss",
                content: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      flex: 3,
                      child: CircularPercentIndicator(
                        radius: 23,
                        // animation: true,
                        // animationDuration: 1000,
                        center: AutoSizeText(
                          "${article.progress}%",
                          maxLines: 1,
                          minFontSize: 5,
                          maxFontSize: 11,
                          style: const TextStyle(
                              fontFamily: "DidactGothic",
                              fontWeight: FontWeight.bold),
                        ),
                        percent: article.progress / 100,
                        progressColor: getProgressColor(article.progress),
                        backgroundColor: Colors.deepPurple.shade100,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FittedBox(
                            child: IconAndLabel(
                                icon: Icon(
                                  Icons.circle,
                                  size: 15,
                                  color: getProgressColor(article.progress),
                                ),
                                label: AutoSizeText(
                                  "${article.progress}% progress made.",
                                  maxFontSize: 12,
                                  maxLines: 1,
                                  minFontSize: 7,
                                )),
                          ),
                          FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 1.0),
                              child: IconAndLabel(
                                icon: const Icon(
                                  Icons.access_time_rounded,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                                label: AutoSizeText(
                                  "${getFormattedDuration(article.estCompletionTime)}, est. total time",
                                  maxFontSize: 12,
                                  maxLines: 1,
                                  minFontSize: 7,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ));
  }

  AutoSizeGroup breadcrumbGroupAutoSize = AutoSizeGroup();
  Future<void> _launchUrl(String url, BuildContext context) async {
    Uri link = Uri.parse(url);
    if (!await launchUrl(link, webOnlyWindowName: "_blank")) {
      debugPrint("Something happened while opening link $url");
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: const Text(
      //       "Could not open URL.",
      //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      //     ),
      //     content: Text("Unable to launch URL $url"),
      //     actions: [
      //       TextButton(
      //           onPressed: () => Navigator.of(context).pop(),
      //           child: const Text("OK"))
      //     ],
      //   ),
      // );
    }
  }

  /// Callback when mouse clicked on `Listener` wrapped widget.
  Future<void> _onPointerDown(PointerDownEvent event) async {
    // Check if right mouse button clicked
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      final overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;
      final menuItem = await showMenu<int>(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(20)),
          context: context,
          items: [
            PopupMenuItem(
                value: 1,
                child: IconAndLabel(
                  icon: Icon(
                    Icons.share,
                    size: 22,
                    color: Colors.blue.shade400,
                  ),
                  label: const Text(
                    'Share',
                  ),
                )),
            PopupMenuItem(
                value: 2,
                child: IconAndLabel(
                    icon: Icon(
                      Icons.edit_square,
                      color: Colors.blue.shade400,
                    ),
                    label: const Text('Edit'))),
          ],
          position: RelativeRect.fromSize(
              event.position & const Size(48.0, 48.0), overlay.size));
      // Check if menu item clicked
      switch (menuItem) {
        case 1:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Share Clicked'),
            behavior: SnackBarBehavior.floating,
          ));
          break;
        case 2:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Edit clicked'),
              behavior: SnackBarBehavior.floating));
          break;
        default:
      }
    }
  }

  Alignment stockImageAndTextAlignment(
      double width, double height, bool isImage) {
    late Alignment image, text;
    //height based alignment
    if (isImage) {
      //image alignment
      if (height > 170) {
        image = const Alignment(-0.35, 0);
      } else {
        image = const Alignment(-0.3, 0);
      }
    } else {
      //text alignment
      if (height > 170) {
        text = const Alignment(0.35, 0);
      } else {
        text = const Alignment(0.3, 0);
      }
    }
    //width based alignment
    if (isImage) {
      if (width < 933 && width > 700) {
        // image = Alignment(image.x, image.y);
        // print("700-933");
      } else if (width < 700 && width > 636) {
        image = Alignment(image.x - 0.05, image.y);
        // print("700-636");
      } else if (width < 636) {
        image = Alignment(image.x - 0.12, image.y);
        // print("636 and less");
      } else {
        //width > 933
        // image = Alignment(image.x - 0.12, image.y);
        image = Alignment(image.x + 0.1, image.y);
        // print("else, must be >933");
      }
    } else {
      if (width < 933 && width > 700) {
        text = Alignment(text.x, text.y);
      } else if (width < 700 && width > 636) {
        text = Alignment(text.x + 0.05, text.y);
      } else if (width < 636) {
        text = Alignment(text.x + 0.12, text.y);
      } else {
        //width > 933
        // text = Alignment(text.x + 0.15, text.y);
        text = Alignment(text.x - 0.1, text.y);
      }
    }
    return isImage ? image : text;
  }

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
}
