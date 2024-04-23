import 'package:flutter/material.dart';

const double _kPanelHeaderCollapsedHeight = kMinInteractiveDimension;
const EdgeInsets _kPanelHeaderExpandedDefaultPadding = EdgeInsets.symmetric(
  //POINT: header margins on expansion
  vertical: 54.0 - _kPanelHeaderCollapsedHeight,
);
const EdgeInsets _kExpandIconPadding = EdgeInsets.all(12.0);

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _SaltedKey<S, V> &&
        other.salt == salt &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? "<'$salt'>" : '<$salt>';
    final String valueString = V == String ? "<'$value'>" : '<$value>';
    return '[$saltString $valueString]';
  }
}

/// Signature for the callback that's called when an [MyExpansionPanel] is
/// expanded or collapsed.
///
/// The position of the panel within an [MyExpansionPanelList] is given by
/// [panelIndex].
typedef ExpansionPanelCallback = void Function(int panelIndex, bool isExpanded);

/// Signature for the callback that's called when the header of the
/// [MyExpansionPanel] needs to rebuild.
typedef ExpansionPanelHeaderBuilder = Widget Function(
    BuildContext context, bool isExpanded);

/// A material expansion panel. It has a header and a body and can be either
/// expanded or collapsed. The body of the panel is only visible when it is
/// expanded.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=2aJZzRMziJc}
///
/// Expansion panels are only intended to be used as children for
/// [MyExpansionPanelList].
///
/// See [MyExpansionPanelList] for a sample implementation.
///
/// See also:
///
///  * [MyExpansionPanelList]
///  * <https://material.io/design/components/lists.html#types>
class MyExpansionPanel {
  /// Creates an expansion panel to be used as a child for [MyExpansionPanelList].
  /// See [MyExpansionPanelList] for an example on how to use this widget.
  MyExpansionPanel({
    required this.headerBuilder,
    required this.body,
    this.isExpanded = false,
    this.hasIcon = true,
    this.canTapOnHeader = false,
    this.backgroundColor,
  });

  /// The widget builder that builds the expansion panels' header.
  final ExpansionPanelHeaderBuilder headerBuilder;

  /// The body of the expansion panel that's displayed below the header.
  ///
  /// This widget is visible only when the panel is expanded.
  final Widget body;

  /// Whether the panel is expanded.
  ///
  /// Defaults to false.
  final bool isExpanded;
  final bool hasIcon;

  /// Whether tapping on the panel's header will expand/collapse it.
  ///
  /// Defaults to false.
  final bool canTapOnHeader;

  /// Defines the background color of the panel.
  ///
  /// Defaults to [ThemeData.cardColor].
  final Color? backgroundColor;
}

/// An expansion panel that allows for radio-like functionality.
/// This means that at any given time, at most, one [MyExpansionPanelRadio]
/// can remain expanded.
///
/// A unique identifier [value] must be assigned to each panel.
/// This identifier allows the [MyExpansionPanelList] to determine
/// which [MyExpansionPanelRadio] instance should be expanded.
///
/// See [ExpansionPanelList.radio] for a sample implementation.
class MyExpansionPanelRadio extends MyExpansionPanel {
  /// An expansion panel that allows for radio functionality.
  ///
  /// A unique [value] must be passed into the constructor.
  MyExpansionPanelRadio({
    required this.value,
    required super.headerBuilder,
    required super.body,
    super.hasIcon = true,
    super.canTapOnHeader,
    super.backgroundColor,
  });

  /// The value that uniquely identifies a radio panel so that the currently
  /// selected radio panel can be identified.
  final Object value;
}

/// A material expansion panel list that lays out its children and animates
/// expansions.
///
/// The [expansionCallback] is called when the expansion state changes. For
/// normal [MyExpansionPanelList] widgets, it is the responsibility of the parent
/// widget to rebuild the [MyExpansionPanelList] with updated values for
/// [MyExpansionPanel.isExpanded]. For [ExpansionPanelList.radio] widgets, the
/// open state is tracked internally and the callback is invoked both for the
/// previously open panel, which is closing, and the previously closed panel,
/// which is opening.
///
/// {@tool dartpad}
/// Here is a simple example of how to use [MyExpansionPanelList].
///
/// ** See code in examples/api/lib/material/expansion_panel/expansion_panel_list.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [MyExpansionPanel], which is used in the [children] property.
///  * [ExpansionPanelList.radio], a variant of this widget where only one panel is open at a time.
///  * <https://material.io/design/components/lists.html#types>
class MyExpansionPanelList extends StatefulWidget {
  /// Creates an expansion panel list widget. The [expansionCallback] is
  /// triggered when an expansion panel expand/collapse button is pushed.
  const MyExpansionPanelList({
    super.key,
    this.children = const <MyExpansionPanel>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.expandedHeaderPadding = _kPanelHeaderExpandedDefaultPadding,
    this.dividerColor,
    this.elevation = 2,
    this.expandIconColor,
    this.materialGapSize = 16.0,
  })  : _allowOnlyOnePanelOpen = false,
        initialOpenPanelValue = null;

  /// Creates a radio expansion panel list widget.
  ///
  /// This widget allows for at most one panel in the list to be open. The
  /// expansion panel callback is triggered when an expansion panel
  /// expand/collapse button is pushed. The [children] objects must be instances
  /// of [MyExpansionPanelRadio].
  ///
  /// {@tool dartpad}
  /// Here is a simple example of how to implement ExpansionPanelList.radio.
  ///
  /// ** See code in examples/api/lib/material/expansion_panel/expansion_panel_list.expansion_panel_list_radio.0.dart **
  /// {@end-tool}
  const MyExpansionPanelList.radio({
    super.key,
    this.children = const <MyExpansionPanelRadio>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.initialOpenPanelValue,
    this.expandedHeaderPadding = _kPanelHeaderExpandedDefaultPadding,
    this.dividerColor,
    this.elevation = 2,
    this.expandIconColor,
    this.materialGapSize = 16.0,
  }) : _allowOnlyOnePanelOpen = true;

  /// The children of the expansion panel list. They are laid out in a similar
  /// fashion to [ListBody].
  final List<MyExpansionPanel> children;

  /// The callback that gets called whenever one of the expand/collapse buttons
  /// is pressed. The arguments passed to the callback are the index of the
  /// pressed panel and whether the panel is currently expanded or not.
  ///
  /// If [ExpansionPanelList.radio] is used, the callback may be called a
  /// second time if a different panel was previously open. The arguments
  /// passed to the second callback are the index of the panel that will close
  /// and false, marking that it will be closed.
  ///
  /// For [MyExpansionPanelList], the callback should call [State.setState] when
  /// it is notified about the closing/opening panel. On the other hand, the
  /// callback for [ExpansionPanelList.radio] is intended to inform the parent
  /// widget of changes, as the radio panels' open/close states are managed
  /// internally.
  ///
  /// This callback is useful in order to keep track of the expanded/collapsed
  /// panels in a parent widget that may need to react to these changes.
  final ExpansionPanelCallback? expansionCallback;

  /// The duration of the expansion animation.
  final Duration animationDuration;

  // Whether multiple panels can be open simultaneously
  final bool _allowOnlyOnePanelOpen;

  /// The value of the panel that initially begins open. (This value is
  /// only used when initializing with the [ExpansionPanelList.radio]
  /// constructor.)
  final Object? initialOpenPanelValue;

  /// The padding that surrounds the panel header when expanded.
  ///
  /// By default, 16px of space is added to the header vertically (above and below)
  /// during expansion.
  final EdgeInsets expandedHeaderPadding;

  /// Defines color for the divider when [MyExpansionPanel.isExpanded] is false.
  ///
  /// If [dividerColor] is null, then [DividerThemeData.color] is used. If that
  /// is null, then [ThemeData.dividerColor] is used.
  final Color? dividerColor;

  /// Defines elevation for the [MyExpansionPanel] while it's expanded.
  ///
  /// By default, the value of elevation is 2.
  final double elevation;

  /// {@macro flutter.material.ExpandIcon.color}
  final Color? expandIconColor;

  /// Defines the [MaterialGap.size] of the [MaterialGap] which is placed
  /// between the [MyExpansionPanelList.children] when they're expanded.
  ///
  /// Defaults to `16.0`.
  final double materialGapSize;

  @override
  State<StatefulWidget> createState() => _MyExpansionPanelListState();
}

class _MyExpansionPanelListState extends State<MyExpansionPanelList> {
  MyExpansionPanelRadio? _currentOpenPanel;

  @override
  void initState() {
    super.initState();
    if (widget._allowOnlyOnePanelOpen) {
      assert(_allIdentifiersUnique(),
          'All ExpansionPanelRadio identifier values must be unique.');
      if (widget.initialOpenPanelValue != null) {
        _currentOpenPanel = searchPanelByValue(
            widget.children.cast<MyExpansionPanelRadio>(),
            widget.initialOpenPanelValue);
      }
    }
  }

  @override
  void didUpdateWidget(MyExpansionPanelList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget._allowOnlyOnePanelOpen) {
      assert(_allIdentifiersUnique(),
          'All ExpansionPanelRadio identifier values must be unique.');
      // If the previous widget was non-radio ExpansionPanelList, initialize the
      // open panel to widget.initialOpenPanelValue
      if (!oldWidget._allowOnlyOnePanelOpen) {
        _currentOpenPanel = searchPanelByValue(
            widget.children.cast<MyExpansionPanelRadio>(),
            widget.initialOpenPanelValue);
      }
    } else {
      _currentOpenPanel = null;
    }
  }

  bool _allIdentifiersUnique() {
    final Map<Object, bool> identifierMap = <Object, bool>{};
    for (final MyExpansionPanelRadio child
        in widget.children.cast<MyExpansionPanelRadio>()) {
      identifierMap[child.value] = true;
    }
    return identifierMap.length == widget.children.length;
  }

  bool _isChildExpanded(int index) {
    if (widget._allowOnlyOnePanelOpen) {
      final MyExpansionPanelRadio radioWidget =
          widget.children[index] as MyExpansionPanelRadio;
      return _currentOpenPanel?.value == radioWidget.value;
    }
    return widget.children[index].isExpanded;
  }

  void _handlePressed(bool isExpanded, int index) {
    if (widget._allowOnlyOnePanelOpen) {
      final MyExpansionPanelRadio pressedChild =
          widget.children[index] as MyExpansionPanelRadio;

      // If another ExpansionPanelRadio was already open, apply its
      // expansionCallback (if any) to false, because it's closing.
      for (int childIndex = 0;
          childIndex < widget.children.length;
          childIndex += 1) {
        final MyExpansionPanelRadio child =
            widget.children[childIndex] as MyExpansionPanelRadio;
        if (widget.expansionCallback != null &&
            childIndex != index &&
            child.value == _currentOpenPanel?.value) {
          widget.expansionCallback!(childIndex, false);
        }
      }

      setState(() {
        _currentOpenPanel = isExpanded ? null : pressedChild;
      });
    }
    // !isExpanded is passed because, when _handlePressed, the state of the panel to expand is not yet expanded.
    widget.expansionCallback?.call(index, !isExpanded);
  }

  MyExpansionPanelRadio? searchPanelByValue(
      List<MyExpansionPanelRadio> panels, Object? value) {
    for (final MyExpansionPanelRadio panel in panels) {
      if (panel.value == value) {
        return panel;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      kElevationToShadow.containsKey(widget.elevation),
      'Invalid value for elevation. See the kElevationToShadow constant for'
      ' possible elevation values.',
    );

    final List<MergeableMaterialItem> items = <MergeableMaterialItem>[];

    for (int index = 0; index < widget.children.length; index += 1) {
      //POINT: expanded margin to top:(alter in size parameter)
      if (_isChildExpanded(index) &&
          index != 0 &&
          !_isChildExpanded(index - 1)) {
        items.add(MaterialGap(
            key: _SaltedKey<BuildContext, int>(context, index * 2 - 1),
            size: 5)); //widget.materialGapSize));
      }

      final MyExpansionPanel child = widget.children[index];
      final Widget headerWidget = child.headerBuilder(
        context,
        _isChildExpanded(index),
      );

      Widget expandIconContainer = Container(
        margin: const EdgeInsetsDirectional.only(end: 8.0),
        child: ExpandIcon(
          color: widget.expandIconColor,
          isExpanded: _isChildExpanded(index),
          padding: _kExpandIconPadding,
          onPressed: !child.canTapOnHeader
              ? (bool isExpanded) => _handlePressed(isExpanded, index)
              : null,
        ),
      );
      if (!child.canTapOnHeader) {
        final MaterialLocalizations localizations =
            MaterialLocalizations.of(context);
        expandIconContainer = Semantics(
          label: _isChildExpanded(index)
              ? localizations.expandedIconTapHint
              : localizations.collapsedIconTapHint,
          container: true,
          child: expandIconContainer,
        );
      }
      Widget header = Row(
        children: <Widget>[
          Expanded(
            child: AnimatedContainer(
              duration: widget.animationDuration,
              curve: Curves.fastOutSlowIn,
              margin: _isChildExpanded(index)
                  ? widget.expandedHeaderPadding
                  : EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    minHeight: _kPanelHeaderCollapsedHeight),
                child: headerWidget,
              ),
            ),
          ),
          Container(
            child: child.hasIcon ? expandIconContainer : null,
          ),
        ],
      );
      if (child.canTapOnHeader) {
        header = MergeSemantics(
          child: InkWell(
            onTap: () => _handlePressed(_isChildExpanded(index), index),
            child: header,
          ),
        );
      }
      items.add(
        MaterialSlice(
          key: _SaltedKey<BuildContext, int>(context, index * 2),
          color: child.backgroundColor,
          child: Column(
            children: <Widget>[
              header,
              AnimatedCrossFade(
                firstChild: Container(height: 0.0),
                secondChild: child.body,
                firstCurve:
                    const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                secondCurve:
                    const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                sizeCurve: Curves.fastOutSlowIn,
                crossFadeState: _isChildExpanded(index)
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: widget.animationDuration,
              ),
            ],
          ),
        ),
      );
      //POINT: expanded bottom gap (alter size parameter)
      if (_isChildExpanded(index) && index != widget.children.length - 1) {
        items.add(MaterialGap(
            key: _SaltedKey<BuildContext, int>(context, index * 2 + 1),
            size: 5)); //widget.materialGapSize));
      }
    }
    //POINT: alter shadow from the elevation provided below
    return MergeableMaterial(
      hasDividers: true,
      dividerColor: widget.dividerColor,
      elevation: 0.2, //widget.elevation,
      children: items,
    );
  }
}
