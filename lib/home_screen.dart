import 'package:flutter/material.dart';
import 'package:sqflite2/db_helper.dart';
import 'db_helper.dart';


class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
List<Map<String,dynamic>> _allData = [];

bool _isLoading = true; 

void refreshData()async{
  final data = await SQLHelper.getAllData();
  setState(() {
    _allData = data;
    _isLoading = false;
  });
}

@override
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void>_addData()async{
    await SQLHelper.createData(_titlecontroller.text, _desccontroller.text);
    refreshData();
    
  }

  Future<void> _updateData(int id)async{
    await SQLHelper.updateData(id, _titlecontroller.text, _desccontroller.text);
    refreshData();
  }

  void _deleteData(int id)async{
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Color.fromARGB(255, 206, 33, 33),
      content: Text('DAta deleted')));
      refreshData();
  }



  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _desccontroller = TextEditingController();

   void showBottomSheet(int? id, )async{
    if(id!=null){
      final existingData = _allData.firstWhere((element) => element['id']==id);
      _titlecontroller.text = existingData['title'];
      _desccontroller.text = existingData['dese'];
    }

    showModalBottomSheet(
      elevation:5,
      isDismissible: true,
      context:context,
     builder: (_) => Container (
      padding: EdgeInsets.only(top: 30,left: 15,right: 15,
      bottom: MediaQuery.of(context).viewInsets.bottom + 50,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _titlecontroller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
               helperText: 'title'
            ),
          ),
          SizedBox(height: 10,),
          
          TextField(
            controller: _desccontroller,
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
               helperText: 'description'
            ),
          ),
                    SizedBox(height: 10,),
           Center(
            
            child: ElevatedButton(
              onPressed: ()async{
                if(id==null){
                  await _addData();
                }
                if(id !=null){
                  await _updateData(id);

                }
                _titlecontroller.text ="";
                _desccontroller.text ="";
                Navigator.of(context).pop();
              },
              child: Padding(padding: EdgeInsets.all(18),
              child: Text(id ==null?'add data':'update',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
              ),
              ), ),
           )

        ],
      ),
     ));
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 239, 238),
      appBar: AppBar(
        title: Text('CRUD'),
      ),
      body: _isLoading?Center(child: CircularProgressIndicator()
      ,):ListView.builder(
        itemCount: _allData.length,
        itemBuilder: (context,intex)=>Card(
          margin: EdgeInsets.all(15),
          child:   ListTile(
            title: Padding(padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(_allData[intex]['title'],
            style: TextStyle(
              fontSize: 20,
            ),
            ),
            ),
            subtitle: Text(_allData[intex]['dese']),
            trailing: Row( 
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: (){
                  showBottomSheet(_allData[intex]['id']);
                },
                 icon:Icon(Icons.edit,color: Colors.indigo,)),
                  IconButton(onPressed: (){
                    _deleteData(_allData[intex]['id']);
                  },
                 icon:Icon(Icons.delete,color: Color.fromARGB(255, 181, 63, 69),))
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()=>showBottomSheet(null),
      child:  Icon(Icons.add),
      ),
    );
  }
}