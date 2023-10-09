import 'package:dreamers_way/utils/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdatePackage extends StatefulWidget {
  final int? city_index;
  UpdatePackage({super.key, this.city_index});

  @override
  State<UpdatePackage> createState() => _UpdatePackageState();
}

class _UpdatePackageState extends State<UpdatePackage> {
  @override
  late int? city_index;

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
      _isLoading = false;
      // _choiceIndex = 0;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    city_index = widget.city_index;
    print(city_index);
    _refreshJournals();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // String _titleController = "";
  // String _descriptionController = "";
  // double _amountController = 0.0;
  // String _imageController = "";


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // (_isEditable) ? _updateItem() : _addItem();
      _updateItem();
      Navigator.of(context).pop();
      _formKey.currentState!.reset();
    }
  }

  // Insert a new journal to the database
  Future<void> _updateItem() async {
    try {
      var abc = await SQLHelper.updateItem(
          city_index!,
          _titleController,
          _descriptionController,
          _amountController,
          _imageController

      );
      print("try update_package");
      print(abc);
      // print(city_index, _titleController, _descriptionController, _amountController, _imageController);
      print('city_index: $city_index');
      print('Title: ${_titleController}');
      print('Description: ${_descriptionController}');
      print('Amount: ${_amountController}');
      print('Image: ${_imageController}');
    } catch (e) {
      print("catch update_package");
      print(e);
    }
    // void _showForm(int? id) async {
    //   if (id != null) {
    //     final existingJournal =
    //     _journals.firstWhere((element) => element['id'] == id);
    //     _titleController = existingJournal['title'];
    //     _descriptionController = existingJournal['description'];
    //     _amountController = existingJournal['amount'];
    //     _imageController = existingJournal['coverImage'];
    //     // _pId.text= existingJournal['pId'];
    //     // _pNm .text= existingJournal['pNm'];
    //     // _appTime.text = existingJournal['appTime'];
    //   }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ADMIN"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _submitForm();
        },
        child: Icon(
            Icons.save
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _journals[city_index!]["title"],
                enabled: false,
                onChanged: (value) {
                  setState(() {
                    _titleController = value.trim();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(12.0)),
                  ),
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _journals[city_index!]["description"],
                enabled: false,
                onChanged: (value) {
                  setState(() {
                    _descriptionController = value.trim();
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(12.0)),
                  ),
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _journals[city_index!]["amount"].toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }

                  double parsedAmount = double.tryParse(value) ?? 0.0;

                  if (parsedAmount < 0) {
                    return "Please enter a valid positive amount";
                  }

                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _amountController = double.tryParse(value) ?? 0.0;
                  });
                },
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\-?\d{0,10}(\.\d{0,2})?$')),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(12.0)),
                  ),
                  labelText: 'Amount',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _journals[city_index!]["coverImage"],
                enabled: false,
                onChanged: (value) {
                  setState(() {
                    _imageController = value.trim();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(12.0)),
                  ),
                  labelText: 'ImageURL',
                ),
              ),
              // ElevatedButton(onPressed: () => _showForm(),
              //   child: Icon(Icons.abc_rounded),),
            ],
          ),
        ),
      ),
    );
  }
}
