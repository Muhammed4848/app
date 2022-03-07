import 'package:flutter/material.dart';
import 'package:granth_flutter/models/response/slider.dart';
import 'package:granth_flutter/utils/slider_widget.dart';
import 'package:granth_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeSliderWidget extends StatelessWidget {
  final List<HomeSlider>? mSliderList;

  HomeSliderWidget(this.mSliderList);

  @override
  Widget build(BuildContext context) {
    return SliderWidget(
      viewportFraction: 0.9,
      height: 250,
      enlargeCenterPage: true,
      autoPlay: true,
      autoPlayInterval: 3.seconds,
      items: mSliderList!.map((slider) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 0.0,
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: cachedImage(slider.slideImage, fit: BoxFit.cover),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
