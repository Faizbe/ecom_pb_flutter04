import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_pb_flutter04/models/product_model.dart';
import 'package:ecom_pb_flutter04/models/purchase_model.dart';

class DBHelper {
  static const _collectionProduct = 'Products';
  static const _collectionCategory = 'Categories';
  static const _collectionPurchase = 'Purchases';
  static const _collectionAdmin = 'Admins';
  static const _collectionUser = 'Users';
  static const _collectionOrder = 'Orders';
  static const _collectionOrderDetails = 'OrderDetails';
  static const _collectionOrderUtils = 'OrderUtils';
  static const _documentConstants = 'Constants';

  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addNewProduct(ProductModel productModel, PurchaseModel purchaseModel) {

    final writeBatch = _db.batch();
    final productDoc = _db.collection(_collectionProduct).doc();
    final purchaseDoc = _db.collection(_collectionPurchase).doc();
    productModel.id = productDoc.id;
    purchaseModel.purchaseId = purchaseDoc.id;
    purchaseModel.productId = productDoc.id;

    writeBatch.set(productDoc, productModel.toMap());
    writeBatch.set(purchaseDoc, purchaseModel.toMap());

    return writeBatch.commit();
  }

  static Future<bool> isAdmin(String email) async {
    final snapshot = await _db.collection(_collectionAdmin).where('email', isEqualTo: email).get();
    return snapshot.docs.isNotEmpty;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllOrders() =>
      _db.collection(_collectionOrder).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllUsers() =>
      _db.collection(_collectionUser).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllOrdersByUser(String userId) =>
      _db.collection(_collectionOrder).where('user_id', isEqualTo: userId).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllOrderDetails(String orderId) =>
      _db.collection(_collectionOrder).doc(orderId).collection(_collectionOrderDetails).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllCategories() =>
      _db.collection(_collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllProducts() =>
      _db.collection(_collectionProduct).snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> fetchProductByProductId(String productId) =>
      _db.collection(_collectionProduct).doc(productId).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllPurchases() =>
      _db.collection(_collectionPurchase).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchPurchaseByProductId(String productId) =>
      _db.collection(_collectionPurchase)
          .where('productId', isEqualTo: productId)
          .snapshots();
  static Stream<DocumentSnapshot<Map<String, dynamic>>> fetchOrderConstants() =>
      _db.collection(_collectionOrderUtils).doc(_documentConstants).snapshots();

  static Future<void> updateImageUrl(String url, String productId) {
    final doc = _db.collection(_collectionProduct).doc(productId);
    return doc.update({'image': url});
  }
}