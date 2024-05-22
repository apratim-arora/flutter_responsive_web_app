import 'package:animate_gradient/animate_gradient.dart';
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
    <p>This is a paragraph with <b>bold text</b> and <i>italic text</i>.</p>
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
    <h2>Video Example</h2>
    <p><iframe width="420" height="345" src="https://www.youtube.com/embed/dQw4w9WgXcQ"></iframe></p>
    <video width="320" height="240" controls>
  <source src="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4" type="video/mp4">
  Your browser does not support the video tag.
  <figcaption> Hello World</figcaption>
</video>
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
  final Uuid uuid = const Uuid();

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

  void _onSelectionChanged(TextSelection selection,
      SelectionChangedCause? cause, String? selectedUuid) {
    setState(() {
      _selection = selection;
      _selectedUuid = selectedUuid;
      debugPrint("Selected UUID:$selectedUuid");
    });
    debugPrint(
        "FUNCTION:selection var update offset= (${selection.baseOffset},${selection.extentOffset}), position:(${selection.start},${selection.end})");
  }

  String generateUuidFromContent(String content, int position) {
    return uuid.v5(Uuid.NAMESPACE_URL, '$content-$position');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final highlights = ref.watch(highlightNotifierProvider);
    final videoProgress = ref.watch(videoProgressProvider(widget.article.id));
    debugPrint(
        "BUILT: highlights = $highlights\t selectionOffset: (${_selection?.baseOffset},${_selection?.extentOffset}), pos: (${_selection?.start},${_selection?.end})");
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnimateGradient(
        primaryBegin: Alignment.bottomRight,
        primaryEnd: Alignment.topRight,
        secondaryBegin: Alignment.topRight,
        secondaryEnd: Alignment.bottomLeft,
        primaryColors: const [
          Color(0xffff7f50),
          Color.fromARGB(255, 194, 129, 255),
        ],
        secondaryColors: const [
          Color(0xff00ffff),
          Color.fromARGB(255, 54, 190, 165),
        ],
        duration: const Duration(seconds: 10),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: const Icon(Icons.arrow_back),
              floating: true,
              snap: true,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      // Color(0xff21d7e7),
                      // Color(0xff2386f4)
                      Color(0xffAEC6F6),
                      Color.fromARGB(255, 115, 161, 254)
                    ], //[Color(0xffe0e1e7), Color(0xfff5f6f8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
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
                            const SplitScreenTitle(
                                text: "About", iconData: Icons.info_outline),
                            const SizedBox(height: 7),
                            Container(
                              clipBehavior: Clip.antiAlias,
                              height: 300,
                              decoration: BoxDecoration(
                                color: const Color(0xfff4f4f4),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.grey[350]!,
                                ),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [],
                              ),
                            )
                          ],
                        ),
                      ),
                      //  BackdropFilter(
                      //   filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      //   child: Container(
                      //     margin: const EdgeInsets.only(right: 5),
                      //     height: 300,
                      //     decoration: BoxDecoration(
                      //       // color: const Color(0xfff4f4f4),
                      //       color: Colors.white.withOpacity(0.25),
                      //       borderRadius: BorderRadius.circular(7),
                      //       // boxShadow: const [
                      //       //   BoxShadow(
                      //       //     offset: Offset(0, 5),
                      //       //     blurRadius: 6,
                      //       //     spreadRadius: -8,
                      //       //   ),
                      //       // ]
                      //       gradient: LinearGradient(
                      //         colors: [
                      //           Colors.white.withOpacity(0.8),
                      //           Colors.white.withOpacity(0.6),
                      //         ],
                      //         begin: AlignmentDirectional.topStart,
                      //         end: AlignmentDirectional.bottomEnd,
                      //       ),
                      //     ),
                      //     child: const Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: <Widget>[
                      //         Text('Tags: Tag1, Tag2, Tag3'),
                      //         Divider()
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ),
                    Expanded(
                        flex: 3,
                        child: GlassContainer(
                          padding: const EdgeInsets.all(9),
                          margin: const EdgeInsets.symmetric(horizontal: 15),
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
                                    minHeight: screenHeight * 0.8),
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
                                      Align(
                                        child: ElevatedButton(
                                            onPressed: _selection != null &&
                                                    _selectedUuid != null
                                                ? () {
                                                    const color = Colors.red;
                                                    ref
                                                        .read(
                                                            highlightNotifierProvider
                                                                .notifier)
                                                        .addHighlight(
                                                            _selectedUuid!,
                                                            TextRange(
                                                                start:
                                                                    _selection!
                                                                        .start,
                                                                end: _selection!
                                                                    .end),
                                                            color);
                                                    _selection = null;
                                                    debugPrint(
                                                        "CLICKED: selection must be updated, check build below");
                                                  }
                                                : null,
                                            child: const Text(
                                                'Highlight Selected Text')),
                                      ),
                                      const SizedBox(height: 20),
                                      HtmlWidget(
                                        widget
                                            .htmlContent, //widget.htmlContent,
                                        enableCaching: false,
                                        customWidgetBuilder: (element) {
                                          final position = element
                                                  .parent?.children
                                                  .indexOf(element) ??
                                              0;
                                          final content = element.outerHtml;
                                          element.attributes['data-uuid'] =
                                              generateUuidFromContent(
                                                  content, position);
                                          return null;
                                        },
                                        factoryBuilder: () =>
                                            CustomWidgetFactory(
                                          _onSelectionChanged,
                                          ref,
                                          _selectedUuid,
                                          widget.article,
                                        ),
                                        onTapUrl: (url) {
                                          debugPrint('tapped $url');
                                          return false;
                                        },
                                        textStyle:
                                            const TextStyle(fontSize: 14),
                                        rebuildTriggers: [highlights],
                                      ),
                                    ],
                                  ),
                                ),
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
    );
  }
}

class CustomWidgetFactory extends WidgetFactory {
  final void Function(TextSelection, SelectionChangedCause?, String? uuid)
      onSelectionChanged;
  final WidgetRef ref;
  final String? selectedUuid;
  final Article article;

  CustomWidgetFactory(
      this.onSelectionChanged, this.ref, this.selectedUuid, this.article);

  @override
  Widget? buildText(
      BuildTree tree, InheritedProperties resolved, InlineSpan text) {
    final uuid = tree.element.attributes['data-uuid'];
    if (uuid == null) return null;
    final Map<String, List<Highlight>> highlights =
        ref.read(highlightNotifierProvider);
    return SelectableText.rich(
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
        style: textSpan.style?.copyWith(
            backgroundColor: color), //TextStyle( backgroundColor: color)
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

    if (built is Image) {
      final url = src.url;
      return Builder(
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

  // @override
  // void parse(BuildTree tree) {
  //   if (tree.element.classes.contains('image')) {
  //     tree.register(BuildOp(defaultStyles: (_) => {'margin': '1em 0'}));
  //   }

  //   super.parse(tree);
  // }
}
