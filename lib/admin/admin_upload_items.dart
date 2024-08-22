import 'dart:convert';
import 'dart:io';
import 'package:LanAnh_FashionShop/admin/admin_get_all_orders.dart';
import 'package:LanAnh_FashionShop/admin/admin_login.dart';
import 'package:LanAnh_FashionShop/api/api_connection.dart';
import 'package:LanAnh_FashionShop/users/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http ; 

class AdminUploadItemsScreen extends StatefulWidget
{
  @override
  State<AdminUploadItemsScreen> createState()=> _AdminUploadItemsScreenState();
  
}

class  _AdminUploadItemsScreenState extends State<AdminUploadItemsScreen> 
{
   final ImagePicker _picker = ImagePicker(); 
   XFile? pickedImageXFile; 

   var formkey = GlobalKey<FormState>(); 
   var nameController = TextEditingController(); 
   var ratingController  = TextEditingController(); 
   var tagsController   = TextEditingController(); 
   var  priceController = TextEditingController(); 
   var  sizesController = TextEditingController(); 
   var  colorsController = TextEditingController(); 
   var  descriptionController = TextEditingController(); 
   var  imageLink = ""; 
    
   uploadItemImage() async
   {
       var requestImgurApi = http.MultipartRequest(
        "POST",
        Uri.parse("https://api.imgur.com/3/image")
       );
      
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      requestImgurApi.fields['title'] = imageName; 
      requestImgurApi.headers['Authorization'] = "Client-ID " + "0577d82bbfbf23a" ;
      var imageFile  = await http.MultipartFile.fromPath(
        'image',
      pickedImageXFile!.path,
      filename: imageName,
      ); 
      requestImgurApi.files.add(imageFile);
      var responseFromImgurApi =  await requestImgurApi.send();
      var responseDatafromImgurApi = await responseFromImgurApi.stream.toBytes();
      var resultFromImgurApi = String.fromCharCodes(responseDatafromImgurApi);

      // print("Result :: "); 
      // print(resultFromImgurApi); 
      Map<String,dynamic> jsonRes = json.decode(resultFromImgurApi); 
      imageLink = (jsonRes["data"]["link"]).toString();
      String deleteHash = (jsonRes["data"]["deletehash"]).toString();

      // print("imageLink :: "); 
      // print(imageLink); 

      // print("Result :: "); 
      // print(deleteHash); 
      saveItemInfoDatabase() ; 
   }
   
   saveItemInfoDatabase() async
   {
     List<String> tagsList = tagsController.text.split(','); //ex: Jecket, sale , girls 
    //  0. jacket 
    //  1. sale 
    //  2. girls 
    List<String> sizedList = sizesController.text.split(',');// S , l ,xl, .... 
    List<String> colorList = colorsController.text.split(',');
     try
     {
       var response = await http.post(
        Uri.parse(API.uploadItem),
        body:{
          'item_id': '1',
          'name': nameController.text.trim().toString(),
          'rating': ratingController.text.trim().toString(),
          'tags': tagsList.toString(),
          'price': priceController.text.trim().toString(),
          'sizes': sizedList.toString(),
          'colors': colorList.toString(),
          'description': descriptionController.text.trim().toString(), 
          'image': imageLink.toString(),
        },
       );
        if(response.statusCode == 200){
          var resBodyOfUploadItem = jsonDecode(response.body);
          if(resBodyOfUploadItem['success'] == true){
            Fluttertoast.showToast(msg: "New item uploaded successfully"); 
            setState(() {
              pickedImageXFile = null ; 
            });
            Get.to(AdminUploadItemsScreen());
          }
          else
          {
            Fluttertoast.showToast(msg: "Item not uploaded. Error,Try Again ");
          }
        }
        else
        {
          Fluttertoast.showToast(msg: "Status is not 200");
        }
     }
     catch(error)
     {
        print("error: " + error.toString());
     }
     
   } 
   
   captureImageWithPhoneCamera() async 
   {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);
    Get.back(); 
    setState(()=> pickedImageXFile); 
   }
  
   pickImageFromPhoneGallery() async
   {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);
    Get.back(); 
    setState(()=> pickedImageXFile); 
   }
   
   showDialogBoxForImagePickingAndCapturing(){
    return showDialog(
      context: context,
      builder: (context)
      {
        return SimpleDialog(
          backgroundColor: Colors.black87 ,
          title: const Text(
          "Item Image",
          style: TextStyle(
            color:Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
          ),
           children: [
            SimpleDialogOption(
              onPressed: ()
              {
                 captureImageWithPhoneCamera();
               },
              child: const Text(
                "Capture with Phone Camera",
                style: TextStyle(
                  color:Colors.grey,
                )
              ),
            ),
            SimpleDialogOption(
              onPressed: (){
               pickImageFromPhoneGallery();
               },
              child: const Text(
                "Pick Image From Phone Gallery",
                style: TextStyle(
                  color:Colors.grey,
                )
              ),
            ),
             SimpleDialogOption(
              onPressed: (){
                 Get.back();
               },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color:Colors.red,
                )
              ),
            ) ,
          ]
        ); 
      }
    );
  }
   
   Widget defaultScreen(){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: 
        Container(
          decoration: 
             const BoxDecoration(
               gradient: LinearGradient(
                colors: 
                 [
                   Colors.purple,
                   Colors.deepPurple,
                 ],
            )
           ),
        ),
        automaticallyImplyLeading: false,
        title: 
        GestureDetector(
          onTap: ()
          {
            Get.to(AdminGetAllOrdersScreen());
          },
           child: const Text(
          "New Orders",
          style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 16),
        ),
        ),
        
         centerTitle: false,
         actions: [
           IconButton(onPressed: ()
           {
             Get.to(LoginScreen());
           },
            icon:const Icon(
              Icons.logout,
              color: Colors.redAccent,
            ),),
         ],
      ),
      body: Container(
         decoration: 
         const BoxDecoration(
          gradient: LinearGradient(
            colors: 
            [
              Colors.black54,
              Colors.deepPurple,
            ],
            )
           ),
         child: Center(
           child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const Icon(
              Icons.add_photo_alternate,
              color: Colors.white54,
              size: 200,
            ),

            //button 
                Material(
                       color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: ()
                              {
                                showDialogBoxForImagePickingAndCapturing(); 
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: 
                               const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 28, 
                                ),
                                child: Text(
                                  "Add New Item",
                                  style: TextStyle(
                                    color:Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            )     
              )
           ]
           ),
         ),  
        ),
    ); ; 
  }
   
   Widget uploadItemFormScreen(){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
         flexibleSpace: 
          Container(
            decoration: 
             const BoxDecoration(
               gradient: LinearGradient(
                colors: 
                 [
                   Colors.purple,
                   Colors.deepPurple,
                 ],
            )
           ),
        ),
         automaticallyImplyLeading: false,
         title:const Text(
          "Upload Form",
          style: TextStyle(color: Colors.white),
         ),
         centerTitle: true,
         leading: IconButton(
             onPressed: ()
             {
                setState(() {
                  pickedImageXFile = null; 
                  nameController.clear(); 
                  ratingController.clear();
                  tagsController.clear();
                  sizesController.clear();
                  colorsController.clear();
                  descriptionController.clear();
                });
                Get.to(AdminLoginScreen());
             },
             icon: const Icon(
              Icons.clear,
             )
          ,),
          actions: [
            TextButton(
             onPressed: ()
             {
                
             },
             child:
              Text(
                "Done",
                style: TextStyle(
                  color: Colors.green, 
                )
              )
             )
          ],
      ),
      body:
      ListView( // picked-image listview
        children: [
          Container(
            height: MediaQuery.of(context).size.width * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: 
                   FileImage(
                    File(pickedImageXFile!.path),
                   ),
                   fit: BoxFit.cover, 
              )
            ),
          ),

          //upload item form 
          Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: 
                    Container(
                    decoration: const BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.all(
                      Radius.circular(60),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color:Colors.black26, 
                        offset: Offset(0, -3),
                      ),
                     ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30,30,30,8),
                      child: Column(
                       children: [
                        
                       
                        Form(
                         key: formkey,
                         child:Column(
                          children: [
                            //item name
                            TextFormField(
                              controller: nameController,
                              validator: (val) => val == "" ? "Please write item name" : null, // user de trong thi hien thi loi 
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.title,
                                  color : Colors.black,
                                ),
                                hintText: "item name...", // cho trong 
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14 , 
                                  vertical: 6, 
                                ),
                                fillColor: Colors.white , 
                                filled: true ,
                              )
                            ),                        
                            
                            const SizedBox(height: 18,),
                            //item rating 
                            TextFormField(
                              controller: ratingController,
                              validator: (val) => val == "" ? "Please give item rating" : null, // user de trong thi hien thi loi 
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.rate_review,
                                  color : Colors.black,
                                ),
                                hintText: "item rating...", 
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14 , 
                                  vertical: 6, 
                                ),
                                fillColor: Colors.white , 
                                filled: true ,
                              )
                            ),                        
                            
                            const SizedBox(height: 18,),
                            //item tags
                            TextFormField(
                              controller: tagsController,
                              validator: (val) => val == "" ? "Please give item tags" : null, // user de trong thi hien thi loi 
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.tag,
                                  color : Colors.black,
                                ),
                                hintText: "item tags...", 
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14 , 
                                  vertical: 6, 
                                ),
                                fillColor: Colors.white , 
                                filled: true ,
                              )
                            ),                        
                            
                            const SizedBox(height: 18,),
                            //item price 
                             TextFormField(
                              controller: priceController,
                              validator: (val) => val == "" ? "Please write item price" : null, // user de trong thi hien thi loi 
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.price_change_outlined,
                                  color : Colors.black,
                                ),
                                hintText: "item price...", 
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14 , 
                                  vertical: 6, 
                                ),
                                fillColor: Colors.white , 
                                filled: true ,
                              )
                            ),                        
                            
                            const SizedBox(height: 18,),
                            //item sizes
                            TextFormField(
                              controller: sizesController,
                              validator: (val) => val == "" ? "Please give item sizes" : null, // user de trong thi hien thi loi 
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.picture_in_picture,
                                  color : Colors.black,
                                ),
                                hintText: "item size...", 
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14 , 
                                  vertical: 6, 
                                ),
                                fillColor: Colors.white , 
                                filled: true ,
                              )
                            ),                        
                            
                            const SizedBox(height: 18,),
                             //item colors
                            TextFormField(
                              controller: colorsController,
                              validator: (val) => val == "" ? "Please give item colors" : null, // user de trong thi hien thi loi 
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.color_lens,
                                  color : Colors.black,
                                ),
                                hintText: "item colors...", 
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14 , 
                                  vertical: 6, 
                                ),
                                fillColor: Colors.white , 
                                filled: true ,
                              )
                            ),                        
                            
                            const SizedBox(height: 18,),
                            //item description 
                            TextFormField(
                              controller: descriptionController,
                              validator: (val) => val == "" ? "Please give item rating" : null, // user de trong thi hien thi loi 
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.description,
                                  color : Colors.black,
                                ),
                                hintText: "item description...", 
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  )
                                 ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14 , 
                                  vertical: 6, 
                                ),
                                fillColor: Colors.white , 
                                filled: true ,
                              )
                            ),                        
                            
                            const SizedBox(height: 18,),

                           //button
                           Material(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: ()
                              {
                                if(formkey.currentState!.validate())
                                {
                                   Fluttertoast.showToast(msg: "Uploading now ...");
                                   uploadItemImage();  
                                }
                              
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: 
                               const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 30, 
                                ),
                                child: Text(
                                  "Upload Now",
                                  style: TextStyle(
                                    color:Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            )
                           )
                          ],
                          )
                        ),
                        
                        const SizedBox(height:16,),
                      ]
                      ), 
                    ),
                  ),
                 )        
        ],
      )
    );
   }
  @override
  Widget build(BuildContext context){
    return pickedImageXFile == null ? defaultScreen() : uploadItemFormScreen();//user have not yet pick any image from phone
  }
}