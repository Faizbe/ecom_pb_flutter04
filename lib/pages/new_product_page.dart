import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_pb_flutter04/db/db_helper.dart';
import 'package:ecom_pb_flutter04/models/product_model.dart';
import 'package:ecom_pb_flutter04/models/purchase_model.dart';
import 'package:ecom_pb_flutter04/providers/product_provider.dart';
import 'package:ecom_pb_flutter04/utils/constants.dart';
import 'package:ecom_pb_flutter04/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class NewProductPage extends StatefulWidget {
  static const String routeName = '/new_product';

  @override
  _NewProductPageState createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  late ProductProvider _productProvider;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _qtyController = TextEditingController();
  String? category;
  DateTime? purchaseDate;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _purchasePriceController.dispose();
    _salePriceController.dispose();
    _descriptionController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _saveProduct,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(12.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Product name'
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return emptyFieldErrMsg;
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: _purchasePriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Purchase Price'
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return emptyFieldErrMsg;
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: _salePriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Sale Price'
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return emptyFieldErrMsg;
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  hintText: 'Product Description'
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return emptyFieldErrMsg;
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Product Quantity'
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return emptyFieldErrMsg;
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                child: DropdownButtonFormField<String>(
                  hint: Text('Select Category'),
                  value: category,
                  onChanged: (value) {
                    setState(() {
                      category = value;
                    });
                  },
                  items: _productProvider.categoryList.map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  )).toList(),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return emptyFieldErrMsg;
                    }
                    return null;
                  },
                ),
              ),
            ),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: Text('Select Purchase Date'),
                      onPressed: _showDatePickerDialog,
                    ),
                    Text(purchaseDate == null ? 'No date chosen' : DateFormat('dd/MM/yyyy').format(purchaseDate!)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePickerDialog() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());
    if(selectedDate != null) {
      setState(() {
        purchaseDate = selectedDate;
      });
    }
  }

  void _saveProduct() {
    if(_formKey.currentState!.validate()) {
      final productModel = ProductModel(
        name: _nameController.text,
        price: num.parse(_salePriceController.text),
        description: _descriptionController.text,
        category: category,
      );
      final purchaseModel = PurchaseModel(
        day: purchaseDate!.day,
        month: purchaseDate!.month,
        year: purchaseDate!.year,
        purchaseTimestamp: Timestamp.fromDate(purchaseDate!),
        purchasePrice: num.parse(_purchasePriceController.text),
        purchaseQuantity: num.parse(_qtyController.text),
      );

      Provider.of<ProductProvider>(context, listen: false).saveProduct(productModel, purchaseModel)
          .then((value) {
            setState(() {
              _nameController.text = '';
              _purchasePriceController.text = '';
              _salePriceController.text = '';
              _descriptionController.text = '';
              _qtyController.text = '';
              category = null;
              purchaseDate = null;
            });
            showMsg(context, 'Saved');
      }).catchError((error) {

      });
    }
  }
}
