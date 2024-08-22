import 'dart:convert';

import 'package:LanAnh_FashionShop/users/UserPrefences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http ;
import 'package:intl/intl.dart';

import '../../api/api_connection.dart';
import '../model/order.dart';
import '../order/order_details.dart';

class HistoryScreen extends StatelessWidget{

  Future<List<Order>> getCurrentUserOrdersList() async 
  {
    final currentOnlineUser = Get.put(CurrentUser());
    List<Order> ordersListOfCurrentUser = [];
    //call php 
    try
    {
      var res = await http.post(
        Uri.parse(API.readHistory),
        body: 
        {
          "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),//lấy tất cả danh sách yêu thích của ng dùng HIỆN TẠI
        }
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfGetCurrentOrdersItems = jsonDecode(res.body);
        if(responseBodyOfGetCurrentOrdersItems['success'] == true)
        {
           (responseBodyOfGetCurrentOrdersItems['currentUserOrderData'] as List ).forEach((eachCurrentUserOrdersData){
               ordersListOfCurrentUser.add(Order.fromJson(eachCurrentUserOrdersData));
           });
        }
      }
      else{
        Fluttertoast.showToast(msg:  "Status code is not 200 ");
      }
    }
    catch(errorMsg){
      Fluttertoast.showToast(msg: "Error:" + errorMsg.toString());
    }
    return ordersListOfCurrentUser;
  }
   
   
   @override 
   Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      body:Column
      ( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children :[

       //my order image       //history image 
       //myOrder title        //history title 

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 8, 0),
          child:  
           Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                    children: 
                    [
                      Image.asset
                      (
                        "images/history_icon.png",
                         width: 45,
                      ),
                       const Text(
                            "My History",
                            style:  TextStyle
                            (
                              color: Colors.purpleAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                            ),
                          )
                    ],
                  ),
            ),
          ),
          ),
        
        //some in4
        const Center(
          child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Here are your successfully recieved parcels.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),),

        Expanded
         (
          child: displayOrdersList(context),
          )
          //displaying the user orderList 
          ,
        ]
        ),
    );
   }  


    displayOrdersList(context)
    {
        return FutureBuilder(
         future: getCurrentUserOrdersList(),
         builder: (context, AsyncSnapshot<List<Order>> dataSnapshot)
         {
          if(dataSnapshot.connectionState == ConnectionState.waiting)
          {
            return 
             const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: 
               [
                Center(
                  child: 
                   Text(
                    "Connection Waiting ...",
                    style: TextStyle(color: Colors.grey),
                   ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                )
               ],
            );
          }
           
          if(dataSnapshot.data == null )
          {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: 
                [
                Center(
                  child: 
                   Text(
                    "Connection Waiting ..."
                   ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                )
               ],
            );
          }

          if(dataSnapshot.data!.length > 0)
          {
             List<Order> orderList = dataSnapshot.data!;
             return ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (context,index)
              {
                return const Divider(
                  height: 1,
                  thickness: 1,
                );
              },
              itemCount: dataSnapshot.data!.length,
              itemBuilder: (context,index)
              {
                Order eachOrderData = orderList[index];
                return Card(
                  color: Colors.white24,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: ListTile(
                      onTap:()
                      {
                         Get.to(OrderDetailsScreen(
                            clickedOrderInfo: eachOrderData,
                         ));
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order ID #" + eachOrderData.order_id.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold, 
                            ),
                          ),

                          Text(
                            "Amount: \$ " + eachOrderData.order_id.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold, 
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //date
                          //time 
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //date //DateFormat
                              Text(
                                DateFormat("dd MMMM, yyyy").format(eachOrderData.dateTime!), //DateFormat
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              
                              const SizedBox(height: 4,),
                              //time //DateFormat 
                              Text(
                                DateFormat(
                                  "hh:mm a"
                                ).format(eachOrderData.dateTime!),
                              )

                            ],
                          ),
                          
                          const SizedBox(width: 6,),

                          const Icon(
                            Icons.navigate_next,
                            color: Colors.purpleAccent,
                          )
                        ],
                      ),
                      ),
                  ),
                );
              },
             );
          }
          else
          {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
              [
                Center(
                  child: Text(
                    "Nothing to show...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            )
;          }
          

         });
    }
}