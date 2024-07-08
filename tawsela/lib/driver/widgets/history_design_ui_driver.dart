import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/trips_history_model_passenger.dart';


class HistoryDesignUIWidget extends StatefulWidget
{
  TripsHistoryModel? tripsHistoryModel;

  HistoryDesignUIWidget({this.tripsHistoryModel});

  @override
  State<HistoryDesignUIWidget> createState() => _HistoryDesignUIWidgetState();
}

class _HistoryDesignUIWidgetState extends State<HistoryDesignUIWidget>
{
  String formatDateAndTime(String dateTimeFromDB)
  {
    DateTime dateTime = DateTime.parse(dateTimeFromDB);

    // Dec 10                            //2022                         //1:12 pm
    String formattedDatetime = "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDatetime;
  }

  @override
  Widget build(BuildContext context)
  {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formatDateAndTime(widget.tripsHistoryModel!.time!),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 10,),

        Container(
          decoration: BoxDecoration(
            color: darkTheme ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(width: 15,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.tripsHistoryModel!.userName!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8,),

                          // Row(
                          //   children: [
                          //     Icon(
                          //       Icons.star,
                          //       color: Colors.orange,
                          //     ),
                          //
                          //     SizedBox(width: 5,),
                          //
                          //     Text(
                          //       widget.tripsHistoryModel!.ratings!,
                          //       style: TextStyle(
                          //         color: Colors.grey,
                          //       ),
                          //     )
                          //
                          //   ],
                          // )
                        ],
                      )

                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Final Cost',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      SizedBox(height: 8,),

                      Text(
                        'US\$${widget.tripsHistoryModel!.fareAmount!}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Text(
                        'Status',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      SizedBox(height: 8,),

                      Text(
                        widget.tripsHistoryModel!.status!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                ],
              ),

              SizedBox(height: 10,),

              Divider(
                height: 10,
                thickness: 3,
                color: Colors.grey[200],
              ),

              SizedBox(height: 10,),

              Row(
                children: [
                  Text(
                    'TRIP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(width: 15,),

                      Text(
                        "${(widget.tripsHistoryModel!.originAddress!).substring(0, 15)} ...",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                ],
              ),

              SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(width: 15,),

                      Text(
                        widget.tripsHistoryModel!.destinationAddress!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ],
          ),
        ),

      ],
    );

    // return Container(
    //   color: Colors.black54,
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //
    //         //driver name + Fare Amount
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.only(left: 6.0),
    //               child: Text(
    //                 "Driver : " + widget.tripsHistoryModel!.driverName!,
    //                 style: const TextStyle(
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ),
    //
    //             const SizedBox(width: 12,),
    //
    //             Text(
    //               "\$ " + widget.tripsHistoryModel!.fareAmount!,
    //               style: const TextStyle(
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ],
    //         ),
    //
    //         const SizedBox(height: 2,),
    //
    //         // car details
    //         Row(
    //           children: [
    //             const Icon(
    //               Icons.car_repair,
    //               color: Colors.black,
    //               size: 28,
    //             ),
    //
    //             const SizedBox(width: 12,),
    //
    //             Text(
    //               widget.tripsHistoryModel!.car_details!,
    //               style: const TextStyle(
    //                 fontSize: 16,
    //                 color: Colors.grey,
    //                 fontWeight: FontWeight.w600,
    //               ),
    //             ),
    //           ],
    //         ),
    //
    //         const SizedBox(height: 20,),
    //
    //         //icon + pickup
    //         Row(
    //           children: [
    //
    //             Image.asset(
    //               "images/origin.png",
    //               height: 26,
    //               width: 26,
    //             ),
    //
    //             const SizedBox(width: 12,),
    //
    //             Expanded(
    //               child: Container(
    //                 child: Text(
    //                   widget.tripsHistoryModel!.originAddress!,
    //                   overflow: TextOverflow.ellipsis,
    //                   style: const TextStyle(
    //                     fontSize: 16,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //
    //           ],
    //         ),
    //
    //         const SizedBox(height: 14,),
    //
    //         //icon + dropOff
    //         Row(
    //           children: [
    //
    //             Image.asset(
    //               "images/destination.png",
    //               height: 24,
    //               width: 24,
    //             ),
    //
    //             const SizedBox(width: 12,),
    //
    //             Expanded(
    //               child: Container(
    //                 child: Text(
    //                   widget.tripsHistoryModel!.destinationAddress!,
    //                   overflow: TextOverflow.ellipsis,
    //                   style: const TextStyle(
    //                     fontSize: 16,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //
    //           ],
    //         ),
    //
    //         const SizedBox(height: 14,),
    //
    //         //trip time and date
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             const Text(""),
    //             Text(
    //               formatDateAndTime(widget.tripsHistoryModel!.time!),
    //               style: const TextStyle(
    //                 color: Colors.grey,
    //               ),
    //             ),
    //           ],
    //         ),
    //
    //         const SizedBox(height: 2,),
    //
    //       ],
    //     ),
    //   ),
    // );
  }
}
