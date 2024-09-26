import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Text(
          '''At Qirat, we’ve been crafting the finest attars and perfumes for over 20 years, blending the essence of nature and tradition to create timeless fragrances. Our journey began with a passion for delivering luxury scents that resonate with the spirit of tradition, and today we continue to innovate, offering unique fragrances that cater to every mood and moment.

Each bottle of Qirat tells a story — whether it’s the cool freshness of our sports-inspired **Sahar**, the romantic allure of **Rubaie Rose**, or the rich earthiness of **Moss Aura**, we create perfumes that elevate your senses and enhance every special occasion.

Our mission is simple: to offer fragrances that leave a lasting impression, combining authenticity with elegance. Explore our world of luxury, tradition, and the finest scents, where every drop is a journey into the heart of fragrance perfection.''',
          style: TextStyle(fontSize: 16, height: 1.5),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
