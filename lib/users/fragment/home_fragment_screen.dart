
import 'dart:convert';
import 'package:LanAnh_FashionShop/api/api_connection.dart';
import 'package:LanAnh_FashionShop/users/cart/cart_list_screen.dart';
import 'package:LanAnh_FashionShop/users/fragment/Category_tab.dart';
import 'package:LanAnh_FashionShop/users/item/item_details_screen.dart';
import 'package:LanAnh_FashionShop/users/model/clothes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http ;
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import '../UserPrefences/current_user.dart';
import '../item/search_items.dart'; 
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:LanAnh_FashionShop/users/controller/item_detais_controller.dart';
class HomeFragmentScreen extends StatelessWidget
{  
 
          //search bar widget
   TextEditingController searchController = TextEditingController(); 
   Widget showSearchBarWidget()
   {
     return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: 
      
      TextField(
          style: const TextStyle(color: Colors.black),
           controller: searchController,
           decoration: InputDecoration( 
           prefixIcon: 
          
           // search 
            IconButton(
             onPressed: ()
              {
                 
              },
              icon: const Icon(
                 Icons.search,
                color: Colors.purpleAccent,
              )
           ),
           hintText: "Search best clothes here...",
           hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
             ),

            // cart button
           suffixIcon: IconButton(
                 onPressed: ()
                 {
                   Get.to(CartListScreen());
                 },
                 icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.purpleAccent
                 ),
              ),
           border: const OutlineInputBorder(
              borderSide: BorderSide(
              width: 12,
              color: Colors.purpleAccent,
            ),
           ),
           enabledBorder: const  OutlineInputBorder(
              borderSide: BorderSide(
              width: 2,
              color: Colors.purple,
            ),
           ),
           focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
              width: 1,
              color: Colors.purpleAccent,
            ),
           ),
           contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
           ),
           fillColor: Colors.white,
           filled:true,
           )
        )
     );
   }
   
  
   Widget build(BuildContext context){
    return 
    DefaultTabController(
      length: 6,
      child: 
       Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: InkWell(
            onTap: ()
            {
              Get.to(() => SearchItems(typedKeywords: searchController.text));
            },
            child: Container(
              height:42,
              decoration:  
                BoxDecoration(
                  border:Border.all(color: Colors.yellow, width: 1.4),
                  borderRadius: BorderRadius.circular(25)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                        Text('What are you looking for?', style: TextStyle(fontSize: 16, color: Colors.grey  )),
                      ],
                    ),
                    
                    Container(
                      height: 44,
                      width: 75,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child: 
                      const Center(
                        child:
                      Text(
                        'Search',
                        style: TextStyle(fontSize: 16, color:Colors.grey),
                      ),),
                    ),
                  ],
                  )  ,
                  ),
          ),
         bottom:  const TabBar(
          isScrollable: true,
          indicatorColor: Colors.yellow,
          indicatorWeight: 3,
          tabs: [
              RepeatedTab(label: 'Home',),
              RepeatedTab(label: 'Men',),
              RepeatedTab(label: 'Women'),
              RepeatedTab(label: 'Shoes'),
              RepeatedTab(label: 'Bags'),
              RepeatedTab(label: 'Kids'),
          ] ),
            ),
          body: TabBarView(
            children: [
                HomeTab(),
                const CategoryTab(categoryName: 'men'),
                const CategoryTab(categoryName: 'women'),
                const CategoryTab(categoryName: 'shoes'),
                const CategoryTab(categoryName: 'bags'),
                const CategoryTab(categoryName: 'kids'),

            ]
              ),
           )
    );
   }
   
   
  }

 class RepeatedTab extends StatelessWidget {
  final String label ; 

  const RepeatedTab({
    Key? key, required this.label
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(child: Text(
       label,
      style: TextStyle(color: Colors.grey.shade600),
      ),
      );
  }
}
 
//  class Tile extends StatelessWidget{
//   final int index ; 
//   const Tile({Key? key, required this.index}) : super(key: key);
//   Widget build(BuildContext context){
//     return Container();
//   }
//  }
  
 class HomeTab extends StatelessWidget{
   Widget trendingMostPopularClothItemWidget(context){
      return 
      // StaggeredGrid.countBuilder(crossAxisCount: 2,);
      FutureBuilder(
        future: getTrendingClothesItem(),
        builder:  (context, AsyncSnapshot<List<Clothes>> datasnapShot)
        {
            if(datasnapShot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              ); 
                 
            }
            if(datasnapShot.data == null){
              return const Center(child: Text(
                "No Trending item found",
              ),
              ); 
            }
            if(datasnapShot.data!.length > 0 ){
              return Container(
               height: 260,
               child:
                 ListView.builder(
                  itemCount: datasnapShot.data!.length ,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index)
                  {
                   Clothes eachClothItemData =  datasnapShot.data![index];
                   return GestureDetector(
                    onTap: (){
                         Get.to(ItemDetailsScreen(itemInfo: eachClothItemData));
                    },
                     child: Container(
                      width: 200,
                      margin: EdgeInsets.fromLTRB(
                        index == 0 ? 16 : 8,
                        10,
                        index == datasnapShot.data!.length - 1 ? 16 : 8 ,
                        10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: 
                           const [ 
                           BoxShadow(
                            offset: Offset(0,3),
                            blurRadius: 6,
                            color: Colors.grey,
                           )
                           ]
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                               topLeft: Radius.circular(22),
                               topRight: Radius.circular(22)
                            ),
                            
                            child: FadeInImage(
                              height: 150,
                              width: 200,
                              fit: BoxFit.cover,
                              placeholder: const AssetImage("images/place_holder.png"),
                              image: NetworkImage(
                                eachClothItemData.image!,
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
                          
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //name $ price 
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        eachClothItemData.name!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const  TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            
                                    const SizedBox(width: 30,),
                            
                                    //price
                                     Text(
                                      eachClothItemData.price!.toString(),
                                      style: const  TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(
                                  width: 8,
                                ),
                             
                                Row(
                                  children: [
                                    //rating stars 
                                    RatingBar.builder(
                                      initialRating: eachClothItemData.rating!,
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
                                      "(" + eachClothItemData.rating.toString() + ")",
                                      style: const TextStyle(
                                        color: Colors.amber,
                                      ),
                                    ),
                               
                                  ],
                                )      
                              ],
                            ),
                          )
                        ],
                        ),
                    )
                   ); // each record of Clothes list 
                  },
                )
              );
            }
            else
            {
              return Center(
                child: Text("Empty, No data. "),
              ); 
            }
        },
      
       );
   
   }
  
   Widget allItemsDesignWidget(context)
   {
    return FutureBuilder(
       future: getAllClothesItem(),
       builder: (context,AsyncSnapshot<List<Clothes>> dataSnapshot)
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
                "No Trending item found",
                 ),
              ); 
            }
           if (dataSnapshot.data!.length > 0) 
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
             

            //  return   
            //  ListView.builder(
            //     itemCount: dataSnapshot.data!.length,
            //     shrinkWrap: true,
            //     physics: const NeverScrollableScrollPhysics(),
            //     scrollDirection: Axis.vertical,
            //     itemBuilder: (context, index )
            //     {
            //       Clothes eachClothItemRecord = dataSnapshot.data![index]; 
            //       return GestureDetector(
            //         onTap: (){
            //               Get.to(ItemDetailsScreen(itemInfo: eachClothItemRecord));
            //         },
            //         child: Container(
            //           margin: EdgeInsets.fromLTRB(
            //            16, 
            //            index == 0 ? 16 : 8,
            //             16, 
            //             index == dataSnapshot.data!.length-1 ? 16 : 3 ,
            //        ),  
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(20),
            //             color: Colors.white,
            //             boxShadow: 
            //                const [ 
            //               BoxShadow(
            //                 offset: Offset(0,0),
            //                 blurRadius: 6,
            //                 color: Colors.grey,
            //                )
            //                ]
            //           ),
            //           child: Row(
            //             children: 
            //             [
            //               //name , price ,tags 
            //               Expanded(
            //                 child: 
            //                   Padding(
            //                      padding:const EdgeInsets.only(left: 15),
            //                      child: 
            //                      Column(
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         children: 
            //                            [
            //                               //name and price 
            //                                  Row(
            //                                      children: 
            //                                          [
            //                                         //name
            //                                             Expanded(
            //                         child: 
            //                         Text(
            //                          eachClothItemRecord.name!,
            //                          maxLines: 2,
            //                          overflow: TextOverflow.ellipsis,
            //                          style: const TextStyle(
            //                           fontSize: 18,
            //                           color: Colors.red,
            //                           fontWeight: FontWeight.bold
            //                         ),
            //                        )
            //                       ),
                                   
            //                       //price
            //                                             Padding(
            //                                                padding: const EdgeInsets.only(left:12, right: 12),
            //                                                child: Text(
            //                                                  "\$" + eachClothItemRecord.price.toString(),
            //                                                   maxLines: 2,
            //                                                   overflow: TextOverflow.ellipsis,
            //                                                   style: const TextStyle(
            //                                                   fontSize: 18,
            //                                                   color: Colors.redAccent,
            //                                                   fontWeight: FontWeight.bold,
            //                                                   ),
            //                                                   ),
            //                                                  ),
            //                       //tags


            //                                             ],
            //                                             ) , 
                               
            //                                  const SizedBox(height: 15,),
            //                               //tags
            //                                   Text(
            //                                        "Tags: \n" + eachClothItemRecord.tags!.toString().replaceAll("[", "").replaceAll("]", ""),
            //                                        maxLines: 2,
            //                                        overflow: TextOverflow.ellipsis,
            //                                        style: const TextStyle
            //                                        (
            //                                           fontSize: 12,
            //                                           color: Colors.black,
            //                                           fontWeight: FontWeight.bold,
            //                                        ),
            //                                       ),
            //                             ],
            //                           )
            //                          )
            //                      ),
            //               //image 

            //                ClipRRect(
            //                 borderRadius: const BorderRadius.only(
            //                    topRight: Radius.circular(20),
            //                    bottomRight: Radius.circular(20)
            //                 ),
                            
            //                 child: FadeInImage(
            //                   height: 150,
            //                   width: 150,
            //                   fit: BoxFit.cover,
            //                   placeholder: const AssetImage("images/place_holder.png"),
            //                   image: NetworkImage(
            //                     eachClothItemRecord.image!,
            //                   ),
            //                   imageErrorBuilder: (context,error,StackTraceError)
            //                   {
            //                     return const Center(
            //                       child: Icon(
            //                         Icons.broken_image_outlined,
            //                       ),
            //                     );
            //                   }
            //                   ,
            //                   ),
            //               ),

            //             ],
            //           ),
            //       ),
            //       );
            //     },
            //     );
            
            } 
            else 
            {
              return const Center(
                child: Text("Empty, No Data"),
              );
            }         
        } 
       );
     
   }
  
  Future<List<Clothes>> getTrendingClothesItem() async {
      List<Clothes> trendingClothItemsList = [] ; 
      try{
        var res =  await http.post(
          Uri.parse(API.getTrendingMostPopularClothes),
         );
         if(res.statusCode == 200){
           var responseBodyOfTrending =  jsonDecode(res.body);//body = clothItemsData
           if(responseBodyOfTrending["success"] == true)
           {// num_row > 0 
            (responseBodyOfTrending["clothItemsData"] as List).forEach((Record)// mỗi bản ghi chuyển thành 1 basic normal format
              {
                trendingClothItemsList.add(Clothes.fromJson(Record)); //add to trending lish 
              }
            ); 
           }
           else{
            Fluttertoast.showToast(msg: "Error,status code is not 200 "); 
           }
         }
      }
      catch(e)
      {
          print("Error:: " + e.toString()); 
      }
      return trendingClothItemsList;  
  }

  Future<List<Clothes>> getAllClothesItem() async {
      List<Clothes> allClothItemsList = [] ; 
      try{
        var res =  await http.post(
          Uri.parse(API.getAllClothes),
         );
         if(res.statusCode == 200){
           var responseBodyOfAllClothes =  jsonDecode(res.body);//body = clothItemsData
           if(responseBodyOfAllClothes["success"] == true)
           {// num_row > 0 
            (responseBodyOfAllClothes["clothItemsData"] as List).forEach((Record)// mỗi bản ghi chuyển thành 1 basic normal format
              {
                allClothItemsList.add(Clothes.fromJson(Record)); //add to trending lish 
              }
            ); 
           }
           else{
            Fluttertoast.showToast(msg: "Error,status code is not 200 "); 
           }
         }
      }
      catch(e)
      {
          print("Error:: " + e.toString()); 
      }
      return allClothItemsList;  
  }

   HomeTab({Key? key}) : super(key: key);
    @override
   Widget build(BuildContext context){
    return 
     Container(
       decoration: BoxDecoration(
         color: Colors.blueGrey.shade500.withOpacity(0.3)
       ),
       child: SingleChildScrollView(
          child: 
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: 
          [         
            const SizedBox(height: 16,),
            //trending-popular items
            const Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20),
              child: 
              Text(
                "Trending",
                style: 
                TextStyle
                (
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),          
              ),
            ),
             
            trendingMostPopularClothItemWidget(context),
       
            const SizedBox(height: 16,),
       
            //all new collection
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("New Collection",
               style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
               ),          
              ),
            ),
          
            allItemsDesignWidget(context),
          ],
          ),
           ),
     );
   }

  }