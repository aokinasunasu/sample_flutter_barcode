import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: HomePage(),
));

class HomePage extends StatefulWidget {
  
  @override
  HomePageState createState() {
    return new HomePageState();
  }

}
String value = "";
class HomePageState extends State<HomePage> {

  String result = "Hey there !";
  var listItem = [];
  int _tap;
  Future _scanQR() async{
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
        // qrResult.codeUnits;
        listItem.add(qrResult);
      });
    } on PlatformException catch (ex) {
      // 不許可
      if(ex.code == BarcodeScanner.CameraAccessDenied) {

        setState(() {
          result = "Camera Permission was denisd";
        });

      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "読み取り形式エラー";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Barcord Scanner"),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black38),
                ),
              ),
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: Text(listItem[index]),
                subtitle: Text('https://www.amazon.co.jp/s?k=$listItem'),
                selected: index == _tap,
                onTap: () { 
                  print("タッチ");
                  print(listItem[index]);
                  setState(() {
                    _tap = index;
                    value = listItem[index];
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondScreen()),
                  ).then((result){
                    if (result == 1) {
                    }
                  
                  });
                },
            ));},
        itemCount: listItem.length,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon:Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class SecondScreen extends StatefulWidget {

  @override
  _SecondScreenState createState() => new _SecondScreenState();

}

class _SecondScreenState extends State<SecondScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url: 'https://www.amazon.co.jp/s?k=$value',
      appBar: AppBar(
        backgroundColor: new Color(0xf7f7f7),
        actions: <Widget>[
          IconButton(
            icon:Icon(Icons.camera_alt),
            onPressed: (){
              
            },)
        ],
      ),
    );
  }
}