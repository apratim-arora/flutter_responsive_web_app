import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:responsive_1/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'data_provider.g.dart';

@riverpod
class IsMobile extends _$IsMobile {
  @override
  bool build() => false;
  void init(double width) => state = width > 600;
}

@riverpod
Future<List<Article>> getArticleList(GetArticleListRef ref) async {
  await Future.delayed(const Duration(milliseconds: 1500));
  return generateArticles(7);
}

@riverpod
Future<List<ValueItem<dynamic>>> allTagsList(AllTagsListRef ref) async {
  List<Article> articleList = await ref.watch(getArticleListProvider.future);
  Set<String> tagsString = {};
  for (var article in articleList) {
    tagsString.addAll(article.tags);
  }

  List<ValueItem<dynamic>> items = <ValueItem<dynamic>>[];
  for (var tag in tagsString) {
    items.add(ValueItem(label: tag, value: tag));
  }
  return items;
}

@riverpod
class SelectedTagIndex extends _$SelectedTagIndex {
  @override
  List<int> build() => <int>[];
  void updateSelectedTags(List<int> newIndexList) => state = newIndexList;
}

@riverpod
class SelectedTagListForFiltering extends _$SelectedTagListForFiltering {
  @override
  List<ValueItem<dynamic>> build() {
    print("SELECTED_TAG_LIST_PROVIDER USING DEFAULT VALUE [] empty list");
    return [];
  }

  void updateSelectedTags(List<ValueItem<dynamic>> newList) {
    var oldState = state;
    if (!listEquals(state, newList)) {
      state = newList;
    }
    print(
        "SELECTED_TAG_LIST_PROVIDER updated in provider from $oldState to $newList");
  }
}

@riverpod
class SelectedSortType extends _$SelectedSortType {
  @override
  SortType build() => SortType.dateNewestFirst;
  void updateSortType(SortType newSortType) => state = newSortType;
}

@riverpod
class SelectedFilterType extends _$SelectedFilterType {
  @override
  FilterType build() => FilterType.none;
  void updateFilterType(FilterType newFilterType) => state = newFilterType;
}

@riverpod
Future<List<Article>> filteredAndSortedArticles(
    FilteredAndSortedArticlesRef ref) async {
  FilterType filter = ref.watch(selectedFilterTypeProvider);
  SortType sort = ref.watch(selectedSortTypeProvider);
  List<Article> currentList = await ref.watch(getArticleListProvider.future);
  List<ValueItem> selectedtags = ref.watch(selectedTagListForFilteringProvider);
  //filtering
  if (filter != FilterType.byTagName && selectedtags.isNotEmpty) {
    ref
        .read(selectedTagListForFilteringProvider.notifier)
        .updateSelectedTags(List.empty());
  }

  switch (filter) {
    case FilterType.byTagName:
      {
        if (selectedtags.isEmpty) {
          ref
              .read(selectedFilterTypeProvider.notifier)
              .updateFilterType(FilterType.none);
          break;
        }
        print(
            "\tFrom Inside provider for applied filtered list:\nselected tags for filtering: $selectedtags");
        print("all tags available from data: $allTags");
        currentList = currentList
            .where((article) =>
                selectedtags.any((tag) => article.tags.contains(tag.value)))
            .toList();
      }
    case FilterType.starred:
      {
        currentList =
            currentList.where((article) => article.isFavouite).toList();
      }
    default:
  }

  // sorting
  switch (sort) {
    case SortType.dateOldestFirst:
      currentList.sort((a, b) => a.dateTimeAdded.compareTo(b.dateTimeAdded));

    case SortType.priorityHighestFirst:
      currentList.sort((a, b) => b.priority.index.compareTo(a.priority.index));

    case SortType.priorityLowestFirst:
      currentList.sort((a, b) => a.priority.index.compareTo(b.priority.index));

    case SortType.dateNewestFirst:
    default:
      currentList.sort((a, b) => b.dateTimeAdded.compareTo(a.dateTimeAdded));
  }

  return currentList;
}

@riverpod
class AsyncArticles extends _$AsyncArticles {
  @override
  FutureOr<List<Article>> build() async {
    return await ref.watch(filteredAndSortedArticlesProvider.future);
  }

  Future<void> addArticle(Article article) async {
    //
  }
  Future<void> editArticle(Article article) async {
    //
  }
  Future<void> deleteArticle(Article article) async {
    //
  }
  Future<void> toggleStarred(Article article) async {
    int index = state.value!.indexOf(article);
    final List<Article> prevState = await future;
    prevState.removeAt(index);
    article.isFavouite = !article.isFavouite;
    state = AsyncData([...prevState, article]);
  }
}

///reader
@Riverpod(keepAlive: true)
class HighlightNotifier extends _$HighlightNotifier {
  @override
  Map<String, List<Highlight>> build() {
    return {};
  }
  // void setHighlights( List<Highlight> highlights) {
  //   state = highlights;
  // }

  void removeHighlight(TextRange range) {
    final newState = Map.of(state);
    newState.remove(range);
    state = newState;
  }

  void addHighlight(String uuid, TextRange range, Color color) {
    final highlight = Highlight(range: range, color: color, uuid: uuid);
    if (state.containsKey(uuid)) {
      state = {
        ...state,
        uuid: _mergeHighlight(state[uuid]!, highlight),
      };
    } else {
      state = {
        ...state,
        uuid: [highlight],
      };
    }
  }

  List<Highlight> _mergeHighlight(
      List<Highlight> existingHighlights, Highlight newHighlight) {
    final mergedHighlights = <Highlight>[];

    for (var highlight in existingHighlights) {
      if (highlight.range.end < newHighlight.range.start ||
          highlight.range.start > newHighlight.range.end) {
        mergedHighlights.add(highlight);
      } else {
        final start = highlight.range.start < newHighlight.range.start
            ? highlight.range.start
            : newHighlight.range.start;
        final end = highlight.range.end > newHighlight.range.end
            ? highlight.range.end
            : newHighlight.range.end;
        newHighlight = Highlight(
            range: TextRange(start: start, end: end),
            color: newHighlight.color,
            uuid: newHighlight.uuid);
      }
    }

    mergedHighlights.add(newHighlight);
    return mergedHighlights;
  }
}

@riverpod
class Some extends _$Some {
  @override
  FutureOr<int> build() async {
    await Future.delayed(const Duration(seconds: 2));
    return 2;
  }
}

@Riverpod(keepAlive: true)
class VideoProgress extends _$VideoProgress {
  ///ask for provider[videoUUid]["currentPosition"] && provider[videoUUid]["totalDuration"]

  @override
  FutureOr<Map<String, Map<String, Duration>?>?> build(String articleId) async {
    // _articleId = articleId;
    //get data from storage using articeID here.
    return {};
  }

  void updateVideoProgress(String videoUuid, Duration currentPosition,
      Duration totalDuration) async {
    Map<String, Map<String, Duration>?> newState = state.value ?? {};
    newState[videoUuid] = {
      "currentPosition": currentPosition,
      "totalDuration": totalDuration
    };
    print(
        "updateVideoProgress provider : ${newState[videoUuid]?["currentPosition"]}= $currentPosition, @videoUUID:$videoUuid\t fullMap:${state.value}");
    state = AsyncValue.data(newState);
  }

  Future<void> saveVideoProgress(
      String videoUuid, Duration currentPosition) async {
    ///Save the progress in storage. using articleId
    articleId;
  }

  Map<String, Duration>? getVideoProgress(String videoUuid) {
    ///returns the video progress.
    ///Returns null if videoUUId not found.
    ///returns map["currentPosition"] and map["totalDuration"] as double Type
    print(
        "current state = ${state.value} and @videoUuid = ${state.value?[videoUuid]}(returning)");
    return state.value?[videoUuid];
  }
}
