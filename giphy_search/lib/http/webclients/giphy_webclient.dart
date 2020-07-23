import 'dart:convert';
import 'package:giphy_search/http/webclient.dart';
import 'package:http/http.dart' as http;

class GiphyWebClient {
  Future<Map> getGiphys(String search, {int offset}) async {
    http.Response resp;

    if (search == null || search.isEmpty)
      resp = await http.get(URL_TREDING);
    else
      resp = await http.get('$URL_SEARCH&offset=$offset&q=$search');

    return json.decode(resp.body);
  }
}
