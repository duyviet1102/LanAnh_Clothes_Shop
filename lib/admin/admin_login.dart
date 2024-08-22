import 'dart:convert';
import 'package:LanAnh_FashionShop/admin/admin_dashboard.dart';
import 'package:LanAnh_FashionShop/admin/admin_upload_items.dart';
import 'package:LanAnh_FashionShop/users/authentication/login_screen.dart';
import 'package:LanAnh_FashionShop/admin/model/admin.dart';
import 'package:flutter/material.dart';
import 'package:LanAnh_FashionShop/api/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' ;
import 'package:http/http.dart' as http ;

import 'Admin_Preferences/admin_preferences.dart'; 
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}
 
class _AdminLoginScreenState extends State<AdminLoginScreen> {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController(); // tao bo dieu khien de nguoi dung dang nhap
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  loginAdminNow() async 
  {
    try{
       var res = await http.post
       (
         Uri.parse(API.adminLogin),
         body: {
        "admin_email": emailController.text.trim(),
        "admin_password": passwordController.text.trim(),
        }
       ); 
    if(res.statusCode == 200) // 200 is response code tell us the request success  
        {
         var resBodyofLogin = jsonDecode(res.body);
         if(resBodyofLogin['success'] == true){
            Admin adminInfo = Admin.fromJson(resBodyofLogin["adminData"]) ;
            await RememberAdminPrefs.storeAdminInfo(adminInfo); 
            Fluttertoast.showToast(msg: "Dear Admin, You Are Login Succesfully");
            Future.delayed(const Duration(milliseconds: 2000), 
             (){
              Get.to(AdminDashboard());
             });
         }
         else {
            Fluttertoast.showToast(msg: "Your Email or Password is not correct, Try Again");
         }
        }; 
    }catch(errorMsg){
        String error = errorMsg.toString(); 
        Fluttertoast.showToast(msg: error); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.black,
     body: LayoutBuilder(
      builder: (context,cons){
        return ConstrainedBox
        (
          constraints: BoxConstraints(
            minHeight: cons.maxHeight
            ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //login screen header
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 285,
                  child: Image.asset(
                    "images/admin.jpg"
                  ) ,
                ),

                //login screen sign-in form
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
                        
                        //email-password-login btn
                        Form(
                         key: formKey,
                         child:Column(
                          children: [
                            //email 
                            TextFormField(
                              controller: emailController,
                              validator: (val) => val == "" ? "Please write email" : null, // user de trong thi hien thi loi 
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color : Colors.black,
                                ),
                                hintText: "Email", // cho trong 
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
                             //password 
                           Obx(
                                ()=> TextFormField(
                                controller: passwordController,
                                obscureText: isObsecure.value,
                                validator: (m) => m == "" ? "Please write password" : null, // user de trong thi hien thi loi 
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.vpn_key_sharp,
                                    color : Colors.black,
                                  ),
                                  suffixIcon: Obx(
                                    ()=> GestureDetector(
                                      onTap: (){
                                        isObsecure.value = !isObsecure.value ; 
                                      },
                                      child: Icon(
                                        isObsecure.value ? Icons.visibility_off : Icons.visibility,
                                      ),
                                    )
                                  ),
                                  hintText: "Password ", // cho trong 
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
                            ),
                           const SizedBox(height: 18,),
                           //button
                           Material(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: ()
                              {
                                if(formKey.currentState!.validate())
                                loginAdminNow(); 
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: 
                               const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 30, 
                                ),
                                child: Text(
                                  "Login",
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
                        
                        //I am not an admin dont have an account button - button  
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          const Text("I am not an Admin?"),
                          TextButton(
                           onPressed:()
                            {
                              // Get.to(SignUpScreen());
                              Get.to(() => LoginScreen());
                            },
                           child: 
                           const Text(
                            "SignUp Here",
                            style: TextStyle(
                              color: Colors.pinkAccent,
                            ),
                            ),
                            )
                          ],
                        ),
                        
                        const Text(
                          "or",
                           style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                           ),
                        ),
                        const SizedBox(height:16,),
                        //are you an admin text  
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:
                           [ 
                           Material(
                             borderRadius: BorderRadius.circular(30),
                             color: Colors.white,
                             child: 
                             IconButton(onPressed: (){}, icon: const Icon(FontAwesomeIcons.google),color: Color(0xFFDB4437) ,)),
                           Material(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              child: IconButton(onPressed: (){}, icon: const Icon(FontAwesomeIcons.facebook),color: Color(0xFF4267B2))),
                           ],
                        ),
                        const SizedBox(height: 10,)
                      ]), 
                    ),
                  ),
                 )
              ], 
            ),
          ),
        );
      }
     ),
    );
  }
}