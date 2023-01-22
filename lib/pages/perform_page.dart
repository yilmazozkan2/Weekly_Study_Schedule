part of 'home_page.dart';

class PerformPage extends StatefulWidget {
  const PerformPage({Key? key}) : super(key: key);

  @override
  State<PerformPage> createState() => _PerformPageState();
}

class _PerformPageState extends State<PerformPage> {
  myAppBar _myAppbar = myAppBar();

  int analizdegeri = 0;
  List _items = [];
  DBHelper _dbHelper = DBHelper();
  String secilenders = '';
  void getItemsFromDb() async {
    List Items = await _dbHelper.retreiveItemsFromDb();
    setState(() {
      _items = Items;
    });
  }

  @override
  Widget build(BuildContext context) {
    getItemsFromDb();
    return Scaffold(
      appBar: AppBar(
        elevation: _myAppbar.elevation,
        title: _myAppbar.title,
        centerTitle: _myAppbar.centerTitle,
        backgroundColor: _myAppbar.backgroundColor,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: ProjectDecorations.symetricPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              analizdegeri >= 1050
                  ? '$secilenders İçin Haftalık Soru Sayınız İyi'
                  : '$secilenders İçin Haftalık Soru Sayınız Yetersiz. Günde En Azından 150 Soru Çözmelisiniz.',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            Text(
              'Analiz Edilecek Derse Dokunun:',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text("Ders"),
                        numeric: false,
                      ),
                      DataColumn(
                        label: Text("Haftalık Toplam"),
                        numeric: false,
                      ),
                    ],
                    rows: _items
                        .map<DataRow>(
                          (item) => DataRow(cells: [
                            DataCell(Text(item['DERS']), onTap: () async {
                              analizdegeri = int.parse(item['TOPLAMHAFTALIK']);
                              secilenders = item['DERS'];
                            }),
                            DataCell(Text(item['TOPLAMHAFTALIK'])),
                          ]),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
