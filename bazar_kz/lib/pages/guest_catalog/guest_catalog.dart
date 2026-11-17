import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/components/catalog_photo.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/pages/offer_planner/offer_planner_widget.dart';

class GuestCatalog extends StatefulWidget {
  const GuestCatalog({super.key});
  @override
  State<GuestCatalog> createState() => _GuestCatalogState();
}

class _GuestCatalogState extends State<GuestCatalog> {
  late Future<(List<ShopSkidkiRecord>, List<TovariRecord>)> _catalog = _load();
  String _search = '';
  String? _city;

  Future<(List<ShopSkidkiRecord>, List<TovariRecord>)> _load() async {
    final results = await Future.wait([
      queryShopSkidkiRecordOnce(),
      queryTovariRecordOnce(),
    ]);
    return (
      results[0].cast<ShopSkidkiRecord>(),
      results[1].cast<TovariRecord>()
    );
  }

  String tr(String ru, String kk, String en) => FFLocalizations.of(context)
      .getVariableText(ruText: ru, kkText: kk, enText: en);

  void _signIn() => context.pushNamed(SelectLangWidget.routeName);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            foregroundColor: const Color(0xFF152E25),
            backgroundColor: Colors.white,
            title: const Text('BazarKz'),
            actions: [
              TextButton(
                  onPressed: _signIn,
                  child: Text(tr('Войти', 'Кіру', 'Sign in')))
            ]),
        body: SafeArea(
            child: FutureBuilder(
          future: _catalog,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: TextButton(
                      onPressed: () => setState(() => _catalog = _load()),
                      child: Text(tr(
                          'Не удалось загрузить каталог. Повторить',
                          'Каталог жүктелмеді. Қайталау',
                          'Could not load catalog. Retry'))));
            }
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final (shops, products) = snapshot.data!;
            final cities = shops
                .map((s) => s.city.trim())
                .where((s) => s.isNotEmpty)
                .toSet()
                .toList()
              ..sort();
            final term = _search.trim().toLowerCase();
            final matches = shops
                .where((s) => _city == null || s.city.trim() == _city)
                .toList();
            final visible = products
                .where((p) =>
                    matches.any((s) => s.reference == p.idSale) &&
                    p.title.toLowerCase().contains(term))
                .toList();
            return Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1040),
                    child:
                        ListView(padding: const EdgeInsets.all(16), children: [
                      Text(
                          tr('Магазины и товары', 'Дүкендер мен тауарлар',
                              'Shops and products'),
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text(tr(
                          'Каталог доступен без регистрации. Войдите, чтобы пользоваться корзиной и заказами.',
                          'Каталог тіркелусіз қолжетімді. Себет пен тапсырыстар үшін кіріңіз.',
                          'Browse without an account. Sign in to use the cart and orders.')),
                      OutlinedButton.icon(
                        onPressed: () =>
                            context.pushNamed(OfferPlannerWidget.routeName),
                        icon: const Icon(Icons.compare_arrows),
                        label: Text(tr('План покупок', 'Сатып алу жоспары',
                            'Shopping planner')),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                          onChanged: (value) => setState(() => _search = value),
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              labelText: tr('Поиск по товарам', 'Тауар іздеу',
                                  'Search products'),
                              border: const OutlineInputBorder())),
                      const SizedBox(height: 12),
                      DropdownButton<String>(
                          isExpanded: true,
                          value: _city ?? '',
                          items: [
                            DropdownMenuItem(
                                value: '',
                                child: Text(tr('Все города', 'Барлық қалалар',
                                    'All cities'))),
                            ...cities.map((c) =>
                                DropdownMenuItem(value: c, child: Text(c)))
                          ],
                          onChanged: (c) =>
                              setState(() => _city = c == '' ? null : c)),
                      if (term.isEmpty)
                        for (final shop in matches)
                          ListTile(
                              leading: const Icon(Icons.storefront_outlined),
                              title: Text(shop.title),
                              subtitle: Text([shop.city, shop.adres]
                                  .where((s) => s.isNotEmpty)
                                  .join(' · ')),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => _showShop(
                                  shop,
                                  products
                                      .where((p) => p.idSale == shop.reference)
                                      .toList())),
                      const Divider(),
                      if (visible.isEmpty)
                        Text(tr('Товары не найдены', 'Тауар табылмады',
                            'No products found')),
                      for (final product in visible)
                        _productTile(
                            product,
                            matches.firstWhere(
                                (s) => s.reference == product.idSale)),
                    ])));
          },
        )),
      );

  String _price(TovariRecord product) => product.price.isFinite &&
          product.price > 0
      ? '${NumberFormat.decimalPattern(FFLocalizations.of(context).languageCode).format(product.price)} ₸'
      : tr('Уточните цену', 'Бағасын нақтылаңыз', 'Ask for price');

  Widget _productTile(TovariRecord product, ShopSkidkiRecord shop) => ListTile(
        leading: CatalogPhoto(product.image.firstOrNull, width: 54, height: 54),
        title: Text(product.title),
        subtitle: Text('${shop.title} · ${_price(product)}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (sheet) => SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  CatalogPhoto(product.image.firstOrNull, height: 220),
                  const SizedBox(height: 12),
                  Text(product.title,
                      style: Theme.of(sheet).textTheme.titleLarge),
                  Text(_price(product)),
                  Text([shop.title, shop.city, shop.adres]
                      .where((s) => s.isNotEmpty)
                      .join(' · ')),
                  const SizedBox(height: 12),
                  FilledButton(
                      onPressed: () {
                        Navigator.pop(sheet);
                        _signIn();
                      },
                      child: Text(tr('Войти для покупок', 'Сатып алу үшін кіру',
                          'Sign in to shop'))),
                ]))),
      );

  void _showShop(ShopSkidkiRecord shop, List<TovariRecord> products) {
    showModalBottomSheet<void>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (sheet) => FractionallySizedBox(
            heightFactor: .8,
            child: ListView(padding: const EdgeInsets.all(24), children: [
              Text(shop.title, style: Theme.of(sheet).textTheme.headlineSmall),
              Text([shop.city, shop.adres]
                  .where((s) => s.isNotEmpty)
                  .join(' · ')),
              if (shop.text.trim().isNotEmpty) Text(shop.text),
              if (shop.uslovia.trim().isNotEmpty) Text(shop.uslovia),
              const Divider(),
              if (products.isEmpty)
                Text(tr(
                    'У магазина пока нет товаров',
                    'Дүкенде әзірге тауар жоқ',
                    'This shop has no products yet')),
              for (final product in products) _productTile(product, shop),
            ])));
  }
}
