import 'package:flutter/material.dart';
import 'package:siku/services/location_service.dart';
class search_bar extends StatefulWidget {
  const search_bar({Key? key}) : super(key: key);


  @override
  State<search_bar> createState() => _search_barState();
}

class _search_barState extends State<search_bar> {
  final TextEditingController searchTextController = TextEditingController();

  void searchPlace() {
    LocationService().getPlaceId(searchTextController.text);
}

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchTextController,
      onFieldSubmitted: (_) {
        _onSearch();
      },
      textCapitalization: TextCapitalization.words ,
      decoration: InputDecoration(hintText: 'Search Here'),
      onChanged: (value) {
        print(value);
      },
      textInputAction: TextInputAction.search,
    );
  }
}
