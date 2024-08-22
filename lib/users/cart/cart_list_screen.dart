import 'dart:convert';
import 'dart:math';

import 'package:LanAnh_FashionShop/api/api_connection.dart';
import 'package:LanAnh_FashionShop/users/UserPrefences/current_user.dart';
import 'package:LanAnh_FashionShop/users/controller/cart_list_controller.dart';
import 'package:LanAnh_FashionShop/users/item/item_details_screen.dart';
import 'package:LanAnh_FashionShop/users/model/cart.dart';
import 'package:LanAnh_FashionShop/users/model/clothes.dart';
import 'package:LanAnh_FashionShop/users/order/order_now_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http ; 
import 'package:get/get.dart' ;

class CartListScreen extends StatefulWidget 
{
  @override  
  State<CartListScreen> createState() => _CartListScreenState(); 
}
class _CartListScreenState extends State<CartListScreen> 
{
  final currentOnlineUser = Get.put(CurrentUser());
  final cartListController = Get.put(CartListController());
  

  getCurrentUserCartList() async 
  {
    List<Cart> carListOfCurrentUser = [];
    //call php 
    try
    {
      var res = await http.post(
        Uri.parse(API.getCartList),
        body: 
        {
          "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),
        }
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfGetCurrentUserCartItems = jsonDecode(res.body);
        if(responseBodyOfGetCurrentUserCartItems['success'] == true)
        {
           (responseBodyOfGetCurrentUserCartItems['currentUserCartData'] as List ).forEach((eachCurrentUserCartItem){
               carListOfCurrentUser.add(Cart.fromJson(eachCurrentUserCartItem));
           });
        }
        else{
          Fluttertoast.showToast(msg: "Your Cart list is Empty. "); 
        }

        cartListController.setList(carListOfCurrentUser);
      }
    }
    catch(errorMsg){
      Fluttertoast.showToast(msg: "Error:" + errorMsg.toString());
    }

    calculateTotalAmount();
  }
  
  calculateTotalAmount(){
    cartListController.setTotal(0);
    if(cartListController.selectedItemList.length > 0) // user have to choose 1 or more item 
    {  //make sure that total always > 0 
     cartListController.cartList.forEach(
      (itemInCart)
       {
          if(cartListController.selectedItemList.contains(itemInCart.cart_id))
          {
            double eachItemTotalAmount =  (itemInCart.price!) * (double.parse(itemInCart.quantity.toString())) ; 
            
            cartListController.setTotal(cartListController.total + eachItemTotalAmount );
          }
       });
    }
  }
  
  deleteSelectedItemsFromUserCartList(int cartID) async
  {
    try{
      var res = await http.post(
         Uri.parse(API.deleteSelectedItemFromCartList),
         body: {
            "cart_id": cartID.toString(),
         }
      );
      //check response 
      if(res.statusCode == 200)
      {
        var responseBodyFromDeleteCart = jsonDecode(res.body);

        if(responseBodyFromDeleteCart["success"] == true){
           getCurrentUserCartList();
        }
      }
      else{
        Fluttertoast.showToast(msg: "Error, status code isn't 200");
      }
    }
    catch(e){
        Fluttertoast.showToast(msg: "Error: "+ e.toString());
    }
  }

  updateQuantityInCart(int cartID , int updatedQuantity) async
   { 
    try{
      var res = await http.post(
         Uri.parse(API.updateItemInCartList),
         body: {
            "cart_id": cartID.toString(),
            "quantity": updatedQuantity.toString(),
         }
      );
       if(res.statusCode == 200)
      {
        var responseBodyOfUpdateQuantityCart = jsonDecode(res.body);

        if(responseBodyOfUpdateQuantityCart["success"] == true){
           getCurrentUserCartList();
        }
      }
      else{
        Fluttertoast.showToast(msg: "Error, status code isn't 200");
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: "Error: " + e.toString());
    }
   }
  
  List<Map<String,dynamic>> getSelectedCartListItemsInformation (){
      List<Map<String,dynamic>> selectedCartListItemsInformation = [];
      if(cartListController.selectedItemList.length > 0 ){
        cartListController.cartList.forEach((selectedCartListItem)
        {
          if(cartListController.selectedItemList.contains(selectedCartListItem.cart_id)){
            Map<String, dynamic> itemInformation = {
              "item_id": selectedCartListItem.item_id,
              "name": selectedCartListItem.name,
              "image": selectedCartListItem.image,
              "color": selectedCartListItem.color,
              "size": selectedCartListItem.size,
              "quantity": selectedCartListItem.quantity,
              "totalAmount": selectedCartListItem.price! * selectedCartListItem.quantity!,
              "price": selectedCartListItem.price!,
            };

            selectedCartListItemsInformation.add(itemInformation);
          }
        });
      }
      return selectedCartListItemsInformation; 
  } 
  
  
  @override
  void initState(){
   super.initState();
   getCurrentUserCartList();
  }
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:  Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
            "Cart",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          ),
          centerTitle: true,
        actions: [
        //to select all item/items
          Obx(()=>
          IconButton
          (
            onPressed: ()
            {
               cartListController.setIsSelectedAllItem();
               cartListController.clearAllSelectedItem();
               if(cartListController.isSelectedAll){
                 cartListController.cartList.forEach((e)
                 {
                   cartListController.addSelectedItem(e.cart_id!);
                 }
                 );
               }
               calculateTotalAmount();
            },
            icon: Icon
            (
               cartListController.isSelectedAll ? 
                    Icons.check_box : Icons.check_box_outline_blank,
               color: cartListController.isSelectedAll ? 
                    Colors.black : Colors.grey,
            ),
          )
         ),
        
        //to delete all item/items
        GetBuilder(
          init: CartListController(),
          builder: (c)
          {
            if(cartListController.selectedItemList.length > 0)
            {
              return IconButton(
                onPressed: () async
                {
                  //yes/no delete
                  var responseFromDialogBox =  await Get.dialog(
                     AlertDialog(
                      backgroundColor: Colors.grey,
                      title:  const Text("Delete"),
                      content: const Text("Are you sure to Delete selected items from your Cart List?"),
                      actions: [
                        TextButton(onPressed:()
                        {
                          Get.back();
                        }, 
                        child: 
                         const Text(
                          "No",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                         ),
                         ),
                        TextButton(onPressed:()
                        {
                          Get.back(result: "yesDelete"); 
                        }, 
                        child: 
                         const Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                         ),
                         ),
                      ],
                    ),

                  );
                  if(responseFromDialogBox == "yesDelete"){
                    // 
                    cartListController.selectedItemList.forEach((eachSelectedItem){
                    //delete selected items now 
                    deleteSelectedItemsFromUserCartList(eachSelectedItem);     
                    }
                   );
                  }
                  calculateTotalAmount();
                },
                icon: const Icon(
                  Icons.delete_sweep_outlined,
                  color:Colors.black,
                )
                );
            }
            else{
              return Container();
            }
          }
          
        ),
        ],
      ),
      body: 
      Obx
      (()=> 
      cartListController.cartList.length > 0 ? 
       ListView.builder
       (
        itemCount: cartListController.cartList.length,
        scrollDirection:  Axis.vertical,
        itemBuilder: (context, index)
        {
          Cart cartModel = cartListController.cartList[index]; 
          Clothes clothesModel = Clothes(
            item_id:  cartModel.item_id,
            colors: cartModel.colors,
            image: cartModel.image,
            name: cartModel.name ,
            price: cartModel.price,
            rating: cartModel.rating,
            sizes: cartModel.sizes,
            description: cartModel.description,
            tags: cartModel.tags,
          );


          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: 
              [
                GetBuilder(// ô tích 
                builder: (c){
                  return IconButton(
                    onPressed: ()
                    {
                      if(cartListController.selectedItemList.contains(cartModel.cart_id)){
                        //
                        cartListController.deleteSelectedItem(cartModel.cart_id!);
                      }
                      else{
                        cartListController.addSelectedItem(cartModel.cart_id!);
                      }
                       
                       calculateTotalAmount();
                    }, 
                    icon: Icon(
                      cartListController.selectedItemList.contains(cartModel.cart_id) ? Icons.check_box : 
                      Icons.check_box_outline_blank,
                      color: cartListController.isSelectedAll ? Colors.black : Colors.black,

                    ));
                },
                init: CartListController(), 
                ),
                
                Expanded(child: 
                 GestureDetector(
                  onTap: (){
                      Get.to(ItemDetailsScreen(itemInfo: clothesModel,));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, index == 0 ? 16 : 8, 16,
                     index == cartListController.cartList.length - 1 ? 16 : 8, ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                      boxShadow: 
                      const [
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 6,
                          color: Colors.white,
                        )
                      ]
                    ),
                    child:Row(
                      children: [
                        Expanded(
                          child: 
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                //name
                                  Text(
                                           clothesModel.name.toString(),
                                           maxLines: 2,
                                           overflow: TextOverflow.ellipsis,
                                           style: const 
                                           TextStyle
                                           (
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),

                                  const SizedBox(height: 20,),


                                  //color size + price 
                                  Row(
                                    children: [
                                      //color.size  
                                      Expanded(
                                        child: Text(
                                          "Color: ${cartModel.color!.replaceAll('[', '').replaceAll(']', '')}" + "\n" + "Size: ${cartModel.size!.replaceAll('[', '').replaceAll(']', '')}",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white60,
                                          ),
                                        )
                                      ),

                                      //price 
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12, right: 12.0),
                                        child: Text(
                                          "\$" + clothesModel.price.toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.purpleAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                  // + - 
                                  const SizedBox(height: 20,),

                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      //-
                                      IconButton(
                                       onPressed: (){
                                          if(cartModel.quantity! - 1 >= 1){
                                              updateQuantityInCart(
                                                cartModel.cart_id!,
                                                cartModel.quantity! - 1 ,
                                              );
                                          }
                                       },
                                       icon: const Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.grey,
                                        size: 30,
                                       ),
                                      ),


                                      Text(
                                        cartModel.quantity.toString(),
                                        style: const TextStyle(
                                          color: Colors.purpleAccent,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 30,),

                                       IconButton(
                                       onPressed: (){
                                            updateQuantityInCart
                                            (
                                                cartModel.cart_id!,
                                                cartModel.quantity! + 1 ,
                                              );
                                       },
                                       icon: const Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.grey,
                                        size: 30,
                                       ),
                                      ),
                                    ],
                                  )

                              ],)
                            ,),
                        ),
                    
                    
                        //image 
                         ClipRRect(
                            borderRadius: const BorderRadius.only(
                               bottomLeft: Radius.circular(22),
                               bottomRight: Radius.circular(22)
                            ),
                            
                            child: FadeInImage(
                              height: 200,
                              width: 150,
                              fit: BoxFit.cover,
                              placeholder: const AssetImage("images/place_holder.png"),
                              image: NetworkImage(
                                cartModel.image!,
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
                    ) 
                     ),
                    
                  )
                )
              
                //
              ],
            ),
          );
        },
       ) : 
       const Center(
        child: Text("Cart is Empty"),
       )
       ),
      bottomNavigationBar: GetBuilder(
        init: CartListController(),
        builder: (e){
          return Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -3),
                  color: Colors.white24,
                  blurRadius: 6,
                ),
              ]
            ),
          
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 18,
            ),

            child: Row(
              children: 
               [
                  //total amount
                  const Text(
                  "Total Amount:",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white38,
                    fontWeight: FontWeight.bold,
                  ),
                  ),


                  const SizedBox(width: 4,),

                  Obx(()=>
                    Text(
                        "\$" + cartListController.total.toStringAsFixed(2),       
                        maxLines: 1,   
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                    ),
                  ) ,       
                  
                  const Spacer(),
                  
                  //order now btn 
                  Material(
                    color: cartListController.selectedItemList.length > 0 ? Colors.purpleAccent : Colors.white24,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: (){
                         cartListController.selectedItemList.length > 0 ? 
                         Get.to(OrderNowScreen(
                          selectedCartListItemsInfo :  getSelectedCartListItemsInformation() ,
                          totalAmount: cartListController.total,
                          selectedCartIDs: cartListController.selectedItemList
                         )):
                         null ;
                      },
                      child: 
                       const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                        child: Text(
                          "Order Now !",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        )
                       )
                    ),
                  ) 
                  ],
               ),
          
          );
        },
        ),
    
      
    );
  }
}