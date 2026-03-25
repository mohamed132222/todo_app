import 'package:flutter/material.dart';
import 'package:todo_app/my_theme.dart';

class DialogUtils {
  static void showLoading(
    BuildContext context, {
    String loadingMessage = "loading..",
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(color: MyTheme.primaryColor),
            SizedBox(width: 10),
            Text(
              loadingMessage,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: MyTheme.blackColor),
            ),
          ],
        ),
      ),
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(
    BuildContext context, {
    required String message,
    String title = "Title",
    String? posActionName,
    VoidCallback? posAction,
    bool isDismissible = true,
    String? negActionName,
    VoidCallback? negAction,
  }) {
    List<TextButton> action = [];
    if (posActionName != null) {
      action.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);

            if (posAction != null) {
              posAction();
            }
          },
          child: Text(posActionName!),
        ),
      );
    }
    if (negActionName != null) {
      action.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (negAction != null) {
              negAction();
            }
          },
          child: Text(negActionName!),
        ),
      );
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: MyTheme.blackColor),
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: MyTheme.blackColor),
        ),
        actions: action,
      ),
    );
  }
}
