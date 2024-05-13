// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getArticleListHash() => r'3c7eb71965f2a96e573174b2c82ff6bb3d02e395';

/// See also [getArticleList].
@ProviderFor(getArticleList)
final getArticleListProvider =
    AutoDisposeFutureProvider<List<Article>>.internal(
  getArticleList,
  name: r'getArticleListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getArticleListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetArticleListRef = AutoDisposeFutureProviderRef<List<Article>>;
String _$allTagsListHash() => r'5446e32b8b8d2aad2bf5a9c8f754d5bd2a03f7f1';

/// See also [allTagsList].
@ProviderFor(allTagsList)
final allTagsListProvider =
    AutoDisposeFutureProvider<List<ValueItem<dynamic>>>.internal(
  allTagsList,
  name: r'allTagsListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allTagsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllTagsListRef = AutoDisposeFutureProviderRef<List<ValueItem<dynamic>>>;
String _$filteredAndSortedArticlesHash() =>
    r'7fc873a7437a80c2173dc4e388281af6c98fc8a5';

/// See also [filteredAndSortedArticles].
@ProviderFor(filteredAndSortedArticles)
final filteredAndSortedArticlesProvider =
    AutoDisposeFutureProvider<List<Article>>.internal(
  filteredAndSortedArticles,
  name: r'filteredAndSortedArticlesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredAndSortedArticlesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredAndSortedArticlesRef
    = AutoDisposeFutureProviderRef<List<Article>>;
String _$isMobileHash() => r'6fa4ec0ff603690216fb69985997d9fbfd2818bc';

/// See also [IsMobile].
@ProviderFor(IsMobile)
final isMobileProvider = AutoDisposeNotifierProvider<IsMobile, bool>.internal(
  IsMobile.new,
  name: r'isMobileProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isMobileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsMobile = AutoDisposeNotifier<bool>;
String _$selectedTagIndexHash() => r'57dcb18f8e1e41085a6b0d47d1057241b5f2e839';

/// See also [SelectedTagIndex].
@ProviderFor(SelectedTagIndex)
final selectedTagIndexProvider =
    AutoDisposeNotifierProvider<SelectedTagIndex, List<int>>.internal(
  SelectedTagIndex.new,
  name: r'selectedTagIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedTagIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedTagIndex = AutoDisposeNotifier<List<int>>;
String _$selectedTagListForFilteringHash() =>
    r'8b3de5a78e92f19c70edee33fde54355a1af41c3';

/// See also [SelectedTagListForFiltering].
@ProviderFor(SelectedTagListForFiltering)
final selectedTagListForFilteringProvider = AutoDisposeNotifierProvider<
    SelectedTagListForFiltering, List<ValueItem<dynamic>>>.internal(
  SelectedTagListForFiltering.new,
  name: r'selectedTagListForFilteringProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedTagListForFilteringHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedTagListForFiltering
    = AutoDisposeNotifier<List<ValueItem<dynamic>>>;
String _$selectedSortTypeHash() => r'd29a9a623f043c98f2efefb7fa2ed0c745465de5';

/// See also [SelectedSortType].
@ProviderFor(SelectedSortType)
final selectedSortTypeProvider =
    AutoDisposeNotifierProvider<SelectedSortType, SortType>.internal(
  SelectedSortType.new,
  name: r'selectedSortTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedSortTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedSortType = AutoDisposeNotifier<SortType>;
String _$selectedFilterTypeHash() =>
    r'9912863ded15cb7ece0690bb4e93a559ef0d1fa7';

/// See also [SelectedFilterType].
@ProviderFor(SelectedFilterType)
final selectedFilterTypeProvider =
    AutoDisposeNotifierProvider<SelectedFilterType, FilterType>.internal(
  SelectedFilterType.new,
  name: r'selectedFilterTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedFilterTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedFilterType = AutoDisposeNotifier<FilterType>;
String _$asyncArticlesHash() => r'1ab50252b319da28da98cc0041aa278c6897a265';

/// See also [AsyncArticles].
@ProviderFor(AsyncArticles)
final asyncArticlesProvider =
    AutoDisposeAsyncNotifierProvider<AsyncArticles, List<Article>>.internal(
  AsyncArticles.new,
  name: r'asyncArticlesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$asyncArticlesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AsyncArticles = AutoDisposeAsyncNotifier<List<Article>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
