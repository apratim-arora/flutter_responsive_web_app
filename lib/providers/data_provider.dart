import 'package:responsive_1/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'data_provider.g.dart';

@riverpod
Future<List<Article>> getArticleList(GetArticleListRef ref) async {
  await Future.delayed(const Duration(milliseconds: 1500));
  return generateArticles(7);
}

@riverpod
Future<List<String>> allTagsList(AllTagsListRef ref) async {
  List<Article> articleList = await ref.watch(getArticleListProvider.future);
  Set<String> tags = Set.from(
      articleList.map((article) => article.tags.map((tagName) => tagName)));
  return tags.toList();
}

// final selectedTagListProvider =
//     StateProvider<List<String>>((ref) => <String>[]);
// final filterTypeProvider = StateProvider<FilterType>((ref) => FilterType.none);
// final sortTypeProvider =
//     StateProvider<SortType>((ref) => SortType.dateNewestFirst);

@riverpod
class SelectedTagListForFiltering extends _$SelectedTagListForFiltering {
  @override
  List<String> build() => [];
  void updateSelectedTags(List<String> newList) => state = newList;
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
  final FilterType filter = ref.watch(selectedFilterTypeProvider);
  final SortType sort = ref.watch(selectedSortTypeProvider);
  List<Article> currentList = await ref.watch(getArticleListProvider.future);
  //filtering

  switch (filter) {
    case FilterType.byTagName:
      {
        List<String> selectedtags =
            ref.read(selectedTagListForFilteringProvider);
        print("all tags from saved data: $selectedtags");
        currentList = currentList
            .where((article) =>
                selectedtags.any((tag) => article.tags.contains(tag)))
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
