import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/components/custom_expansion_tile.dart';
import 'package:to_do_app/model/boxes.dart';
import 'package:to_do_app/model/local_database.dart';

class CompletedTaskPage extends StatefulWidget {
  const CompletedTaskPage({super.key});

  @override
  State<CompletedTaskPage> createState() => _CompletedTaskPageState();
}

class _CompletedTaskPageState extends State<CompletedTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF801E48),
        title: const Text(
          "Completed task",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: ValueListenableBuilder<Box<LocalDatabase>>(
        valueListenable: Boxes.getData().listenable(),
        builder: ((context, box, _) {
          final data = box.values.toList().cast<LocalDatabase>();
          // final keys = box.keys.toList();
          final List<LocalDatabase> result = [];
          for (int i = 0; i < data.length; i++) {
            if (data[i].done == true) {
              result.add(data[i]);
              debugPrint('done = ${data[i].done.toString()}');
            }
          }
          return ListView.builder(
            itemCount: result.length,
            itemBuilder: (context, index) {
              debugPrint(data[index].uuid);
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              );
            },
          );
        }),
      ),
    );
  }
}
