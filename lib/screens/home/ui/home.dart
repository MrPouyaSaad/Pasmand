// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:demo/screens/common/widgets/banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:demo/screens/collect/collect_screen.dart';
import 'package:demo/screens/home/wallet/wallet_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: const HomeScreenDrawer(),
          appBar: AppBar(
            elevation: 0.0,
            title: const Text('App Name'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.profile_circled,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return BannerSlider().marginOnly(top: 24, bottom: 24);

                case 1:
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HomeScreenItem(
                        imageName: 'recycling',
                        title: 'جمع آوری',
                        onTap: () {
                          Get.to(
                            const CollectScreen(),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      HomeScreenItem(
                        imageName: 'deposit',
                        title: 'کیف پول',
                        onTap: () {
                          Get.to(
                            const WalletScreen(),
                            transition: Transition.leftToRight,
                          );
                        },
                      ),
                    ],
                  );

                case 2:
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HomeScreenItem(
                        imageName: 'store',
                        title: 'فروشگاه',
                        onTap: () {},
                      ),
                      HomeScreenItem(
                        imageName: 'history',
                        title: 'تاریخچه',
                        onTap: () {},
                      ),
                    ],
                  );

                case 3:
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HomeScreenItem(
                        imageName: 'score',
                        title: 'امتیاز',
                        onTap: () {},
                      ),
                      HomeScreenItem(
                        imageName: 'center',
                        title: 'مراکز حضوری',
                        onTap: () {},
                      ),
                    ],
                  );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}

class HomeScreenItem extends StatelessWidget {
  const HomeScreenItem({
    Key? key,
    required this.title,
    required this.imageName,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final String imageName;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: Get.width / 2 - 32,
        height: 140,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.deepPurple.shade700,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset('assets/images/$imageName.png'),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            )
          ],
        ).marginOnly(left: 16, right: 16, top: 12, bottom: 12),
      ),
    );
  }
}
