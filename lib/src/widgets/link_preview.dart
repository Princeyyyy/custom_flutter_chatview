import 'package:any_link_preview/any_link_preview.dart';
import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/models/link_preview_configuration.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/constants/constants.dart';

class LinkPreview extends StatelessWidget {
  const LinkPreview({
    super.key,
    required this.url,
    this.linkPreviewConfig,
  });

  /// Provides url which is passed in message.
  final String url;

  /// Provides configuration of chat bubble appearance when link/URL is passed
  /// in message.
  final LinkPreviewConfiguration? linkPreviewConfig;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 6, vertical: verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: verticalPadding),
            child: url.isImageUrl
                ? InkWell(
                    onTap: _onLinkTap,
                    child: Image.network(
                      url,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  )
                : AnyLinkPreview(
                    link: url,
                    removeElevation: true,
                    proxyUrl: linkPreviewConfig?.proxyUrl,
                    onTap: _onLinkTap,
                    placeholderWidget: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: linkPreviewConfig?.loadingColor,
                        ),
                      ),
                    ),
                    backgroundColor: Colors.grey.shade200,
                    borderRadius: linkPreviewConfig?.borderRadius,
                    bodyStyle: const TextStyle(color: Colors.black),
                    titleStyle: linkPreviewConfig?.titleStyle,
                  ),
          ),
          const SizedBox(height: verticalPadding),
          InkWell(
            onTap: _onLinkTap,
            child: Text(
              url,
              style: const TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onLinkTap() {
    if (linkPreviewConfig?.onUrlDetect != null) {
      linkPreviewConfig?.onUrlDetect!(url);
    } else {
      _launchURL();
    }
  }

  void _launchURL() async {
    final parsedUrl = Uri.parse(url);
    await canLaunchUrl(parsedUrl)
        ? await launchUrl(parsedUrl)
        : throw couldNotLunch;
  }
}
