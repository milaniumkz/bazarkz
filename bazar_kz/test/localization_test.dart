import 'package:bazar_kz/flutter_flow/internationalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final locale in [
    const Locale('en'),
    const Locale('kk'),
    const Locale('en', 'US')
  ]) {
    test('checkout remains readable for $locale', () {
      final localization = FFLocalizations(locale);
      expect(localization.getText('m887wc6b'), 'Оформить заказ');
      expect(localization.getText('fq7iva6t'), 'Корзина');
      expect(localization.getVariableText(ruText: 'Далее'), 'Далее');
    });
  }
  test('existing English text is preserved', () {
    expect(
        FFLocalizations(const Locale('en', 'US')).getVariableText(
          ruText: 'Корзина пуста',
          enText: 'Your cart is empty',
        ),
        'Your cart is empty');
  });
}
