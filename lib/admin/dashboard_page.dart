import 'package:flutter/material.dart';

List<String> label = 
[
  'My Store',
  'Orders',
  'Edit Profile',
  'Manage Products',
  'Balance',
  'Statics',
];

List<IconData> icon = 
[
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart
];
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(onPressed: (){}, icon: 
          const Icon(
            Icons.logout,
            color: Colors.black,
          ),
          )
        ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(15.0),
      child: GridView.count(
       crossAxisCount: 2,
       crossAxisSpacing: 40,
       mainAxisSpacing: 70,
       children: List.generate(6, 
       (index)
       {
         return Card(
          elevation: 30,
          shadowColor: Colors.purpleAccent.shade200,
          child: DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(0),color: Colors.blueGrey.withOpacity(0.7)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
                  [ 
                   Icon(
                   icon[index],
                    size: 50,
                    color: Colors.yellowAccent,),
                   Text(
                    textAlign: TextAlign.center,
                    label[index].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      fontFamily: 'Acme',
                    )
                  )
                ],
              ),
          ),
         );
       }),),
    )
    );
  }
}