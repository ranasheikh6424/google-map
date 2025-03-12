import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

customCircleProgress(){
  return LoadingIndicator(
  indicatorType: Indicator.ballRotate, /// Required, The loading type of the widget
  colors: const [Colors.amber],       /// Optional, The color collections
strokeWidth: 1,                     /// Optional, The stroke of the line, only applicable to widget which contains line
//backgroundColor: Colors.black,      /// Optional, Background of the widget
pathBackgroundColor: Colors.black   /// Optional, the stroke backgroundColor
);
}