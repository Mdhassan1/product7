import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'dart:async';
import 'product_widget.dart' show ProductWidget;
import 'package:flutter/material.dart';

class ProductModel extends FlutterFlowModel<ProductWidget> {
  ///  Local state fields for this page.

  List<ProductRow> searchedproduct = [];
  void addToSearchedproduct(ProductRow item) => searchedproduct.add(item);
  void removeFromSearchedproduct(ProductRow item) =>
      searchedproduct.remove(item);
  void removeAtIndexFromSearchedproduct(int index) =>
      searchedproduct.removeAt(index);
  void insertAtIndexInSearchedproduct(int index, ProductRow item) =>
      searchedproduct.insert(index, item);
  void updateSearchedproductAtIndex(int index, Function(ProductRow) updateFn) =>
      searchedproduct[index] = updateFn(searchedproduct[index]);

  List<ProductRow> products = [];
  void addToProducts(ProductRow item) => products.add(item);
  void removeFromProducts(ProductRow item) => products.remove(item);
  void removeAtIndexFromProducts(int index) => products.removeAt(index);
  void insertAtIndexInProducts(int index, ProductRow item) =>
      products.insert(index, item);
  void updateProductsAtIndex(int index, Function(ProductRow) updateFn) =>
      products[index] = updateFn(products[index]);

  int? productcount;

  bool isLoading = true;
  bool hasError = false;
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in Product widget.
  List<ProductRow>? allproduct;
  bool requestCompleted = false;
  String? requestLastUniqueKey;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  List<String> simpleSearchResults = [];

  /// Query cache managers for this widget.

  final _valueManager = FutureRequestManager<List<ProductRow>>();
  Future<List<ProductRow>> value({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<ProductRow>> Function() requestFn,
  }) =>
      _valueManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearValueCache() => _valueManager.clear();
  void clearValueCacheKey(String? uniqueKey) =>
      _valueManager.clearRequest(uniqueKey);

  final _nameManager = FutureRequestManager<List<ProfileRow>>();
  Future<List<ProfileRow>> name({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<ProfileRow>> Function() requestFn,
  }) =>
      _nameManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearNameCache() => _nameManager.clear();
  void clearNameCacheKey(String? uniqueKey) =>
      _nameManager.clearRequest(uniqueKey);

  final _personalManager = FutureRequestManager<List<ProductRow>>();
  Future<List<ProductRow>> personal({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<ProductRow>> Function() requestFn,
  }) =>
      _personalManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearPersonalCache() => _personalManager.clear();
  void clearPersonalCacheKey(String? uniqueKey) =>
      _personalManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    /// Dispose query cache managers for this widget.

    clearValueCache();

    clearNameCache();

    clearPersonalCache();
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
      final requestComplete = requestCompleted;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
