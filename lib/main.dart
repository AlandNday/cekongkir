import 'dart:convert';

    import 'package:cekongkir/Details.dart';
    import 'package:flutter/material.dart';
    import 'package:dropdown_search/dropdown_search.dart';
    import 'package:http/http.dart' as http;
    
    void main() {
      runApp(const MyApp());
    }
 class Kota {
        String? cityId;
        String? type;
        String? cityName;
      
        Kota(
            {this.cityId,
            this.type,
            this.cityName});
      
        Kota.fromJson(Map<String, dynamic> json) {
          cityId = json['city_id'];
          type = json['type'];
          cityName = json['city_name'];
        }
      
        @override
        String toString() => cityName as String;
      
        static List<Kota> fromJsonList(List list) {
          if (list.length == 0) return List<Kota>.empty();
          return list.map((item) => Kota.fromJson(item)).toList();
        }
      } 

    class MyApp extends StatelessWidget {
      const MyApp({Key? key}) : super(key: key);
    
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Cek Ongkos Kirim',
          home: Home(),
        );
      }
    }
    class Home extends StatefulWidget {
      const Home({Key? key}) : super(key: key);
    
      @override
      State<Home> createState() => _HomeState();
    }
    
    class _HomeState extends State<Home> {
      var key = '41991cb18667322c19e0a51024ad3026';
      var kota_asal;
      var kota_tujuan; 
      var berat; 
      var kurir;
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Cek Ongkir"),
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownSearch<Kota>(
                  //kamu bisa mendekorasi tampilan field
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Kota Asal",
                    hintText: "Pilih Kota Asal",
                  ),
    
                  //tersedia mode menu dan mode dialog
                  mode: Mode.MENU,
    
                  //jika ingin menampilkan pencarian box
                  showSearchBox: true,
    
                  //di dalam event kita bisa set state atau menyimpan variabel
                  onChanged: (value) {
                    kota_asal = value?.cityId;
                  },
    
                  //kata yang ditampilkan setelah kita memilih
                  itemAsString: (item) => "${item!.type} ${item.cityName}",
    
                  //mencari data dari api
                  onFind: (text) async {
    
                    //mengambil data dari api
                    var response = await http.get(Uri.parse(
                        "https://api.rajaongkir.com/starter/city?key=${key}"));
    
                    //parse string json as dart string dynamic
                    //get data just from results
                    List allKota = (jsonDecode(response.body)
                        as Map<String, dynamic>)['rajaongkir']['results'];
    
                    //simpan data ke dalam model kota
                    var dataKota = Kota.fromJsonList(allKota);
    
                    //return data
                    return dataKota;
                  },
                ),
                SizedBox(height: 20),
                DropdownSearch<Kota>(
    
                  //kamu bisa merubah tampilan field sesuai keinginan
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Kota Tujuan",
                    hintText: "Pilih Kota Tujuan",
                  ),
    
                  //tersedia mode menu dan mode dialog
                  mode: Mode.MENU,
    
                  //jika kamu ingin menampilkan pencarian
                  showSearchBox: true,
    
                  //di dalam onchang3e kamu bisa set state
                  onChanged: (value) {
                    kota_tujuan = value?.cityId;
                  },
    
                  //kata yang akan ditampilkan setelah dipilih
                  itemAsString: (item) => "${item!.type} ${item.cityName}",
    
                  //find data from api
                  onFind: (text) async {
                    //get data from api
                    var response = await http.get(Uri.parse(
                        "https://api.rajaongkir.com/starter/city?key=${key}"));
    
                    //parse string json as dart string dynamic
                    //get data just from results
    
                    List allKota = (jsonDecode(response.body)
                        as Map<String, dynamic>)['rajaongkir']['results'];
    
                    //store data to model
                    var dataKota = Kota.fromJsonList(allKota);
    
                    //return data
                    return dataKota;
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  //input hanya angka
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Berat Paket (gram)",
                    hintText: "Input Berat Paket",
                  ),
                  onChanged: (text) {
                    berat = text;
                  },
                ),
                SizedBox(height: 20),
                DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSelectedItems: true,
                  //pilihan kurir
                  items: ["jne", "tiki", "pos"],
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Kurir",
                    hintText: "Kurir",
                  ),
                  popupItemDisabled: (String s) => s.startsWith('I'),
                  onChanged: (text){
                    kurir = text;
                  }
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: (){
    
                    //validasi
                    if(kota_asal == '' || kota_tujuan == '' || berat == '' || kurir == ''){
                      final snackBar = SnackBar(content: Text("Isi bidang yang masih kosong!"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }else{
                      //berpindah halaman dan bawa data
                      Navigator.push(
                        context,
                        // DetailPage adalah halaman yang dituju 
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            kota_asal: kota_asal,
                            kota_tujuan: kota_tujuan,
                            berat: berat,
                            kurir: kurir,
                          )
                        ),
                      );
                    }
    
                  }, 
                  child: Center(
                    child: Text("Cek Ongkir"),
                  ),
                )
              ],
            ),
          ),
        );
      }
    }