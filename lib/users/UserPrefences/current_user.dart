//cung cap tt local user vao local storage 

import 'package:LanAnh_FashionShop/users/UserPrefences/user_prefences.dart';
import 'package:LanAnh_FashionShop/users/model/user.dart';
import 'package:get/get.dart';

class CurrentUser extends GetxController 
 {
  Rx<User> _currentUser = User(0,'','','').obs; 

  User get user  => _currentUser.value; 

  getUserInfo() async 
  {
    User? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    //lay thong tin tu bo nho cuc bo  (get in4 from local storage)
    _currentUser.value = getUserInfoFromLocalStorage!; 

  }
}