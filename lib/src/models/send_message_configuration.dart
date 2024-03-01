import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SendMessageConfiguration {
  /// Used to give background color to text field.
  final Color? textFieldBackgroundColor;

  /// Used to give color to send button.
  final Color? defaultSendButtonColor;

  /// Provides ability to give custom send button.
  final Widget? sendButtonIcon;

  /// Used to give reply dialog color.
  final Color? replyDialogColor;

  /// Used to give color to title of reply pop-up.
  final Color? replyTitleColor;

  /// Used to give color to reply message.
  final Color? replyMessageColor;

  /// Used to give color to close icon in reply pop-up.
  final Color? closeIconColor;

  /// Provides configuration of text field.
  final TextFieldConfiguration? textFieldConfig;

  const SendMessageConfiguration({
    this.textFieldConfig,
    this.textFieldBackgroundColor,
    this.defaultSendButtonColor,
    this.sendButtonIcon,
    this.replyDialogColor,
    this.replyTitleColor,
    this.replyMessageColor,
    this.closeIconColor,
  });
}

class TextFieldConfiguration {
  /// Used to give max lines in text field.
  final int? maxLines;

  /// Used to give min lines in text field.
  final int? minLines;

  /// Used to give padding in text field.
  final EdgeInsetsGeometry? padding;

  /// Used to give margin in text field.
  final EdgeInsetsGeometry? margin;

  /// Used to give hint text in text field.
  final String? hintText;

  /// Used to give text style of hint text in text field.
  final TextStyle? hintStyle;

  /// Used to give text style of actual text in text field.
  final TextStyle? textStyle;

  /// Used to give border radius in text field.
  final BorderRadius? borderRadius;

  /// Used to give content padding in text field.
  final EdgeInsetsGeometry? contentPadding;

  /// Used to give text input type of text field.
  final TextInputType? textInputType;

  /// Used to give list of input formatters for text field.
  final List<TextInputFormatter>? inputFormatters;

  /// Used to give textCapitalization enums to text field.
  final TextCapitalization? textCapitalization;

  /// After typing stopped, the threshold time after which the composing
  /// status to be changed to [TypeWriterStatus.composed].
  /// Default is 1 second.
  final Duration compositionThresholdTime;

  const TextFieldConfiguration({
    this.contentPadding,
    this.maxLines,
    this.borderRadius,
    this.hintText,
    this.hintStyle,
    this.textStyle,
    this.padding,
    this.margin,
    this.minLines,
    this.textInputType,
    this.compositionThresholdTime = const Duration(seconds: 1),
    this.inputFormatters,
    this.textCapitalization,
  });
}
