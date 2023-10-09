import 'package:dreamers_way/utils/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InsertPackage extends StatefulWidget {
  const InsertPackage({super.key});

  @override
  State<InsertPackage> createState() => _InsertPackageState();
}

class _InsertPackageState extends State<InsertPackage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _titleController = "";
  String _descriptionController = "";
  double _amountController = 0.0;
  String _imageController = "";


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // (_isEditable) ? _updateItem() : _addItem();
      _addItem();
      Navigator.of(context).pop();
      _formKey.currentState!.reset();
    }
  }

  // Insert a new journal to the database
  Future<void> _addItem()  async {
    try {
       SQLHelper.createItem(
          _titleController,
          _descriptionController,
          _amountController,
          _imageController

      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ADMIN"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {_submitForm();},
        child: Icon(
            Icons.save
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                // initialValue: _transactionItem['title'],
                onChanged: (value) {
                  setState(() {
                    _titleController = value.trim();
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(12.0)),
                  ),
                  labelText: 'Title',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                // initialValue: _transactionItem['description'],
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
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                // initialValue:  _transactionItem['amount'].toString(),
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
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\-?\d{0,10}(\.\d{0,2})?$')),
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(12.0)),
                  ),
                  labelText: 'Amount',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                // initialValue: _transactionItem['title'],
                onChanged: (value) {
                  setState(() {
                    _imageController = value.trim();
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(12.0)),
                  ),
                  labelText: 'ImageURL',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
