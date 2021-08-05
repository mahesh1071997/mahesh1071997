import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension customExtension on Widget {
  Widget toProgressIndicator({required RxBool isLoading}) {
    return ObxValue<RxBool>(
          (isSearching) => isSearching()
          ? this
          : CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
      ).paddingAll(8.0),
      isLoading,
    );
  }


}

extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    return this.add(
      Duration(
        days: (day - this.weekday) % DateTime.daysPerWeek,
      ),
    );
  }
}

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (this.hour < other.hour) return -1;
    if (this.hour > other.hour) return 1;
    if (this.minute < other.minute) return -1;
    if (this.minute > other.minute) return 1;
    return 0;
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
          '${alpha.toRadixString(16).padLeft(2, '0')}'
          '${red.toRadixString(16).padLeft(2, '0')}'
          '${green.toRadixString(16).padLeft(2, '0')}'
          '${blue.toRadixString(16).padLeft(2, '0')}';
}



//--------------------- crm  


extension WidgetExtension on Widget {
  /// Wrap Widget with Center
  Widget center() {
    return Center(
      child: this,
    );
  }

  ///Use As Bellow
  ///Icon(Icons.cancel,size: 30).expended(flex:1),
  /// Wrap Widget With Expanded and add flex parameter
  ///default value flex=1
  Widget expended({
    Key? key,
    final int flex = 1,
  }) =>
      Expanded(flex: flex, child: this);

  ///Use As Bellow
  ///Icon(Icons.cancel,size: 30).flexible(flex:1),
  /// Wrap Widget With Flexible and add flex parameter
  /// default value flex=1
  Widget flexible({
    Key? key,
    final int flex = 1,
  }) =>
      Flexible(
        flex: flex,
        child: this,
      );

  /// Wrap Widget With FittedBox
  Widget fittedbox() => FittedBox(child: this);

  ///Use As Bellow
  ///Icon(Icons.cancel,size: 30).paddingAll(),
  /// Wrap Widget With Padding apply at all side
  /// default value Padding=8.0
  Widget paddingAll({
    Key? key,
    final double padding = 8.0,
  }) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  /// Wrap widget With Padding You have To pass EdgeInsets
  ///Use As Bellow
  ///Icon(Icons.cancel,size: 30).padding(edgeInsets: EdgeInsets.all(10.0)),
  Widget padding({Key? key, required EdgeInsets edgeInsets}) =>
      Padding(padding: edgeInsets, child: this);

  /// Wrap widget With Padding
  Widget paddingFromLTRB({
    Key? key,
    final double left = 0.0,
    final double right = 0.0,
    final double top = 0.0,
    final double bottom = 0.0,
  }) =>
      Padding(
          padding: EdgeInsets.only(
              bottom: bottom, top: top, right: right, left: left),
          child: this);

  ///Use As Bellow
  ///Icon(Icons.cancel,size: 30).singleChildScrollView(scrollDirection:  Axis.vertical),
  /// Wrap Widget With SingleChildScrollView add scrolldirection with Axis.value
  /// default value scrollDirection=Axis.vertical
  Widget singleChildScrollView({
    Key? key,
    final Axis scrollDirection = Axis.vertical,
  }) =>
      SingleChildScrollView(
        scrollDirection: scrollDirection,
        child: this,
      );

  ///Use As Bellow
  ///Icon(Icons.cancel,size: 30).align(alignment: Alignment.topRight),
  /// Wrap Widget With Align You Have To pass Aligmnet.value
  /// default value alignment=Alignment.center
  Widget align({
    Key? key,
    final AlignmentGeometry alignment = Alignment.center,
  }) =>
      Align(
        alignment: alignment,
        child: this,
      );

  /// Wrap Widget With Aligment Center Start
  /// default value alignment=Alignment.centerStart
  Widget alignAtStart() => Align(
        alignment: AlignmentDirectional.centerStart,
        child: this,
      );

  /// Wrap Widget With Aligment Center End
  ///  default value alignment=Alignment.centerEnd
  Widget alignAtEnd() => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: this,
      );

  ///Use As Bellow
  ///Icon(Icons.cancel,size: 30).clipRRect(edgeInsets: BorderRadius.circular(8.0)),
  /// Wrap Widget With ClipRect You have To pass Border Radious
  Widget clipRRect({
    Key? key,
    final BorderRadiusGeometry? edgeInsets,
  }) =>
      ClipRRect(borderRadius: edgeInsets as BorderRadius?, child: this);

  ///Use As Bellow
  ///Icon(Icons.cancel,size: 30).circleAvatar(maxRadius: 10),
  /// Wrap Widget With CircleAvatar You have To pass Maximum Radius
  Widget circleAvatar({
    Key? key,
    Color backgroundColor = ColorsList.black,
    final double maxRadius = 10,
  }) =>
      CircleAvatar(
        child: this,
        backgroundColor: backgroundColor,
        maxRadius: maxRadius,
      );

  Widget visibility({
    Key? key,
    required final bool visible,
  }) =>
      Visibility(
        child: this,
        visible: visible,
      );

  ///Use As Bellow
  ///Icon(Icons.cancel,size: 30).inkwell(onTap: ()=> Navigator.pop(context, true)),
  /// Wrap Widget With InkWell and pass OnTap Function
  Widget inkwell({
    Key? key,
    Color splashColor = ColorsList.inkWellGrey,
    required final Function? onTap,
  }) =>
      InkWell(
        splashColor: ColorsList.inkWellGrey,
        child: this,
        onTap: onTap as void Function()?,
      );
  Widget circular({
    Key? key,
    Color splashColor = ColorsList.inkWellGrey,
    required final Function? onTap,
  }) =>
      CircularProgressIndicator(
      );
  /// Wrap Widget With InkWell With Show Dialog and pass widgetDialog Widget and BuildContext
  inkwellShowDialog(
          {Key? key,
          required final Widget? widgetDialog,
          final Function? refresh,
          Color splashColor = ColorsList.inkWellGrey,
          required final BuildContext context}) =>
      InkWell(
          splashColor: ColorsList.inkWellGrey,
          child: this,
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)), //this right here
                      child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return widgetDialog!;
                        },
                      )
                      //widgetDialog
                      );
                });
          });
}
