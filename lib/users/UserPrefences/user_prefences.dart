// xay dung class de nho cac thong tin nguoi dung da dang nhap 
import 'dart:convert';
import 'package:LanAnh_FashionShop/users/fragment/dashboard_of_fragment.dart';
import 'package:LanAnh_FashionShop/users/model/user.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPrefs // contain user-information 
{
 //save-remember User-Info 
 static Future<void> storeUserInfo(User userInfo) async 
 {
  SharedPreferences preferences = await SharedPreferences.getInstance(); // 
  String userJsonData = jsonEncode(userInfo.toJson());
  await preferences.setString("currentUser",userJsonData); 
  Get.to(DashboardOfFragement());
 }
 //get-read User-info
 static Future<User?> readUserInfo() async {
   User? currentUserInfo; 
   SharedPreferences preferences = await SharedPreferences.getInstance(); // 
   String? userInfo = preferences.getString("currentUser");// now in Json 
   if(userInfo != null)
   {
          //decode here 
          Map<String,dynamic> userDataMap = jsonDecode(userInfo); 
          User.fromJson(userDataMap);
          currentUserInfo = User.fromJson(userDataMap);
   }
   return currentUserInfo; 
 }

 static Future<void> removeUserInfo() async{
   SharedPreferences preferences = await SharedPreferences.getInstance(); // 
   await preferences.remove("currentUser");
 }
}