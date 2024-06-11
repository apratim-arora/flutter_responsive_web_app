import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:photo_view/photo_view.dart';
import 'package:responsive_1/models.dart';
import 'package:responsive_1/providers/data_provider.dart';
import 'package:responsive_1/video_widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'widgets.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen(this.article, {super.key});
  final Article article;
  final String htmlContent = '''
<html>
<body>
  <article>
    <h1>Sample Article</h1>
    <p>This is a paragraph with some sample content.<br>The Next Line</p>
    <h2>List Example</h2>
    <ul>
      <li>List item 1</li>
      <li>List item 2</li>
      <li>List item 3</li>
    </ul>
    <h2>Table Example</h2>
    <table border="1">
      <tr>
        <th>Header 1</th>
        <th>Header 2</th>
      </tr>
      <tr>
        <td>Data 1</td>
        <td>Data 2</td>
      </tr>
    </table>
    <h2>Image Example</h2>
    <p><img src="https://hips.hearstapps.com/hmg-prod/images/bright-forget-me-nots-royalty-free-image-1677788394.jpg" alt="Flowers image"></p>
    <h2>IFrame Example</h2>
    <p><iframe width="420" height="345" src="https://www.youtube.com/embed/dQw4w9WgXcQ"></iframe></p>
    </ul>
    <h2>Video Example</h2>
    <video width="320" height="240" controls>
  <source src="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4" type="video/mp4">
  Your browser does not support the video tag.
  <figcaption> Hello World</figcaption>
</video>
<h2>Another Video Example</h2>
    <video width="320" height="240" controls>
  <source src="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4" type="video/mp4">
  Your browser does not support the video tag.
  <figcaption> Hello World</figcaption>
</video>
<p><img src="https://www.shutterstock.com/shutterstock/photos/2056485080/display_1500/stock-vector-address-and-navigation-bar-icon-business-concept-search-www-http-pictogram-d-concept-2056485080.jpg" alt="Flowers image"></p>
  </article>
</body>
</html>
''';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  TextSelection? _selection;
  String? _selectedUuid;
  late Article article;
  final Uuid uuid = const Uuid();
  bool eraserActive = false;
  late bool isMobile;
  bool addNoteActive = false;
  Size mainContainerSize = const Size(0, 0);
  late CustomWidgetFactory widgetFactory;
  ScrollController customScrollViewController = ScrollController();

  void updateMainContainerSize(Size size) {
    debugPrint("Updating mainContainerSize");
    setState(() {
      mainContainerSize = size;
    });
  }

  void _toggleEraser({bool? value}) {
    setState(() {
      eraserActive = value ?? !eraserActive;
      if (eraserActive) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Highlight eraser active'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Highlight eraser Inactive'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _toggleAddNote({bool? value}) {
    setState(() {
      addNoteActive = value ?? !addNoteActive;
    });
    if (addNoteActive) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Click anywhere add a note."),
        duration: Duration(seconds: 2),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Notes adding mode off."),
        duration: Duration(seconds: 2),
      ));
    }
  }

  String generateUuidFromContent(String content, int position) {
    return uuid.v5(Uuid.NAMESPACE_URL, '$content-$position');
  }

  void _onSelectionChanged(TextSelection selection,
      SelectionChangedCause? cause, String? selectedUuid) {
    setState(() {
      _selection = selection;
      _selectedUuid = selectedUuid;
      debugPrint("Selected UUID:$selectedUuid");
      if (eraserActive && _selectedUuid != null && _selection != null) {
        ref
            .read(highlightNotifierProvider.notifier)
            .removeHighlight(_selectedUuid!, _selection!.baseOffset);
      }
    });
    debugPrint(
        "FUNCTION:selection var update offset= (${selection.baseOffset},${selection.extentOffset}), position:(${selection.start},${selection.end})");
  }

  Future<void> _addNoteAtPosition(
      Offset position, Size contentContainerSize) async {
    final xPercent = (position.dx * 100) / contentContainerSize.width;
    final yPercent = (position.dy * 100) / contentContainerSize.height;

    showDialog(
      context: context,
      builder: (context) => AddNoteDialog((noteText, iconImageIndex) {
        if (noteText.isNotEmpty) {
          final Note newNote = Note(
            id: uuid.v4(),
            iconImageIndex: iconImageIndex,
            text: noteText,
            xPercent: xPercent,
            yPercent: yPercent,
          );
          ref.read(notesNotifierProvider(article.id).notifier).addNote(newNote);
          setState(() {
            addNoteActive = false;
          });
        }
      }),
    );
  }

  Future<void> _editNoteText(Note note) async {
    showDialog(
      context: context,
      builder: (context) => AddNoteDialog(
        noteForEditing: note,
        onDelete: () => ref
            .read(notesNotifierProvider(article.id).notifier)
            .deleteNote(note),
        (noteText, iconImageIndex) {
          Note updatedNote =
              note.copyWith(text: noteText, iconImage: iconImageIndex);
          ref
              .read(notesNotifierProvider(article.id).notifier)
              .editNote(updatedNote);
          setState(() {
            addNoteActive = false;
          });
        },
      ),
    );
  }

  // Widget to display notes
  List<Widget> _buildNotesOverlay(Size size) {
    final overlayWidth = size.width; //constraints.maxWidth;
    final overlayHeight = size.height; //constraints.maxHeight;
    debugPrint("NOTES-OVERLAY-SIZE: $overlayWidth, $overlayHeight");
    return ref.read(notesNotifierProvider(article.id)).map((note) {
      final xPos = overlayWidth * note.xPercent / 100;
      final yPos = overlayHeight * note.yPercent / 100;
      return Positioned(
        left: xPos,
        top: yPos,
        child: GestureDetector(
            onTap: () => _editNoteText(note),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Tooltip(
                  message: note.text,
                  child: SizedBox(
                    width: 38,
                    child: Image.asset(
                        "assets/images/note_image/note_image_${note.iconImageIndex}.png"),
                  )),
            )),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    article = widget.article;
    widgetFactory =
        CustomWidgetFactory(_onSelectionChanged, ref, _selectedUuid, article);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          if (customScrollViewController.hasClients) {
            double progress = ref.read(scrollProgressProvider(article.id)) *
                customScrollViewController.position.maxScrollExtent;
            double mark =
                0.05 * customScrollViewController.position.maxScrollExtent;
            print(
                "SCROLL HAS CLIENT, SCROLL TO: (${ref.read(scrollProgressProvider(article.id))}%)*${customScrollViewController.position.maxScrollExtent}=${ref.read(scrollProgressProvider(article.id)) * customScrollViewController.position.maxScrollExtent}");

            if (progress > mark) {
              customScrollViewController
                  .animateTo(mark,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.bounceIn)
                  .then(
                    (value) => customScrollViewController.jumpTo(progress),
                  );
            } else {
              customScrollViewController.animateTo(progress,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceIn);
            }
          } else {
            print("SCROLL CONTROLLER HAS NO CLIENTS");
          }
        },
      );
    });
  }

  @override
  void dispose() {
    customScrollViewController.dispose();
    super.dispose();
  }

  bool isSelected2 = false;
  @override
  Widget build(BuildContext context) {
    ref.listen<FutureOr<String>>(combinedProgressProvider(article.id).future,
        (_, val) async {
      ///listener made just to have provider instantiated, to show progress in logs.
    });
    isMobile = MediaQuery.of(context).size.width < 600;
    double screenHeight = MediaQuery.of(context).size.height;
    final highlights = ref.watch(highlightNotifierProvider);
    final scaleFactor = ref.watch(textScaleFactorProvider);
    final highlightColor = ref.watch(highLightColorProvider);
    final notes = ref.watch(notesNotifierProvider(article.id));
    debugPrint("Notes: $notes");
    ref.watch(textScaleFactorProvider);
    debugPrint(
        "BUILT: highlights = $highlights\t selectionOffset: (${_selection?.baseOffset},${_selection?.extentOffset}), pos: (${_selection?.start},${_selection?.end})");

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const MyAnimatedBackground(),
          ScrollListener(
            article: article,
            widgetFactory: widgetFactory,
            child: CustomScrollView(
              controller: customScrollViewController,
              slivers: [
                SliverAppBar(
                  leading: const Icon(Icons.arrow_back),
                  floating: true,
                  snap: true,
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffAEC6F6),
                          Color.fromARGB(255, 115, 161, 254)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Align(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ReaderAppbarIcon(
                            icon: Padding(
                              padding: const EdgeInsets.all(2.5),
                              child: Image.asset(
                                "assets/images/icons/marker.png",
                                fit: BoxFit.scaleDown,
                                color: Colors.white,
                                width: 19.5,
                                height: 19.5,
                              ),
                            ),
                            tooltip: "Highlight Selection",
                            dropdownItemList: [
                              PopupMenuItem(
                                onTap: () => ref
                                    .read(highLightColorProvider.notifier)
                                    .updateColor(Colors.yellow),
                                child: const ColorSelectionDropdownItem(
                                    Colors.yellow),
                              ),
                              PopupMenuItem(
                                onTap: () => ref
                                    .read(highLightColorProvider.notifier)
                                    .updateColor(Colors.red),
                                child: const ColorSelectionDropdownItem(
                                    Colors.red),
                              ),
                              PopupMenuItem(
                                onTap: () => ref
                                    .read(highLightColorProvider.notifier)
                                    .updateColor(Colors.green),
                                child: const ColorSelectionDropdownItem(
                                    Colors.green),
                              ),
                              PopupMenuItem(
                                onTap: () => ref
                                    .read(highLightColorProvider.notifier)
                                    .updateColor(Colors.blue),
                                child: const ColorSelectionDropdownItem(
                                    Colors.blue),
                              ),
                            ],
                            onTap: () {
                              if (_selection != null && _selectedUuid != null) {
                                ref
                                    .read(highlightNotifierProvider.notifier)
                                    .addHighlight(
                                      _selectedUuid!,
                                      TextRange(
                                          start: _selection!.start,
                                          end: _selection!.end),
                                    );
                                _selection = null;
                              }
                            },
                            highlightColor: highlightColor,
                            isSelected: true,
                          ),
                          ReaderAppbarIcon(
                            icon: Padding(
                              padding: const EdgeInsets.all(2.5),
                              child: Image.asset(
                                "assets/images/icons/eraser.png",
                                fit: BoxFit.scaleDown,
                                color: Colors.white,
                                width: 18,
                                height: 18,
                              ),
                            ),
                            tooltip: "Erase Highlight",
                            isSelected: eraserActive,
                            onTap: () {
                              _toggleEraser();
                              debugPrint("Cursor changed: $eraserActive");
                            },
                          ),
                          // const SizedBox(width: 15),
                          ReaderAppbarIcon(
                            icon: Image.asset(
                              "assets/images/icons/text_increase.png",
                              fit: BoxFit.scaleDown,
                              color: Colors.white,
                              width: 24,
                              height: 24,
                            ),
                            tooltip: "Increase Text Size",
                            isSelected: false,
                            onTap: () => ref
                                .read(textScaleFactorProvider.notifier)
                                .increaseSizeFactor(),
                          ),
                          ReaderAppbarIcon(
                              icon: Image.asset(
                                "assets/images/icons/text_decrease.png",
                                fit: BoxFit.scaleDown,
                                color: Colors.white,
                                width: 24,
                                height: 24,
                              ),
                              tooltip: "Decrease Text Size",
                              // makeDivider: false,
                              isSelected: false,
                              onTap: () => ref
                                  .read(textScaleFactorProvider.notifier)
                                  .decreaseSizeFactor()),
                          // const SizedBox(width: 15),
                          ReaderAppbarIcon(
                            icon: Padding(
                              padding: const EdgeInsets.all(2.5),
                              child: Image.asset(
                                "assets/images/icons/add_note.png",
                                fit: BoxFit.scaleDown,
                                color: Colors.white,
                                width: 18,
                                height: 18,
                              ),
                            ),
                            tooltip: "Add a Note",
                            isSelected: addNoteActive,
                            onTap: () => _toggleAddNote(),
                            makeDivider: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: GlassContainer(
                            margin: const EdgeInsets.only(right: 5, left: 15),
                            padding: const EdgeInsets.all(9),
                            topBorderRadius: 12,
                            allowBottomRadius: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SplitScreenTitle(
                                  text: "About",
                                  iconData: Icons.info_outline,
                                  trailing: IconButton.outlined(
                                      style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.grey)),
                                      color: Colors.blue,
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            icon: const Icon(
                                              Icons.edit_square,
                                              size: 36,
                                            ),
                                            iconColor: Colors.blue,
                                            iconPadding:
                                                const EdgeInsets.all(8),
                                            title: const Text(
                                                "Dialog/Screen to edit Article Meta Data"),
                                            content: const SizedBox(
                                              height: 250,
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text("Cancel")),
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text("Save"))
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 20,
                                      )),
                                ),
                                const SizedBox(height: 7),
                                Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff4f4f4),
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Colors.grey[350]!,
                                      ),
                                    ),
                                    child: AboutArticleContainer(article))
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: GlassContainer(
                              padding: const EdgeInsets.all(9),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              topBorderRadius: 12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SplitScreenTitle(
                                      text: "Article",
                                      iconData: Icons.article_outlined),
                                  const SizedBox(height: 7),
                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    constraints: BoxConstraints(
                                      minHeight: screenHeight * 0.8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff4f4f4),
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Colors.grey[350]!,
                                      ),
                                    ),
                                    child: DefaultTabController(
                                      length: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const TabBar(
                                            isScrollable: true,
                                            tabAlignment: TabAlignment.start,
                                            indicatorColor: Colors.blue,
                                            tabs: [
                                              Tab(text: "Article"),
                                              Tab(text: "Highlights"),
                                              Tab(text: "Summary"),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          MeasureSize(
                                            onChange: (size) =>
                                                updateMainContainerSize(size),
                                            child: Stack(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: HtmlWidget(
                                                  widget.htmlContent,
                                                  customWidgetBuilder:
                                                      (element) {
                                                    final position = element
                                                            .parent?.children
                                                            .indexOf(element) ??
                                                        0;
                                                    final content =
                                                        element.outerHtml;
                                                    element.attributes[
                                                            'data-uuid'] =
                                                        generateUuidFromContent(
                                                            content, position);
                                                    return null;
                                                  },
                                                  factoryBuilder: () =>
                                                      widgetFactory,
                                                  onTapUrl: (url) {
                                                    debugPrint('tapped $url');
                                                    return false;
                                                  },
                                                  textStyle: TextStyle(
                                                      fontSize:
                                                          14 * scaleFactor),
                                                  rebuildTriggers: [
                                                    highlights,
                                                    scaleFactor
                                                  ],
                                                ),
                                              ),
                                              // ..._buildNotesOverlay(constraints),
                                              ..._buildNotesOverlay(
                                                  mainContainerSize),
                                              if (addNoteActive)
                                                Positioned.fill(
                                                    child: MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.copy,
                                                  child: GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTapUp: (details) {
                                                      _addNoteAtPosition(
                                                          details.localPosition,
                                                          mainContainerSize);
                                                    },
                                                    child: Container(
                                                      color: Colors.black12,
                                                    ),
                                                  ),
                                                )),
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                        onPressed: () {},
                                        child: const Text("Read ")),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ProgressBar(article: article),
        ],
      ),
    );
  }

  //to remove inline tags from html content
  String removeInlineTags(String htmlContent) {
    // Parse the HTML content
    final document = html_parser.parse(htmlContent);

    // Function to recursively process each node
    String processNode(dom.Node node) {
      // If it's an element and not a text node
      if (node.nodeType == dom.Node.ELEMENT_NODE) {
        final element = node as dom.Element;

        // If the element is a block-level element, keep it but process its children
        if ([
          'p',
          'div',
          'h1',
          'h2',
          'h3',
          'h4',
          'h5',
          'h6',
          'article',
          'section'
        ].contains(element.localName)) {
          // Recursively process child nodes and reconstruct the element without inline children
          final childContent =
              element.nodes.map((child) => processNode(child)).join('');
          return '<${element.localName}>$childContent</${element.localName}>';
        } else {
          // If it's an inline element, return its text content only
          return element.text;
        }
      } else if (node.nodeType == dom.Node.TEXT_NODE) {
        // If it's a text node, return its text
        return node.text!;
      }
      return '';
    }

    // Process each node in the body and reconstruct the HTML
    final processedContent =
        document.body!.nodes.map((node) => processNode(node)).join('');

    return processedContent;
  }
}

class CustomWidgetFactory extends WidgetFactory {
  final void Function(TextSelection, SelectionChangedCause?, String? uuid)
      onSelectionChanged;
  final WidgetRef ref;
  final String? selectedUuid;
  final Article article;
  final List<GlobalKey> textKeys = [], imageKeys = [];

  final Map<GlobalKey, String> textContents = {};

  CustomWidgetFactory(
      this.onSelectionChanged, this.ref, this.selectedUuid, this.article);

  @override
  Widget? buildText(
      BuildTree tree, InheritedProperties resolved, InlineSpan text) {
    //progress tracking part
    final key = GlobalKey();
    textKeys.add(key);
    textContents[key] = text.toPlainText();
    //rest
    final uuid = tree.element.attributes['data-uuid'];
    if (uuid == null) return null;
    final Map<String, List<Highlight>> highlights =
        ref.read(highlightNotifierProvider);
    return SelectableText.rich(
      key: key, //adding key for progress char based progress tracking
      TextSpan(
        children: _buildHighlightedSpans(text as TextSpan, highlights, uuid),
      ),
      // contextMenuBuilder: for making options like copy/select all
      onSelectionChanged: (selection, cause) =>
          onSelectionChanged(selection, cause, uuid),
    );
  }

  List<InlineSpan> _buildHighlightedSpans(
      TextSpan textSpan, Map<String, List<Highlight>> highlights, String uuid) {
    debugPrint("_buildHighlightedSpan function ran");
    List<InlineSpan> spans = [];
    int currentIndex = 0;
    String text = textSpan.text ?? '';
    if (!highlights.containsKey(uuid)) {
      return [textSpan];
    }
    debugPrint("TEXT=$text, highlights=$highlights");

    // Sort the highlights by their start position
    var sortedHighlights = highlights[uuid]!
      ..sort((a, b) =>
          a.range.start.compareTo(b.range.start)); //returing empty list
    debugPrint("Sorted Highlights: $sortedHighlights");

    for (var highlights in sortedHighlights) {
      final range = highlights.range;
      final color = highlights.color;

      debugPrint(
          "Entered in loop for all highlighted entries.\n CUrrentrange = $range");

      // Add unhighlighted text before the highlight
      if (range.start > currentIndex) {
        debugPrint(
            "span BEFORE highlight: ${text.substring(currentIndex, range.start)}");
        spans.add(TextSpan(
          text: text.substring(currentIndex, range.start),
          style: textSpan.style,
        ));
      }

      // Add the highlighted text
      debugPrint("HIGHLIGHTED span: ${text.substring(range.start, range.end)}");
      spans.add(TextSpan(
        text: text.substring(range.start, range.end),
        style: textSpan.style?.copyWith(backgroundColor: color),
      ));

      currentIndex = range.end;
    }

    // Add any remaining unhighlighted text
    if (currentIndex < text.length) {
      debugPrint("AFTER highlight span: ${text.substring(currentIndex)}");
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: textSpan.style,
      ));
    }
    String output = "";
    for (final span in spans) {
      output += "${span.toPlainText()}[fontSIze:${span.style?.fontSize}]";
    }
    debugPrint("Final spans returned : $output");
    return spans;
  }

  @override
  Widget? buildVideoPlayer(BuildTree tree, String url,
      {required bool autoplay,
      required bool controls,
      double? height,
      required bool loop,
      String? posterUrl,
      double? width}) {
    String uuid = tree.element.attributes["data-uuid"]!;
    return DirectVideoPlayer(
      url: url,
      articleId: article.id,
      videoUuid: uuid,
    );
  }

  @override
  Widget? buildImage(BuildTree tree, ImageMetadata data) {
    return Container(
        height: 250,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: super.buildImage(tree, data));
  }

  @override
  Widget buildImageWidget(BuildTree tree, ImageSource src) {
    final built = super.buildImageWidget(tree, src);
    final key = GlobalKey();
    imageKeys.add(key);
    if (built is Image) {
      final url = src.url;
      return Builder(
        key: key,
        builder: (context) => GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(
                  title: const Text("Full-Screen Image View"),
                  foregroundColor: Colors.white,
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffAEC6F6),
                          Color.fromARGB(255, 115, 161, 254)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                body: PhotoView(
                  heroAttributes: PhotoViewHeroAttributes(tag: url),
                  imageProvider: built.image,
                ),
              ),
            ),
          ),
          child: Hero(tag: url, child: built),
        ),
      );
    }

    return built ?? const SizedBox.shrink();
  }

  @override
  Widget? buildWebView(BuildTree tree, String url,
      {double? height, Iterable<String>? sandbox, double? width}) {
    print("BUILDING WEBVIEW URL: $url");
    print("SANDBOX: $sandbox\n tag: ${tree.element.attributeSpans}");
    return super.buildWebView(tree, url,
        height: height, sandbox: sandbox, width: width);
  }
  // @override
  // void parse(BuildTree tree) {
  //   if (tree.element.classes.contains('image')) {
  //     tree.register(BuildOp(defaultStyles: (_) => {'margin': '1em 0'}));
  //   }

  //   super.parse(tree);
  // }
}
