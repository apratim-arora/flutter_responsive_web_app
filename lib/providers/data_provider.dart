import 'package:flutter/foundation.dart';
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

  ///
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
