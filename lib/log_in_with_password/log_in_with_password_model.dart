import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'log_in_with_password_widget.dart' show LogInWithPasswordWidget;
import 'package:flutter/material.dart';

class LogInWithPasswordModel extends FlutterFlowModel<LogInWithPasswordWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  String? _passwordTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 8) {
      return 'Password should be minimum 8 character ';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    passwordTextControllerValidator = _passwordTextControllerValidator;
  }

  @override
  void dispose() {
    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }
}
