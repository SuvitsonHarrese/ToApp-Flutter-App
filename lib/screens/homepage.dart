import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_app/components/custom_expansion_tile.dart';
import 'package:to_do_app/model/local_database.dart';
import 'package:to_do_app/screens/add_task_page.dart';
import 'package:to_do_app/screens/side_drawer.dart';

import '../model/boxes.dart';

class HomePage extends StatefulWidget {
  final userID;

  const HomePage({super.key, required this.userID});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Hive.deleteFromDisk();
    debugPrint("Box deletd");
  }

  @override
  void initState() {
    // TODO: implement initState

    final box = Boxes.getData();
    if (box.isEmpty) {
      getBoxInfo();
    }
    super.initState();
  }

  void getBoxInfo() async {
    // final box = Boxes.getData();
    // if (!Hive.isBoxOpen('to_do_list')) {
    //   debugPrint("started");
    //   final timer = Timer(
    //     const Duration(seconds: 3),
    //     () {},
    //   );
    //   setState(() {
    //     debugPrint("Finished");
    //   });
    // } else {
    //   debugPrint("Confused");
    // }
    if (Hive.isBoxOpen('to_do_list')) {
      final box = Boxes.getData();
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final collectionReference = firestore.collection(widget.userID);
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collectionReference.get();

      if (querySnapshot.size > 0) {
        List<Map<String, dynamic>> list = [];
        list.addAll(querySnapshot.docs.map((e) => e.data()));
        for (int i = 0; i < list.length; i++) {
          final data = LocalDatabase(
              uuid: list[i]['uuid'].toString(),
              title: list[i]['title'].toString(),
              description: list[i]['description'].toString(),
              date: list[i]['date'].toString(),
              notify: list[i]['notify'].toString().toLowerCase() == 'true',
              time: list[i]['time'].toString(),
              done: list[i]['done'].toString().toLowerCase() == 'true');
          box.add(data);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF801E48),
          title: const Text(
            "TO DO task",
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            IconButton(
              onPressed: signUserOut,
              iconSize: 30,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskPage(
                  uuid: widget.userID,
                  operation: 'add',
                  objindex: -1, // Dummy value
                ),
              ),
            );
          },
          label: const Text("New task"),
          icon: const Icon(
            Icons.add,
          ),
          backgroundColor: const Color(0xFF801E48),
        ),
        drawer: const NavigationDrawer(),
        body: ValueListenableBuilder<Box<LocalDatabase>>(
          valueListenable: Boxes.getData().listenable(),
          builder: ((context, box, _) {
            final data = box.values.toList().cast<LocalDatabase>();
            final keys = box.keys.toList();
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                debugPrint(data[index].uuid);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Slidable(
                    startActionPane:
                        ActionPane(motion: const BehindMotion(), children: [
                      SlidableAction(
                        onPressed: (context) => {
                          // data[index].delete(),
                          // FutureBuilder
                          box.delete(keys[index]),
                          FirebaseFirestore.instance
                              .collection(widget.userID)
                              .doc(data[index].uuid)
                              .delete()
                        },
                        backgroundColor: Colors.pink.shade200,
                        icon: Icons.delete,
                        label: 'Delete',
                      )
                    ]),
                    endActionPane:
                        ActionPane(motion: const BehindMotion(), children: [
                      SlidableAction(
                        onPressed: (context) {
                          debugPrint(keys[index].toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTaskPage(
                                uuid: widget.userID,
                                operation: 'update',
                                updateobj: data[index],
                                objindex: keys[index],
                              ),
                            ),
                          );
                        },
                        backgroundColor: Colors.pink.shade200,
                        icon: Icons.edit,
                        label: 'edit',
                      )
                    ]),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[400],
                      ),
                      child: CustomExpansionTile(
                        backgroundColor: Colors.grey[400],
                        title: Text(data[index].title),
                        childrenPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              data[index].description,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              data[index].date,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              data[index].time,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        )
        // : const Center(
        //     child: CircularProgressIndicator(),
        //   ),
        );
  }
}
