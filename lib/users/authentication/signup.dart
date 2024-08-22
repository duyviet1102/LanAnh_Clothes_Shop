import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:LanAnh_FashionShop/api/api_connection.dart';
import 'package:LanAnh_FashionShop/users/authentication/login_screen.dart';
import 'package:LanAnh_FashionShop/users/model/user.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http; 
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_application_1/api/'; 


class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>{
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController(); 
  var emailController = TextEditingController(); // tao bo dieu khien de nguoi dung dang nhap
  var passwordController = TextEditingController();
  var isObsecure = true.obs;
  validateUserEmail() async  
  {
    try{
      var res = await http.post( // response of server 
        Uri.parse(API.validateEmail),
        body:
           {
          'user_email':emailController.text.trim(), // get user-email to put in API xampp
           }
        );
        if(res.statusCode == 200) // 200 is response code tell us the request success  
        {
         var resBodyofValidateEmail = jsonDecode(res.body);
         if(resBodyofValidateEmail['emailFound'] == true){
            Fluttertoast.showToast(msg: "Email is already in someone else use. Try another email");
         }
         else {
          //register & save new user record to database 
           registerAndSaveUserRecord();
         }
        }; 
    }
    catch(e)
     { 
        print(e.toString());
       Fluttertoast.showToast(msg: e.toString());
     }
  }
 registerAndSaveUserRecord() async
   { 
      User userModel = User
      (
        1,//id 
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      try
      {
         var res = await http.post( 
            Uri.parse(API.signUp),  //1. Ket noi voi API 
            body: userModel.toJson(),
          );
          if(res.statusCode == 200)
          {//2. neu ket noi thanh cong : 
            var resBodyOfSignUp = jsonDecode(res.body);
            if(resBodyOfSignUp['success'] == true){ //3.Va cau lenh truy van thanh cong 
               Fluttertoast.showToast(msg: "SignUp Successfully"); //Tra ve thong bao  
              setState(() {
                emailController.clear();
                passwordController.clear();
                nameController.clear();
              });
             }
             else{
              Fluttertoast.showToast(msg: "Error Occur , Try Again");
             }
          }
      }catch(e){
          print(e.toString());
          Fluttertoast.showToast(msg: e.toString());
      }
   }
   
  @override
  Widget build(BuildContext context) { // 
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
                //sign-up screen header
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 285,
                  child: Image.asset(
                    "images/signup1.jpg"
                  ) ,
                ),

                //sign up form
                 Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: 
                    Container(
                    decoration: const BoxDecoration(
                    color: Color.fromARGB(60, 240, 231, 231),
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
                        
                        //name- email-password- signup btn
                         Form(
                          key: formKey,
                          child:Column(
                          children: [
                            //name 
                            TextFormField(
                              controller: nameController,
                              validator: (val) => val == "" ? "Please write name" : null, // user de trong thi hien thi loi 
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color : Colors.black,
                                ),
                                hintText: "Name", // cho trong 
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
                            
                            //password field 
                            Obx(
                                ()=> TextFormField(
                                controller: passwordController,
                                obscureText: isObsecure.value,
                                validator: (val) => val == "" ? "Please write password" : null, // user de trong thi hien thi loi 
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

                            //sign up button 
                             Material(
                               color: Colors.greenAccent,
                               borderRadius: BorderRadius.circular(30),
                               child: InkWell(
                                  onTap: ()
                                    {
                                      if(formKey.currentState!.validate())
                                      {
                                        validateUserEmail();
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
                                      "SignUp",
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
                        
                        //dont have an account button - button  
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          const Text("Already have an Account?"),
                          TextButton(
                           onPressed:()
                            {
                             Get.to(()=> const LoginScreen()); 
                            },
                           child: 
                           const Text(
                            "Login Here",
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
                        const SizedBox(height:18,), 
                       //sign up google facebook 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:
                           [ 
                           Material(
                             borderRadius: BorderRadius.circular(30),
                             color: Colors.white,
                             child: 
                             IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.google),color: Color(0xFFDB4437) ,)),
                           Material(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              child: IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.facebook),color: Color(0xFF4267B2))),
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