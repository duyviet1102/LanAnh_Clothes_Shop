import 'dart:convert';

import 'package:LanAnh_FashionShop/api/api_connection.dart';
import 'package:LanAnh_FashionShop/users/UserPrefences/current_user.dart';
import 'package:LanAnh_FashionShop/users/cart/cart_list_screen.dart';
import 'package:LanAnh_FashionShop/users/controller/item_detais_controller.dart';
import 'package:LanAnh_FashionShop/users/model/clothes.dart';
import 'package:flutter/material.dart' ;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http ; 

class ItemDetailsScreen extends StatefulWidget
{
  final Clothes? itemInfo ; 
  ItemDetailsScreen({this.itemInfo}); 
  @override 
  State<ItemDetailsScreen> createState()  => _ItemDetailsScreenState(); 
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> 
{
  final itemDetailsController = Get.put(ItemDetaisController());
  final currentOnlineUser = Get.put(CurrentUser());

  addItemToCart() async {
    try{
      var res = await http.post
       (
         Uri.parse(API.addToCart),
         body: {
            "user_id": currentOnlineUser.user.user_id.toString(), 
            "item_id": widget.itemInfo!.item_id.toString(), 
            "quantity": itemDetailsController.quantity.toString(), 
            "color": widget.itemInfo!.colors![itemDetailsController.color], 
            "size": widget.itemInfo!.sizes![itemDetailsController.size], 
        }
       ); 
      if(res.statusCode == 200) // 200 is response code tell us the request success  
        {
         var resBodyofAddCart = jsonDecode(res.body);
         if(resBodyofAddCart['success'] == true){
            Fluttertoast.showToast(msg: "item saved to Cart Successfully");
         }
         else {
            Fluttertoast.showToast(msg: "Error Occur. Item not saved to Cart and Try Again. ");
         }
        } 
        else{
          Fluttertoast.showToast(msg: "Status is not 200"); 
        }
    }
    catch(error){
       print("Error ::" + error.toString());
    }
  }


  validateFavouriteList() async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.validateFavourite),
        body: {
          "user_id": currentOnlineUser.user.user_id.toString(),
          "item_id": widget.itemInfo!.item_id.toString(),
        },
      );

      if(res.statusCode == 200) //from flutter app the connection with api to server - success
      {
        var resBodyOfValidateFavorite = jsonDecode(res.body);
        if(resBodyOfValidateFavorite['favouriteFound'] == true)
        {
          itemDetailsController.setisFavouriteItem(true);
        }
        else
        {
          itemDetailsController.setisFavouriteItem(false);
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error :: " + errorMsg.toString());
    }
  }

  addItemToFavouriteList() async 
  {
     try
    {
      var res = await http.post(
        Uri.parse(API.addFavourite),
        body: {
          "user_id": currentOnlineUser.user.user_id.toString(),
          "item_id": widget.itemInfo!.item_id.toString(),
        },
      );

      if(res.statusCode == 200) //from flutter app the connection with api to server - success
      {
        var resBodyOfAddFavorite = jsonDecode(res.body);
        if(resBodyOfAddFavorite['success'] == true)
        {
          Fluttertoast.showToast(msg: "item saved to your Favorite List Successfully.");

          validateFavouriteList();
        }
        else
        {
          Fluttertoast.showToast(msg: "Item not saved to your Favorite List.");
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error :: " + errorMsg.toString());
    }
  }
  
  deleteItemToFavouriteList() async
  {
    try
    {
       var res = await http.post
       (
         Uri.parse(API.deleteFavourite),
         body: {
            "user_id": currentOnlineUser.user.user_id.toString(), 
            "item_id": widget.itemInfo!.item_id.toString(), 
        }
       ); 
       if(res.statusCode == 200) // 200 is response code tell us the request success  
        {
         var resBodyOfAdDeleteFavourite = jsonDecode(res.body);
         if(resBodyOfAdDeleteFavourite['success'] == true){
            Fluttertoast.showToast(msg: "item Deleted to Favourite List Successfully");
            validateFavouriteList();
         }
         else {
            Fluttertoast.showToast(msg: "item is Not in Favourite List. ");
         }
        } 
        else{
          Fluttertoast.showToast(msg: "Status is not 200"); 
        }

    }
    catch(e)
    {
      print("Error: " + e.toString());

    }
  }
 
  @override
  void initState(){
    super.initState();
    validateFavouriteList();
  }
  @override  
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: 
        [
          FadeInImage(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage("images/place_holder.png"),
                  image: NetworkImage
                  (
                    widget.itemInfo!.image!,
                  ),
                  imageErrorBuilder: (context,error,StackTraceError)
                    {
                      return const Center(
                          child: Icon
                          (
                            Icons.broken_image_outlined,
                          ),
                          ) ;
                        },
                   ),
          //item information 
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
            ),
        
          //3 buttons - favourite - shopping cart - back 
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  //back 
                   IconButton(
                     onPressed: (){
                     Get.back();
                   },
                    icon: const Icon(
                      Icons.arrow_back,
                      color : Colors.purpleAccent,
                    ),),

                    const Spacer(),

                    //favourite 
                    Obx(()=> IconButton(
                     onPressed: ()
                      {
                         if(itemDetailsController.isFavourite == true){
                          //delete item from favorite 
                          deleteItemToFavouriteList();
                         }
                         else{
                           // save item to user favourite list
                           addItemToFavouriteList();
                         }
                      },
                     icon: Icon(
                       itemDetailsController.isFavourite ? 
                       Icons.bookmark :
                       Icons.favorite_outline,
                       color: Colors.purpleAccent,
                      ),
                      ),
                      ),
                     
                     //Cart
                     IconButton(
                      onPressed: ()
                      {
                        Get.to(CartListScreen());
                      },
                     
                      icon: 
                       const Icon(
                        Icons.shopping_cart,
                        color: Colors.purpleAccent,
                       ),),
                ],
              ),
            )
            )
        ],
      )
    );
  
  }

  itemInfoWidget(){
  return Container(
    height: MediaQuery.of(Get.context!).size.height * 0.6,
    width: MediaQuery.of(Get.context!).size.width,
    decoration: const BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      boxShadow: 
      [
        BoxShadow(
          offset: Offset(0,-3),
          blurRadius: 6,
          color: Colors.purpleAccent
        )
      ]
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: SingleChildScrollView(
      child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: 
        [
          const SizedBox(height: 30,),
           
          Center(
            child: Container(
              height: 8,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(30),
              ),
              ),
          ),
        
          const SizedBox(height: 30,),
          
          //name
          Text(
                  widget.itemInfo!.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const 
                    TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                           ),
                 ),
          
          const SizedBox(height: 10,),

          //rating + rating number


          //tags


          //price


          //item counter
           Row(
            crossAxisAlignment: CrossAxisAlignment.start,
             //rating + rating number
               //tags
               //price
            children: 
            [
              Expanded(

               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: 
                [
                   //rating + rating number
                   Row(
                    children: 
                    [
                       RatingBar.builder(
                            initialRating: widget.itemInfo!.rating!,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (context, c) => 
                             const Icon(
                                Icons.star,
                                      color: Colors.amber,
                                  ),
                            onRatingUpdate: (updateRating){},
                            ignoreGestures: true ,
                            unratedColor:Colors.grey,
                            itemSize: 20 ,
                        ),

                        //rating number 
                         Text
                         (
                               "(" + widget.itemInfo!.rating.toString() + ")",
                                style: 
                                 const TextStyle(
                                        color: Colors.grey,
                                      ),
                             ),
                    ]
                   ),
                    //tags
                              
                         const SizedBox(height: 16,),
                         Text(
                          widget.itemInfo!.tags!.toString().replaceAll("[","" ).replaceAll("]", ""),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight:FontWeight.bold
                          ),
                         ),

                         const SizedBox(height: 16,),
                         //price       
                         Text(
                               "\$" + widget.itemInfo!.price.toString(),
                              style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.purpleAccent,
                                      fontWeight: FontWeight.bold,
                                        ),
                         ),
                ],
               )
              ),
              
              //item counter 
            ],
           ),
           
            const SizedBox(height: 18,),
           //size
            const Text(
            "Size",
            style:  TextStyle(
              fontSize: 16,
              color: Colors.purpleAccent,
              fontWeight: FontWeight.bold,
            ),
           ),

            const SizedBox(height: 9,),
           //Wrap
            Wrap(
            runSpacing: 8,
            spacing: 8,
            children: 
              List.generate
              (
                widget.itemInfo!.sizes!.length, 
              (index){
                return Obx(
                  ()=> GestureDetector(
                    onTap: ()
                    {
                       itemDetailsController.setSizeItem(index);
                    },
                    child: Container(
                       height: 35,
                       width: 60,
                       decoration: 
                       BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: itemDetailsController.size == index ? Colors.green : Colors.grey,
                        ),
                        color: itemDetailsController.size == index ? Colors.purpleAccent.withOpacity(0.7) : Colors.white,
                       ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.itemInfo!.sizes![index].replaceAll("[", "").replaceAll("]", ""),
                      )
                      ),
                  )
                );
              }
              ),
            ),
           
            const SizedBox(height: 20,),
           
           
            //Color   
            const Text(
               "Color",
                style:  TextStyle
                (
                  fontSize: 16,
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                 ),
               ),
            const SizedBox(height: 9,),
           //Wrap
             Wrap(
            runSpacing: 8,
            spacing: 8,
            children: 
              List.generate
              (
                widget.itemInfo!.colors!.length, 
              (index){
                return Obx(
                  ()=> GestureDetector(
                    onTap: ()
                    {
                       itemDetailsController.setColorItem(index);
                    },
                    child: Container(
                       height: 35,
                       width: 60,
                       decoration: 
                       BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: itemDetailsController.color == index ? Colors.green : Colors.grey,
                        ),
                        color: itemDetailsController.color == index ? Colors.purpleAccent.withOpacity(0.7) : Colors.white,
                       ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.itemInfo!.colors![index].replaceAll("[", "").replaceAll("]", ""),
                      )
                      ),
                  )
                );
              }
              ),
            ),
            
            
            const SizedBox(height: 20,),

            //description 
            const Text(
               "Description:",
                style:  TextStyle
                (
                  fontSize: 16,
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                 ),
               ),
            const SizedBox(height: 9,),
            Text(
                  widget.itemInfo!.description!,
                  textAlign: TextAlign.justify,
                  style: 
                  const TextStyle
                    (
                        color: Colors.grey
                    ),
                 ),
           
           
           Obx(
            ()=> Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children: [
                //- button 
                IconButton(
                onPressed: 
                (){
                   if(itemDetailsController.quantity - 1 >= 1 ){
                      itemDetailsController.setQuantityItem(itemDetailsController.quantity - 1 );
                   }
                   else{
                    Fluttertoast.showToast(msg: "Quantity must be 1 or greater than 1"); 
                   }
                },
                 icon: const Icon(Icons.remove_circle_outline, color: Colors.white,),
                 ),
                
                //show quantity
                  Text(
                  itemDetailsController.quantity.toString(),
                    style: const TextStyle
                    (
                    fontSize: 20,
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.bold,
                   )
                  ),
                //+ button 
                IconButton(
                onPressed: 
                (){
                   itemDetailsController.setQuantityItem(itemDetailsController.quantity + 1);
                },
                 icon: const Icon(Icons.add_circle_outline, color: Colors.white,),
                 ),
               
                
              ],
            )
           ),

          const SizedBox(height: 20,),


           //add to cart button 
           Material(
            elevation: 4,
            color:  Colors.purpleAccent,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: ()
              {
                addItemToCart();
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                alignment: Alignment.center,
                height: 50,
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                 ),
                ),
              ),
           ),
          ],
        ),
      ),
  );
}
}


