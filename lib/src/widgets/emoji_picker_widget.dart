import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import '../values/typedefs.dart';

class EmojiPickerWidget extends StatelessWidget {
  const EmojiPickerWidget({super.key, required this.onSelected});

  /// Provides callback when user selects emoji.
  final StringCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            width: 35,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          Expanded(
            child: EmojiPicker(
              onEmojiSelected: (Category? category, Emoji emoji) =>
                  onSelected(emoji.emoji),
              config: Config(
                height: 256,
                checkPlatformCompatibility: true,
                emojiViewConfig: EmojiViewConfig(
                  emojiSizeMax: 28 * ((!kIsWeb && Platform.isIOS) ? 1.2 : 1.0),
                ),
                swapCategoryAndBottomBar: false,
                skinToneConfig: const SkinToneConfig(),
                categoryViewConfig: const CategoryViewConfig(),
                bottomActionBarConfig: const BottomActionBarConfig(),
                searchViewConfig: const SearchViewConfig(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
