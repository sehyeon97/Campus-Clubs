import 'package:flutter/material.dart';

class FeedbackSystem {
  static Text content = const Text("");
  static SnackBar snackBar = SnackBar(content: content);

  static void setCustomFeedback(String message) {
    content = Text(message);
  }

  static SnackBar getCustomFeedback() {
    return snackBar;
  }

  static SnackBar getNotAdminFeedback() {
    return const SnackBar(content: Text("You are not an admin"));
  }

  static SnackBar getPasswordIncorrectFeedback() {
    return const SnackBar(content: Text("Password incorrect"));
  }

  static SnackBar getInvalidEmailFeedback() {
    return const SnackBar(content: Text("Invalid CBU Email"));
  }

  static SnackBar getPDFIncorrectTermFeedback() {
    return const SnackBar(content: Text("PDF file not valid for current term"));
  }

  static SnackBar getNotificationSettingFeedback(
      String onOrOff, String clubName) {
    return onOrOff == 'on'
        ? SnackBar(content: Text("Notifications enabled for $clubName"))
        : SnackBar(content: Text('Notifications disabled for $clubName'));
  }

  static SnackBar getGroupChatTimerFeedback() {
    int pauseTimer = 2;
    return SnackBar(
        content: Text("Cannot send message. Wait $pauseTimer seconds"));
  }

  static SnackBar getSuccessfullyJoinedClubFeedback(String clubName) {
    return SnackBar(content: Text("Successfully joined $clubName"));
  }

  static SnackBar getLeftClubFeedback(String clubName) {
    return SnackBar(content: Text("Left $clubName"));
  }
}
