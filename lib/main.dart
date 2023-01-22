import 'package:ders_calisma_programi/db_helper.dart';
import 'package:ders_calisma_programi/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper().initilizaeDb();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.green,
          items: items,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
        ),
        body: pages[_currentIndex],
      ),
    );
  }

  List<Widget> pages = [
    HomePage(),
    PerformPage()
  ];
  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
    BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Analiz"),
  ];
}
