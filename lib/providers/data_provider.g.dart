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
String _$allTagsListHash() => r'c0c440d0ebf01afeb2f0ef26818227ebccd6e07e';

/// See also [allTagsList].
@ProviderFor(allTagsList)
final allTagsListProvider = AutoDisposeFutureProvider<List<String>>.internal(
  allTagsList,
  name: r'allTagsListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allTagsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllTagsListRef = AutoDisposeFutureProviderRef<List<String>>;
String _$filteredAndSortedArticlesHash() =>
    r'fce20e60349481ea618ef4e17930747732dedeab';

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
String _$selectedTagListForFilteringHash() =>
    r'8de51cb3d9130d074647f389014135ef3da7c250';

/// See also [SelectedTagListForFiltering].
@ProviderFor(SelectedTagListForFiltering)
final selectedTagListForFilteringProvider = AutoDisposeNotifierProvider<
    SelectedTagListForFiltering, List<String>>.internal(
  SelectedTagListForFiltering.new,
  name: r'selectedTagListForFilteringProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedTagListForFilteringHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedTagListForFiltering = AutoDisposeNotifier<List<String>>;
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
