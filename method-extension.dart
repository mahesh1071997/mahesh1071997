import 'package:flutter/material.dart';
import 'package:crm/gs_stateless_widget/text.dart';
import 'package:crm/resources/themes/border/borders.dart';
import 'package:crm/resources/themes/colors_list.dart';
extension StringExtension on String {
  bool get isEmail => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
  bool get isMobileNo => RegExp(r"^[0-9]{6}").hasMatch(this);
  bool get isNumber => RegExp(r"^((\+){1}[0-9]){1,3}[1-9]{1}[0-9]{10}$").hasMatch(this);//this is correct validation for mobile number.

  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this.split(" ").map((str) => str.toUpperCase()).join(" ");
}
extension SnackbarExtension on BuildContext {

  displaySnackBar(String content, {Color? backgroundColor}) {
    // ignore: deprecated_member_use
    return Scaffold.of(this).showSnackBar(
      SnackBar(duration: Duration(seconds:5),
        shape: RoundedRectangleBorder(
            borderRadius:
            Borders.borderRadiousAllCircular(
                radious: 10)),
        backgroundColor: ColorsList.blueColor,
        behavior: SnackBarBehavior.floating,
        content: TextWidget.title(
          title:
          "\t\t$content",color: ColorsList.whiteColor,
        ),
      ),
    );
  }

  Size get mediaQuerySize => MediaQuery.of(this).size;

  Orientation get orientation => MediaQuery.of(this).orientation;

  bool get isLandscape => orientation == Orientation.landscape;

  bool get isPortrait => orientation == Orientation.portrait;
}

