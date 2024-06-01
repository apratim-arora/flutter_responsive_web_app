import 'dart:math';
import 'dart:ui';
import 'package:animate_gradient/animate_gradient.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:responsive_1/models.dart';
import 'package:responsive_1/my_expansion_panel_widget.dart';
import 'package:responsive_1/providers/data_provider.dart';
import 'package:responsive_1/reader_widget.dart';
import 'package:universal_html/html.dart' as my_html;
import 'package:url_launcher/url_launcher.dart';

//functions
Alignment stockImageAndTextAlignment(double width, double height, bool isImage,
    {bool isMobile = false}) {
  late Alignment image, text;
  late Alignment mobileImage, mobileText;
  //Mobile:
  if (isMobile) {
    if (isImage) {
      mobileImage = const Alignment(0, -0.234);
    } else {
      mobileText = const Alignment(0, 0.234);
    }
    return isImage ? mobileImage : mobileText;
  }

  //Desktop:
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

//widgets
class PriorityViewEmptyWidget extends StatelessWidget {
  const PriorityViewEmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      double height = constraints.maxHeight;
      bool isMobile = MediaQuery.of(context).size.width < 588;
      return Opacity(
        opacity: 0.15,
        child: Stack(
          children: [
            Align(
              alignment: stockImageAndTextAlignment(width, height, true,
                  isMobile: isMobile),
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
                alignment: stockImageAndTextAlignment(width, height, false,
                    isMobile: isMobile),

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
    });
  }
}

class FolderViewEmptyWidget extends StatelessWidget {
  const FolderViewEmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        bool isMobile = MediaQuery.of(context).size.width < 588;
        return Center(
          child: Opacity(
            opacity: 0.15,
            child: Stack(
              children: [
                // const SizedBox(
                //   height: 150,
                // ),
                Align(
                  alignment: stockImageAndTextAlignment(width, height, true,
                      isMobile: isMobile),
                  child: Lottie.asset(
                    "assets/lottie/folder_animation.json",
                    repeat: false,
                    fit: BoxFit.scaleDown,
                    width: width / 2.5,
                  ),
                ),
                Align(
                  alignment: stockImageAndTextAlignment(width, height, false,
                      isMobile: isMobile),
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
    );
  }
}

class AppbarIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  const AppbarIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? "",
      child: Padding(
        padding: const EdgeInsets.only(right: 9),
        child: Material(
          type: MaterialType.transparency,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white54,
                width: 1,
              ),
            ),
            child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.all(4.5),
                  child: icon,
                )),
          ),
        ),
      ),
    );
  }
}

class MobileSplitContainer extends StatelessWidget {
  const MobileSplitContainer(
      {super.key,
      required this.iconData,
      required this.heading,
      this.trailing,
      required this.container});
  final IconData iconData;
  final String heading;
  final Widget? trailing;
  final Widget container;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              margin: const EdgeInsets.fromLTRB(9, 7, 0, 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.black.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 0.3,
                    // offset: const Offset(0.3, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(
                      iconData,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Text(
                    heading,
                    style: const TextStyle(
                      color: Colors.white,
                      // fontFamily: "DidactGothic",
                      fontSize: 15.1,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
            trailing ?? const SizedBox()
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 5,
              right: 5,
            ),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.grey[350]!,
                ),
              ),
              child: container,
            ),
          ),
        ),
      ],
    );
  }
}

class SplitContainer extends StatelessWidget {
  final Widget heading;
  final Widget container;
  final double? containerLeftMargin, containerRightMargin;

  const SplitContainer({
    super.key,
    required this.heading,
    required this.container,
    this.containerLeftMargin,
    this.containerRightMargin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 23,
            top: 12,
            right: containerRightMargin ?? 8,
          ),
          child: heading,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: 11,
              left: containerLeftMargin ?? 15,
              right: containerRightMargin ?? 5,
              bottom: 5,
            ),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.grey[350]!,
                ),
              ),
              child: container,
            ),
          ),
        ),
      ],
    );
  }
}

class IconAndLabel extends StatelessWidget {
  final Widget icon;
  final Widget label;
  final double gap;

  const IconAndLabel({
    super.key,
    required this.icon,
    required this.label,
    this.gap = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          gap == 5
              ? const SizedBox(width: 5)
              : SizedBox(
                  width: gap,
                ),
          label
        ],
      ),
    );
  }
}

class SplitScreenTitle extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Widget? trailing;
  const SplitScreenTitle({
    super.key,
    required this.text,
    required this.iconData,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 600;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: FittedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  iconData,
                  color: Colors.blue[400],
                  size: isMobile ? 22 : null,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: isMobile ? 14 : 18,
                    letterSpacing: 1,
                    fontFamily: "DidactGothic",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        trailing != null
            ? Flexible(flex: 1, child: FittedBox(child: trailing!))
            : const SizedBox(),
      ],
    );
  }
}

class ExpandedBodyRowItem extends StatelessWidget {
  final String title;
  final Widget? content;
  final int? flexLeft, flexRight;
  const ExpandedBodyRowItem({
    super.key,
    required this.title,
    required this.content,
    this.flexLeft,
    this.flexRight,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    bool isMobile = width < 600;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          fit: isMobile ? FlexFit.tight : FlexFit.tight,
          flex: flexLeft ?? 2,
          child: SizedBox(
            width: isMobile ? width * 0.2 : width * 0.07,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: AutoSizeText(
                title.isNotEmpty ? title : "-N/A-",
                maxLines: 1,
                minFontSize: 9,
                maxFontSize: isMobile ? 12 : 13,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
        Flexible(
            flex: flexRight ?? 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: content ??
                  const AutoSizeText(
                    "-N/A-",
                    maxLines: 1,
                    minFontSize: 9,
                    maxFontSize: 13,
                    style: TextStyle(color: Colors.grey),
                  ),
            ))
      ],
    );
  }
}

class FilterSortButtons extends ConsumerWidget {
  const FilterSortButtons({
    super.key,
  });

  TextStyle? selectionBasedStyle(dynamic selectedType, dynamic thisType) {
    if (thisType == selectedType) {
      return TextStyle(color: Colors.blue.shade400);
    } else {
      return null;
    }
  }

  Future<void>
      makeDelay() async => //made for letting the menu close first so as to make app feel not too laggy
          await Future.delayed(const Duration(milliseconds: 300));
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FilterType selectedFilter = ref.watch(selectedFilterTypeProvider);
    SortType selectedSorting = ref.watch(selectedSortTypeProvider);
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 600;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //filter button
        PopupMenuButton(
          offset: const Offset(-100, 2),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          popUpAnimationStyle: AnimationStyle(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
          ),
          tooltip: "Filter Options",
          position: PopupMenuPosition.under,
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () async {
                //filter by tag name
                await makeDelay();
                if (context.mounted) {
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return const FilterTagDialog();
                    },
                  );
                } else {
                  debugPrint(
                      "Unable to show dialog show to context across async gaps");
                }

                // ref
                //     .read(selectedFilterTypeProvider.notifier)
                //     .updateFilterType(FilterType.byTagName);
              },
              child: IconAndLabel(
                gap: 7,
                icon: Icon(
                  CupertinoIcons.tag,
                  color: Colors.blue.shade600,
                  size: isMobile ? 22 : null,
                ),
                label: Text(
                  "Tag name",
                  style: selectionBasedStyle(
                    // ref.read(selectedFilterTypeProvider),
                    selectedFilter,
                    FilterType.byTagName,
                  ),
                ),
              ),
            ),
            PopupMenuItem(
              onTap: () async {
                //clear all filters
                await makeDelay();
                ref
                    .read(selectedFilterTypeProvider.notifier)
                    .updateFilterType(FilterType.starred);
              },
              child: IconAndLabel(
                gap: 7,
                icon: Icon(
                  CupertinoIcons.star,
                  color: Colors.blue.shade600,
                ),
                label: Text(
                  "Starred",
                  style: selectionBasedStyle(
                    // ref.read(selectedFilterTypeProvider),
                    selectedFilter,
                    FilterType.starred,
                  ),
                ),
              ),
            ),
            if (ref.read(selectedFilterTypeProvider) != FilterType.none &&
                isMobile)
              PopupMenuItem(
                onTap: () async {
                  //clear all filters
                  await makeDelay();
                  ref
                      .read(selectedFilterTypeProvider.notifier)
                      .updateFilterType(FilterType.none);
                },
                child: IconAndLabel(
                  gap: 7,
                  icon: Icon(
                    CupertinoIcons.xmark,
                    color: Colors.blue.shade600,
                  ),
                  label: Text(
                    "Clear Filters",
                    style: selectionBasedStyle(
                      // ref.read(selectedFilterTypeProvider),
                      selectedFilter,
                      FilterType.none,
                    ),
                  ),
                ),
              )
          ],
          //TODO
          child: SizedBox(
            height: isMobile ? 27 : null,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 0.5, color: Colors.blue[200]!),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                backgroundColor: Colors.white70,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7),
                    bottomLeft: Radius.circular(7),
                  ),
                ),
              ),
              onPressed: null,
              icon: Icon(
                Icons.filter_alt_sharp,
                color: Colors.deepPurple[400],
                size: 16,
              ),
              label: Text(
                "Filter",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: isMobile ? 12 : 13,
                ),
              ),
            ),
          ),
        ),
        //sort button
        PopupMenuButton(
          offset: const Offset(20, 2),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          popUpAnimationStyle: AnimationStyle(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
          ),
          tooltip: "Sort options",
          position: PopupMenuPosition.under,
          itemBuilder: (context) => [
            PopupMenuItem(
              child: IconAndLabel(
                icon: Icon(CupertinoIcons.sort_up, color: Colors.blue.shade600),
                label: Text(
                  "Date - Newest first",
                  style: selectionBasedStyle(
                    selectedSorting, // ref.read(selectedSortTypeProvider),
                    SortType.dateNewestFirst,
                  ),
                ),
              ),
              onTap: () async {
                //sort by date newest first
                await makeDelay();
                ref
                    .read(selectedSortTypeProvider.notifier)
                    .updateSortType(SortType.dateNewestFirst);
              },
            ),
            PopupMenuItem(
              child: IconAndLabel(
                  icon: Icon(CupertinoIcons.sort_down,
                      color: Colors.blue.shade600),
                  label: Text(
                    "Date - Oldest first",
                    style: selectionBasedStyle(
                      selectedSorting, // ref.read(selectedSortTypeProvider),
                      SortType.dateOldestFirst,
                    ),
                  )),
              onTap: () async {
                //sort by date oldest first
                await makeDelay();
                ref
                    .read(selectedSortTypeProvider.notifier)
                    .updateSortType(SortType.dateOldestFirst);
              },
            ),
            PopupMenuItem(
              child: IconAndLabel(
                  icon: Icon(Icons.priority_high_rounded,
                      color: Colors.blue.shade600),
                  label: Text(
                    "Priority - Highest first",
                    style: selectionBasedStyle(
                      selectedSorting, // ref.read(selectedSortTypeProvider),
                      SortType.priorityHighestFirst,
                    ),
                  )),
              onTap: () async {
                //sort by priority highest first
                await makeDelay();
                ref
                    .read(selectedSortTypeProvider.notifier)
                    .updateSortType(SortType.priorityHighestFirst);
              },
            ),
            PopupMenuItem(
              child: IconAndLabel(
                  icon: Icon(Icons.low_priority_rounded,
                      color: Colors.blue.shade600),
                  label: Text(
                    "Priority - Lowest first",
                    style: selectionBasedStyle(
                      selectedSorting, // ref.read(selectedSortTypeProvider),
                      SortType.priorityLowestFirst,
                    ),
                  )),
              onTap: () async {
                //sort by priority lowest first
                await makeDelay();
                ref
                    .read(selectedSortTypeProvider.notifier)
                    .updateSortType(SortType.priorityLowestFirst);
              },
            ),
          ],
          //TODO
          child: SizedBox(
            height: isMobile ? 27 : null,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 0.5, color: Colors.blue[200]!),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                backgroundColor: Colors.white70,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                  ),
                ),
              ),
              onPressed: null,
              icon: const Icon(
                CupertinoIcons.arrow_up_arrow_down,
                color: Colors.deepPurple,
                size: 15,
              ),
              label: Text(
                "Sort",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: isMobile ? 12 : 13,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomCircularProgress extends StatelessWidget {
  const CustomCircularProgress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: Colors.blue.shade400,
      strokeCap: StrokeCap.round,
      strokeWidth: 5,
      strokeAlign: 1,
    );
  }
}

class FilterTagDialog extends ConsumerStatefulWidget {
  const FilterTagDialog({super.key});
  @override
  ConsumerState<FilterTagDialog> createState() => _FiltertagDialogState();
}

class _FiltertagDialogState extends ConsumerState<FilterTagDialog> {
  late bool enableClearAllButton;
  @override
  void initState() {
    super.initState();
    enableClearAllButton =
        ref.read(selectedTagListForFilteringProvider).isNotEmpty;
  }

  MultiSelectController controller = MultiSelectController();
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isMobile = screenWidth < 600;
    var allTags = ref.watch(allTagsListProvider);
    var selectedTags = ref.watch(selectedTagListForFilteringProvider);

    print("\tRight before opening dialog:\nselected tags=$selectedTags");
    return Dialog(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: screenHeight * 0.4,
                maxWidth: screenWidth * 0.3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select the tags to filter: ",
                    style: TextStyle(
                        fontSize: isMobile ? 20 : 23,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  allTags.when(
                    data: (allTagsList) => MultiSelectDropDown(
                      clearIcon: null,
                      borderRadius: 25,
                      padding: const EdgeInsets.fromLTRB(9, 9, 20, 9),
                      // searchEnabled: true,
                      // searchBackgroundColor: Colors.white,
                      // searchLabel: "Search Tags here...",
                      inputDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 0,
                            blurRadius: 15,
                            offset: const Offset(
                                0, 5), // Shadow moved to the right and bottom
                          )
                        ],
                        gradient: const LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Color.fromARGB(157, 255, 127, 80),
                              Color.fromARGB(139, 194, 129, 255),
                            ]),
                      ),
                      hint: "Select Tags",
                      hintStyle:
                          TextStyle(fontSize: 14.5, color: Colors.grey[50]),
                      hintPadding: const EdgeInsets.only(left: 20),
                      suffixIcon: Icon(
                        Icons.arrow_downward_sharp,
                        color: Colors.grey[50], //Colors.white70
                      ),

                      chipConfig: const ChipConfig(
                        deleteIconColor: Colors.white,
                        wrapType: WrapType.wrap,
                        backgroundColor: Color(0xffD7A3A8), //Color(0xffD2A2B2),
                        labelStyle: TextStyle(
                          // fontFamily: "DidactGothic",
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                        ),
                        spacing: 9,
                        runSpacing: 9,
                      ),
                      controller: controller,
                      dropdownMargin: 2,
                      onOptionSelected: (selectedOptions) {
                        // setState(() {
                        //   enableClearAllButton = selectedOptions.isNotEmpty;
                        // });
                        print(
                            "ON_OPTION_SELECTED ran, enableButton = $enableClearAllButton");
                      },
                      selectedOptions: [
                        for (int i = 0; i < selectedTags.length; i++)
                          selectedTags[i]
                      ],
                      options: [
                        for (int i = 0; i < allTagsList.length; i++)
                          allTagsList[i]
                      ],
                    ),
                    error: (error, stackTrace) => Center(
                      child: Text("Error: , $error\n$stackTrace"),
                    ),
                    loading: () => const CustomCircularProgress(),
                  ),
                  // const Expanded(child: SizedBox()),
                  const SizedBox(
                    height: 200,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 9,
                      runSpacing: 9,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              controller.clearAllSelection();
                              ref
                                  .read(selectedTagListForFilteringProvider
                                      .notifier)
                                  .updateSelectedTags(List.empty());
                            },
                            // enableClearAllButton
                            //     ? () {
                            //         setState(() {
                            //           controller.clearAllSelection();
                            //           enableClearAllButton = false;
                            //           print(
                            //               "button pressed, controler status=${controller.selectedOptions}");
                            //         });
                            //       }
                            //     : null,
                            child: const Text("Clear all")),
                        ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Cancel")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              ref
                                  .read(selectedFilterTypeProvider.notifier)
                                  .updateFilterType(FilterType.byTagName);
                              ref
                                  .read(selectedTagListForFilteringProvider
                                      .notifier)
                                  .updateSelectedTags(
                                      controller.selectedOptions);
                            },
                            child: const Text("Apply Filter")),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class DesktopAppBar extends StatelessWidget {
  const DesktopAppBar({
    super.key,
    required this.title,
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
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
                title!,
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
}

class MobileAppBar extends StatelessWidget {
  const MobileAppBar({
    super.key,
    required this.title,
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AppBar(
          backgroundColor: Colors.black.withOpacity(0.2),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // const SizedBox(width: 5),
              // CircleAvatar(
              //   radius: 24,
              //   backgroundColor: Colors.white54,
              //   child: SizedBox(
              //     height: 32,
              //     child: Image.asset(
              //       "assets/images/increase.png",
              //       semanticLabel: "The Logo",
              //     ),
              //   ),
              // ),
              // const SizedBox(width: 11),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title!,
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

          // flexibleSpace: Container(),
        ),
      ),
    );
  }
}

class MobileBottomNavBar extends StatelessWidget {
  const MobileBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  final int currentIndex;
  final Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: BottomNavigationBar(
            // unselectedIconTheme: const IconThemeData(color: Colors.white),
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.black54,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            currentIndex: currentIndex,
            onTap: onTap,
            backgroundColor: Colors.white.withOpacity(0.2),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                  // activeIcon: ,
                  icon: Icon(CupertinoIcons.list_bullet_below_rectangle),
                  label: "Article List"),
              BottomNavigationBarItem(
                  activeIcon: Icon(CupertinoIcons.folder_fill),
                  icon: Icon(CupertinoIcons.folder),
                  label: "Folder View"),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.text_badge_checkmark),
                  label: "Priority View"),
            ]),
      ),
    );
  }
}

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.topBorderRadius,
    this.padding,
    this.margin,
    this.allowBottomRadius = false,
  });
  final Widget child;
  final double? topBorderRadius;
  final bool allowBottomRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.6),
            Colors.white.withOpacity(0.3),
          ],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        // color: Colors.white.withOpacity(0.3),
        borderRadius: topBorderRadius != null
            ? BorderRadius.only(
                topLeft: Radius.circular(topBorderRadius!),
                topRight: Radius.circular(topBorderRadius!),
                bottomLeft: allowBottomRadius
                    ? Radius.circular(topBorderRadius!)
                    : Radius.zero,
                bottomRight: allowBottomRadius
                    ? Radius.circular(topBorderRadius!)
                    : Radius.zero,
              )
            : const BorderRadius.only(
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
        child: child,
      ),
    );
  }
}

class ArticleListContainerWebView extends ConsumerWidget {
  const ArticleListContainerWebView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SplitContainer(
      heading: SplitScreenTitle(
        text: "Article List",
        iconData: CupertinoIcons.list_bullet_below_rectangle,
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: ref.watch(selectedFilterTypeProvider) != FilterType.none,
              child: SizedBox(
                height: 27,
                child: TextButton(
                  onPressed: () {
                    ref
                        .read(selectedFilterTypeProvider.notifier)
                        .updateFilterType(FilterType.none);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                  ),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(CupertinoIcons.xmark_octagon, size: 18),
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
      container: const ScrollableExpansionArticleList(),
    );
  }
}

class ScrollableExpansionArticleList extends ConsumerStatefulWidget {
  const ScrollableExpansionArticleList({super.key});

  @override
  ConsumerState<ScrollableExpansionArticleList> createState() =>
      _MyExpansionPanelListWidgetState();
}

class _MyExpansionPanelListWidgetState
    extends ConsumerState<ScrollableExpansionArticleList> {
  @override
  void initState() {
    super.initState();
    // Prevent default event handler
    my_html.document.onContextMenu.listen((event) => event.preventDefault());
  }

  late bool isMobile;

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(filteredAndSortedArticlesProvider);
    isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          data.when(
            data: (data) => data.isNotEmpty
                ? articleListFunction(data)
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 250.0),
                      child: Text(
                        "Nothing to Show! ;)",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
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
    // final statesController = MaterialStatesController();
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
                                //Gradient Icon
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
        body: aboutArticleColumn(article, selectedtags));
  }

  Column aboutArticleColumn(Article article, List<dynamic> selectedtags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExpandedBodyRowItem(
          title: "URL",
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 15,
                child: InkWell(
                  onTap: () => _launchUrl(article.url, context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                      if (!isMobile)
                        const Flexible(flex: 2, child: SizedBox(width: 3)),
                      Flexible(
                          flex: 5,
                          child: FittedBox(
                            child: Icon(
                              CupertinoIcons.arrow_up_right_square,
                              size: 16,
                              color: Colors.blue[600],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              const Flexible(
                  child: SizedBox(
                width: 5,
              )),
              Flexible(
                flex: 5,
                // height: 25,
                child: FittedBox(
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Colors.white54,
                      gradient: const LinearGradient(colors: [
                        Color(0xfff9ce34),
                        Color.fromARGB(187, 238, 42, 124),
                        Color.fromARGB(169, 110, 66, 198),
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReaderScreen(article)));
                      },
                      // statesController: statesController,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(style: BorderStyle.none),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0)),
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        textStyle: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      child: const Text(
                        "Read here",
                        style: TextStyle(color: Color.fromRGBO(66, 66, 66, 1)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                            backgroundColor: Colors.primaries[
                                    Random().nextInt(Colors.primaries.length)]
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
    );
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
}

class ColorSelectionDropdownItem extends ConsumerWidget {
  const ColorSelectionDropdownItem(
    this.optionColor, {
    super.key,
  });
  final Color optionColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highlightColor = ref.read(highLightColorProvider);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: highlightColor == optionColor ? Colors.deepPurple : null,
      ),
      child: Icon(Icons.circle, color: optionColor, size: 27),
    );
  }
}

class MeasureSize extends StatefulWidget {
  final Widget child;
  final void Function(Size size) onChange;

  const MeasureSize({super.key, required this.child, required this.onChange});

  @override
  MeasureSizeState createState() => MeasureSizeState();
}

class MeasureSizeState extends State<MeasureSize> {
  Size? oldSize;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (oldSize == null || oldSize != context.size) {
        oldSize = context.size;
        widget.onChange(context.size!);
      }
    });
    return widget.child;
  }
}

////////////beautifil dialog
class AddNoteDialog extends ConsumerStatefulWidget {
  const AddNoteDialog(this.noteSubmission,
      {super.key, this.noteForEditing, this.onDelete})
      : assert(
            (noteForEditing != null && onDelete != null) ||
                (noteForEditing == null && onDelete == null),
            "both noteForEditing and onDelete should either be null or have a value");
  final Note? noteForEditing;
  final VoidCallback? onDelete;
  final void Function(String noteText, int iconImageIndex) noteSubmission;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends ConsumerState<AddNoteDialog> {
  late TextEditingController _noteController;
  late List<bool> _isSelected;
  bool isMobile = false;
  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _noteController = TextEditingController();
    if (widget.noteForEditing != null) {
      _noteController.text = widget.noteForEditing!.text;
      _isSelected = List.generate(
          5, (index) => index == widget.noteForEditing!.iconImageIndex);
    } else {
      _isSelected = [true, false, false, false, false];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Note? note = widget.noteForEditing;
    double width = MediaQuery.of(context).size.width;
    isMobile = width < 600;
    return AlertDialog(
      title: note != null
          ? const Text("Edit the Note Here")
          : const Text('Add a Note Here'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: !isMobile ? width * 0.34 : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _noteController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Enter your note here...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 5),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Note Icon:",
                  style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  return Flexible(
                    child: FittedBox(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            for (int i = 0; i < _isSelected.length; i++) {
                              _isSelected[i] = i == index;
                            }
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: _isSelected[index]
                              ? Colors.deepPurple
                              : Colors.grey[300],
                          maxRadius: 27,
                          child: CircleAvatar(
                            maxRadius: 25,
                            child: Image.asset(
                              "assets/images/note_image/note_image_$index.png",
                              width: index < 2
                                  ? 34
                                  : 41, //first 2 icons are bigger
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (note != null)
          TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                if (widget.onDelete != null) {
                  widget.onDelete!();
                }
              },
              icon: const Icon(Icons.delete_outline_outlined),
              label: const Text("Delete Note")),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String note = _noteController.text;
            int selectedImage = _isSelected.indexOf(true);
            Navigator.of(context).pop();
            widget.noteSubmission(note, selectedImage);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

//////progress bar
class ScrollListener extends ConsumerStatefulWidget {
  final Widget child;
  final Article article;

  const ScrollListener({required this.article, required this.child, super.key});

  @override
  ScrollListenerState createState() => ScrollListenerState();
}

class ScrollListenerState extends ConsumerState<ScrollListener> {
  final ScrollController _scrollController = ScrollController();
  double _totalContentHeight = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          _totalContentHeight = scrollNotification.metrics.maxScrollExtent;
          print(
              "SCROLLED: CURRENT:(${scrollNotification.metrics.pixels}), MAX:($_totalContentHeight)");
          ref
              .read(scrollPositionProvider(widget.article.id).notifier)
              .setScrollPosition(ScrollData(scrollNotification.metrics.pixels,
                  scrollNotification.metrics.maxScrollExtent));
          print(
              "SCROLL_PROGRESS: ${ref.read(scrollPositionProvider(widget.article.id))}");
        }
        return false;
      },
      child: widget.child,
    );
  }
}

class ProgressBar extends ConsumerWidget {
  const ProgressBar({required this.article, super.key});
  final Article article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(scrollPositionProvider(article.id));

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          height: 6,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xffffdd6a),
            Color(0xffff0b93),
            Color.fromARGB(255, 164, 51, 156),
          ])),
          width: MediaQuery.of(context).size.width *
              ref
                  .read(scrollPositionProvider(article.id).notifier)
                  .getScrollProgress(),
        ),
      ),
    );
  }
}

class MyAnimatedBackground extends StatelessWidget {
  final Widget? child;
  const MyAnimatedBackground({this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimateGradient(
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
      child: child ??
          const SizedBox(
            width: double.infinity,
            height: double.infinity,
          ),
    );
  }
}
