import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:uts/ui/inputpenjualan.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
class Home extends StatefulWidget {
 @override
 _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
 
 List penjualanList;
 
 int count = 0;
 Future<List> getData() async{
 final response=await http.get('http://192.168.43.87/rest_apici/index.php/penjualan/');
 return json.decode(response.body);
 }
 @override
 void initState() {
 Future<List> penjualanListFuture=getData();
 penjualanListFuture.then((penjualanList){
 setState(() {
 this.penjualanList=penjualanList;
 this.count=penjualanList.length;
 });
 });
 super.initState();
 }
 
 @override
 //membuat widget body
 Widget build(BuildContext context) {
 return Scaffold(
 appBar: new AppBar(
 title: Text("Penjualan Senjata"),
 ),
 body: createListView(),
 //tombol add
 floatingActionButton: FloatingActionButton(
 child: Icon(Icons.add),
 tooltip: 'Input Penjualan',
 onPressed: ()=>Navigator.of(context).push(
      new MaterialPageRoute(
          builder: (BuildContext context)=> new InputPenjualan(list: null,index: null,)
      )
     )
    ),
  );
}

 ListView createListView() {
 TextStyle textStyle = Theme.of(context).textTheme.subhead;
 return ListView.builder(
 itemCount: count,
 itemBuilder: (BuildContext context, int index) {
 return Card(
 color: Colors.white,
 elevation: 2.0,
 child: ListTile(
 title: Text(penjualanList[index]['nama'], style: textStyle,),
 subtitle: Row(
 children: <Widget>[
 Text(penjualanList[index]['tanggal'].toString().toString()),
 Text(" | Rp. "+penjualanList[index]['jumlah'], style: TextStyle(fontWeight:FontWeight.bold),),
 ],
 ),
 //icon delete
 trailing: GestureDetector(
 child: Icon(Icons.delete),
onTap: () => confirm(penjualanList[index]['id'],penjualanList[index]['nama']), 
 ),
 //klik list untuk tampilkan form update
onTap: () =>Navigator.of(context).pushReplacement( new 
            MaterialPageRoute(
            //mengirim list penjualan dan index
            builder:(BuildContext context)=>
          new InputPenjualan(list:penjualanList[index],index:index,)
            )
          )
        ),
      );
    },
  );
 }
   Future<http.Response> deletePenjualan(id) async { 
    final http.Response response = await http.delete(
      'http://192.168.43.87/rest_apici/index.php/penjualan/delete/$id'); 
    return response;
}
void confirm(id,nama){
  AlertDialog alertDialog = new AlertDialog(
    content: new Text("Anda yakin hapus penjualan '$nama'"),
    actions: <Widget>[
      new RaisedButton(
        child: new Text("OK Hapus!",style: new TextStyle(color: Colors.black),),
        color: Colors.red,
        onPressed: (){
          deletePenjualan(id);
          Navigator.of(context, rootNavigator: 
          true).pop(); initState();
        },
      ),
    new RaisedButton(
      child: new Text("Batal",style: new TextStyle(color: Colors.black)),
      color: Colors.green,
      onPressed: ()=> Navigator.of(context, rootNavigator: true).pop(), 
      ),
    ],
  );
  showDialog(context: context, child: alertDialog);
}

}
