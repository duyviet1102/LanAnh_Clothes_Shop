import 'dart:convert';

import 'package:LanAnh_FashionShop/users/cart/cart_list_screen.dart';
import 'package:LanAnh_FashionShop/users/model/clothes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http ;

import '../../api/api_connection.dart';
import 'item_details_screen.dart'; 


class SearchItems extends StatefulWidget 
{
  final String? typedKeywords ; 
  SearchItems({this.typedKeywords});
  @override  
  State<SearchItems> createState() => _SearchItemState() ; 
}

class _SearchItemState extends State<SearchItems>
{
  TextEditingController searchController = TextEditingController(); 

  Future<List<Clothes>> readSearchRecordsFound() async
  {
     List<Clothes> clothesSearchList = [] ; 
     if(searchController.text != ""){
        try
          {
            var res = await http.post(
              Uri.parse(API.searchItems),
              body: 
              {
                "typedKeyWords": searchController.text,//lấy tất cả danh sách yêu thích của ng dùng HIỆN TẠI
              }
            );

            if(res.statusCode == 200)
            {
              var responseBodyOfSearchItems = jsonDecode(res.body);
              if(responseBodyOfSearchItems['success'] == true)
              {
                (responseBodyOfSearchItems['itemsFoundData'] as List ).forEach((eachItemData){
                    clothesSearchList.add(Clothes.fromJson(eachItemData));
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
        }
        return clothesSearchList ; 
  }

   @override void initState() {
    super.initState();

    searchController.text = widget.typedKeywords! ; 
  }

  @override   
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: showSearchBarWidget(),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: (){
             Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.purpleAccent,
          ),
        )
      ),
      body: searchItemDesignWidget(context,)
    );
  }

  Widget showSearchBarWidget()
   {
     return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: 
      Stack(
        children: [
          Expanded(
            child: 
            Container(
              height: 42,
              child: TextField(
                  style: const TextStyle(color: Colors.black),
                   controller: searchController,
                   decoration: 
                   InputDecoration( 
                   prefixIcon: 
                    IconButton(
                     onPressed: ()
                      {
                         setState(() {
                           
                         });
                      },
                      icon: const Icon(
                         Icons.search,
                        color: Colors.grey,
                      )
                   ),
                   hintText: "Search best clothes here...",
                   hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                     ),
                   suffixIcon: IconButton(
                         onPressed: ()
                         {
                            searchController.clear(); 
                         },
                         icon: const Icon(
                          Icons.close,
                          color: Colors.purpleAccent
                         ),
                      ),
                   border: const OutlineInputBorder(
                      borderSide: BorderSide(
                      width: 12,
                      color: Colors.purpleAccent,
                    ),
                   ),
                   enabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(44),
                      borderSide: const BorderSide(
                      width: 2,
                      color: Colors.yellow,
                    ),
                   ),
                   focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(44),
                      borderSide: const BorderSide(
                      width: 1,
                      color: Colors.yellow,
                    ),
                   ),
                   contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                   ),
                   fillColor: Colors.white,
                   filled:true,
                   )
                ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: InkWell(
              onTap: (){
                setState(() {
                  
                });
              },
              child: Container(
                      height: 32,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(44)
                      ),
                      child: 
                       const Center(
                        child:
                          Text(
                            'Search',
                            style: TextStyle(fontSize: 16, color:Colors.grey),
                          ),
                      ),
                    ),
            ),
          )
        ],
      )
     );
   }

  Widget searchItemDesignWidget(context)
   {
    return FutureBuilder(
       future: readSearchRecordsFound(),
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
            if(dataSnapshot.data!.length > 0 ){
              return ListView.builder(
                itemCount: dataSnapshot.data!.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index )
                {
                  Clothes eachClothItemRecord = dataSnapshot.data![index]; 
                  return GestureDetector(
                    onTap: (){
                           Get.to(ItemDetailsScreen(itemInfo: eachClothItemRecord));
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
                                     eachClothItemRecord.name!,
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
                                                             "\$" + eachClothItemRecord.price.toString(),
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
                                                   "Tags: \n" + eachClothItemRecord.tags!.toString().replaceAll("[", "").replaceAll("]", ""),
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
                                eachClothItemRecord.image!,
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
