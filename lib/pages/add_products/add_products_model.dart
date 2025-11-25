import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'add_products_widget.dart' show AddProductsWidget;
import 'package:flutter/material.dart';

class AddProductsModel extends FlutterFlowModel<AddProductsWidget> {
  ///  Local state fields for this page.

  List<String> warrantycard = [];
  void addToWarrantycard(String item) => warrantycard.add(item);
  void removeFromWarrantycard(String item) => warrantycard.remove(item);
  void removeAtIndexFromWarrantycard(int index) => warrantycard.removeAt(index);
  void insertAtIndexInWarrantycard(int index, String item) =>
      warrantycard.insert(index, item);
  void updateWarrantycardAtIndex(int index, Function(String) updateFn) =>
      warrantycard[index] = updateFn(warrantycard[index]);

  List<String> billimage = [];
  void addToBillimage(String item) => billimage.add(item);
  void removeFromBillimage(String item) => billimage.remove(item);
  void removeAtIndexFromBillimage(int index) => billimage.removeAt(index);
  void insertAtIndexInBillimage(int index, String item) =>
      billimage.insert(index, item);
  void updateBillimageAtIndex(int index, Function(String) updateFn) =>
      billimage[index] = updateFn(billimage[index]);

  List<String> productimage = [];
  void addToProductimage(String item) => productimage.add(item);
  void removeFromProductimage(String item) => productimage.remove(item);
  void removeAtIndexFromProductimage(int index) => productimage.removeAt(index);
  void insertAtIndexInProductimage(int index, String item) =>
      productimage.insert(index, item);
  void updateProductimageAtIndex(int index, Function(String) updateFn) =>
      productimage[index] = updateFn(productimage[index]);

  DateTime? purchasedatedone;

  DateTime? validitydatedone;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - uploadFileMobileOnly] action in Container widget.
  String? uploadedProductImage;
  // Stores action output result for [Custom Action - uploadFileMobileOnly] action in Container widget.
  String? uploadedProductWarranty;
  // Stores action output result for [Custom Action - uploadFileMobileOnly] action in Container widget.
  String? uploadedProductBill;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;

  /// Query cache managers for this widget.

  final _productPhotoManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> productPhoto({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _productPhotoManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearProductPhotoCache() => _productPhotoManager.clear();
  void clearProductPhotoCacheKey(String? uniqueKey) =>
      _productPhotoManager.clearRequest(uniqueKey);

  final _warantyPhotoManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> warantyPhoto({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _warantyPhotoManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearWarantyPhotoCache() => _warantyPhotoManager.clear();
  void clearWarantyPhotoCacheKey(String? uniqueKey) =>
      _warantyPhotoManager.clearRequest(uniqueKey);

  final _billImagesManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> billImages({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _billImagesManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearBillImagesCache() => _billImagesManager.clear();
  void clearBillImagesCacheKey(String? uniqueKey) =>
      _billImagesManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    /// Dispose query cache managers for this widget.

    clearProductPhotoCache();

    clearWarantyPhotoCache();

    clearBillImagesCache();
  }
}
