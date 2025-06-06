import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:khareedu/controller/banner_controller.dart';
class CustomeBanners extends StatefulWidget {
  const CustomeBanners({super.key});

  @override
  State<CustomeBanners> createState() => _CustomeBannersState();
}

class _CustomeBannersState extends State<CustomeBanners> {
  final CarouselController carouselController = CarouselController();
 final BannerController _bannerController = Get.put(BannerController());
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(()
      {
        if (_bannerController.Banners.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
      return  CarouselSlider(
        items: _bannerController.Banners.map((imgUrl) => ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: CachedNetworkImage(
            imageUrl: imgUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder: (context, url) => const ColoredBox(
              color: Colors.white,
              child: CupertinoActivityIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        )).toList(),
        options: CarouselOptions(
          height: 180, // or whatever height suits your design
          autoPlay: true, // 🔄 Auto-slide enabled
          autoPlayInterval: Duration(seconds: 3), // ⏱ Interval between slides
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          enlargeCenterPage: true, // optional for effect
          viewportFraction: 0.9,
          aspectRatio: 16 / 9,
          initialPage: 0,
          enableInfiniteScroll: true,
        ),
        );
      }
      )
    );
  }
}
