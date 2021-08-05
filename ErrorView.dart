import 'package:flutter/material.dart';

import 'package:get/get.dart';
// here use getx 
class ErrorView extends GetView {
  final String errorText;
  final VoidCallback? function;
  ErrorView({required this.errorText, this.function});
  @override
  Widget build(BuildContext context) {
    return Center(
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
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 56,
                ),
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
    );
  }
}
