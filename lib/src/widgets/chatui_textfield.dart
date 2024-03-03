import 'package:chatview/src/utils/constants/constants.dart';
import 'package:flutter/material.dart';

import '../../chatview.dart';
import '../utils/debounce.dart';
import '../utils/package_strings.dart';

class ChatUITextField extends StatefulWidget {
  const ChatUITextField({
    super.key,
    required this.focusNode,
    required this.textEditingController,
    required this.onPressed,
  });

  /// Provides focusNode for focusing text field.
  final FocusNode focusNode;

  /// Provides functions which handles text field.
  final TextEditingController textEditingController;

  /// Provides callback when user tap on text field.
  final VoidCallBack onPressed;

  @override
  State<ChatUITextField> createState() => _ChatUITextFieldState();
}

class _ChatUITextFieldState extends State<ChatUITextField> {
  final ValueNotifier<String> _inputText = ValueNotifier('');

  OutlineInputBorder get _outLineBorder => OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(textFieldBorderRadius),
      );

  late Debouncer debouncer;

  @override
  void initState() {
    debouncer = Debouncer(const Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    debouncer.dispose();
    _inputText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(textFieldBorderRadius),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: widget.focusNode,
              controller: widget.textEditingController,
              style: const TextStyle(color: Colors.black),
              maxLines: 5,
              minLines: 1,
              onChanged: _onChanged,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: PackageStrings.message,
                fillColor: Colors.white,
                filled: true,
                hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.25,
                    ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                border: _outLineBorder,
                focusedBorder: _outLineBorder,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(textFieldBorderRadius),
                ),
              ),
            ),
          ),
          ValueListenableBuilder<String>(
            valueListenable: _inputText,
            builder: (_, inputTextValue, child) {
              if (inputTextValue.isNotEmpty) {
                return IconButton(
                  color: Colors.green,
                  onPressed: () {
                    widget.onPressed();
                    _inputText.value = '';
                  },
                  icon: const Icon(Icons.send),
                );
              } else {
                return IconButton(
                  color: Colors.green,
                  onPressed: () {
                  },
                  icon: const Icon(Icons.attach_file),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _onChanged(String inputText) {
    _inputText.value = inputText;
  }
}
