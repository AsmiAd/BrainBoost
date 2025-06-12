import 'package:brain_boost/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
      backgroundColor: AppColors.background,
        title: const Text("Edit Profile"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: CircleAvatar(
                radius: 50,
                foregroundImage: AssetImage("assets/images/profile.jpg"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: TextButton(
                  onPressed: () {}, child: const Text("Add Profile Picture")),
            ),
            const SizedBox(
              height: 10,
            ),
            EditListTile(
                title: "Name",
                icon: const Icon(Icons.person),
                desc: "Asmi Poudel",
                onTap: () {}),
            EditListTile(
                title: "Phone",
                icon: const Icon(Icons.phone),
                desc: "+977 98801222415",
                onTap: () {}),
            EditListTile(
                title: "Email",
                icon: const Icon(Icons.mail),
                desc: "a@gmail.com",
                onTap: () {}),
            EditListTile(
                title: "Country",
                icon: const Icon(Icons.flag),
                desc: "Nepal",
                onTap: () {}),
            Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () {},
               child: Container(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  decoration: BoxDecoration(
    color: Colors.white, 
    border: Border.all(color: Colors.red, width: 1), 
    borderRadius: BorderRadius.circular(8), 
  ),
  child: const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: 30,
        height: 30,
        child: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
      SizedBox(width: 5),
      Text(
        "Delete my account",
        style: TextStyle(
          fontSize: 15,
          color: Colors.red,
          fontWeight: FontWeight.bold, 
        ),
      ),
    ],
  ),
),
              ),
            )
          ],
        ),
      )),
    );
  }
  
}

class EditListTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final String desc;
  final VoidCallback onTap;

  const EditListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.desc,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(title),
      subtitle: Text(desc),
      trailing: const Icon(Icons.edit),
      onTap: onTap,
    );
  }
}