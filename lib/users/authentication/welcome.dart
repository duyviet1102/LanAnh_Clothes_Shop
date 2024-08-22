import 'dart:convert';
import 'package:LanAnh_FashionShop/admin/admin_login.dart';
import 'package:LanAnh_FashionShop/admin/dashboard_page.dart';
import 'package:LanAnh_FashionShop/users/authentication/login_screen.dart';
import 'package:LanAnh_FashionShop/widget/yellowbutton.dart';
import 'package:flutter/material.dart';
import 'package:LanAnh_FashionShop/api/api_connection.dart';
import 'package:LanAnh_FashionShop/users/UserPrefences/user_prefences.dart';
import 'package:LanAnh_FashionShop/users/authentication/signup.dart';
import 'package:LanAnh_FashionShop/users/fragment/dashboard_of_fragment.dart';
import 'package:LanAnh_FashionShop/users/model/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' ;
import 'package:http/http.dart' as http ; 
class WelcomeScreenState extends StatefulWidget {
  const WelcomeScreenState({super.key});

  @override
  State<WelcomeScreenState> createState() => __WelcomeScreenStateState();
}

class __WelcomeScreenStateState extends State<WelcomeScreenState> {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController(); // tao bo dieu khien de nguoi dung dang nhap
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  loginUserNow() async 
  {
    try{
       var res = await http.post
       (
         Uri.parse(API.signIn),
         body: {
        "user_email": emailController.text.trim(),
        "user_password": passwordController.text.trim(),
        }
       ); 
    if(res.statusCode == 200) // 200 is response code tell us the request success  
        {
         var resBodyofLogin = jsonDecode(res.body);
         if(resBodyofLogin['success'] == true){
            Fluttertoast.showToast(msg: "Login Succesfully");
            User userInfo = User.fromJson(resBodyofLogin["userData"]); //dang o dinh dang json 
            await RememberUserPrefs.storeUserInfo(userInfo); 
            Future.delayed(Duration(milliseconds: 2000), 
             (){
              Get.to(DashboardOfFragement());
             });
         }
         else {
            Fluttertoast.showToast(msg: "Your Email or Password is not correct, Try Again");
         }
        } 
    }catch(errorMsg){
        String error = errorMsg.toString(); 
        Fluttertoast.showToast(msg: error); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/inapp/bgimage.jpg'),
              fit: BoxFit.cover,
            )
          ),
          constraints: const BoxConstraints.expand(),

          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: 
                [
                  const Text('Lan Anh Clothes',style: TextStyle(color: Colors.white, fontSize: 30),),
                  const SizedBox(height: 120,width: 200, child: Image(image: AssetImage('images/inapp/logo.jpg'))),
                  const Text(
                    "Shop",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),

                  //supplier 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                              )
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Suppliers only', style: TextStyle(color:  Colors.yellow, fontSize: 26,fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(height: 6,),
                          Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: const BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          )
                          ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               const  Image(image: AssetImage('images/inapp/logo.jpg')),
                                SizedBox(
                                  height: 35,
                                  child: Material(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      
                                      onTap: ()
                                      {
                                        Get.to(AdminLoginScreen());
                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: 
                                       const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 22, 
                                        ),
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                            color:Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                    )
                                   ),
                                ),
                                 const SizedBox(width: 5,),
                                 SizedBox(
                                  height: 35,
                                   child: Material(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: ()
                                      {
                                        Get.to(AdminLoginScreen());
                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: 
                                       const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 15, 
                                        ),
                                        child: Text(
                                          "Sign Up",
                                          style: TextStyle(
                                            color:Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                    )
                                   ),
                                 ),
                            ],
                          ),
                        ),
                      ),
                        ],
                      ),
                    ],
                  ),
                  
                   //guest 
                   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: const BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )
                          ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 1),
                                  child: 
                                  SizedBox(
                                    height: 35,
                                    child: Material(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.circular(30),
                                      child: InkWell(
                                        
                                        onTap: ()
                                        {
                                          Get.to(LoginScreen());
                                        },
                                        borderRadius: BorderRadius.circular(30),
                                        child: 
                                         const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 22,  
                                          ),
                                          child: Text(
                                            "Login",
                                            style: TextStyle(
                                              color:Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        )
                                      )
                                     ),
                                  ),
                                ),
                                 const SizedBox(width: 5,),
                                 SizedBox(
                                   height: 35,
                                   child: 
                                   Material(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: ()
                                      {
                                        Get.to(SignUpScreen());
                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: 
                                       const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 15, 
                                        ),
                                        child: Text(
                                          "Sign Up",
                                          style: TextStyle(
                                            color:Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                    )
                                   ),
                                 ),
                                 const  Image(image: AssetImage('images/inapp/logo.jpg')),
                            ],
                          ),
                        ),
                                         ),
                     ],
                   ),
                   

                   //facebook google auth
                   Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                     child: Container(
                      decoration: const BoxDecoration(color: Colors.white38),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: 
                        [
                          GoogleFacebookLogin(label: 'Google',onPressed: (){},child: const Image(image: AssetImage('images/inapp/google.jpg')),),
                          GoogleFacebookLogin(label: 'Facebook',onPressed: (){},child: const Image(image: AssetImage('images/inapp/facebook.jpg')),),
                          GoogleFacebookLogin(label: 'Guest',onPressed: (){},child: const Icon(Icons.person,size: 55,color: Colors.lightBlueAccent,)),
                        ],
                        ),
                     ),
                   )
                ],),
          ),
          ),
      ),
    );
    // return Scaffold(
    //  backgroundColor: Colors.black,
    //  body: LayoutBuilder(
    //   builder: (context,cons){
    //     return ConstrainedBox
    //     (
    //       constraints: BoxConstraints(
    //         minHeight: cons.maxHeight
    //         ),
    //       child: SingleChildScrollView(
    //         child: Column(
    //           children: [
    //             //login screen header
    //             SizedBox(
    //               width: MediaQuery.of(context).size.width,
    //               height: 285,
    //               child: Image.asset(
    //                 "images/login2.jpg"
    //               ) ,
    //             ),

    //             //login screen header
    //              Padding(
    //                padding: const EdgeInsets.all(16.0),
    //                child: 
    //                 Container(
    //                 decoration: const BoxDecoration(
    //                 color: Colors.white24,
    //                 borderRadius: BorderRadius.all(
    //                   Radius.circular(60),
    //                 ),
    //                 boxShadow: [
    //                   BoxShadow(
    //                     blurRadius: 8,
    //                     color:Colors.black26, 
    //                     offset: Offset(0, -3),
    //                   ),
    //                  ]
    //                 ),
    //                 child: Padding(
    //                   padding: const EdgeInsets.fromLTRB(30,30,30,8),
    //                   child: Column(
    //                    children: [
                        
    //                     //email-password-login btn
    //                     Form(
    //                      key: formKey,
    //                      child:Column(
    //                       children: [
    //                         //email 
    //                         TextFormField(
    //                           controller: emailController,
    //                           validator: (val) => val == "" ? "Please write email" : null, // user de trong thi hien thi loi 
    //                           decoration: InputDecoration(
    //                             prefixIcon: const Icon(
    //                               Icons.email,
    //                               color : Colors.black,
    //                             ),
    //                             hintText: "Email", // cho trong 
    //                             border: OutlineInputBorder(
    //                               borderRadius: BorderRadius.circular(30),
    //                               borderSide: const BorderSide(
    //                                 color:Colors.white60,
    //                               )
    //                              ),
    //                             enabledBorder: OutlineInputBorder(
    //                               borderRadius: BorderRadius.circular(30),
    //                               borderSide: const BorderSide(
    //                                 color:Colors.white60,
    //                               )
    //                              ),
    //                             focusedBorder: OutlineInputBorder(
    //                               borderRadius: BorderRadius.circular(30),
    //                               borderSide: const BorderSide(
    //                                 color:Colors.white60,
    //                               )
    //                              ),
    //                             disabledBorder: OutlineInputBorder(
    //                               borderRadius: BorderRadius.circular(30),
    //                               borderSide: const BorderSide(
    //                                 color:Colors.white60,
    //                               )
    //                              ),
    //                             contentPadding: const EdgeInsets.symmetric(
    //                               horizontal: 14 , 
    //                               vertical: 6, 
    //                             ),
    //                             fillColor: Colors.white , 
    //                             filled: true ,
    //                           )
    //                         ),                        
    //                         const SizedBox(height: 18,),
    //                          //password 
    //                        Obx(
    //                             ()=> TextFormField(
    //                             controller: passwordController,
    //                             obscureText: isObsecure.value,
    //                             validator: (m) => m == "" ? "Please write password" : null, // user de trong thi hien thi loi 
    //                             decoration: InputDecoration(
    //                               prefixIcon: const Icon(
    //                                 Icons.vpn_key_sharp,
    //                                 color : Colors.black,
    //                               ),
    //                               suffixIcon: Obx(
    //                                 ()=> GestureDetector(
    //                                   onTap: (){
    //                                     isObsecure.value = !isObsecure.value ; 
    //                                   },
    //                                   child: Icon(
    //                                     isObsecure.value ? Icons.visibility_off : Icons.visibility,
    //                                   ),
    //                                 )
    //                               ),
    //                               hintText: "Password ", // cho trong 
    //                               border: OutlineInputBorder(
    //                                 borderRadius: BorderRadius.circular(30),
    //                                 borderSide: const BorderSide(
    //                                   color:Colors.white60,
    //                                 )
    //                                ),
    //                               enabledBorder: OutlineInputBorder(
    //                                 borderRadius: BorderRadius.circular(30),
    //                                 borderSide: const BorderSide(
    //                                   color:Colors.white60,
    //                                 )
    //                                ),
    //                               focusedBorder: OutlineInputBorder(
    //                                 borderRadius: BorderRadius.circular(30),
    //                                 borderSide: const BorderSide(
    //                                   color:Colors.white60,
    //                                 )
    //                                ),
    //                               disabledBorder: OutlineInputBorder(
    //                                 borderRadius: BorderRadius.circular(30),
    //                                 borderSide: const BorderSide(
    //                                   color:Colors.white60,
    //                                 )
    //                                ),
    //                               contentPadding: const EdgeInsets.symmetric(
    //                                 horizontal: 14 , 
    //                                 vertical: 6, 
    //                               ),
    //                               fillColor: Colors.white , 
    //                               filled: true ,
    //                             )
    //                           ),
    //                         ),
    //                        const SizedBox(height: 18,),
    //                        Material(
    //                         color: Colors.greenAccent,
    //                         borderRadius: BorderRadius.circular(30),
    //                         child: InkWell(
    //                           onTap: ()
    //                           {
    //                             if(formKey.currentState!.validate())
    //                             loginUserNow(); 
    //                           },
    //                           borderRadius: BorderRadius.circular(30),
    //                           child: 
    //                            const Padding(
    //                             padding: EdgeInsets.symmetric(
    //                               vertical: 10,
    //                               horizontal: 30, 
    //                             ),
    //                             child: Text(
    //                               "Login",
    //                               style: TextStyle(
    //                                 color:Colors.white,
    //                                 fontSize: 16,
    //                               ),
    //                             ),
    //                           )
    //                         )
    //                        )
    //                       ],
    //                       )
    //                     ),
                        
    //                     const SizedBox(height:16,),
                        
    //                     //dont have an account button - button  
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                       const Text("Dont't have an Account?"),
    //                       TextButton(
    //                        onPressed:()
    //                         {
    //                           // Get.to(SignUpScreen());
    //                           Get.to(() => SignUpScreen());
    //                         },
    //                        child: 
    //                        const Text(
    //                         "SignUp Here",
    //                         style: TextStyle(
    //                           color: Colors.pinkAccent,
    //                         ),
    //                         ),
    //                         )
    //                       ],
    //                     ),
                        
    //                     const Text(
    //                       "or",
    //                        style: TextStyle(
    //                         color: Colors.grey,
    //                         fontSize: 16,
    //                        ),
    //                     ),
    //                     //are you an admin text  
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       const Text(
    //                         "Are you an Admin?"
    //                       ),
    //                       TextButton(
    //                         onPressed: ()
    //                         {
    //                           Get.to(AdminLoginScreen());
    //                         }, 
    //                       child: const Text(
    //                         "Click Here",
    //                         style: TextStyle(
    //                           color: Colors.black,
    //                           fontSize: 16,
    //                         )
    //                       ) )
    //                      ],
    //                     ),
    //                   Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                       children:
    //                        [ 
    //                        Material(
    //                          borderRadius: BorderRadius.circular(30),
    //                          color: Colors.white,
    //                          child: 
    //                          IconButton(onPressed: (){}, icon: const Icon(FontAwesomeIcons.google),color: Color(0xFFDB4437) ,)),
    //                        Material(
    //                           borderRadius: BorderRadius.circular(30),
    //                           color: Colors.white,
    //                           child: IconButton(onPressed: (){}, icon: const Icon(FontAwesomeIcons.facebook),color: Color(0xFF4267B2))),
    //                        ],
    //                     ),
    //                     const SizedBox(height: 10,)
    //                   ]), 
    //                 ),
    //               ),
    //              )
    //           ], 
    //         ),
    //       ),
    //     );
    //   }
    //  ),
    // );
  }
}

class GoogleFacebookLogin extends StatelessWidget {
  final String label;
  final Function() onPressed; 
  final Widget child ; 
  const GoogleFacebookLogin({
    super.key, required this.child, required this.label, required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: (){},
        child: Column(
          children: 
          [
            SizedBox(
              height: 50, 
              width:50, 
              child: child,
                ),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}