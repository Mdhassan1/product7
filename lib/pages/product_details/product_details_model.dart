import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'dart:async';
import 'product_details_widget.dart' show ProductDetailsWidget;
import 'package:flutter/material.dart';

class ProductDetailsModel extends FlutterFlowModel<ProductDetailsWidget> {
  ///  Local state fields for this page.

  List<String> billimages = [];
  void addToBillimages(String item) => billimages.add(item);
  void removeFromBillimages(String item) => billimages.remove(item);
  void removeAtIndexFromBillimages(int index) => billimages.removeAt(index);
  void insertAtIndexInBillimages(int index, String item) =>
      billimages.insert(index, item);
  void updateBillimagesAtIndex(int index, Function(String) updateFn) =>
      billimages[index] = updateFn(billimages[index]);

  List<String> warrantyimages = [];
  void addToWarrantyimages(String item) => warrantyimages.add(item);
  void removeFromWarrantyimages(String item) => warrantyimages.remove(item);
  void removeAtIndexFromWarrantyimages(int index) =>
      warrantyimages.removeAt(index);
  void insertAtIndexInWarrantyimages(int index, String item) =>
      warrantyimages.insert(index, item);
  void updateWarrantyimagesAtIndex(int index, Function(String) updateFn) =>
      warrantyimages[index] = updateFn(warrantyimages[index]);

  ///  State fields for stateful widgets in this page.

  Completer<List<ProductRow>>? requestCompleter;
  // Stores action output result for [Custom Action - uploadFileMobileOnly] action in Column widget.
  String? uploadedNewProductBill;
  // Stores action output result for [Custom Action - appendImagePathAction] action in Column widget.
  List<String>? appednedBillImages;
  // Stores action output result for [Custom Action - uploadFileMobileOnly] action in Column widget.
  String? uploadedNewProductWarranty;
  // Stores action output result for [Custom Action - appendImagePathAction] action in Column widget.
  List<String>? appendedWarrantyImages;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

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
