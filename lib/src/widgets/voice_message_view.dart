import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatview/chatview.dart';
import 'package:chatview/src/widgets/reaction_widget.dart';
import 'package:chatview/src/widgets/text_message_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VoiceMessageView extends StatefulWidget {
  const VoiceMessageView({
    super.key,
    required this.screenWidth,
    required this.message,
    required this.isMessageBySender,
    this.onMaxDuration,
  });

  /// Allow user to set width of chat bubble.
  final double screenWidth;

  /// Provides message instance of chat.
  final Message message;
  final Function(int)? onMaxDuration;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  @override
  State<VoiceMessageView> createState() => _VoiceMessageViewState();
}

class _VoiceMessageViewState extends State<VoiceMessageView> {
  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;

  final ValueNotifier<PlayerState> _playerState =
      ValueNotifier(PlayerState.stopped);

  PlayerState get playerState => _playerState.value;

  PlayerWaveStyle playerWaveStyle = const PlayerWaveStyle(scaleFactor: 70);

  @override
  void initState() {
    super.initState();

    controller = PlayerController()
      ..preparePlayer(
        path: widget.message.message,
        noOfSamples: playerWaveStyle.getSamplesForWidth(widget.screenWidth * 0.5),
      ).whenComplete(() => widget.onMaxDuration?.call(controller.maxDuration));

    playerStateSubscription = controller.onPlayerStateChanged.listen((state) => _playerState.value = state);
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    controller.dispose();
    _playerState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomPaint(
          painter: SpecialChatBubbleOne(
            color: widget.isMessageBySender ? Colors.blue : Colors.pink,
            alignment: widget.isMessageBySender
                ? Alignment.topRight
                : Alignment.topLeft,
            tail: true,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: widget.message.reaction.reactions.isNotEmpty ? 15 : 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<PlayerState>(
                  builder: (context, state, child) {
                    return IconButton(
                      onPressed: _playOrPause,
                      icon: state.isStopped ||
                              state.isPaused ||
                              state.isInitialised
                          ? const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.stop,
                              color: Colors.white,
                            ),
                    );
                  },
                  valueListenable: _playerState,
                ),
                AudioFileWaveforms(
                  size: Size(widget.screenWidth * 0.50, 60),
                  playerController: controller,
                  waveformType: WaveformType.fitWidth,
                  playerWaveStyle: playerWaveStyle,
                  padding: const EdgeInsets.only(right: 10),
                  animationCurve: Curves.easeIn,
                  animationDuration: const Duration(milliseconds: 500),
                  enableSeekGesture: true,
                ),
              ],
            ),
          ),
        ),
        if (widget.message.reaction.reactions.isNotEmpty)
          ReactionWidget(
            isMessageBySender: widget.isMessageBySender,
            reaction: widget.message.reaction,
            isMessageImage: false,
          ),
      ],
    );
  }

  void _playOrPause() {
    assert(
      defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android,
      "Voice messages are only supported with android and ios platform",
    );
    if (playerState.isInitialised ||
        playerState.isPaused ||
        playerState.isStopped) {
      controller.startPlayer(finishMode: FinishMode.pause);
    } else {
      controller.pausePlayer();
    }
  }
}
