import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_1/constants.dart';
import 'package:responsive_1/models.dart';
import 'package:responsive_1/providers/data_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class DirectVideoPlayer extends ConsumerStatefulWidget {
  final String url;
  final String articleId;
  final String videoUuid;
  const DirectVideoPlayer(
      {super.key,
      required this.url,
      required this.articleId,
      required this.videoUuid});

  @override
  DirectVideoPlayerState createState() => DirectVideoPlayerState();
}

class DirectVideoPlayerState extends ConsumerState<DirectVideoPlayer> {
  late VideoPlayerController _controller;
  late String articleId, videoUuid;
  late Duration? resumePoint;
  bool pastProgressLoaded = false;
  int i = 0;

  @override
  void initState() {
    super.initState();
    articleId = widget.articleId;
    videoUuid = widget.videoUuid;
    resumePoint = ref
        .read(videoProgressProvider(articleId).notifier)
        .getVideoProgress(videoUuid)?[videoCurrentPosition];
    articleId = widget.articleId;
    videoUuid = widget.videoUuid;
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {
          if (resumePoint != null) _controller.seekTo(resumePoint!);
          pastProgressLoaded = true;
        });
      })
      ..addListener(_updateWatchedProgress);
  }

  void _updateWatchedProgress() {
    setState(() {});
    if (i % 5 == 0) {
      if (!pastProgressLoaded) return; //important as pos
      final position = _controller.value.position;
      final duration = _controller.value.duration;

      ref
          .read(videoProgressProvider(articleId).notifier)
          .updateVideoProgress(videoUuid, position, duration);
      // ref.read(videoProgressProvider(articleId)).whenData((value) => debugPrint(
      //     "UPDATED VIDEO PROGRESS: $position, @videoUUID:$videoUuid\tproviderValue: $value"));
    }
    i++;
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen(videoProgressProvider(widget.articleId), (previous, next) {
    //   next.whenData((value) {
    //     Duration? progress = value?[widget.videoUuid]?[videoCurrentPosition];
    //     if (progress != null) {
    //       _controller.seekTo(progress);
    //       print("ref.listen worked");
    //     }
    //   });
    // });
    return SizedBox(
      width: 520,
      child: Column(
        children: [
          _controller.value.isInitialized
              ? Hero(
                  tag: videoUuid,
                  child: Material(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          VideoPlayer(_controller),
                          // ClosedCaption(text: _controller.value.caption.text),
                          _ControlsOverlay(
                              articleId: articleId,
                              videoUuid: videoUuid,
                              controller: _controller,
                              isFullScreen: false),
                          VideoProgressIndicator(_controller,
                              allowScrubbing: true),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
          // Displaying the watched percentage
        ],
      ),
    );
  }

  @override
  void dispose() {
    // _controller.removeListener(_updateWatchedProgress);
    _controller.dispose();
    super.dispose();
  }
}

class _ControlsOverlay extends ConsumerWidget {
  const _ControlsOverlay(
      {required this.controller,
      required this.isFullScreen,
      required this.articleId,
      required this.videoUuid});

  // static const List<Duration> _exampleCaptionOffsets = <Duration>[
  //   Duration(seconds: -10),
  //   Duration(seconds: -3),
  //   Duration(seconds: -1, milliseconds: -500),
  //   Duration(milliseconds: -250),
  //   Duration.zero,
  //   Duration(milliseconds: 250),
  //   Duration(seconds: 1, milliseconds: 500),
  //   Duration(seconds: 3),
  //   Duration(seconds: 10),
  // ];
  static const List<double> examplePlaybackRates = <double>[
    0.5,
    1.0,
    1.25,
    1.5,
    1.75,
    2.0,
    2.5,
    3.0,
  ];
  final String articleId, videoUuid;
  final VideoPlayerController controller;
  final bool isFullScreen;
  // final String articleId, videoUuid;
  void _togglePlay() {
    controller.value.isPlaying ? controller.pause() : controller.play();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : const ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () => _togglePlay(),
        ),
        Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: "Play / Pause",
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 7,
                      horizontal: 9,
                    ),
                    child: InkWell(
                      onTap: () => _togglePlay(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 1.5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: Colors.black54,
                            border: Border.all(color: Colors.white60)),
                        child: Icon(
                          controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 21,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black54,
                    ),
                    child: Text(
                      "${getFormattedDurationForVideo(controller.value.position)}/${getFormattedDurationForVideo(controller.value.duration)}",
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 12),
                    ))
              ],
            )),
        Align(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton<double>(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(9.0),
                  ),
                ),
                initialValue: controller.value.playbackSpeed,
                tooltip: 'Playback speed',
                onSelected: (double speed) {
                  controller.setPlaybackSpeed(speed);
                },
                position: PopupMenuPosition.over,
                itemBuilder: (BuildContext context) {
                  return <PopupMenuItem<double>>[
                    for (final double speed
                        in _ControlsOverlay.examplePlaybackRates)
                      PopupMenuItem<double>(
                        value: speed,
                        child: Text('${speed}x'),
                      )
                  ];
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  // margin:
                  //     isFullScreen ? const EdgeInsets.only(bottom: 5) : null,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black54,
                      border: Border.all(color: Colors.white60)),
                  child: Text(
                    '${controller.value.playbackSpeed}x',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ),
              Tooltip(
                message:
                    !isFullScreen ? "Go FullScreen" : "Back to mini player",
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 9,
                  ),
                  child: InkWell(
                    onTap: () {
                      if (!isFullScreen) {
                        controller.pause();
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => _FullVideoScreenPlayer(
                            articleId: articleId,
                            videoUuid: videoUuid,
                            url: controller.dataSource,
                            position: controller.value.position,
                          ),
                        ))
                            .then((_) {
                          Duration? p = ref
                              .read(videoProgressProvider(articleId).notifier)
                              .getVideoProgress(
                                  videoUuid)?[videoCurrentPosition];
                          // debugPrint("RUNNING THEN AFTER POP: value: $p");
                          if (p != null) {
                            print("pop seek worked");
                            controller.seekTo(p);
                          }
                        });
                      } else {
                        Navigator.pop(context, controller.value.position);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 1.5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Colors.black54,
                          border: Border.all(color: Colors.white60)),
                      child: !isFullScreen
                          ? const Icon(
                              Icons.fullscreen,
                              size: 21,
                              color: Colors.white70,
                            )
                          : const Icon(
                              Icons.fullscreen_exit,
                              size: 21,
                              color: Colors.white70,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FullVideoScreenPlayer extends ConsumerStatefulWidget {
  final String url;
  final String articleId;
  final String videoUuid;
  const _FullVideoScreenPlayer(
      {required this.articleId,
      required this.videoUuid,
      required this.url,
      this.position});
  final Duration? position;
  @override
  _FullVideoScreenPlayerState createState() => _FullVideoScreenPlayerState();
}

class _FullVideoScreenPlayerState
    extends ConsumerState<_FullVideoScreenPlayer> {
  late VideoPlayerController controller;
  bool startedPlaying = false;
  double watchedPercentage = 0;
  int i = 0;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {
          if (widget.position != null && widget.position?.inSeconds != 0) {
            controller.seekTo(widget.position!);
          }
        });
      });
    controller.play();
    controller.addListener(_updateWatchedProgress);
  }

  void _updateWatchedProgress() {
    setState(() {});
    if (i % 5 == 0) {
      final position = controller.value.position;
      final duration = controller.value.duration;
      ref
          .read(videoProgressProvider(widget.articleId).notifier)
          .updateVideoProgress(widget.videoUuid, position, duration);

      // debugPrint("UPDATED VIDEO PROGRESS: $position");
    }
    i++;
  }

  @override
  void dispose() {
    controller.removeListener(_updateWatchedProgress);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Center(
        child: FutureBuilder<bool>(
          future: Future.value(true),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data ?? false) {
              return Hero(
                tag: widget.videoUuid,
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(controller),
                      // ClosedCaption(text: _controller.value.caption.text),
                      _ControlsOverlay(
                          articleId: widget.articleId,
                          videoUuid: widget.videoUuid,
                          controller: controller,
                          isFullScreen: true),
                      VideoProgressIndicator(controller, allowScrubbing: true),
                    ],
                  ),
                ),
              );
            } else {
              return const Text(
                'Loading...',
                style: TextStyle(color: Colors.white38),
              );
            }
          },
        ),
      ),
    );
  }
}

class IframeWidget extends ConsumerStatefulWidget {
  const IframeWidget(
      {required this.uuid,
      required this.url,
      required this.articleId,
      super.key});
  final String uuid, url, articleId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IframeWidgetState();
}

class _IframeWidgetState extends ConsumerState<IframeWidget> {
  late YoutubePlayerController controller;
  bool _isMounted = true;

  @override
  void initState() {
    var resumePoint = ref
        .read(videoProgressProvider(widget.articleId).notifier)
        .getVideoProgress(widget.uuid)?[videoCurrentPosition]
        ?.inSeconds;
    controller = YoutubePlayerController.fromVideoId(
      videoId: YoutubePlayerController.convertUrlToId(widget.url) ?? "",
      startSeconds: resumePoint?.toDouble(),
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    )..listen((currentStatus) => _saveProgress(currentStatus));
    // _seekToLastProgress();
    super.initState();
  }

  void _seekToLastProgress() async {
    if (!_isMounted) return;
    var resumePoint = ref
        .read(videoProgressProvider(widget.articleId).notifier)
        .getVideoProgress(widget.uuid)?[videoCurrentPosition]
        ?.inSeconds;
    print("init iframe video, resumePoint: $resumePoint");
    if (resumePoint != null) {
      await controller.seekTo(seconds: resumePoint.toDouble());
    }
    setState(() {});
  }

  void _saveProgress(YoutubePlayerValue currentStatus) async {
    if (!_isMounted) return;
    var current = await controller.currentTime;
    var total = controller.value.metaData.duration == Duration.zero
        ? Duration(seconds: (await controller.duration).toInt())
        : controller.value.metaData.duration;

    if ([
      PlayerState.playing,
      PlayerState.paused,
      PlayerState.ended,
      PlayerState.cued
    ].contains(currentStatus.playerState)) {
      ref
          .read(videoProgressProvider(widget.articleId).notifier)
          .updateVideoProgress(
              widget.uuid, Duration(seconds: current.toInt()), total);
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return YoutubePlayer(
      controller: controller,
      aspectRatio: 16 / 9,
    );
  }
}
