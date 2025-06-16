import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleApiService {
  final String apiKey = 'AIzaSyDvKn_fqK4JDATVZpxFCAF7HrRIELhj0go';

  Future<Map<String, dynamic>> getPlaceDetails(String input) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&fields=formatted_address,name,geometry&key=$apiKey';

    final response = await http.get(Uri.parse(url));


    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch place details');
    }
  }
}
