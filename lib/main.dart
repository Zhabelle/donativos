import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key,}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? selRadio;
  var drItems = ['100', '350', '850', '1000', '9999'];
  String? drVal = '100';
  List<int> donas = [0, 0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donaciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Align(child: Column(children: [Text("Por una buena causa",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),Text("Método de pago",style: TextStyle(color: Colors.grey, fontSize: 14)),],crossAxisAlignment: CrossAxisAlignment.start,),alignment: Alignment.centerLeft,),
          Container(height: 10,),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color:Colors.black)),
            width: MediaQuery.of(context).size.width*0.8,
            child: Column(children: [
              ListTile(leading: Image.asset("assets/paypal.png", width: 32,),title: Text("Paypal"),trailing: Radio(value: 1, groupValue: selRadio, onChanged: (int? newRad){selRadio = newRad; setState(() {});}),),
              ListTile(leading: Image.asset("assets/credit.png", width: 32,),title: Text("Tarjeta"),trailing: Radio(value: 2, groupValue: selRadio, onChanged: (int? newRad){selRadio = newRad; setState(() {});}),),
            ],),
          ),
          Row(children: [
            Text("Cantidad a donar:"),
            DropdownButton(value: drVal,items: drItems.map((e) => DropdownMenuItem(child: Text(e),value: e,)).toList(), onChanged: (String? c){setState(() {drVal = c;});})
          ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
          LinearPercentIndicator(
            lineHeight: 25.0,
            backgroundColor: Colors.purpleAccent,
            animation: true,
            percent: (donas[0]+donas[1])/10000 > 1.0? 1.0: (donas[0]+donas[1])/10000,
            progressColor: Colors.purple,
            center: Text(
              ((donas[0]+donas[1])/100).toString() + "%",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white
              ),
            ),
          ),
          ElevatedButton(onPressed: (){
            setState(() {
              if(selRadio==null)return;
              donas[selRadio!-1] += int.parse(drVal!);
            });
          }, child: Text("Donar"), style: ElevatedButton.styleFrom(minimumSize: Size(MediaQuery.of(context).size.width*0.95, 25)),),
          Spacer(),
        ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SecondPage(donas: {"donos":donas, "total":donas.reduce((v, e) => v+e), "meta":donas.reduce((v, e) => v+e)>=10000})));
      }, child: Icon(Icons.arrow_right), tooltip: "Ver donativos",),
    );
  }
}

class SecondPage extends StatefulWidget {
  Map donas;
  SecondPage({Key? key, required this.donas}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  Widget imageWidgetProvider(){
    return widget.donas["meta"]?Image.asset("assets/thank_you.png"):Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Donativos obtenidos"),),
      body: 
        Column(
          children: [
            Container(height: MediaQuery.of(context).size.height*0.4, 
            child: Padding(
              child: Column(children: [
                Row(children: [
                  Image(image: AssetImage("assets/paypal.png"), height: 50,),
                  Text("\$ ${widget.donas["donos"][0]}",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                Row(children: [
                  Image.asset("assets/credit.png",height: 50,),
                  Text("\$ ${widget.donas["donos"][1]}",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                Container(height: MediaQuery.of(context).size.height*0.002,color: Colors.grey,),
                Row(children: [
                  Icon(Icons.monetization_on, size: 50, color: Color(0xff407020),),
                  Text("${widget.donas["total"]}",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
              ],mainAxisAlignment: MainAxisAlignment.spaceEvenly,),
              padding: EdgeInsets.symmetric(horizontal: 30),
              ),
            ),
            imageWidgetProvider(),
          ],
        ),
    );
  }
}
