import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'api_manager.dart';
import '/backend/supabase/supabase.dart';
export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class GetSignedUrlCall {
  static Future<ApiCallResponse> call({
    List<String>? imagepathsList,
  }) async {
    final imagepaths = _serializeList(imagepathsList);

    final ffApiRequestBody = '''
{
  "urls":$imagepaths
}''';
    
    final userToken = SupaFlow.client.auth.currentSession?.accessToken;
    if (userToken == null) {
      throw Exception('User not authenticated');
    }

    return ApiManager.instance.makeApiCall(
      callName: 'GetSignedUrl',
      apiUrl: 'https://yifwqsbdmkljzglsyynq.supabase.co/functions/v1/hyper-api',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeletefileandupdateCall {
  static Future<ApiCallResponse> call({
    String? signedUrl = '',
    String? columnName = '',
    String? productId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "signedUrl": "{{${escapeStringForJson(signedUrl)}}}",
  "columnName": "{{${escapeStringForJson(columnName)}}}",
  "productId": "{{${escapeStringForJson(productId)}}}"
}''';
    
    final userToken = SupaFlow.client.auth.currentSession?.accessToken;
    if (userToken == null) {
      throw Exception('User not authenticated');
    }

    return ApiManager.instance.makeApiCall(
      callName: 'deletefileandupdate ',
      apiUrl: 'https://yifwqsbdmkljzglsyynq.supabase.co/functions/v1/delete-file-and-update',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
