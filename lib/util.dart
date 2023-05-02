import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

MarkdownStyleSheet markdownStyle(BuildContext context) {
  return MarkdownStyleSheet(
    p: const TextStyle(fontSize: 16),
    pPadding: const EdgeInsets.only(bottom: 8),
    a: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        decoration: TextDecoration.underline),
    h2: const TextStyle(fontSize: 24, color: Colors.black),
    h2Padding: const EdgeInsets.only(top: 8),
    tableBorder: TableBorder.all(color: Colors.transparent),
    tableBody: const TextStyle(fontSize: 16),
  );
}

void Function(String, String?, String) linkHandler(BuildContext context) {
  return (String text, String? url, String title) {
    if (url == null) {
      return;
    }
    if (url.startsWith("http://") ||
        url.startsWith("https://") ||
        url.startsWith("tel:") ||
        url.startsWith("mailto:")) {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else if (url.startsWith("/")) {
      final random = Random().nextInt(1000000);
      url += '${url.contains('?') ? '&' : '?'}refresh=$random';
      Beamer.of(context, root: true).beamToNamed(url);
    }
  };
}

final startDate = DateTime(2022, 8, 26, 0, 0);
const days = ['VR', 'ZA', 'ZO'];

DateTime? parseTime(String str) {
  final parts = str.split(' ');
  if (parts.length != 2) return null;
  final dayIndex = days.indexOf(parts[0]);
  if (dayIndex == -1) return null;
  final timeParts = parts[1].split(':');
  if (timeParts.length != 2) return null;
  final hour = int.tryParse(timeParts[0]);
  final minute = int.tryParse(timeParts[1]);
  if (hour == null || minute == null) return null;
  return startDate
      .add(Duration(days: dayIndex))
      .copyWith(hour: hour, minute: minute);
}

String formatTime(DateTime time) {
  return '${time.hour.toString().padLeft(2, '0')}.${time.minute.toString().padLeft(2, '0')}';
}
