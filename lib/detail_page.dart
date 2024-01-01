import 'dart:convert';

        import 'package:flutter/material.dart';
        import 'package:http/http.dart' as http;
        
        class DetailPage extends StatefulWidget {
          final String? kota_asal;
          final String? kota_tujuan;
          final String? berat;
          final String? kurir;
        
          DetailPage({this.kota_asal, this.kota_tujuan, this.berat, this.kurir});
        
          @override
          State<DetailPage> createState() => _DetailPageState();
        }

        class _DetailPageState extends State<DetailPage> {
          List _data = [];
          var key = '41991cb18667322c19e0a51024ad3026';
        
          @override
          void initState() {
            // ignore: todo
            // TODO: implement initState
            super.initState();
            _getData();
          }
        
          Future _getData() async {
            try {
              final response = await http.post(
                Uri.parse(
                  "https://api.rajaongkir.com/starter/cost",
                ),
                //MENGIRIM PARAMETER
                body: {
                  "key": key,
                  "origin": widget.kota_asal,
                  "destination": widget.kota_tujuan,
                  "weight": widget.berat,
                  "courier": widget.kurir
                },
              ).then((value) {
                var data = jsonDecode(value.body);
        
                setState(() {
                  _data = data['rajaongkir']['results'][0]['costs'];
                });
              });
            } catch (e) {
              //ERROR
              print(e);
            }
          }
        
          @override
          Widget build(BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Detail Cek Ongkir"),
              ),
              body: ListView.builder(
                itemCount: _data.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text("${_data[index]['service']}"),
                    subtitle: Text("${_data[index]['description']}"),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height: 5,), 
                        Text(
                          "Rp ${_data[index]['cost'][0]['value']}",
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                        SizedBox(height: 3,),
                        Text("${_data[index]['cost'][0]['etd']} Days")
                      ],
                    ),
                  );
                },
              ),
            );
          }
        }