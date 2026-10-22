import 'package:bazar_kz/pages/offer_planner/offer_math.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('discount parsing never invents a percentage from conditions', () {
    expect(exactDiscount('25%'), 25);
    expect(exactDiscount('−12,5 %'), 12.5);
    for (final text in ['', 'до 50%', '10–20%', 'buy 1 get 1', '101%', '0']) {
      expect(exactDiscount(text), isNull, reason: text);
    }
  });
  test('budget validates currency input and savings uses minor units', () {
    expect(shoppingBudget('10 000,50'), 10000.5);
    for (final text in ['0', '-100', 'NaN', 'Infinity', '100000001', 'abc']) {
      expect(shoppingBudget(text), isNull, reason: text);
    }
    expect(estimatedSavings(10000.5, 12.5), 1250.06);
  });
  test('date-only expiry includes the entire stated last day', () {
    final now = DateTime(2026, 10, 22, 20);
    expect(offerExpired(DateTime(2026, 10, 22), now), false);
    expect(offerExpired(DateTime(2026, 10, 21, 23), now), true);
    expect(offerExpired(null, now), false);
  });
  test('plan totals use current catalog prices and reject unusable prices', () {
    expect(plannedLineTotal(5000, 2) + plannedLineTotal(45000, 1), 55000);
    expect(plannedLineTotal(12.345, 2), 24.69);
    expect(plannedLineTotal(double.nan, 2), 0);
    expect(plannedLineTotal(-5, 2), 0);
    expect(plannedLineTotal(5000, 0), 0);
  });
}
