
import 'package:LanAnh_FashionShop/admin/Admin_Preferences/current_admin.dart';
import 'package:LanAnh_FashionShop/admin/admin_upload_items.dart';
import 'package:LanAnh_FashionShop/admin/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:LanAnh_FashionShop/users/UserPrefences/current_user.dart';
import 'package:LanAnh_FashionShop/users/fragment/home_fragment_screen.dart';
import 'package:LanAnh_FashionShop/users/fragment/order_fragment_screen.dart';
import 'package:LanAnh_FashionShop/users/fragment/profile_fragment_screen.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 

class AdminDashboard extends StatelessWidget 
{
  CurrentAdmin _rememberCurrentUser = Get.put(CurrentAdmin()); 
   final List<Widget>  _fragementScreens = 
  [
    HomeFragmentScreen(),
    DashboardPage(),
    OrderFragmentScreen(),
    AdminUploadItemsScreen(),
    ProfileFragmentScreen(),
  ]; 
//Button_properties list 
  static const List _navigationButtonsProperties  = 
  [
     {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined, 
      "label": "Home",
     },
     {
      "active_icon": Icons.dashboard,
      "non_active_icon": Icons.dashboard_customize_outlined, 
      "label": "Dashboard",
     },
     {
      "active_icon": Icons.settings,
      "non_active_icon": Icons.settings_outlined, 
      "label": "Setting",
     },
     {
      "active_icon": Icons.upload,
      "non_active_icon": Icons.upload_file_outlined, 
      "label": "Upload",
     },
     {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person_outline, 
      "label": "Profile",
     },
  ]; 

  final RxInt _indexNumber = 0.obs ; 

  @override
  Widget build(BuildContext context)
  {
    return GetBuilder( // put details of userdata  into dashboard
      init: CurrentUser(),
      initState: (currentState)
      {
        _rememberCurrentUser.getAdminInfo(); 
      },
      builder: (controller)
      {
        return Scaffold
        (
         backgroundColor: Colors.white,
          // appBar: AppBar(
          //   backgroundColor: Colors.purple,
          //   title: const Text("Dashboard",style: TextStyle(color: Colors.white),),
          // ),
          body: SafeArea(
             child: Obx(() 
             =>  _fragementScreens[_indexNumber.value],
            ),
          ),
          bottomNavigationBar: Obx(
            ()=> BottomNavigationBar(
              currentIndex: _indexNumber.value,
              onTap: (value)
              {
                _indexNumber.value = value; 
              },
              
              showSelectedLabels:  true,
              showUnselectedLabels: true,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black,
              selectedFontSize: 16,
              items: List.generate(5, (index){
                var navBtnProperty = _navigationButtonsProperties[index];
                return BottomNavigationBarItem(
                  backgroundColor: Colors.white70,
                  icon: Icon(navBtnProperty["non_active_icon"],color: Colors.black,),
                  activeIcon: Icon(navBtnProperty["active_icon"],color: Colors.red,),
                  label: navBtnProperty["label"],
                );
              }
             ),
            )
          ),
        ) ;
      },
    ); 
  }
}