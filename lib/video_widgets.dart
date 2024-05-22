import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_1/models.dart';
import 'package:responsive_1/providers/data_provider.dart';
import 'package:video_player/video_player.dart';

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
  // int i = 0;

  @override
  void initState() {
    super.initState();
    articleId = widget.articleId;
    videoUuid = widget.videoUuid;
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {});
      })
      ..addListener(_updateWatchedProgress);
  }

  void _updateWatchedProgress() {
    //bug in library causing toggle icon play/pause updating problems with below if statement
    //wrote to update screen(provider) less frequently than every second.
    // if (i % 5 == 0) {
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    ref
        .read(videoProgressProvider(articleId).notifier)
        .updateVideoProgress(videoUuid, position, duration);

    debugPrint("UPDATED VIDEO PROGRESS: $position");
    // }
    // i++;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Column(
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(_controller),
                      // ClosedCaption(text: _controller.value.caption.text),
                      _ControlsOverlay(
                          controller: _controller, isFullScreen: false),
                      VideoProgressIndicator(_controller, allowScrubbing: true),
                    ],
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
    _controller.removeListener(_updateWatchedProgress);
    _controller.dispose();
    // progressSavingTimer.cancel();
    super.dispose();
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay(
      {required this.controller, required this.isFullScreen});

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

  final VideoPlayerController controller;
  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
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
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
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
                      onTap: () {
                        if (controller.value.isPlaying) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                      },
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
                    for (final double speed in examplePlaybackRates)
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
                    onTap: () => !isFullScreen
                        ? Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => _FullVideoScreenPlayer(
                              url: controller.dataSource,
                              position: controller.value.position,
                            ),
                          ))
                        : Navigator.pop(context),
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

class _FullVideoScreenPlayer extends StatefulWidget {
  final String url;
  const _FullVideoScreenPlayer({required this.url, required this.position});
  final Duration? position;
  @override
  _FullVideoScreenPlayerState createState() => _FullVideoScreenPlayerState();
}

class _FullVideoScreenPlayerState extends State<_FullVideoScreenPlayer> {
  late VideoPlayerController videoPlayerController;
  bool startedPlaying = false;
  double watchedPercentage = 0;

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url))
          ..initialize().then((_) {
            setState(() {
              if (widget.position != null && widget.position?.inSeconds != 0) {
                videoPlayerController.seekTo(widget.position!);
              }
              videoPlayerController.play();
            });
          })
          ..addListener(updateWatchedPercentage);
  }

  void updateWatchedPercentage() {
    final position = videoPlayerController.value.position;
    final duration = videoPlayerController.value.duration;
    if (duration.inMilliseconds > 0) {
      setState(() {
        watchedPercentage = position.inMilliseconds / duration.inMilliseconds;
      });
      // Optionally, do something with this information, like updating a server or local database
      print("Watched: ${(watchedPercentage * 100).toStringAsFixed(2)}%");
    }
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
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
              return AspectRatio(
                aspectRatio: videoPlayerController.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(videoPlayerController),
                    // ClosedCaption(text: _controller.value.caption.text),
                    _ControlsOverlay(
                        controller: videoPlayerController, isFullScreen: true),
                    VideoProgressIndicator(videoPlayerController,
                        allowScrubbing: true),
                  ],
                ),
              );
            } else {
              return const Text('Loading...');
            }
          },
        ),
      ),
    );
  }
}
