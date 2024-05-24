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
String _$highLightColorHash() => r'3bbcd2cb5896beb41c66c8d6741348b9afe2906a';

///reader
///
/// Copied from [HighLightColor].
@ProviderFor(HighLightColor)
final highLightColorProvider =
    AutoDisposeNotifierProvider<HighLightColor, Color>.internal(
  HighLightColor.new,
  name: r'highLightColorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$highLightColorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HighLightColor = AutoDisposeNotifier<Color>;
String _$highlightNotifierHash() => r'375d763fcf6f97e776abcac1f7e7f7229774aa73';

/// See also [HighlightNotifier].
@ProviderFor(HighlightNotifier)
final highlightNotifierProvider =
    NotifierProvider<HighlightNotifier, Map<String, List<Highlight>>>.internal(
  HighlightNotifier.new,
  name: r'highlightNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$highlightNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HighlightNotifier = Notifier<Map<String, List<Highlight>>>;
String _$someHash() => r'00dc88b04d39562a9fc184eff1410901cf848508';

/// See also [Some].
@ProviderFor(Some)
final someProvider = AutoDisposeAsyncNotifierProvider<Some, int>.internal(
  Some.new,
  name: r'someProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$someHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Some = AutoDisposeAsyncNotifier<int>;
String _$videoProgressHash() => r'72afaad496f9b92aedcb6f13aa7bdbbe39b729d1';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$VideoProgress
    extends BuildlessAsyncNotifier<Map<String, Map<String, Duration>?>?> {
  late final String articleId;

  FutureOr<Map<String, Map<String, Duration>?>?> build(
    String articleId,
  );
}

/// See also [VideoProgress].
@ProviderFor(VideoProgress)
const videoProgressProvider = VideoProgressFamily();

/// See also [VideoProgress].
class VideoProgressFamily
    extends Family<AsyncValue<Map<String, Map<String, Duration>?>?>> {
  /// See also [VideoProgress].
  const VideoProgressFamily();

  /// See also [VideoProgress].
  VideoProgressProvider call(
    String articleId,
  ) {
    return VideoProgressProvider(
      articleId,
    );
  }

  @override
  VideoProgressProvider getProviderOverride(
    covariant VideoProgressProvider provider,
  ) {
    return call(
      provider.articleId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'videoProgressProvider';
}

/// See also [VideoProgress].
class VideoProgressProvider extends AsyncNotifierProviderImpl<VideoProgress,
    Map<String, Map<String, Duration>?>?> {
  /// See also [VideoProgress].
  VideoProgressProvider(
    String articleId,
  ) : this._internal(
          () => VideoProgress()..articleId = articleId,
          from: videoProgressProvider,
          name: r'videoProgressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$videoProgressHash,
          dependencies: VideoProgressFamily._dependencies,
          allTransitiveDependencies:
              VideoProgressFamily._allTransitiveDependencies,
          articleId: articleId,
        );

  VideoProgressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.articleId,
  }) : super.internal();

  final String articleId;

  @override
  FutureOr<Map<String, Map<String, Duration>?>?> runNotifierBuild(
    covariant VideoProgress notifier,
  ) {
    return notifier.build(
      articleId,
    );
  }

  @override
  Override overrideWith(VideoProgress Function() create) {
    return ProviderOverride(
      origin: this,
      override: VideoProgressProvider._internal(
        () => create()..articleId = articleId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        articleId: articleId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<VideoProgress,
      Map<String, Map<String, Duration>?>?> createElement() {
    return _VideoProgressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoProgressProvider && other.articleId == articleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, articleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin VideoProgressRef
    on AsyncNotifierProviderRef<Map<String, Map<String, Duration>?>?> {
  /// The parameter `articleId` of this provider.
  String get articleId;
}

class _VideoProgressProviderElement extends AsyncNotifierProviderElement<
    VideoProgress, Map<String, Map<String, Duration>?>?> with VideoProgressRef {
  _VideoProgressProviderElement(super.provider);

  @override
  String get articleId => (origin as VideoProgressProvider).articleId;
}

String _$textScaleFactorHash() => r'7b014b77314deed7dd1ae995b3387d6471891f90';

/// See also [TextScaleFactor].
@ProviderFor(TextScaleFactor)
final textScaleFactorProvider =
    NotifierProvider<TextScaleFactor, double>.internal(
  TextScaleFactor.new,
  name: r'textScaleFactorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$textScaleFactorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TextScaleFactor = Notifier<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
