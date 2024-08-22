import 'dart:convert';

import 'package:LanAnh_FashionShop/api/api_connection.dart';
import 'package:LanAnh_FashionShop/users/model/clothes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http ;
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../item/item_details_screen.dart';
class CategoryTab extends StatelessWidget {
  
  final String? categoryName ; 
  const CategoryTab({super.key, required this.categoryName});
  
  Future<List<Clothes>> getClothesbyCategory() async { 
    List<Clothes> ClothItemsList = [];
    if(categoryName != "")
    {
      try
      {
        // tim kiem theo ten
        var res = await http.post(
          Uri.parse(API.getClothesbyTypes),
          body: 
          {
            "categoryName": categoryName,
          }
        );

        // ket qua tra ve 
        if(res.statusCode == 200)
        {
          var responseBody = jsonDecode(res.body);
          if(responseBody['success'] == true)
          {
            (responseBody['clothItemsData'] as List).forEach((eachItemData){
              ClothItemsList.add(Clothes.fromJson(eachItemData));
            }); 
          }
        }
        else 
        {
          Fluttertoast.showToast(msg: "status code is not 200");
        }
      }
      catch(errorMsg)
      {
        Fluttertoast.showToast(msg: "Error" + errorMsg.toString());
      }
    }
     return ClothItemsList; 

  }

 Widget allItemsDesignWidget(context){
  return FutureBuilder(
    future: getClothesbyCategory(), 
    builder: (context,AsyncSnapshot<List<Clothes>> dataSnapshot)
      {
        if(dataSnapshot.connectionState == ConnectionState.waiting)
        {
          return const Center(child: CircularProgressIndicator(),);
        }
        if(dataSnapshot.data == null)
        {
          return const Center
          (
            child: Text("No Item"),
          );
        }
         if(dataSnapshot.data!.length > 0 )
           {
             return StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dataSnapshot.data!.length,
              
              itemBuilder:(context,index)
              {
                 Clothes eachClothItemRecord = dataSnapshot.data![index];
                  return 
                  GestureDetector(
                    onTap: () 
                    {
                        Get.to(ItemDetailsScreen(itemInfo: eachClothItemRecord));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                                child: Container(
                                  constraints: const BoxConstraints(minHeight: 100, maxHeight: 200),
                                  child: 
                                    Image
                                    (
                                      fit: BoxFit.cover,
                                      image: NetworkImage
                                        (
                                          eachClothItemRecord.image!
                                        ),
                                    )
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     Get.to(ItemDetailsScreen(itemInfo: eachClothItemRecord));
                                  //   },
                                  //   child: Container(
                                  //     margin: EdgeInsets.fromLTRB(
                                  //       8,
                                  //       index == 0 ? 16 : 8,
                                  //       8,
                                  //       index == dataSnapshot.data!.length - 1 ? 16 : 8,
                                  //     ),
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(20),
                                  //       color: Colors.white,
                                  //       boxShadow: const [
                                  //         BoxShadow(
                                  //           offset: Offset(0, 0),
                                  //           blurRadius: 6,
                                  //           color: Colors.grey,
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     child: Column(
                                  //       crossAxisAlignment: CrossAxisAlignment.start, // Căn chỉnh theo chiều ngang
                                  //       mainAxisSize: MainAxisSize.min, // Đảm bảo chiều cao tự động điều chỉnh theo nội dung
                                  //       children: [
                                  //         // Image
                                  //         ClipRRect(
                                  //           borderRadius: const BorderRadius.only(
                                  //             topRight: Radius.circular(20),
                                  //             topLeft: Radius.circular(20),
                                  //           ),
                                  //           child: FadeInImage(
                                  //             fit: BoxFit.cover,
                                  //             placeholder: const AssetImage("images/place_holder.png"),
                                  //             image: NetworkImage(
                                  //               eachClothItemRecord.image!,
                                  //             ),
                                  //             imageErrorBuilder: (context, error, stackTrace) {
                                  //               return const Center(
                                  //                 child: Icon(
                                  //                   Icons.broken_image_outlined,
                                  //                 ),
                                  //               );
                                  //             },
                                  //           ),
                                  //         ),
                                  //         Padding(
                                  //           padding: const EdgeInsets.all(8.0),
                                  //           child: Column(
                                  //             crossAxisAlignment: CrossAxisAlignment.start,
                                  //             children: [
                                  //               // Name and Price
                                  //               Row(
                                  //                 children: [
                                  //                   // Name
                                  //                   Expanded(
                                  //                     child: Text(
                                  //                       eachClothItemRecord.name!,
                                  //                       maxLines: 2,
                                  //                       overflow: TextOverflow.ellipsis,
                                  //                       style: const TextStyle(
                                  //                         fontSize: 18,
                                  //                         color: Colors.red,
                                  //                         fontWeight: FontWeight.bold,
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                   // Price
                                  //                   Padding(
                                  //                     padding: const EdgeInsets.only(left: 12, right: 12),
                                  //                     child: Text(
                                  //                       "\$${eachClothItemRecord.price}",
                                  //                       maxLines: 2,
                                  //                       overflow: TextOverflow.ellipsis,
                                  //                       style: const TextStyle(
                                  //                         fontSize: 18,
                                  //                         color: Colors.redAccent,
                                  //                         fontWeight: FontWeight.bold,
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               const SizedBox(height: 15),
                                  //               // Tags
                                  //               Text(
                                  //                 "Tags: \n${eachClothItemRecord.tags!.toString().replaceAll("[", "").replaceAll("]", "")}",
                                  //                 maxLines: 2,
                                  //                 overflow: TextOverflow.ellipsis,
                                  //                 style: const TextStyle(
                                  //                   fontSize: 12,
                                  //                   color: Colors.black,
                                  //                   fontWeight: FontWeight.bold,
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                                         
                                ),
                              ),
                              Text
                               (
                                eachClothItemRecord.name!.toString(),maxLines: 2,overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey.shade600,fontSize: 16,fontWeight: FontWeight.w600),
                               ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: 
                                  [
                                    Text(eachClothItemRecord.price!.toStringAsFixed(2)+(' \$'),
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    ),
                                    IconButton(onPressed: ()
                                    {
                                      //  if(itemDetailsController.isFavourite == true){
                                      //   //delete item from favorite 
                                      //     deleteItemToFavouriteList();
                                      //   }
                                      //   else{
                                      //     // save item to user favourite list
                                      //     addItemToFavouriteList();
                                      // }
                                    },
                                     icon: const Icon(Icons.favorite_border_outlined,color: Colors.red,))
                                  ],
                                  ),
                              
                               Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                                   RatingBar.builder(
                                            initialRating: eachClothItemRecord.rating!,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemBuilder: (context, c) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (updateRating){},
                                              ignoreGestures: true ,
                                              unratedColor:Colors.grey,
                                              itemSize: 20 ,
                                            ),
                                         const SizedBox(width: 8,),
                                      //rating numbers
                                      Text(
                                        "(" + eachClothItemRecord.rating.toString() + ")",
                                        style: const TextStyle(
                                          color: Colors.amber,
                                        ),
                                      ),
                                 ],
                               ),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       Text(
                                        "types:" + eachClothItemRecord.tags!.toString().replaceAll("[", "").replaceAll("]", ""),
                                         maxLines: 2,
                                         overflow: TextOverflow.ellipsis,
                                         style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                       ),
                                     ],
                                   )   
                                     
                    
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                
              },
              
              staggeredTileBuilder: (context) => const StaggeredTile.fit(1) ,
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

  @override
  Widget build(BuildContext context) {
    return allItemsDesignWidget(context);
  }
}