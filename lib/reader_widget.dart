import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:responsive_1/models.dart';
import 'package:responsive_1/providers/data_provider.dart';
import 'package:responsive_1/video_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
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
  ScrollController customScrollViewController = ScrollController(
      // onAttach: (position) {
      //   print(
      //       "Attached, position: $position, extent: ${position.maxScrollExtent}");
      // },
      );

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          if (customScrollViewController.hasClients) {
            customScrollViewController.animateTo(
                ref.read(scrollPositionProvider(article.id)).current,
                duration: const Duration(milliseconds: 400),
                curve: Curves.bounceIn);
          } else {
            print("SCROLL CONTROLLER HAS NO CLIENTS");
          }
        },
      );
      // setState(() {
      // print(
      //     "SCROLL_INIT to PROGRESS:${ref.read(scrollProgressProvider(article.id))}; EXTENT: ${customScrollViewController.position.maxScrollExtent}");
      // customScrollViewController.animateTo(
      //     ref.read(scrollProgressProvider(article.id)) *
      //         customScrollViewController.position.maxScrollExtent,
      //     duration: const Duration(milliseconds: 500),
      //     curve: Curves.easeIn);
      // Future.delayed(
      //   const Duration(seconds: 1),
      //   () => print(
      //       "now after 1 sec, extent total: ${customScrollViewController.position.extentTotal}, ${customScrollViewController.position.maxScrollExtent}"),
      // );
      // });

      // Future.delayed(
      //     const Duration(seconds: 1),
      //     () => setState(() {
      //           customScrollViewController.animateTo(
      //               ref.read(scrollProgressProvider(article.id)) *
      //                   customScrollViewController.position.maxScrollExtent,
      //               duration: const Duration(milliseconds: 500),
      //               curve: Curves.easeIn);
      //         }));
    });
  }

  @override
  void dispose() {
    customScrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          AppbarIconButton(
                            tooltip: "Bigger Text",
                            icon: const Icon(Icons.add),
                            onPressed: () => ref
                                .read(textScaleFactorProvider.notifier)
                                .increaseSizeFactor(),
                          ),
                          AppbarIconButton(
                            tooltip: "Smaller Text",
                            icon: const Icon(CupertinoIcons.minus),
                            onPressed: () => ref
                                .read(textScaleFactorProvider.notifier)
                                .decreaseSizeFactor(),
                          ),
                          AppbarIconButton(
                            tooltip: "Highlight Selection",
                            icon: Icon(
                              CupertinoIcons.pencil,
                              color: highlightColor,
                            ),
                            onPressed: (_selection != null &&
                                    _selectedUuid != null)
                                ? () {
                                    ref
                                        .read(
                                            highlightNotifierProvider.notifier)
                                        .addHighlight(
                                          _selectedUuid!,
                                          TextRange(
                                              start: _selection!.start,
                                              end: _selection!.end),
                                        );
                                    _selection = null;
                                  }
                                : null,
                          ),
                          PopupMenuButton(
                            position: PopupMenuPosition.under,
                            constraints: const BoxConstraints(
                                minWidth: double.minPositive,
                                maxWidth: 5 * 56.0),
                            child: const AppbarIconButton(
                              tooltip: "Highlight color",
                              icon: Icon(
                                Icons.arrow_drop_down_circle_outlined,
                              ),
                              onPressed: null,
                            ),
                            itemBuilder: (context) => [
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
                          ),
                          AppbarIconButton(
                            tooltip: "Erase Highlight",
                            icon: Icon(
                              Icons.stay_current_landscape_rounded,
                              color: eraserActive ? Colors.blue : Colors.black,
                            ),
                            onPressed: () {
                              _toggleEraser();
                              debugPrint("Cursor changed: $eraserActive");
                            },
                          ),
                          AppbarIconButton(
                            tooltip: "Add Note",
                            icon: Icon(
                              Icons.note_add,
                              color: addNoteActive ? Colors.blue : Colors.black,
                            ),
                            onPressed: () {
                              _toggleAddNote();
                            },
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
                                      onPressed: () {},
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
                                    child: aboutArticleColumn(
                                        article,
                                        ref.read(
                                            selectedTagListForFilteringProvider)))
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

  Column aboutArticleColumn(Article article, List<dynamic> selectedtags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExpandedBodyRowItem(
          title: "URL",
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 15,
                child: InkWell(
                  onTap: () => _launchUrl(article.url, context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        flex: 100,
                        child: AutoSizeText(
                          article.url.length > 40
                              ? "${article.url.substring(0, 40)}..."
                              : article.url,
                          minFontSize: 12,
                          maxFontSize: 14,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          wrapWords: false,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontFamily: "DidactGothic",
                          ),
                        ),
                      ),
                      if (!isMobile)
                        const Flexible(flex: 2, child: SizedBox(width: 3)),
                      Flexible(
                          flex: 5,
                          child: FittedBox(
                            child: Icon(
                              CupertinoIcons.arrow_up_right_square,
                              size: 16,
                              color: Colors.blue[600],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              const Flexible(
                  child: SizedBox(
                width: 5,
              )),
              Flexible(
                flex: 5,
                // height: 25,
                child: FittedBox(
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Colors.white54,
                      gradient: const LinearGradient(colors: [
                        Color(0xfff9ce34),
                        Color.fromARGB(187, 238, 42, 124),
                        Color.fromARGB(169, 110, 66, 198),
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReaderScreen(article)));
                      },
                      // statesController: statesController,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(style: BorderStyle.none),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0)),
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        textStyle: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      child: const Text(
                        "Read here",
                        style: TextStyle(color: Color.fromRGBO(66, 66, 66, 1)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ExpandedBodyRowItem(
            title: "Description",
            content: AutoSizeText(
              article.description,
              minFontSize: 5,
              maxFontSize: 12,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            )),
        ExpandedBodyRowItem(
          title: "Tags",
          content: article.tags.isNotEmpty
              ? Wrap(
                  clipBehavior: Clip.antiAlias,
                  spacing: 3,
                  runSpacing: 3,
                  children: article.tags
                      .map((tagName) => Chip(
                            backgroundColor: Colors.primaries[
                                    Random().nextInt(Colors.primaries.length)]
                                .withAlpha(15),
                            side: !selectedtags.contains(tagName)
                                ? BorderSide(
                                    width: 0.2, color: Colors.grey.shade200)
                                : const BorderSide(
                                    width: 1, color: Colors.blue),
                            label: AutoSizeText(
                              tagName,
                              minFontSize: 5,
                              maxFontSize: 11,
                              style: const TextStyle(color: Colors.black87),
                            ),
                            clipBehavior: Clip.antiAlias,
                            labelStyle: const TextStyle(),
                          ))
                      .toList(),
                )
              : null,
        ),
        ExpandedBodyRowItem(
          title: "Folder path",
          content: (article.folderPath?.isNotEmpty != null &&
                  article.folderPath?.isNotEmpty == true)
              ? BreadCrumb(
                  items: article.folderPath!
                      .map((folder) => BreadCrumbItem(
                              content: AutoSizeText(
                            folder,
                            group: breadcrumbGroupAutoSize,
                            softWrap: true,
                            minFontSize: 7,
                            maxFontSize: 12,
                          )))
                      .toList(),
                  divider: const Icon(Icons.chevron_right_rounded),
                )
              : null,
        ),
        ExpandedBodyRowItem(
            title: "Progresss",
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  flex: 3,
                  child: CircularPercentIndicator(
                    radius: 23,
                    // animation: true,
                    // animationDuration: 1000,
                    center: AutoSizeText(
                      "${article.progress}%",
                      maxLines: 1,
                      minFontSize: 5,
                      maxFontSize: 11,
                      style: const TextStyle(
                          fontFamily: "DidactGothic",
                          fontWeight: FontWeight.bold),
                    ),
                    percent: article.progress / 100,
                    progressColor: getProgressColor(article.progress),
                    backgroundColor: Colors.deepPurple.shade100,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ),
                Flexible(
                  flex: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: IconAndLabel(
                            icon: Icon(
                              Icons.circle,
                              size: 15,
                              color: getProgressColor(article.progress),
                            ),
                            label: AutoSizeText(
                              "${article.progress}% progress made.",
                              maxFontSize: 12,
                              maxLines: 1,
                              minFontSize: 7,
                            )),
                      ),
                      FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 1.0),
                          child: IconAndLabel(
                            icon: const Icon(
                              Icons.access_time_rounded,
                              size: 15,
                              color: Colors.grey,
                            ),
                            label: AutoSizeText(
                              "${getFormattedDuration(article.estCompletionTime)}, est. total time",
                              maxFontSize: 12,
                              maxLines: 1,
                              minFontSize: 7,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }

  AutoSizeGroup breadcrumbGroupAutoSize = AutoSizeGroup();
  Future<void> _launchUrl(String url, BuildContext context) async {
    Uri link = Uri.parse(url);
    if (!await launchUrl(link, webOnlyWindowName: "_blank")) {
      debugPrint("Something happened while opening link $url");
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: const Text(
      //       "Could not open URL.",
      //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      //     ),
      //     content: Text("Unable to launch URL $url"),
      //     actions: [
      //       TextButton(
      //           onPressed: () => Navigator.of(context).pop(),
      //           child: const Text("OK"))
      //     ],
      //   ),
      // );
    }
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
