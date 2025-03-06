import 'package:flutter/material.dart';

class CustomShowModalButton {
  static void show({
    required BuildContext context,
    required String title,
    required Widget children,
    required bool isLoading,
    Color? backgroundColor,
    Color? textColor,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor ?? Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor ?? Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              children,
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
