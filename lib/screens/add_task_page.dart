import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/model/boxes.dart';
import 'package:to_do_app/model/local_database.dart';

class AddTaskPage extends StatefulWidget {
  final String uuid;
  final LocalDatabase? updateobj;
  final String operation;
  final int objindex;

  const AddTaskPage(
      {super.key,
      required this.uuid,
      required this.operation,
      this.updateobj,
      required this.objindex});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  bool notify = false;
  bool done = false;
  // create TimeOfDay variable
  TimeOfDay timeOfDay = const TimeOfDay(hour: 8, minute: 30);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final timeController = TextEditingController();
  final dateController = TextEditingController();
  final taskController = TextEditingController();
  final descriptionController = TextEditingController();

  

  // show time picker method
  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        timeOfDay = value!;
        timeController.text = timeOfDay.format(context).toString();
      });
    });
  }

  void _showDatePicker() {
    final initialDate = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then(
      (date) => {
        setState(() {
          if (date != null) {
            dateController.text = '${date.day}/${date.month}/${date.year}';
          }
        })
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.operation=='update'){
      setState(() {
      taskController.text=widget.updateobj!.title;
      descriptionController.text=widget.updateobj!.description;
      dateController.text=widget.updateobj!.date;
      timeController.text=widget.updateobj!.time;
      notify=widget.updateobj!.notify;  
      });
    }
    descriptionController.addListener(() {debugPrint("Typing.......");});
  }

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 35,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Create New To do Task",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Task Title",
                ),
                const SizedBox(
                  height: 15,
                ),
                titleTask(),
                const SizedBox(
                  height: 25,
                ),
                const Text("Description"),
                const SizedBox(
                  height: 15,
                ),
                description(),
                const SizedBox(
                  height: 15,
                ),
                const Divider(),
                const SizedBox(
                  height: 15,
                ),
                notifyBox(),
                const SizedBox(
                  height: 55,
                ),
                timeTextField(timeController),
                const SizedBox(
                  height: 20,
                ),
                dateTextfield(dateController),
                const SizedBox(
                  height: 20,
                ),
                addTaskButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleTask() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: taskController,
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: 'Task Title',
            hintStyle: TextStyle(color: Colors.grey.shade600),
            // contentPadding: EdgeInsets.only(left: 0, right: 20),
          ),
        ),
      ),
    );
  }

  Widget description() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextFormField(
          controller: descriptionController,
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: 'Task Description',
            hintStyle: TextStyle(color: Colors.grey.shade600),
            // contentPadding: EdgeInsets.only(left: 20, right: 20),
          ),
        ),
      ),
    );
  }

  Widget notifyBox() {
    return Row(
      children: [
        Checkbox(
          value: notify,
          onChanged: (bool? value) {
            setState(() {
              notify = value!;
            });
          },
        ),
        const Text("Notify me"),
      ],
    );
  }

  Widget timeTextField(TextEditingController controller) {
    return Row(
      children: [
        const Text("Time : "),
        Container(
          height: 55,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 4),
            child: TextFormField(
              controller: controller,
              maxLines: null,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: '6:00 AM',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  suffixIcon: IconButton(
                    onPressed: () => _showTimePicker(),
                    icon: const Icon(Icons.alarm),
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Widget dateTextfield(TextEditingController controller) {
    return Row(
      children: [
        const Text("Date : "),
        Container(
          height: 55,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 4),
            child: TextFormField(
              controller: controller,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: 'DD-MM-YYYY',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                suffixIcon: IconButton(
                  onPressed: () => _showDatePicker(),
                  icon: const Icon(Icons.calendar_month_outlined),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget addTaskButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: Material(
        //Wrap with Material
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
        elevation: 18.0,
        color: const Color(0xFF801E48),
        clipBehavior: Clip.antiAlias, // Add This
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width - 20,
          height: 65,
          color: const Color(0xFF801E48),
          onPressed: widget.operation == 'add'
              ? () async {
                  final documentReference =
                      _firestore.collection(widget.uuid).doc();
                  final docId = documentReference.id;
                  final data = LocalDatabase(
                      uuid: docId,
                      title: taskController.text,
                      description: descriptionController.text,
                      date: dateController.text.isEmpty
                          ? 'NA'
                          : dateController.text,
                      notify: notify,
                      time: timeController.text.isEmpty
                          ? 'NA'
                          : timeController.text,
                      done: done);
                  await FirebaseFirestore.instance
                      .collection(widget.uuid)
                      .doc(docId)
                      .set({
                    'uuid': docId,
                    'title': taskController.text,
                    'description': descriptionController.text,
                    'date': dateController.text.isEmpty
                        ? 'NA'
                        : dateController.text,
                    'notify': notify.toString(),
                    'time': timeController.text.isEmpty
                        ? 'NA'
                        : timeController.text,
                    'done': done
                  });
                  final box = Boxes.getData();
                  box.add(data);
                  Navigator.pop(context);
                }
              : () async {
                  final documentReference = _firestore.collection(widget.uuid);
                  final data = LocalDatabase(
                      uuid: widget.updateobj!.uuid,
                      title: taskController.text,
                      description: descriptionController.text,
                      date: dateController.text.isEmpty
                          ? 'NA'
                          : dateController.text,
                      notify: notify,
                      time: timeController.text.isEmpty
                          ? 'NA'
                          : timeController.text,
                      done: done);

                  await documentReference.doc(widget.updateobj!.uuid).update({
                    'uuid': widget.updateobj!.uuid,
                    'title': taskController.text,
                    'description': descriptionController.text,
                    'date': dateController.text.isEmpty
                        ? 'NA'
                        : dateController.text,
                    'notify': notify.toString(),
                    'time': timeController.text.isEmpty
                        ? 'NA'
                        : timeController.text,
                    'done': done,
                  });
                  final box = Boxes.getData();
                  debugPrint("INdex = ${widget.objindex}");
                  await box.put(widget.objindex, data);
                  Navigator.pop(context);
                },
          child: widget.operation == 'add'
              ? const Text('Add task',
                  style: TextStyle(fontSize: 16.0, color: Colors.white))
              : const Text('Update task',
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
        ),
      ),
    );
  }
}
