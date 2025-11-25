import 'package:intl/intl.dart';

String? datecount(
  DateTime? toDate,
  DateTime? fromDate,
) {
  // Return null if either date is null
  if (fromDate == null || toDate == null) {
    return null;
  }

  // Ensure fromDate is before toDate
  if (fromDate.isAfter(toDate)) {
    return 'Invalid dates';
  }

  // Calculate difference
  int years = toDate.year - fromDate.year;
  int months = toDate.month - fromDate.month;
  int days = toDate.day - fromDate.day;

  if (days < 0) {
    months--;
    DateTime prevMonth = DateTime(toDate.year, toDate.month, 0);
    days += prevMonth.day;
  }

  if (months < 0) {
    years--;
    months += 12;
  }

  String result = '';
  if (years > 0) result += '${years}y ';
  if (months > 0) result += '${months}m ';
  if (days > 0) result += '${days}d ';
  if (result.trim().isEmpty) {
    result = '0d ';
  }
  result += ' ago';

  return result.trim();
}

String sumpurchaseValue(List<int> purchaseValue) {
  // Write a Dart function `sumpurchaseValue` that takes a non-nullable `List<int>` and returns a `String`. It sums the list and formats it as: - `10,000,000+` → crores (`cr`), `100,000+` → lakhs (`l`), `1,000+` → thousands (`t`), each with one decimal. - Otherwise, return the sum as a string. - If empty, return `"0"`.  Ensure efficiency and avoid unnecessary null checks. Do not modify code outside the function.
  if (purchaseValue.isEmpty) return "0";

  int sum = purchaseValue.reduce((a, b) => a + b);

  final format = NumberFormat.decimalPattern('en_IN');

  return format.format(sum);
}

DateTime? getFilterDate(
  bool? isLast3Days,
  bool? isLast7Days,
  bool? isLast30Days,
  bool? isLast3Months,
  bool? isShowAllDescending,
) {
  DateTime now = DateTime.now();

  if (isLast3Days == true) {
    return now.subtract(const Duration(days: 3));
  } else if (isLast7Days == true) {
    return now.subtract(const Duration(days: 7));
  } else if (isLast30Days == true) {
    return now.subtract(const Duration(days: 30));
  } else if (isLast3Months == true) {
    return now.subtract(const Duration(days: 90));
  } else if (isShowAllDescending == true) {
    return null; // Show all without filter
  }

  return now; // fallback if nothing selected
}

bool isDateWithin30Days(
  DateTime? fromDate,
  DateTime? toDate,
) {
// Use current date as fromDate if not provided
  fromDate ??= DateTime.now();

  // If toDate is null, return false
  if (toDate == null) {
    return false;
  }

  // Calculate the difference in days
  final differenceInDays = toDate.difference(fromDate).inDays;

  // Return true if within 30 days
  return differenceInDays <= 30;
}

String? extractImagePathFromSignedUrl(String signedUrl) {
  try {
    // Remove surrounding quotes if present
    signedUrl = signedUrl.trim();
    if (signedUrl.startsWith('"') && signedUrl.endsWith('"')) {
      signedUrl = signedUrl.substring(1, signedUrl.length - 1);
    }

    final uri = Uri.parse(signedUrl);
    final pathSegments = uri.pathSegments;

    // Replace 'sign' with 'public' in the path
    final newPathSegments = List<String>.from(pathSegments);
    final signIndex = newPathSegments.indexOf('sign');
    if (signIndex != -1) {
      newPathSegments[signIndex] = 'public';
    } else {
      return null; // If "sign" is not found, it's not a valid signed URL
    }

    final newPath = newPathSegments.join('/');

    // Construct the new public URL (omit query parameters like token)
    final newUri = Uri(
      scheme: uri.scheme,
      host: uri.host,
      path: newPath,
    );

    return newUri.toString();
  } catch (e) {
    return null;
  }
}

String? formatIndianCurrency(int? amount) {
  final format = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0, // ← ensures no decimal places
  );
  return format.format(amount);
}

String getFileExtension(String url) {
  try {
    final uri = Uri.parse(url);
    final fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : "";
    return fileName.contains(".") ? fileName.split('.').last : "unknown";
  } catch (_) {
    return "invalid";
  }
}

double? calculateValuePerDay(
  DateTime? purchaseDate,
  double? purchaseValue,
) {
  if (purchaseDate == null || purchaseValue == null) return null;

  final now = DateTime.now();
  final days = now.difference(purchaseDate).inDays;
  if (days <= 0) return 0.0;

  final valuePerDay = purchaseValue / days;
  return double.parse(valuePerDay.toStringAsFixed(2));
}
