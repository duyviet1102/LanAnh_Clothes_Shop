import 'dart:convert';
import 'package:LanAnh_FashionShop/api/api_connection.dart';
import 'package:LanAnh_FashionShop/users/UserPrefences/current_user.dart';
import 'package:LanAnh_FashionShop/users/model/clothes.dart';
import 'package:LanAnh_FashionShop/users/model/favourite.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http ;

import '../item/item_details_screen.dart'; 

class FavoritesFragmentScreen extends StatelessWidget{
    
   Future<List<Favourite>> getCurrentUserFavouriteList() async 
  {
    final currentOnlineUser = Get.put(CurrentUser());
    List<Favourite> favouriteListOfCurrentUser = [];
    //call php 
    try
    {
      var res = await http.post(
        Uri.parse(API.readFavourite),
        body: 
        {
          "user_id": currentOnlineUser.user.user_id.toString(),//lấy tất cả danh sách yêu thích của ng dùng HIỆN TẠI
        }
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfGetCurrentFavouriteItems = jsonDecode(res.body);
        if(responseBodyOfGetCurrentFavouriteItems['success'] == true)
        {
           (responseBodyOfGetCurrentFavouriteItems['currentUserFavouriteData'] as List ).forEach((eachCurrentUserFavouriteItem){
               favouriteListOfCurrentUser.add(Favourite.fromJson(eachCurrentUserFavouriteItem));
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

    return favouriteListOfCurrentUser;
  }

   @override 
   Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: 
        [
          const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 8, 8),
              child: Center(
                child: Text(
                "My Favorite List: ",
                style: TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                            ),
              ),
            ),


             const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 8, 8),
              child: Text(
              "Order these best Clothes for yourself now: ",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                
              ),
            ),
            ),

            const SizedBox(height: 24,), 


            //displaying favoriteList 
            favouriteListItemDesignWidget(context)


        ],
      ),
    );
   }

    favouriteListItemDesignWidget(context)
              {
                return FutureBuilder(
                  future: getCurrentUserFavouriteList(),
                  builder: (context,AsyncSnapshot<List<Favourite>> dataSnapshot)
                  {
                      if(dataSnapshot.connectionState == ConnectionState.waiting){
                          return const Center(
                            child: CircularProgressIndicator(),
                          ); 
                        }
                        if(dataSnapshot.data == null){
                          return const Center
                          (
                            child: 
                            Text(
                            "No favourite item found",
                            style: TextStyle(color: Colors.grey)
                            ),
                          ); 
                        }
                        if(dataSnapshot.data!.length > 0 ){
                          return ListView.builder(
                            itemCount: dataSnapshot.data!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index )
                            {
                              Favourite eachFavouriteItemRecord = dataSnapshot.data![index]; 
                              
                              Clothes clickClothItem = Clothes(
                                item_id: eachFavouriteItemRecord.item_id,
                                colors: eachFavouriteItemRecord.colors,
                                image: eachFavouriteItemRecord.image,
                                name: eachFavouriteItemRecord.name,
                                price: eachFavouriteItemRecord.price,
                                rating:  eachFavouriteItemRecord.rating,
                                sizes: eachFavouriteItemRecord.sizes,
                                description: eachFavouriteItemRecord.description,
                                tags: eachFavouriteItemRecord.tags,
                              );
                              return GestureDetector(
                                onTap: (){
                                    Get.to(ItemDetailsScreen(itemInfo: clickClothItem));
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(
                                  16, 
                                  index == 0 ? 16 : 8,
                                    16, 
                                    index == dataSnapshot.data!.length-1 ? 16 : 3 ,
                              ),  
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black,
                                    boxShadow: 
                                      const [ 
                                      BoxShadow(
                                        offset: Offset(0,0),
                                        blurRadius: 6,
                                        color: Colors.grey,
                                      )
                                      ]
                                  ),
                                  child: Row(
                                    children: 
                                    [
                                      //name , price ,tags 
                                      Expanded(
                                        child: 
                                          Padding(
                                            padding:const EdgeInsets.only(left: 15),
                                            child: 
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: 
                                                  [
                                                      //name and price 
                                                        Row(
                                                            children: 
                                                                [
                                                                //name
                                                                    Expanded(
                                                child: 
                                                Text(
                                                eachFavouriteItemRecord.name!,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              )
                                              ),
                                              
                                              //price
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left:12, right: 12),
                                                                      child: Text(
                                                                        "\$" + eachFavouriteItemRecord.price.toString(),
                                                                          maxLines: 2,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: const TextStyle(
                                                                          fontSize: 18,
                                                                          color: Colors.purpleAccent,
                                                                          fontWeight: FontWeight.bold,
                                                                          ),
                                                                          ),
                                                                        ),
                                              //tags


                                                                    ],
                                                                    ) , 
                                          
                                                        const SizedBox(height: 15,),
                                                      //tags
                                                          Text(
                                                              "Tags: \n" + eachFavouriteItemRecord.tags!.toString().replaceAll("[", "").replaceAll("]", ""),
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle
                                                              (
                                                                  fontSize: 12,
                                                                  color: Colors.grey,
                                                                  fontWeight: FontWeight.bold,
                                                              ),
                                                              )
                                                    ],
                                                  )
                                                )
                                            ),
                                      //image 

                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)
                                        ),
                                        
                                        child: FadeInImage(
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover,
                                          placeholder: const AssetImage("images/place_holder.png"),
                                          image: NetworkImage(
                                            eachFavouriteItemRecord.image!,
                                          ),
                                          imageErrorBuilder: (context,error,StackTraceError)
                                          {
                                            return const Center(
                                              child: Icon(
                                                Icons.broken_image_outlined,
                                              ),
                                            );
                                          }
                                          ,
                                          ),
                                      ),

                                    ],
                                  ),
                              ),
                              );
                            },
                            );
                        }
                        else{
                          return const Center(
                            child: Text("Empty, No Data"),
                            );
                        }
                    } 
                  );
              }
}
