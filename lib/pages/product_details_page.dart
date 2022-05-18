import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_pb_flutter04/customwidgets/custom_progress_dialog.dart';
import 'package:ecom_pb_flutter04/models/product_model.dart';
import 'package:ecom_pb_flutter04/providers/product_provider.dart';
import 'package:ecom_pb_flutter04/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/product_details';

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductProvider _productProvider;
  String? _productId;
  String? _productName;
  bool _isUploading = false;
  ImageSource _imageSource = ImageSource.camera;
  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    _productId = argList[0];
    _productName = argList[1];
    _productProvider.getAllPurchasesByProductId(_productId!);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_productName!),
      ),
      body: Center(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _productProvider.getProductByProductId(_productId!),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              final product = ProductModel.fromMap(snapshot.data!.data()!);
              return Stack(
                children: [
                  ListView(
                    children: [
                      product.productImageUrl == null ?
                          Image.asset('images/imagenotavailable.png', width: double.infinity, height: 250, fit: BoxFit.cover,) :
                          FadeInImage.assetNetwork(
                            image: product.productImageUrl!,
                            placeholder: 'images/imagenotavailable.png',
                            width: double.infinity,
                            fadeInDuration: const Duration(seconds: 3),
                            fadeInCurve: Curves.bounceInOut,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                  onPressed: () {
                                    _imageSource = ImageSource.camera;
                                    _getImage();
                                  },
                                  icon: const Icon(Icons.camera),
                                  label: const Text('Capture')
                              ),
                              TextButton.icon(
                                  onPressed: () {
                                    _imageSource = ImageSource.gallery;
                                    _getImage();
                                  },
                                  icon: const Icon(Icons.photo_album),
                                  label: const Text('Gallery')
                              ),
                            ],
                          ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey, width: 2)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Sale Price'),
                            Text('BDT ${product.price}', style: TextStyle(fontSize: 20),),
                            TextButton(
                              child: const Text('Update'),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Purchase History', style: TextStyle(fontSize: 20),),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey, width: 2)
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _productProvider.purchaseListOfSpecificProduct.map((e) => ListTile(
                            title: Text(getFormattedDate(e.purchaseTimestamp!.millisecondsSinceEpoch, 'dd/MM/yyyy', )),
                            trailing: Text('BDT ${e.purchasePrice}', style: const TextStyle(fontSize: 18),),
                            leading: CircleAvatar(
                              child: Text('${e.purchaseQuantity}'),
                            ),
                          )).toList(),
                        ),
                      )
                    ],
                  ),
                  if(_isUploading) const CustomProgressDialog('Please wait')
                ],
              );
            }
            if(snapshot.hasError) {
              return const Text('Failed to fetch data');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  void _getImage() async {
    final imageFile = await ImagePicker().pickImage(source: _imageSource, imageQuality: 75);
    if(imageFile != null) {
      setState(() {
        _isUploading = true;
      });
      //print(imageFile.path);
      _productProvider.uploadImage(
          File(imageFile.path),
          _productId!,
          _productName!).then((value) {
            setState(() {
              _isUploading = false;
            });
      }).catchError((error) {
        setState(() {
          _isUploading = false;
        });

      });
    }
  }
}
