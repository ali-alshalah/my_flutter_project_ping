import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:dart_ping/dart_ping.dart';

class homesecren extends StatefulWidget {
  homesecren({Key? key}) : super(key: key);

  @override
  _homesecrenState createState() => _homesecrenState();
}

class _homesecrenState extends State<homesecren> {
  TextEditingController ip_ping = new TextEditingController();
  ScrollController controller = ScrollController();

  String ip = "192.168.0.1";
  String one = "192.168.0.1";
  bool startping = false;

  List listping = [];
  ping_1(String ip) async {
    Ping ping = new Ping(ip);

    ping.stream.listen((event) {
      if (startping) {
        setState(() {
          listping.add(event.toString());
          scrollDown();
        });
      } else {
        ping.stop();
      }
    });
  }

  saveprefs(String ip, String key) async {
    SharedPreferences prif = await SharedPreferences.getInstance();

    prif.setString(key, ip);
  }

  getprefs(String key) async {
    SharedPreferences prif1 = await SharedPreferences.getInstance();

    if (prif1.getString(key).toString() == "null") {
      ip = prif1.getString(key).toString();
    } else {
      setState(() {
        ip = prif1.getString(key).toString();
        ip_ping.text = ip;
      });
    }
  }

  scrollDown() {
    final double end = controller.position.maxScrollExtent;
    controller.animateTo(end,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  @override
  void initState() {
    // TODO: implement initState

    getprefs("ip");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (startping) {
          } else {
            ping_1(ip_ping.text);
          }
          setState(() {
            startping = !startping;
            print(startping);
          });
          await saveprefs(ip_ping.text, "ip");
        },
        child: startping ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ),
      appBar: AppBar(
        title: Text("Ping"),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Enter IP"),
              controller: ip_ping,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 250,
            margin: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: ListView.builder(
              controller: controller,
              itemCount: listping.length,
              itemBuilder: (context, index) {
                return Text(
                  listping[index],
                  style: TextStyle(fontSize: 15),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
