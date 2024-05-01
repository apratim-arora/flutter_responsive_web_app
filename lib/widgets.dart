import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:responsive_1/models.dart';
import 'package:responsive_1/providers/data_provider.dart';

class AppbarIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  const AppbarIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class SplitContainer extends StatelessWidget {
  final Widget heading;
  final Widget container;
  final double? containerLeftMargin, containerRightMargin;

  const SplitContainer(
      {super.key,
      required this.heading,
      required this.container,
      this.containerLeftMargin,
      this.containerRightMargin});

  @override
  Widget build(BuildContext context) {
    return Container(
      //TODO:remove below comment before removing glass effect
      // color: Colors.white12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 23, top: 12, right: 8),
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
      ),
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
                  // size: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: flexLeft ?? 2,
          child: SizedBox(
            width: width * 0.07,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: AutoSizeText(
                title.isNotEmpty ? title : "-N/A-",
                maxLines: 1,
                minFontSize: 9,
                maxFontSize: 13,
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
            // PopupMenuItem(
            //   onTap: () async {
            //     //clear all filters
            //     await makeDelay();
            //     ref
            //         .read(selectedFilterTypeProvider.notifier)
            //         .updateFilterType(FilterType.none);
            //   },
            //   child: IconAndLabel(
            //     gap: 7,
            //     icon: Icon(
            //       CupertinoIcons.xmark,
            //       color: Colors.blue.shade600,
            //     ),
            //     label: Text(
            //       "No Filters",
            //       style: selectionBasedStyle(
            //         // ref.read(selectedFilterTypeProvider),
            //         selectedFilter,
            //         FilterType.none,
            //       ),
            //     ),
            //   ),
            // ),
          ],
          //TODO
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
            label: const Text(
              "Filter",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 13,
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
            label: const Text(
              "Sort",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 13,
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
                  const Text(
                    "Select the tags to filter: ",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
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
                            onPressed: () => controller.clearAllSelection(),
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
                              ref
                                  .read(selectedFilterTypeProvider.notifier)
                                  .updateFilterType(FilterType.byTagName);
                              ref
                                  .read(selectedTagListForFilteringProvider
                                      .notifier)
                                  .updateSelectedTags(
                                      controller.selectedOptions);

                              Navigator.of(context).pop();
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
