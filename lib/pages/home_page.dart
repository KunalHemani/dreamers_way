import 'package:dreamers_way/pages/detailed_page.dart';
import 'package:dreamers_way/pages/insert_package.dart';
import 'package:dreamers_way/utils/sql_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var category = [
    'Best Places',
    'Most Visited',
    'Hotels',
    'Restaurants',
    'Favourites',
    'New Added'
  ];

  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;
  int _choiceIndex = 0;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems(
        switchArg: "all", tableName: "package");

    setState(() {
      _journals = data;
      print(_journals.toString());
      // _walletjournals = cashWalletdata;
      // _categoriesjournals = categoriesdata;
      _isLoading = false;
      _choiceIndex = 0;
      // offsetN = 10;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshJournals();
  }

  void _deleteItem(int id) async{
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of (context).showSnackBar (const SnackBar(
      content: Text('Successfully deleted a Record !'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
    centerTitle: true,
    title: const Text("Packages"),
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      InsertPackage()));
        },
        child: Icon(Icons.edit),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              SizedBox(
                height: 52,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: category.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 7),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 3,
                              )
                            ]),
                        child: Text(
                          category[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }),
              ),

              SizedBox(
                height: 620,
                child: ListView.builder(
                    itemCount: _journals.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPackage(city_index: index)));
                              },
                              child: Container(
                                height: 250,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: NetworkImage(_journals[index]["coverImage"],
                                      )
                                    // fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_journals[index]["title"],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  IconButton(onPressed: () =>
                                      _deleteItem(_journals[index]["id"]),
                                      icon: Icon(Icons.delete))
                                  // const Icon(Icons.flight_takeoff, size: 29),
                                ],

                              ),
                            ),
                            // ElevatedButton(onPressed: (){
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               InsertPackage()));
                            // }, child: Text("ADMIN")),
                            // const SizedBox(height: 5),
                            // Row(
                            //   children: [Text('Desc')],
                            // ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    // bottomNavigationBar: const HomeNavigationBar(),
    );
  }
}
