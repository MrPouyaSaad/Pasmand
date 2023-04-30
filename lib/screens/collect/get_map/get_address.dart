import 'package:demo/screens/collect/get_map/address_data.dart';
import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';

final Dio httpClient = Dio(
  BaseOptions(
    baseUrl: 'https://map.ir/',
  ),
);

class GetAddress {
  static Future<AddressData> getAddress(LatLng origin) async {
    final response = await httpClient.get(
        options: Options(
          headers: {
            'x-api-key':
                'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjZiNjQ3NjEwZjgzNjg0OTM2YTIwNjU4YzFhOTljYTMzY2VjNGViODM1MDU3ZmU0OWViMDhiNzNiNzdmMjdhZjYyMzhlMGVmMzQ5MThiZGM5In0.eyJhdWQiOiIyMjAzMCIsImp0aSI6IjZiNjQ3NjEwZjgzNjg0OTM2YTIwNjU4YzFhOTljYTMzY2VjNGViODM1MDU3ZmU0OWViMDhiNzNiNzdmMjdhZjYyMzhlMGVmMzQ5MThiZGM5IiwiaWF0IjoxNjgyNTI4MTM1LCJuYmYiOjE2ODI1MjgxMzUsImV4cCI6MTY4NTEyMDEzNSwic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.rNq1nwnJNLHSeRL_zea1qwmswwy-OIbJ3gHWfZ-M3XG7WdjYzmZYFSS9D2RfY93mK5mWRBE105Hdln6FBWw2Dp40hXCGwkrknrsgE0D5zAn3Ge-fcLc-CD_8e2f5zbRLHVsXLpRhvMKXfpWPB4gdFhbxu1jSbcR_nZ-WbEhwsZ5X1Hd32ZCFOX7H4MdDdeua72QYnPdf8HGn1bIW60MIUsJZq6zOVopmV7HKOGPXruaneFM24Sm8ywkmAr-fsO7hHiNigZWLc9a-xCibemBWalnG5lub9oKU_EIGJnjHjwAQ6QTneqyyMvDcF2U1RgQ7Ozd4nXSoIpq81y5lsWWS0A',
          },
        ),
        'reverse/fast-reverse?lat=${origin.latitude}&lon=${origin.longitude}');
    final address = response.data['address_compact'];

    return AddressData(address);
  }
}
