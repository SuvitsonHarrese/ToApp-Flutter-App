import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/screens/completed_task_page.dart';
import 'package:to_do_app/screens/pending_task_page.dart';

class NavigationDrawer extends StatelessWidget {
   const NavigationDrawer({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [buildHeader(context), buildMenuItems(context)],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      color: Colors.greenAccent[200],
      padding: EdgeInsets.only(
        top: 24 + MediaQuery.of(context).padding.top,
        bottom: 24,
      ),
      child: Column(
        children: const [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 52,
            // backgroundImage: AssetImage("lib/images/logo.png"),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'To Do App',
            style: TextStyle(fontSize: 28, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Logout"),
            onTap: () {
              // sign User out method
              FirebaseAuth.instance.signOut();
            },
          ),
          const Divider(
            color: Colors.black54,
          ),
          ListTile(
            leading: const Icon(Icons.done_outline_rounded),
            title: const Text("Show Completed Task"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CompletedTaskPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.pending_actions_rounded),
            title: const Text("Pending Tasks"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PendingTaskPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
