import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:responsive_1/constants.dart';
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
@riverpod
class HighLightColor extends _$HighLightColor {
  @override
  Color build() {
    return Colors.yellow;
  }

  void updateColor(Color color) {
    state = color;
  }
}

@Riverpod(keepAlive: true)
class HighlightNotifier extends _$HighlightNotifier {
  @override
  Map<String, List<Highlight>> build() {
    return {};
  }
  // void setHighlights( List<Highlight> highlights) {
  //   state = highlights;
  // }

  void removeHighlight(String uuid, int clickIndex) {
    // Check avaailability of the highlight for given uuid
    if (state.containsKey(uuid)) {
      final newState = Map<String, List<Highlight>>.from(state);
      final List<Highlight>? currentHighlights = newState[uuid];
      if (currentHighlights == null) return;
      // selecting the highlight containing clickIndex
      Highlight highlightToRemove = currentHighlights.firstWhere(
          (highlight) =>
              highlight.range.start <= clickIndex &&
              highlight.range.end >= clickIndex,
          orElse: Highlight.empty);
      if (highlightToRemove.range.start == highlightToRemove.range.end) return;
      // removing on match
      newState[uuid]!.remove(highlightToRemove);
      // If after removal, the list for this uuid is empty, removing the whole key.
      if (newState[uuid]!.isEmpty) {
        newState.remove(uuid);
      }
      state = newState;
    }
  }

  void addHighlight(String uuid, TextRange range) {
    final color = ref.read(highLightColorProvider);
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

@Riverpod(keepAlive: true)
class VideoProgress extends _$VideoProgress {
  ///ask for provider[videoUUid][videoCurrentPosition] && provider[videoUUid][videoTotalDuration]

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
      videoCurrentPosition: currentPosition,
      videoTotalDuration: totalDuration
    };
    print(
        "updateVideoProgress provider : ${newState[videoUuid]?[videoCurrentPosition]}= $currentPosition, @videoUUID:$videoUuid\t fullMap:${state.value}");
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
    ///returns map[videoCurrentPosition] and map[videoTotalDuration] as Duration Type
    print(
        "current state = ${state.value} and @videoUuid = ${state.value?[videoUuid]}(returning)");
    return state.value?[videoUuid];
  }
}

@Riverpod(keepAlive: true)
class TextScaleFactor extends _$TextScaleFactor {
  @override
  double build() {
    return 1.0;
  }

  void increaseSizeFactor() {
    if (state > 2.1) return;
    state = state + 0.1;
  }

  void decreaseSizeFactor() {
    if (state < 0.7) return;
    state = state - 0.1;
  }
}

@Riverpod(keepAlive: true)
class NotesNotifier extends _$NotesNotifier {
  @override
  List<Note> build(String articleId) {
    //use articleId to fetch all notes from the database
    return List<Note>.empty();
  }

  void addNote(Note note) => state = [...state, note];
  void editNote(Note note) {
    List<Note> newList = List.from(state);
    newList.removeWhere((n) => n.id == note.id);
    newList.add(note);
    print("Updating notes state. Old State = $state");
    state = newList;
    print("New State = $state");
  }

  void deleteNote(Note note) {
    List<Note> newList = List.from(state);
    newList.removeWhere((n) => n.id == note.id);
    state = newList;
  }
}

@Riverpod(keepAlive: true)
class ScrollProgress extends _$ScrollProgress {
  @override
  double build(String articleId) {
    //use articleId to article specific progress

    return 0;
  }

  void setScrollProgress(double position) {
    state = position;
  }
}

@riverpod
class TextCharsRead extends _$TextCharsRead {
  int _charsRead = 0;
  int _totalChars = 0;
  @override
  (int, int) build(String articleId) {
    return (_charsRead, _totalChars);
  }

  void setCharsRead(int charsRead, int totalChars) {
    state = (charsRead, totalChars);
    _totalChars = totalChars;
    _charsRead = charsRead;
  }

  double getTextReadProgress() => _totalChars == 0
      ? throw UnimplementedError("Text reading progress never set")
      : _charsRead / _totalChars;
}

@riverpod
class CombinedProgress extends _$CombinedProgress {
  @override
  FutureOr<String> build(String articleID) async {
    var (charsRead, totalChars) = ref.watch(textCharsReadProvider(articleID));
    var videoP = await ref.watch(videoProgressProvider(articleID).future);
    int videoCharsRead = 0, totalVideoChars = 0;
    String textProgress = "[Text] = $charsRead/$totalChars";
    videoP?.forEach((_, value) => value?.forEach(
          (key, value) {
            if (key == videoCurrentPosition) {
              videoCharsRead += value.inSeconds * videoSecondToChar;
            } else if (key == videoTotalDuration) {
              totalVideoChars += value.inSeconds * videoSecondToChar;
            }
          },
        ));
    print(
        "$textProgress\n[VIDEO] = $videoCharsRead/$totalVideoChars \n[TOTAL] = ${videoCharsRead + charsRead}/${totalVideoChars + totalChars}, ${(videoCharsRead + charsRead) / (totalVideoChars + totalChars)}->${((videoCharsRead + charsRead) / (totalVideoChars + totalChars)).toStringAsFixed(2)}");

    return ((videoCharsRead + charsRead) / (totalVideoChars + totalChars))
        .toStringAsFixed(2);
  }
}
