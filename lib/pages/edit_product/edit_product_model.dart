import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'dart:async';
import 'edit_product_widget.dart' show EditProductWidget;
import 'package:flutter/material.dart';

class EditProductModel extends FlutterFlowModel<EditProductWidget> {
  ///  Local state fields for this page.

  bool purchasedate = false;

  bool validitydate = false;

  ///  State fields for stateful widgets in this page.

  Completer<List<ProductRow>>? requestCompleter;
  // Stores action output result for [Backend Call - API (deletefileandupdate )] action in IconButton widget.
  ApiCallResponse? isThereNoErrorWithImage;
  // Stores action output result for [Custom Action - uploadFileMobileOnly] action in Column widget.
  String? uploadedNewProductImages;
  // Stores action output result for [Custom Action - appendImagePathAction] action in Column widget.
  List<String>? appendedProductImage;
  // Stores action output result for [Backend Call - API (deletefileandupdate )] action in IconButton widget.
  ApiCallResponse? isThereNoErrorWithwcard;
  // Stores action output result for [Custom Action - uploadFileMobileOnly] action in Column widget.
  String? uploadedNewProductWarrantyCards;
  // Stores action output result for [Custom Action - appendImagePathAction] action in Column widget.
  List<String>? appendedWarrantyImages;
  // Stores action output result for [Backend Call - API (deletefileandupdate )] action in IconButton widget.
  ApiCallResponse? isThereNoErrorWithBill;
  // Stores action output result for [Custom Action - uploadFileMobileOnly] action in Column widget.
  String? uploadedNewProductBills;
  // Stores action output result for [Custom Action - appendImagePathAction] action in Column widget.
  List<String>? appednedBillImages;
  // State field(s) for Product_name widget.
  FocusNode? productNameFocusNode;
  TextEditingController? productNameTextController;
  String? Function(BuildContext, String?)? productNameTextControllerValidator;
  // State field(s) for Product_value widget.
  FocusNode? productValueFocusNode;
  TextEditingController? productValueTextController;
  String? Function(BuildContext, String?)? productValueTextControllerValidator;
  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for Product_description widget.
  FocusNode? productDescriptionFocusNode;
  TextEditingController? productDescriptionTextController;
  String? Function(BuildContext, String?)?
      productDescriptionTextControllerValidator;

  /// Query cache managers for this widget.

  final _productImagesManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> productImages({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _productImagesManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearProductImagesCache() => _productImagesManager.clear();
  void clearProductImagesCacheKey(String? uniqueKey) =>
      _productImagesManager.clearRequest(uniqueKey);

  final _warrantyImagesManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> warrantyImages({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _warrantyImagesManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearWarrantyImagesCache() => _warrantyImagesManager.clear();
  void clearWarrantyImagesCacheKey(String? uniqueKey) =>
      _warrantyImagesManager.clearRequest(uniqueKey);

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
    productNameFocusNode?.dispose();
    productNameTextController?.dispose();

    productValueFocusNode?.dispose();
    productValueTextController?.dispose();

    productDescriptionFocusNode?.dispose();
    productDescriptionTextController?.dispose();

    /// Dispose query cache managers for this widget.

    clearProductImagesCache();

    clearWarrantyImagesCache();

    clearBillImagesCache();
  }

  /// Additional helper methods.
  Future waitForRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(const Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = requestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
