// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:demo/screens/collect/get_map/address_data.dart';
import 'package:demo/screens/collect/get_map/get_address.dart';
import 'package:demo/screens/home/ui/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:demo/screens/collect/get_map/neshan.dart';
import 'package:demo/screens/home/wallet/wallet_screen.dart';

class CollectScreen extends StatefulWidget {
  const CollectScreen({super.key});

  @override
  State<CollectScreen> createState() => _CollectScreenState();
}

class _CollectScreenState extends State<CollectScreen> {
  LocationData? userLocation;
  MapController mapController = MapController();
  Marker? originMarker;
  List<LatLng> routePoints = [];
  NeshanAddrees? geAdrress;
  AddressData? getAdrressMapIr;
  bool isSetOrigin = false;
  double isVisitDialog = 0;
  String? address;
  dynamic _dropDownValueType;
  dynamic _dropDownValueWeight;
  TextEditingController addressController = TextEditingController();

  bool isLoading = false;
  @override
  void initState() {
    getUserAplication();

    Future.delayed(
      const Duration(milliseconds: 500),
    )
        .then(
          (value) => setState(
            () {
              isVisitDialog = 1;
            },
          ),
        )
        .then(
          (value) => Future.delayed(
            const Duration(seconds: 5),
          ).then(
            (value) => setState(
              () {
                isVisitDialog = 0;
              },
            ),
          ),
        );

    super.initState();
  }

  Future<void> getUserAplication() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    userLocation = await location.getLocation();
    mapController.move(
        LatLng(userLocation!.latitude!, userLocation!.longitude!), 18);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: const HomeScreenDrawer(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
            width: Get.width - 24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.purpleAccent,
                  onPressed: () async {
                    mapController.move(
                      LatLng(userLocation!.latitude!, userLocation!.longitude!),
                      16,
                    );

                    try {
                      final result = await GetAddress.getAddress(
                        LatLng(
                            userLocation!.latitude!, userLocation!.longitude!),
                      );
                      getAdrressMapIr = result;
                      setState(() {
                        isSetOrigin = true;
                        address = getAdrressMapIr!.fullAddress;
                      });
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                  child: const Icon(Icons.location_searching),
                ),
                // const SizedBox(
                //   height: 16,
                // ),
                // FloatingActionButton.extended(
                //   onPressed: () {},
                //   label: SizedBox(
                //     width: Get.width - 64,
                //     child: const Text(
                //       'تایید مبدا',
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         letterSpacing: 0.5,
                //       ),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // ),
                Visibility(
                  visible: isSetOrigin,
                  child: isSetOrigin
                      ? Container(
                          width: Get.width - 24,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9.0),
                            border: Border.all(
                                color: Colors.deepPurple, width: 1.5),
                            color: Colors.white,
                          ),
                          child: Text(
                            address!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ).marginOnly(top: 16)
                      : const SizedBox(),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: const Text('App Name'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  Get.to(
                    const HomeScreen(),
                    transition: Transition.leftToRight,
                  );
                },
                icon: const Icon(
                  CupertinoIcons.home,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: LatLng(51.394912, 35.72164),
                  zoom: 16,
                  onTap: (tapPosition, point) async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      final result = await GetAddress.getAddress(
                        point,
                      );

                      getAdrressMapIr = result;

                      setState(() {
                        isLoading = false;
                        originMarker = Marker(
                          point: point,
                          builder: (context) {
                            return const Icon(
                              Icons.location_history,
                              size: 32,
                            );
                          },
                        );
                        isSetOrigin = true;
                        address = getAdrressMapIr!.fullAddress;
                        addressController.text = '${address!}  ';
                        showModalBottomSheet<void>(
                          useSafeArea: true,
                          enableDrag: true,
                          isScrollControlled: true,
                          shape: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (context, setState) => Container(
                                // height: Get.height / 2,
                                width: Get.width,
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 4,
                                        width: 36,
                                        margin: const EdgeInsets.only(top: 12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 36,
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: DropdownButton(
                                          value: _dropDownValueType,
                                          isExpanded: true,
                                          hint: const Text(
                                            'نوع پسماند',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'پت',
                                              child: DropDownItem(text: 'پت'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'کارتن',
                                              child:
                                                  DropDownItem(text: 'کارتن'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'کاغذ',
                                              child: DropDownItem(text: 'کاغذ'),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _dropDownValueType = value;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 36,
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: DropdownButton(
                                          value: _dropDownValueWeight,
                                          isExpanded: true,
                                          borderRadius:
                                              BorderRadius.circular(9.0),
                                          underline: null,
                                          hint: const Text(
                                            'وزن تقریبی',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'کمتر از 1 کیلوگرم',
                                              child: DropDownItem(
                                                  text: 'کمتر از 1 کیلوگرم'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'بین 1 الی 2 کیوگرم',
                                              child: DropDownItem(
                                                  text: 'بین 1 الی 2 کیوگرم'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'بین 2 الی 5 کیلوگرم',
                                              child: DropDownItem(
                                                  text: 'بین 2 الی 5 کیلوگرم'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'بیش از 5 کیلوگرم',
                                              child: DropDownItem(
                                                  text: 'بیش از 5 کیلوگرم'),
                                            ),
                                          ],
                                          onChanged: (valueWeight) {
                                            setState(() {
                                              _dropDownValueWeight =
                                                  valueWeight;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 36,
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextField(
                                          controller: addressController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
                                            ),
                                            labelText: 'آدرس دقیق',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 36,
                                      ),
                                      SizedBox(
                                        height: 54,
                                        width: Get.width,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                            shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(9.0),
                                              ),
                                            ),
                                          ),
                                          child: const Text('درخواست'),
                                        ),
                                      ),
                                    ],
                                  ).paddingOnly(
                                      left: 24, right: 24, bottom: 24),
                                ),
                              ),
                            );
                          },
                        );
                      });
                    } catch (e) {
                      setState(() {
                        isLoading = false;
                      });
                      Get.bottomSheet(BottomSheet(
                        onClosing: () {},
                        builder: (context) {
                          return Container(
                            width: Get.width,
                            padding: const EdgeInsets.all(24.0),
                            child: const Text(
                              'مختصات وارد شده نادرست میباشد!',
                              textDirection: TextDirection.rtl,
                            ),
                          );
                        },
                      ));
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: [
                      if (userLocation != null)
                        Marker(
                          point: LatLng(userLocation!.latitude!,
                              userLocation!.longitude!),
                          builder: (context) => const Icon(
                            Icons.location_on,
                            size: 36,
                            color: Colors.indigo,
                          ),
                        ),
                      if (originMarker != null) originMarker!,
                    ],
                  ),
                ],
              ),
              AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: isVisitDialog,
                child: Center(
                  child: Container(
                    width: Get.width / 2,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: const Text(
                      'برای انتخاب مبدا ، روی مکان مورد نظر کلیک کنید!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isLoading,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              // const Center(
              //   child: Icon(
              //     CupertinoIcons.map_pin,
              //     color: Colors.pink,
              //     size: 36,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class DropDownItem extends StatelessWidget {
  const DropDownItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width - 72,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ).marginOnly(right: 16),
    );
  }
}

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Get.width * 2 / 3,
      child: Column(
        children: const [
          Icon(
            Icons.account_circle_outlined,
            size: 92,
            color: Colors.deepPurple,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'پویا صادقزاده',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 24,
          ),
          DrawerItems(
            icon: CupertinoIcons.profile_circled,
            text: 'حساب کاربری',
          ),
          DrawerItems(
            icon: Icons.settings,
            text: 'تنظیمات',
          ),
          DrawerItems(
            icon: Icons.support_agent_sharp,
            text: 'پشتیبانی',
          ),
          DrawerItems(
            icon: Icons.info_outline,
            text: 'درباره ما',
          ),
        ],
      ).paddingOnly(top: 24),
    );
  }
}

class DrawerItems extends StatelessWidget {
  final String text;
  final IconData icon;
  const DrawerItems({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(Colors.black87),
      ),
      onPressed: () {},
      icon: Icon(icon),
      label: SizedBox(
        width: Get.width,
        child: Text(text),
      ),
    );
  }
}
