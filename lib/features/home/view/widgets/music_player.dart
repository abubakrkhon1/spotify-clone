import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone/core/providers/current_song_notifier.dart';
import 'package:spotify_clone/core/theme/app_pallette.dart';
import 'package:spotify_clone/core/utils.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);

    return Hero(
      tag: 'music-image',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexToColor(currentSong!.hex_code),
              const Color(0xFF121212),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Pallete.transparentColor,
          appBar: AppBar(
            backgroundColor: Pallete.transparentColor,
            leading: Transform.translate(
              offset: const Offset(-15, 0),
              child: InkWell(
                highlightColor: Pallete.transparentColor,
                focusColor: Pallete.transparentColor,
                splashColor: Pallete.transparentColor,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'assets/images/pull-down-arrow.png',
                  color: Pallete.whiteColor,
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(currentSong.thumbnail_url),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSong.title,
                              style: const TextStyle(
                                color: Pallete.whiteColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              currentSong.artist,
                              style: const TextStyle(
                                color: Pallete.subtitleText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            CupertinoIcons.heart,
                            color: Pallete.whiteColor,
                          ),
                        ),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    StreamBuilder(
                      stream: songNotifier.audioPlayer!.positionStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        final position = snapshot.data;
                        final duration = songNotifier.audioPlayer?.duration;
                        double sliderValue = 0;

                        if (position != null && duration != null) {
                          sliderValue =
                              position.inMilliseconds / duration.inMilliseconds;
                        }
                        return Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Pallete.whiteColor,
                                inactiveTickMarkColor: Pallete.whiteColor
                                    .withOpacity(0.117),
                                thumbColor: Pallete.whiteColor,
                                trackHeight: 1,
                                overlayShape: SliderComponentShape.noOverlay,
                              ),
                              child: Slider(
                                value: sliderValue,
                                min: 0,
                                max: 1,
                                onChanged: (val) {
                                  sliderValue = val;
                                },
                                onChangeEnd: songNotifier.seek,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${position?.inMinutes}:${(position?.inSeconds ?? 0) < 10 ? '0${position?.inSeconds}' : '${position?.inSeconds}'}',
                                  style: const TextStyle(
                                    color: Pallete.subtitleText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Text(
                                  '${duration?.inMinutes}:${(duration?.inSeconds ?? 0) < 10 ? '0${duration?.inSeconds}' : '${duration?.inSeconds}'}',
                                  style: TextStyle(
                                    color: Pallete.subtitleText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/shuffle.png',
                            color: Pallete.whiteColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/previous-song.png',
                            color: Pallete.whiteColor,
                          ),
                        ),
                        IconButton(
                          onPressed: songNotifier.playPause,
                          icon:
                              songNotifier.isPlaying
                                  ? Icon(CupertinoIcons.pause_circle_fill)
                                  : Icon(CupertinoIcons.play_circle_fill),
                          iconSize: 80,
                          color: Pallete.whiteColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/next-song.png',
                            color: Pallete.whiteColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/repeat.png',
                            color: Pallete.whiteColor,
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: const SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/connect-device.png',
                            color: Pallete.whiteColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/playlist.png',
                            color: Pallete.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
