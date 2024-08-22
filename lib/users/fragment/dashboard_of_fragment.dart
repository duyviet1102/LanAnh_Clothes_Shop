import 'package:LanAnh_FashionShop/users/cart/cart_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:LanAnh_FashionShop/users/UserPrefences/current_user.dart';
import 'package:LanAnh_FashionShop/users/fragment/favorites_fragment_screen.dart';
import 'package:LanAnh_FashionShop/users/fragment/home_fragment_screen.dart';
import 'package:LanAnh_FashionShop/users/fragment/order_fragment_screen.dart';
import 'package:LanAnh_FashionShop/users/fragment/profile_fragment_screen.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 

class DashboardOfFragement extends StatelessWidget 
{
  CurrentUser _rememberCurrentUser = Get.put(CurrentUser()); 
   final List<Widget>  _fragementScreens = 
  [
    HomeFragmentScreen(),
    FavoritesFragmentScreen(),
    OrderFragmentScreen(),
    CartListScreen(),
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
      "active_icon": Icons.favorite,
      "non_active_icon": Icons.favorite_border, 
      "label": "Favourites",
     },
     {
      "active_icon": FontAwesomeIcons.boxOpen,
      "non_active_icon": FontAwesomeIcons.box, 
      "label": "Orders",
     },
     
     {
      "active_icon": Icons.shopping_cart,
      "non_active_icon": Icons.shopping_cart_outlined, 
      "label": "Cart",
     },
     {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person_outlined, 
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
        _rememberCurrentUser.getUserInfo(); 
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