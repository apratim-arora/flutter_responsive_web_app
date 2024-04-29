import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    ref.listen(selectedFilterTypeProvider, (previous, newFilter) {
      if (newFilter != FilterType.byTagName) return;
      // showModalBottomSheet(context: context, builder: (context) => ,);
    });
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
                ref
                    .read(selectedFilterTypeProvider.notifier)
                    .updateFilterType(FilterType.byTagName);
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
                    .updateFilterType(FilterType.none);
              },
              child: IconAndLabel(
                gap: 7,
                icon: Icon(
                  CupertinoIcons.xmark,
                  color: Colors.blue.shade600,
                ),
                label: Text(
                  "No Filters",
                  style: selectionBasedStyle(
                    // ref.read(selectedFilterTypeProvider),
                    selectedFilter,
                    FilterType.none,
                  ),
                ),
              ),
            ),
          ],
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(width: 0.5, color: Colors.blue[200]!),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              backgroundColor: Colors.blue[50],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7),
                  bottomLeft: Radius.circular(7),
                ),
              ),
            ),
            onPressed: null,
            icon: Icon(
              CupertinoIcons.slider_horizontal_3,
              color: Colors.blue[400],
              size: 16,
            ),
            label: Text(
              "Filter by",
              style: TextStyle(color: Colors.blue[300], fontSize: 11),
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
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(width: 0.5, color: Colors.blue[200]!),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              backgroundColor: Colors.blue[50],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(7),
                  bottomRight: Radius.circular(7),
                ),
              ),
            ),
            onPressed: null,
            icon: Icon(
              CupertinoIcons.arrow_up_arrow_down,
              color: Colors.blue[400],
              size: 15,
            ),
            label: Text(
              "Sort by",
              style: TextStyle(color: Colors.blue[300], fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }
}

class ModalBottomSheetForTagFiltering extends ConsumerStatefulWidget {
  const ModalBottomSheetForTagFiltering({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ModalBottomSheetForTagFilteringState();
}

class _ModalBottomSheetForTagFilteringState
    extends ConsumerState<ModalBottomSheetForTagFiltering> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
