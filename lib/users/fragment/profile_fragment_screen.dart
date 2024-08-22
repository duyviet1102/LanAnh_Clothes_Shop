
import 'package:LanAnh_FashionShop/admin/Admin_Preferences/current_admin.dart';
import 'package:LanAnh_FashionShop/users/UserPrefences/current_user.dart';
import 'package:LanAnh_FashionShop/users/UserPrefences/user_prefences.dart';
import 'package:LanAnh_FashionShop/users/authentication/login_screen.dart';
import 'package:LanAnh_FashionShop/users/cart/cart_list_screen.dart';
import 'package:LanAnh_FashionShop/users/model/favourite.dart';
import 'package:LanAnh_FashionShop/users/order/order_now_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileFragmentScreen extends StatelessWidget{
  CurrentUser _currentUser = Get.put(CurrentUser()); // access of the already login user
 
  signOutUser() async
  {
     var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey ,
        title: const Text(
          "Logout",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )
        ),
        content: const Text(
          "Are you sure? \n you want to logout from app"
        ),
        actions: [
          TextButton(
            onPressed: ()
            {
            Get.back();
            }, 
          child:const Text(
            "No",
            style: TextStyle(
              color: Colors.black,
            ),
          ) 
          ),
           TextButton(
            onPressed: ()
            {
            Get.back(result:"LoggedOut");
            }, 
          child:const Text(
            "Yes",
            style: TextStyle(
              color: Colors.black,
            ),
          ) 
          )
        ],
      )
     );

     if(resultResponse == "LoggedOut"){
      //delete/remove the user data from phone local storage 
       RememberUserPrefs.removeUserInfo().then((value){
        Get.off(LoginScreen());
       });
      
     }
  } 
  Widget userInfoItemProfile(String userData)
  {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(22),
        color: const Color.fromRGBO(255, 255, 255, 1),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16, 
        vertical: 8,
      ),
      child: Row(children: [
        // Icon(
        //   iconData,
        //   size: 30,
        //   color:Colors.black,
        // ),
        // const SizedBox(width: 15,),
        Text(
          userData,
          style: const TextStyle(
            fontSize: 15,
          )
        )
      ]),
    );
  }
   
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromARGB(179, 218, 213, 213),
      body: Stack(
        children: [
          Container(
            height: 170,
            decoration: 
            const BoxDecoration( 
              gradient: LinearGradient(
              colors: [
                         Colors.yellow, Colors.brown
                        ],
               ),),),
         CustomScrollView(
          slivers: 
          [
            SliverAppBar(
              // centerTitle: true,
              pinned: true,
              expandedHeight: 130,
              elevation: 0,
              automaticallyImplyLeading: true,
              // backgroundColor: Colors.blue,
              flexibleSpace: LayoutBuilder(
                builder: (context,constraints){
                return FlexibleSpaceBar(
                  centerTitle: true,
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: constraints.biggest.height <= 120 ? 1 : 0,
                    child:   Text(_currentUser.user.user_name,style: const TextStyle(color: Colors.black),),
                  ),
                  background: 
                   Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.yellow, Colors.brown
                          ],
                          ),
                        ),
                    child:  
                    Padding(
                      padding: const EdgeInsets.only(top: 24, left: 30, bottom: 15),
                      child: Row(
                        children: 
                        [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage:  AssetImage('images/inapp/guest.jpg'),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text(_currentUser.user.user_name.toUpperCase(),style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600 )),
                        )
                        ],
                      ),
                    ),
                  ),
                );
              },
             ),
            ),
        
        
            SliverToBoxAdapter(
              child: 
                Column(
                  children: 
                    [
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration:
                          BoxDecoration(
                            color: Colors.white,
                             borderRadius: BorderRadius.circular(50),
                             ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: 
                                [
                                  Container(
                                  decoration:
                                  const BoxDecoration(
                                    color: Colors.black54, borderRadius: BorderRadius.only(topLeft: Radius.circular(30),bottomLeft:  Radius.circular(30))),
                                  child: TextButton(
                                    onPressed:()
                                    {
                                      CartListScreen();
                                    },
                                    child: 
                                    SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width * 0.2,
                                      child: 
                                      const Center(
                                        child: 
                                          Text('Cart', style: TextStyle(color: Colors.yellow, fontSize: 20)))),
                                    ),
                                  ),
        
                                  Container(
                                  decoration:
                                  const BoxDecoration(
                                    color: Colors.yellow, borderRadius: BorderRadius.only(topLeft: Radius.circular(1),bottomLeft:  Radius.circular(1))),
                                  child: TextButton(
                                    onPressed:()
                                    {
                                      OrderNowScreen();
                                    },
                                    child: 
                                    SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width * 0.2,
                                      child: 
                                      const Center(
                                        child: 
                                          Text('Orders', style: TextStyle(color: Colors.black, fontSize: 20)))),
                                    ),
                                  ),
        
                                  Container(
                                  decoration:
                                  const BoxDecoration(
                                    color: Colors.black54, borderRadius: BorderRadius.only(topRight: Radius.circular(30),bottomRight:  Radius.circular(30))),
                                  child: TextButton(
                                    onPressed:()
                                    {
                                      Favourite();
                                    },
                                    child: 
                                    SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width * 0.2,
                                      child: 
                                      const Center(
                                        child: 
                                          Text('Wishlist', style: TextStyle(color: Colors.yellow, fontSize: 19)))),
                                    ),
                                  ),
                                ],
                                ),
                     ),
                    
                      Container(
                        color: Colors.grey.shade300,
                        child: Column(
                          children: [
                          const SizedBox(height: 150,child: Image(image: AssetImage('images/inapp/logo.jpg'),),),
                          const ProfileHeaderLabel(label: " Account Info "),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 264,decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(16)),
                              child:  Column(
                              children: 
                              [
                                RepeatedListStyle(icon: Icons.email, title: 'Email Address', subTitle: _currentUser.user.user_email,),
                                const YellowDivider(),
                                RepeatedListStyle(icon: Icons.phone, title: 'Phone:', subTitle: '12345545',),
                                const YellowDivider(),
                                RepeatedListStyle(icon: Icons.location_on_rounded, title: 'Address', subTitle: 'Nha 6',),
                                // Padding(padding: EdgeInsets.symmetric(horizontal: 40),child: Divider(color: Colors.yellow, thickness: 1,),),
                              ],
                              ),
                              ),
                          ),
                        ],
                                             ),
                      ),
                      const ProfileHeaderLabel(label: "  Account Setting  "),
                         Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 264,
                            decoration:
                             BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(16)),
                            child:  Column(
                            children: 
                            [ 
                              RepeatedListStyle(
                                 title: 'Edit Profile',
                                 subTitle: '',
                                 icon: Icons.edit,
                                 onPressed: () {}
                              ),
                              const YellowDivider(),
                              RepeatedListStyle(
                                 title: 'Change Password',
                                 subTitle: '',
                                 icon: Icons.lock,
                                 onPressed: () {}
                              ),
                              const YellowDivider(),
                              RepeatedListStyle(
                                 title: 'Log Out',
                                 subTitle: '',
                                 icon: Icons.logout,
                                 onPressed: () 
                                 {
                                  signOutUser();
                                 }
                              ),
                              // Padding(padding: EdgeInsets.symmetric(horizontal: 40),child: Divider(color: Colors.yellow, thickness: 1,),),
                            ],
                            ),
                            ),
                        ),
                    
                    
                    ],  
                ),
             ),
          
        
          // Container(
          //   decoration: BoxDecoration(color: Colors.yellow),
          // )
          
          ],
        ),
        ]
      ),
    );
    // ListView(
    //    padding: const EdgeInsets.all(32),
    //    children: [
    //     Center(
    //       child: Image.asset(
    //         "images/man.png",
    //         width: 240
    //       )
    //     )
    //     ,const SizedBox(
    //       height: 20,
    //     ),
    //     userInfoItemProfile(Icons.person, _currentAdmin.admin.admin_name),
    //     const SizedBox(
    //       height: 20,
    //     ),
    //     userInfoItemProfile(Icons.email, _currentAdmin.admin.admin_email),
    //     const SizedBox(height: 20,),
    //     Center(
    //       child: Material(
    //         color:Colors.redAccent,
    //          borderRadius: BorderRadius.circular(8),
    //          child: InkWell(
    //           onTap: (){
    //              signOutUser();
    //           },
    //           borderRadius: BorderRadius.circular(32),
    //           child: const Padding(
    //             padding: const EdgeInsets.symmetric(
    //               horizontal: 30,
    //               vertical: 12,
    //             ),
    //            child: const Text(
    //             "Sign Out",
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 16,
    //             ),
    //            ),
    //           ),

             

    //           )
    //          ),
    //       ),
    //      ],
    //     ); 
   }
}

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(horizontal: 40),child: Divider(color: Colors.yellow, thickness: 1,),);
  }
}

class RepeatedListStyle extends StatelessWidget {
  final String title;
  final String subTitle ;
  final IconData icon; 
  final Function()? onPressed ; 
  const RepeatedListStyle({
    super.key, required this.icon, this.onPressed,  this.subTitle = '', required this.title
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
       onTap: onPressed,
       child : ListTile(
        title: Text(title),
        subtitle: Text(subTitle),
        leading:  Icon(icon),),
       );
  }
}

class ProfileHeaderLabel extends StatelessWidget {
  final String label ; 
  const ProfileHeaderLabel({
    super.key, required this.label
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
     height: 40,
    child: 
     Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: 
     [
       const SizedBox(height: 40, width: 50,child: Divider(color: Colors.grey,thickness: 1),),
       Text(
        label,
        style: const TextStyle(
         color: Colors.grey,
         fontSize: 24,
         fontWeight: FontWeight.w600
         ),
       ),
       const SizedBox(height: 40, width: 50,child: Divider(color: Colors.grey,thickness: 1),),
     ],),);
  }
}