import 'package:flutter/material.dart';

import 'package:get/get.dart';
// here use getx

class NetworkErrorView extends GetView {
  final String errorText;
  final Widget? widget;
  final VoidCallback? function;
  NetworkErrorView({required this.errorText, this.function,this.widget});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          width: 344,
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 8.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget,
                ),
                ListTile(
                  title: Text(
                    "Error!",
                    textAlign: TextAlign.center,
                  ),
                  isThreeLine: true,
                  subtitle: Text(errorText, textAlign: TextAlign.center),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: function,
                  child: Text('Try again', style: TextStyle(color: Colors.red)),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
