import 'package:dreamers_way/pages/update_package.dart';
import 'package:dreamers_way/utils/sql_helper.dart';
import 'package:dreamers_way/widgets/app_buttons.dart';
import 'package:flutter/material.dart';

class _DetailPackageState extends State<DetailPackage> {
  late int? city_index;
  var selectedIndex;

  String _titleController = "";
  String _descriptionController = "";
  double _amountController = 0.0;
  String _imageController = "";

  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;
  // int _choiceIndex = 0;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems(
        switchArg: "all", tableName: "package");

    setState(() {
      _journals = data;
      print(_journals.toString());
      // _walletjournals = cashWalletdata;
      // _categoriesjournals = categoriesdata;
      _isLoading = false;
      // _choiceIndex = 0;
      // offsetN = 10;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    city_index = widget.city_index;
    _refreshJournals();
  }

  // Future<void> _updateItem(int id) async {
  //   await SQLHelper.updateItem(
  //     // id,
  //       _titleController,
  //       _descriptionController,
  //       _amountController,
  //       _imageController
  //   );
  //   _refreshJournals();
  // }

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
      _journals.firstWhere((element) => element['id'] == id);
      _titleController = existingJournal['title'];
      _descriptionController = existingJournal['description'];
      _amountController = existingJournal['amount'];
      _imageController = existingJournal['coverImage'];
      // _pId.text= existingJournal['pId'];
      // _pNm .text= existingJournal['pNm'];
      // _appTime.text = existingJournal['appTime'];
    }

    int selectedIndex = -1;

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_journals[city_index!]["title"]),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        UpdatePackage(city_index: city_index,)));
          },
          child: Icon(Icons.edit),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Stack(
              children: [
                Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.maxFinite,
                      height: 400,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              _journals[city_index!]["coverImage"]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
                Positioned(
                  top: 320,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 550,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_journals[city_index!]["title"],
                              style: TextStyle(fontSize: 35,
                                  fontWeight: FontWeight.bold),),
                            Text(_journals[city_index!]["amount"].toString(),
                              style: TextStyle(fontSize: 32),)
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 22,
                              color: Colors.deepPurpleAccent,),
                            SizedBox(width: 5),
                            Text(_journals[city_index!]["title"] + ", India",
                              style: TextStyle(fontSize: 17,
                                  color: Colors.deepPurpleAccent),),
                          ],
                        ),
                        SizedBox(height: 25),
                        Text("People",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.8)
                          ),
                        ),
                        SizedBox(height: 4),
                        Text("Number of people in your group",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          children: List.generate(5, (index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 5),
                                child: AppButtons(
                                  color: selectedIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                  // backgroundColor: selcetedIndex==index?HexColor("000000FF"):HexColor("B0BAC7FF"),
                                  backgroundColor: selectedIndex == index
                                      ? Colors.blue.shade200
                                      : Colors.white,
                                  size: 50,
                                  borderColor: selectedIndex == index ? Colors
                                      .black : Colors.grey,
                                  text: (index + 1).toString(),
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 25),
                        Text("Description",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(_journals[city_index!]["description"],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(top: 720, left: 100),
                  child: ElevatedButton(
                      onPressed: () {}, child: Text("BOOK NOW",
                    style: TextStyle(fontSize: 20),)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailPackage extends StatefulWidget {
final int? city_index;
  DetailPackage({super.key, this.city_index});

  @override
  State<DetailPackage> createState() => _DetailPackageState();
}
