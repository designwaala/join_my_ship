import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DottedBorder extends CustomPainter {
  //number of stories
  final int numberOfStories;
  //length of the space arc (empty one)
  final int spaceLength;
  //start of the arc painting in degree(0-360)
  double startOfArcInDegree = -90;

  List<int>? seenStoriesIndicies;

  DottedBorder(
      {required this.numberOfStories,
      this.spaceLength = 10,
      this.seenStoriesIndicies});

  //drawArc deals with rads, easier for me to use degrees
  //so this takes a degree and change it to rad
  double inRads(double degree) {
    return (degree * pi) / 180;
  }

  @override
  bool shouldRepaint(DottedBorder oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //circle angle is 360, remove all space arcs between the main story arc (the number of spaces(stories) times the  space length
    //then subtract the number from 360 to get ALL arcs length
    //then divide the ALL arcs length by number of Arc (number of stories) to get the exact length of one arc
    double arcLength =
        (360 - (numberOfStories * spaceLength)) / numberOfStories;

    //be careful here when arc is a negative number
    //that happens when the number of spaces is more than 360
    //feel free to use what logic you want to take care of that
    //note that numberOfStories should be limited too here
    if (arcLength <= 0) {
      arcLength = 360 / spaceLength - 1;
    }

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    if (numberOfStories == 1) {
      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.height / 2,
          Paint()
            ..color = Get.theme.primaryColor
            ..strokeWidth = 6
            ..style = PaintingStyle.stroke);
    } else {
      for (int i = 0; i < numberOfStories; i++) {
        //printing the arc
        canvas.drawArc(
            rect,
            inRads(startOfArcInDegree),
            //be careful here is:  "double sweepAngle", not "end"
            inRads(arcLength),
            false,
            Paint()
              //here you can compare your SEEN story index with the arc index to make it grey
              ..color = seenStoriesIndicies?.contains(i) == true
                  ? Colors.grey
                  : Get.theme.primaryColor
              ..strokeWidth = 6
              ..style = PaintingStyle.stroke);

        //the logic of spaces between the arcs is to start the next arc after jumping the length of space
        startOfArcInDegree += arcLength + spaceLength;
      }
    }
  }
}
