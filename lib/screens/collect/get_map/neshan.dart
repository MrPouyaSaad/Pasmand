// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

final Dio neshanHttp = Dio();

class GetAddressFromNeshan {
  static Future<NeshanAddrees> neshanAddress(LatLng origin) async {
    final response = await neshanHttp.get(
        'https://api.neshan.org/v5/reverse?lat=${origin.latitude}&lng=${origin.longitude}',
        options: Options(
            headers: {'Api-Key': 'service.b8dd5968d4254c978cdf94591bfaa7a1'}));
    final address = response.data['formatted_address'];
    return NeshanAddrees(address: address);
  }
}

class NeshanAddrees {
  String address;
  NeshanAddrees({
    required this.address,
  });
}
