// xay dung class de nho cac thong tin nguoi dung da dang nhap 
import 'dart:convert';

import 'package:LanAnh_FashionShop/admin/Admin_Dashboard.dart';
import 'package:LanAnh_FashionShop/admin/model/admin.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RememberAdminPrefs // contain Admin-information 
{
 //save-remember Admin-Info 
 static Future<void> storeAdminInfo(Admin AdminInfo) async 
 {
  SharedPreferences preferences = await SharedPreferences.getInstance(); // 
  String AdminJsonData = jsonEncode(AdminInfo.toJson());
  await preferences.setString("currentAdmin",AdminJsonData); 
  Get.to(AdminDashboard());
 }
 //get-read Admin-info
 static Future<Admin?> readAdminInfo() async {
   Admin? currentAdminInfo; 
   SharedPreferences preferences = await SharedPreferences.getInstance(); // 
   String? AdminInfo = preferences.getString("currentAdmin");// now in Json 
   if(AdminInfo != null)
   {
          //decode here 
          Map<String,dynamic> AdminDataMap = jsonDecode(AdminInfo); 
          Admin.fromJson(AdminDataMap);
          currentAdminInfo = Admin.fromJson(AdminDataMap);
   }
   return currentAdminInfo; 
 }

 static Future<void> removeAdminInfo() async{
   SharedPreferences preferences = await SharedPreferences.getInstance(); // 
   await preferences.remove("currentAdmin");
 }
}