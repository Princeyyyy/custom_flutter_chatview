import 'package:chatview/src/utils/constants/constants.dart';
import 'package:flutter/material.dart';

import '../../chatview.dart';
import '../utils/debounce.dart';
import '../utils/package_strings.dart';

class ChatUITextField extends StatefulWidget {
  const ChatUITextField({
    super.key,
    this.sendMessageConfig,
    required this.focusNode,
    required this.textEditingController,
    required this.onPressed,
  });

  /// Provides configuration of default text field in chat.
  final SendMessageConfiguration? sendMessageConfig;

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

  SendMessageConfiguration? get sendMessageConfig => widget.sendMessageConfig;

  TextFieldConfiguration? get textFieldConfig =>
      sendMessageConfig?.textFieldConfig;

  OutlineInputBorder get _outLineBorder => OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: textFieldConfig?.borderRadius ??
            BorderRadius.circular(textFieldBorderRadius),
      );

  late Debouncer debouncer;

  @override
  void initState() {
    debouncer = Debouncer(
        sendMessageConfig?.textFieldConfig?.compositionThresholdTime ??
            const Duration(seconds: 1));
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
      padding:
          textFieldConfig?.padding ?? const EdgeInsets.symmetric(horizontal: 6),
      margin: textFieldConfig?.margin,
      decoration: BoxDecoration(
        borderRadius: textFieldConfig?.borderRadius ??
            BorderRadius.circular(textFieldBorderRadius),
        color: sendMessageConfig?.textFieldBackgroundColor ?? Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: widget.focusNode,
              controller: widget.textEditingController,
              style: textFieldConfig?.textStyle ??
                  const TextStyle(color: Colors.white),
              maxLines: textFieldConfig?.maxLines ?? 5,
              minLines: textFieldConfig?.minLines ?? 1,
              keyboardType: textFieldConfig?.textInputType,
              inputFormatters: textFieldConfig?.inputFormatters,
              onChanged: _onChanged,
              textCapitalization: textFieldConfig?.textCapitalization ??
                  TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText:
                textFieldConfig?.hintText ?? PackageStrings.message,
                fillColor: sendMessageConfig?.textFieldBackgroundColor ??
                    Colors.white,
                filled: true,
                hintStyle: textFieldConfig?.hintStyle ??
                    TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.25,
                    ),
                contentPadding: textFieldConfig?.contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 6),
                border: _outLineBorder,
                focusedBorder: _outLineBorder,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: textFieldConfig?.borderRadius ??
                      BorderRadius.circular(textFieldBorderRadius),
                ),
              ),
            ),
          ),
          ValueListenableBuilder<String>(
            valueListenable: _inputText,
            builder: (_, inputTextValue, child) {
              if (inputTextValue.isNotEmpty) {
                return IconButton(
                  color: sendMessageConfig?.defaultSendButtonColor ??
                      Colors.green,
                  onPressed: () {
                    widget.onPressed();
                    _inputText.value = '';
                  },
                  icon: sendMessageConfig?.sendButtonIcon ??
                      const Icon(Icons.send),
                );
              } else {
                return IconButton(
                  color: sendMessageConfig?.defaultSendButtonColor ??
                      Colors.green,
                  onPressed: () {
                  },
                  icon: sendMessageConfig?.sendButtonIcon ??
                      const Icon(Icons.attach_file),
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
