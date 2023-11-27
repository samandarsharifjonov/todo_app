import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_last/data/database.dart';
import 'package:todo_last/utils/dialog_box.dart';
import 'package:todo_last/utils/todo_title.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  final _myBox = Hive.box("myBox");
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
   if(_myBox.get("TODOLIST") == null){
     db.createInitialData();
   }else{
     db.loadData();
   }
    super.initState();
  }


  final _controller = TextEditingController();

   void checkBoxChanged( value, int index) async {
     setState(() {
       db.toDoList[index][1] = !db.toDoList[index][1];
     });
     db.updateDataBase();
  }

  void saveNewTask (){
     setState(() {
       db.toDoList.add([_controller.text, false]);
     });
     Navigator.of(context).pop();
     _controller.clear();
     db.updateDataBase();
  }

  void createNewTask(){
     showDialog(context: context, builder: (context){
       return DialogBox(
         controller: _controller,
         onSave: saveNewTask,
         onCancel: () {
           Navigator.of(context).pop();
         },
       );
     });
  }


  void deleteTask (int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyanAccent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(child: Text("TODO", style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),)),

              IconButton(
                icon: Image.asset("lib/assets/img_2.png"),
                onPressed: () => showDialog(context: context,
                    builder: (builder){
                     return AlertDialog(
                       title: Text("❗️ About"),
                       content: Container(
                         child: Text("This TODO program was developed  by Samandarbek Sharifjonov, a student of the GITA Academy of Programmers. \n\n ⚠️ The application is in test mode"),
                       ),
                     );
                    })
              )

            ],
          ),
          elevation: 0,
        ),

        floatingActionButton: Container(
          padding: EdgeInsets.only(right: 10, bottom: 10),
          child: IconButton(
            onPressed: createNewTask,
            icon: Image.asset("lib/assets/img.png"),
          ),
        ),

        body: ListView.builder(
          itemCount: db.toDoList.length,
          itemBuilder: (context, index) {
            return ToDoTitle(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );

          },

        ),
      ),
    );
  }
}
