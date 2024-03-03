import 'package:flutter/material.dart';

import 'package:chatview/src/utils/package_strings.dart';

import '../values/typedefs.dart';

class ReplyPopupWidget extends StatelessWidget {
  const ReplyPopupWidget({
    super.key,
    required this.sendByCurrentUser,
    required this.onUnsendTap,
    required this.onReplyTap,
    required this.onCopyTap,
  });

  /// Represents message is sent by current user or not.
  final bool sendByCurrentUser;

  /// Provides call back when user tap on unsend button.
  final VoidCallBack onUnsendTap;

  /// Provides call back when user tap on reply button.
  final VoidCallBack onReplyTap;

  /// Provides call back when user tap on more button.
  final VoidCallBack onCopyTap;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 14, color: Colors.black);
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      height: deviceWidth * 0.18,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade400, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: onReplyTap,
            child: Container(
              height: 40,
              width: 90,
              color: Colors.transparent,
              child: const Center(
                child: Text(
                  PackageStrings.reply,
                  style: textStyle,
                ),
              ),
            ),
          ),
          if (sendByCurrentUser)
            InkWell(
              onTap: onUnsendTap,
              child: Container(
                height: 40,
                width: 90,
                color: Colors.transparent,
                child: const Center(
                  child: Text(
                    PackageStrings.unsend,
                    style: textStyle,
                  ),
                ),
              ),
            ),
          InkWell(
            onTap: onCopyTap,
            child: Container(
              height: 40,
              width: 90,
              color: Colors.transparent,
              child: const Center(
                child: Text(
                  PackageStrings.copy,
                  style: textStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
