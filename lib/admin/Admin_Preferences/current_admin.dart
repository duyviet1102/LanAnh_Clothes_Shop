
import 'package:LanAnh_FashionShop/admin/Admin_Preferences/admin_preferences.dart';
import 'package:LanAnh_FashionShop/admin/model/admin.dart';
import 'package:get/get.dart';

class CurrentAdmin extends GetxController 
 {
  Rx<Admin> _currentAdmin = Admin(0,'','','').obs; 

  Admin get admin  => _currentAdmin.value; 

  getAdminInfo() async 
  {
    Admin? getAdminInfoFromLocalStorage = await RememberAdminPrefs.readAdminInfo();
    //lay thong tin tu bo nho cuc bo  (get in4 from local storage)
    _currentAdmin.value = getAdminInfoFromLocalStorage! ; 

  }
}