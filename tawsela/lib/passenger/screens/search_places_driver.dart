import 'package:flutter/material.dart';
import 'package:users/passenger/Assistants/request_assistant.dart';
import 'package:users/passenger/global/map_key.dart';
import 'package:users/passenger/models/predicted_places.dart';
import 'package:users/passenger/screens/precise_pickup_driver.dart';

import '../../widgets/progress_dialog.dart';
import '../models/directions.dart';

typedef DataCallback = void Function(Directions data);

class SearchPlacesDriver extends StatefulWidget {
  // const SearchPlacesScreen({Key? key}) : super(key: key);
  DataCallback callback;

  SearchPlacesDriver({required this.callback});

  @override
  State<SearchPlacesDriver> createState() => _searchPlacesDriver();
}

class _searchPlacesDriver extends State<SearchPlacesDriver> {
  List<PredictedPlaces> placesPredictedList = [];

  findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:EG";

      var responseAutoCompleteSearch =
          await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      if (responseAutoCompleteSearch == "Error Occured. Failed. No Response.") {
        return;
      }

      if (responseAutoCompleteSearch["status"] == "OK") {
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionsList = (placePredictions as List)
            .map((jsonData) => PredictedPlaces.fromJson(jsonData))
            .toList();

        setState(() {
          placesPredictedList = placePredictionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xFFfdf9eb),
        appBar: AppBar(
          backgroundColor: Color(0xFFfdf9eb),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.clear,
              color: Color(0xFF3C4650),
              size: 26,
            ),
          ),
          title: Text(
            "Search Locations",
            style: TextStyle(color:Color(0xFF3C4650),
              fontSize: 25,
              fontWeight: FontWeight.bold,),
          ),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFfdf9eb),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.white54,
                  //     blurRadius: 8,
                  //     spreadRadius: 0.5,
                  //     offset: Offset(
                  //       0.7,
                  //       0.7,
                  //     )
                  //   )
                  // ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: TextFormField(
                                onChanged: (value) {
                                  findPlaceAutoCompleteSearch(value);
                                },
                                style: TextStyle(color: Color(0xFFfdf9eb)),
                                decoration: InputDecoration(
                                    hintText: "Search",
                                    hintStyle:
                                        const TextStyle(color: Color(0xFF808080)),
                                    filled: true,
                                    fillColor: Color(0xFF3C4650),
                                    contentPadding: EdgeInsets.all(0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        )),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    )),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
          
              //display place predictions result
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: placesPredictedList.length,
                    // physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              getPlaceDirectionDetails(
                                  placesPredictedList[index].place_id, context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF3C4650)                        ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 5 , bottom: 5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_location,
                                    color: Color(0xFFEB9042),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          placesPredictedList[index].main_text!,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFFfdf9eb)
                                          ),
                                        ),
                                        Text(
                                          placesPredictedList
                                                      .elementAt(index)
                                                      .secondary_text !=
                                                  null
                                              ? placesPredictedList
                                                  .elementAt(index)
                                                  .secondary_text!
                                              : "",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFFfdf9eb)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      );
                      // PlacePredictionTileDesign(
                      // predictedPlaces: placesPredictedList[index],
                      // );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 0,
                        color: Color(0xFFfdf9eb),
                        thickness: 0,
                      );
                    },
                  ),
                ],
              )
              // : Container(),
            ],
          ),
        ),
      ),
    );
  }

  getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Setting up Drop-off. Please wait.....",
            ));

    String placeDirectionDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var responseApi =
        await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

    Navigator.pop(context);

    if (responseApi == "Error Occured. Failed. No Response.") {
      print("FFFFFFFFFFFFFFFF");

      return;
    }
    if (responseApi["status"] == "OK") {
      print("SSSSSSSSSSSSSSssss");

      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude =
          responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude =
          responseApi["result"]["geometry"]["location"]["lng"];

      // Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);

      setState(() {
        widget.callback(directions);
      });

      Navigator.pop(context);
    }
  }
}
