import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'set_password_widget.dart' show SetPasswordWidget;
import 'package:flutter/material.dart';

class SetPasswordModel extends FlutterFlowModel<SetPasswordWidget> {
  ///  Local state fields for this page.

  bool isPasswordSame = true;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  String? _passwordTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Password is required';
    }

    if (val.length < 8) {
      return 'the password should be minimum 8 character';
    }

    return null;
  }

  // State field(s) for Confirmpassword widget.
  FocusNode? confirmpasswordFocusNode;
  TextEditingController? confirmpasswordTextController;
  String? Function(BuildContext, String?)?
      confirmpasswordTextControllerValidator;
  String? _confirmpasswordTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Confirm password is required';
    }

    if (val.length < 8) {
      return 'the password should be minimum 8 character';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    passwordTextControllerValidator = _passwordTextControllerValidator;
    confirmpasswordTextControllerValidator =
        _confirmpasswordTextControllerValidator;
  }

  @override
  void dispose() {
    passwordFocusNode?.dispose();
    passwordTextController?.dispose();

    confirmpasswordFocusNode?.dispose();
    confirmpasswordTextController?.dispose();
  }
}
