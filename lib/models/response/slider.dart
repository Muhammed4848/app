class HomeSlider {
  String? link;
  int? sliderId;
  String? slideImage;
  Object? title;

  HomeSlider({this.link, this.sliderId, this.slideImage, this.title});

  factory HomeSlider.fromJson(Map<String, dynamic> json) {
    return HomeSlider(
      link: json['link'] != null ? json['link'] : null,
      sliderId: json['mobile_slider_id'],
      slideImage: json['slide_image'],
      title: json['title'] != null ? json['title'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile_slider_id'] = this.sliderId;
    data['slide_image'] = this.slideImage;
    if (this.link != null) {
      data['link'] = this.link;
    }
    if (this.title != null) {
      data['title'] = this.title;
    }
    return data;
  }
}
