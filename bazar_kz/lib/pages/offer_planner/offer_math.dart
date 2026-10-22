/// Only an unambiguous percentage can be used for a savings estimate.
/// Text such as "up to 50%" must not be presented as a guaranteed discount.
double? exactDiscount(String source) {
  final match =
      RegExp(r'^\s*[-−]?\s*(\d+(?:[.,]\d+)?)\s*%?\s*$').firstMatch(source);
  if (match == null) return null;
  final value = double.tryParse(match.group(1)!.replaceAll(',', '.'));
  return value != null && value > 0 && value <= 100 ? value : null;
}

double? shoppingBudget(String source) {
  final value =
      double.tryParse(source.replaceAll(' ', '').replaceAll(',', '.'));
  return value != null && value.isFinite && value > 0 && value <= 100000000
      ? value
      : null;
}

bool offerExpired(DateTime? end, DateTime now) =>
    end != null && end.isBefore(DateTime(now.year, now.month, now.day));

double estimatedSavings(double budget, double percent) =>
    (budget * percent).roundToDouble() / 100;

double plannedLineTotal(double price, int quantity) =>
    price.isFinite && price > 0 && quantity > 0
        ? (price * quantity * 100).roundToDouble() / 100
        : 0;
