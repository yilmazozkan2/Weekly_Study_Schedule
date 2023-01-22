import 'package:ders_calisma_programi/constants/appBar.dart';
import 'package:ders_calisma_programi/constants/padding.dart';
import 'package:ders_calisma_programi/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'perform_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List items = [];
  static String itemTitle = '';
  static String toplamHaftalik = '';

  DBHelper dbHelper = new DBHelper();
  InterstitialAd? _interstitialAd;

  insertItems() async {
    await dbHelper.insertItemsToDb(itemTitle, 0, toplamHaftalik);
    getItemsFromDb();
  }

  deleteTable() async {
    if (items.isNotEmpty) {
      await dbHelper.deleteTable();
      getItemsFromDb();
      ToastMsg('Tablo temizlendi!.');
    } else {
      ToastMsg('Tablo boş!.');
    }
  }

  Future<bool?> ToastMsg(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void getItemsFromDb() async {
    List Items = await dbHelper.retreiveItemsFromDb();
    setState(() {
      items = Items;
    });

  }

  Widget DataListWidget() {

    getItemsFromDb();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: ProjectDecorations.symetricPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ders Adı Giriniz:',style: Theme.of(context).textTheme.bodyText1),
              Container(
                width: 200,
                child: TextFormField(
                  cursorColor: Colors.green,
                  onChanged: (String mytitle) {
                    setState(() {
                      itemTitle = mytitle;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.green,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.green,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.green)),
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(height: 5),
              Text('Dersin Haftalık Toplam Soru Sayısını Giriniz:',style: Theme.of(context).textTheme.bodyText1),
              Container(
                width: 200,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.green,
                  onChanged: (String mytitle) {
                    setState(() {
                      toplamHaftalik = mytitle;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.green,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.green,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.green)),
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Üstteki Boş Alanları Doldurduktan Sonra Ekle'ye Basınız",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Divider(
                color: Colors.green,
                thickness: 1,
              ),
            ],
          ),
        ),
        addTableWidget(),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text("Sil"),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text("Ders"),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text("Haftalık Toplam"),
                    numeric: false,
                  ),
                ],
                rows: items
                    .map<DataRow>((item) => DataRow(cells: [
                          DataCell(
                              Icon(Icons.delete, color: Colors.red, size: 20),
                              onTap: () async {
                            await dbHelper.deleteItemDb(item['ID']);
                            getItemsFromDb();
                          }),
                          DataCell(
                              Text(
                                item['DERS'],
                                style: TextStyle(
                                  decoration: item['SORUSAYI'] == 1
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ), onTap: () async {

                          }),
                          DataCell(
                              Text(
                                item['TOPLAMHAFTALIK'],
                                style: TextStyle(
                                  decoration: item['SORUSAYI'] == 1
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              onTap: () async {}),

                        ]))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row addTableWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            insertItems();
            InterstitialAd.load(
                adUnitId: 'ca-app-pub-8924173754312904/8540837017',
                request: AdRequest(),
                adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
                  this._interstitialAd = ad;
                  _interstitialAd!.show();
                  print('ad loaded');
                  _interstitialAd!.fullScreenContentCallback =
                      FullScreenContentCallback(
                          onAdFailedToShowFullScreenContent: ((ad, error) {
                    ad.dispose();
                    _interstitialAd!.dispose();
                  }), onAdDismissedFullScreenContent: (ad) {
                    ad.dispose();
                    _interstitialAd!.dispose();
                  });
                }, onAdFailedToLoad: (LoadAdError error) {
                  print('InterstitialAd failed ' + error.toString());
                }));
          },
          child: Container(
            width: 120,
            height: 50,
            alignment: Alignment.center,
            color: Colors.green,
            child: Text('Ekle',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white)),
          ),
        ),
        deleteTableWidget(),
      ],
    );
  }

  GestureDetector deleteTableWidget() {
    return GestureDetector(
      onTap: () {
        deleteTable();
      },
      child: Container(
        width: 120,
        height: 50,
        alignment: Alignment.center,
        color: Colors.green,
        child: Text('Tabloyu Temizle',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white)),
      ),
    );
  }

  myAppBar _myAppbar = myAppBar();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: _myAppbar.elevation,
          title: _myAppbar.title,
          centerTitle: _myAppbar.centerTitle,
          backgroundColor: _myAppbar.backgroundColor,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: DataListWidget(),
      ),
    );
  }
}
