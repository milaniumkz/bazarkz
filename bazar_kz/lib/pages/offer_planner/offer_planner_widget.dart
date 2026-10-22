import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'offer_math.dart';

/// A buyer-only workspace for planning a visit to independent local shops.
/// Catalog data stays on the server; the comparison and budget stay on device.
class OfferPlannerWidget extends StatefulWidget {
  const OfferPlannerWidget({super.key});
  static const routeName = 'offerPlanner';
  static const routePath = '/offerPlanner';

  @override
  State<OfferPlannerWidget> createState() => _OfferPlannerWidgetState();
}

class _OfferPlannerWidgetState extends State<OfferPlannerWidget> {
  late Future<List<ShopSkidkiRecord>> _shops;
  late Future<List<TovariRecord>> _products;
  final _search = TextEditingController();
  final _budget = TextEditingController(text: '10000');
  final _selected = <String>{};
  final _quantities = <String, int>{};
  String _city = '';
  String _category = '';
  bool _hideExpired = true;
  bool _restoring = true;
  int _sort = 0;
  late final String _storageKey;
  Future<void> _saveQueue = Future.value();

  String tr(String ru, String kk, String en) => FFLocalizations.of(context)
      .getVariableText(ruText: ru, kkText: kk, enText: en);

  @override
  void initState() {
    super.initState();
    _shops = queryShopSkidkiRecordOnce();
    _products = queryTovariRecordOnce();
    _city = currentUserDocument?.city.trim() ?? '';
    _storageKey = 'bazarkz.offerPlanner.v1.$currentUserUid';
    _restore();
  }

  Future<void> _restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _selected
            .addAll((prefs.getStringList('$_storageKey.shops') ?? []).take(3));
        final saved = prefs.getString('$_storageKey.budget');
        if (saved != null) _budget.text = saved;
        for (final entry
            in prefs.getStringList('$_storageKey.items') ?? <String>[]) {
          final parts = entry.split(':');
          final qty = parts.length == 2 ? int.tryParse(parts[1]) : null;
          if (qty != null && qty > 0 && qty <= 99) _quantities[parts[0]] = qty;
        }
      });
    } catch (_) {
      // The planner remains usable if local storage is unavailable.
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  void _save() {
    final ids = _selected.toList();
    final amount = _budget.text;
    final items =
        _quantities.entries.map((e) => '${e.key}:${e.value}').toList();
    _saveQueue = _saveQueue.catchError((_) {}).then((_) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('$_storageKey.shops', ids);
      await prefs.setString('$_storageKey.budget', amount);
      await prefs.setStringList('$_storageKey.items', items);
    }).catchError((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(tr(
              'Не удалось сохранить сравнение на устройстве.',
              'Салыстыруды құрылғыда сақтау мүмкін болмады.',
              'Could not save the comparison on this device.')),
        ));
      }
    });
  }

  void _toggle(ShopSkidkiRecord shop) {
    final id = shop.reference.id;
    if (!_selected.contains(id) && _selected.length == 3) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(tr(
            'Можно сравнить до трёх магазинов. Уберите один из выбранных.',
            'Үш дүкенге дейін салыстыруға болады. Таңдалған біреуін алып тастаңыз.',
            'Compare up to three shops. Remove a selected shop first.')),
      ));
      return;
    }
    setState(() =>
        _selected.contains(id) ? _selected.remove(id) : _selected.add(id));
    _save();
  }

  @override
  void dispose() {
    _search.dispose();
    _budget.dispose();
    super.dispose();
  }

  String money(double value) =>
      '${formatNumber(value, formatType: FormatType.decimal, decimalType: DecimalType.commaDecimal)} ₸';

  Widget _field(String label, String value) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF526064))),
          const SizedBox(height: 3),
          Text(value, style: const TextStyle(fontSize: 15)),
        ]),
      );

  Widget _purchasePlan(List<ShopSkidkiRecord> chosen) =>
      FutureBuilder<List<TovariRecord>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return TextButton(
                onPressed: () =>
                    setState(() => _products = queryTovariRecordOnce()),
                child: Text(tr('Повторить загрузку товаров',
                    'Тауарларды қайта жүктеу', 'Retry loading products')));
          if (!snapshot.hasData) return const LinearProgressIndicator();
          final refs = chosen.map((s) => s.reference).toSet();
          final products =
              snapshot.data!.where((p) => refs.contains(p.idSale)).toList();
          final total = products.fold<double>(
              0,
              (sum, p) =>
                  sum +
                  plannedLineTotal(p.price, _quantities[p.reference.id] ?? 0));
          final budget = shoppingBudget(_budget.text);
          return Card(
              child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                          tr(
                              'Список покупок по магазинам',
                              'Дүкендер бойынша сатып алу тізімі',
                              'Shopping list by shop'),
                          style: const TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(tr(
                          'Планируйте количество по текущим ценам каталога. Это личный список, '
                              'он не создаёт заказ и не резервирует товар. Дополнительная скидка к ценам не применяется.',
                          'Каталог бағалары бойынша санын жоспарлаңыз. Бұл жеке тізім, тапсырыс жасамайды және тауарды брондамайды. '
                              'Бағаларға қосымша жеңілдік қолданылмайды.',
                          'Plan quantities using current catalog prices. This personal list does not place an order '
                              'or reserve stock. No additional discount is applied to these prices.')),
                      if (chosen.isEmpty)
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(tr(
                                'Выберите магазины для списка.',
                                'Тізім үшін дүкендерді таңдаңыз.',
                                'Choose shops for your list.'))),
                      for (final shop in chosen) ...[
                        Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 8),
                            child: Text(shop.title,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600))),
                        if (!products.any((p) => p.idSale == shop.reference))
                          Text(tr(
                              'В каталоге магазина пока нет товаров.',
                              'Дүкен каталогында әзірге тауарлар жоқ.',
                              'This shop has no catalog products yet.')),
                        for (final product in products
                            .where((p) => p.idSale == shop.reference))
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 12,
                                runSpacing: 8,
                                children: [
                                  SizedBox(
                                      width: 230,
                                      child: Text(
                                          '${product.title}\n${money(product.price)}',
                                          style:
                                              const TextStyle(fontSize: 16))),
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            tooltip: tr(
                                                'Уменьшить количество',
                                                'Санын азайту',
                                                'Decrease quantity'),
                                            onPressed: (_quantities[product
                                                            .reference.id] ??
                                                        0) >
                                                    0
                                                ? () {
                                                    setState(() => _quantities[
                                                            product
                                                                .reference.id] =
                                                        (_quantities[product
                                                                    .reference
                                                                    .id] ??
                                                                0) -
                                                            1);
                                                    _save();
                                                  }
                                                : null,
                                            icon: const Icon(
                                                Icons.remove_circle_outline)),
                                        Semantics(
                                            liveRegion: true,
                                            child: Text(
                                                '${_quantities[product.reference.id] ?? 0}',
                                                style: const TextStyle(
                                                    fontSize: 18))),
                                        IconButton(
                                            tooltip: tr(
                                                'Увеличить количество',
                                                'Санын көбейту',
                                                'Increase quantity'),
                                            onPressed: product.price > 0 &&
                                                    (product.hasCols()
                                                        ? product.cols > 0
                                                        : true) &&
                                                    (_quantities[product
                                                                .reference
                                                                .id] ??
                                                            0) <
                                                        (product.hasCols()
                                                            ? product.cols
                                                                .clamp(0, 99)
                                                            : 99)
                                                ? () {
                                                    setState(() => _quantities[
                                                            product
                                                                .reference.id] =
                                                        (_quantities[product
                                                                    .reference
                                                                    .id] ??
                                                                0) +
                                                            1);
                                                    _save();
                                                  }
                                                : null,
                                            icon: const Icon(
                                                Icons.add_circle_outline)),
                                      ]),
                                  Text(money(plannedLineTotal(product.price,
                                      _quantities[product.reference.id] ?? 0))),
                                ],
                              )),
                        Text(
                            '${tr('По магазину', 'Дүкен бойынша', 'Shop subtotal')}: '
                            '${money(products.where((p) => p.idSale == shop.reference).fold<double>(0, (sum, p) => sum + plannedLineTotal(p.price, _quantities[p.reference.id] ?? 0)))}'),
                      ],
                      const Divider(height: 28),
                      Text(
                          '${tr('План всего', 'Жоспардың жалпы сомасы', 'Planned total')}: ${money(total)}',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700)),
                      if (budget != null)
                        Text(
                            total <= budget
                                ? '${tr('Остаток бюджета', 'Бюджет қалдығы', 'Budget remaining')}: ${money(budget - total)}'
                                : '${tr('Превышение бюджета', 'Бюджеттен артық', 'Over budget')}: ${money(total - budget)}',
                            style: TextStyle(
                                color: total > budget
                                    ? Colors.red.shade800
                                    : const Color(0xFF12664F))),
                      TextButton(
                          onPressed: _quantities.values.any((q) => q > 0)
                              ? () {
                                  setState(_quantities.clear);
                                  _save();
                                }
                              : null,
                          child: Text(tr(
                              'Сбросить количество в плане',
                              'Жоспардағы санын қалпына келтіру',
                              'Reset planned quantities'))),
                    ],
                  )));
        },
      );

  Widget _comparison(ShopSkidkiRecord shop) {
    final expired = offerExpired(shop.dateTheEnd, DateTime.now());
    final percent = exactDiscount(shop.procent);
    final budget = shoppingBudget(_budget.text);
    final savings = !expired && percent != null && budget != null
        ? estimatedSavings(budget, percent)
        : null;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFCBDAD6))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Text(shop.title,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w700))),
          IconButton(
              tooltip: tr('Убрать из сравнения', 'Салыстырудан алып тастау',
                  'Remove from comparison'),
              onPressed: () => _toggle(shop),
              icon: const Icon(Icons.close)),
        ]),
        _field(
            tr('Город и адрес', 'Қала және мекенжай', 'City and address'),
            [shop.city, shop.adres]
                .where((v) => v.trim().isNotEmpty)
                .join(' · ')),
        _field(
            tr('Скидка магазина', 'Дүкен жеңілдігі', 'Shop discount'),
            shop.procent.trim().isEmpty
                ? tr('Не указана', 'Көрсетілмеген', 'Not provided')
                : shop.procent),
        _field(
            tr('Срок предложения', 'Ұсыныс мерзімі', 'Offer validity'),
            shop.dateTheEnd == null
                ? tr(
                    'Не указан — уточните у магазина',
                    'Көрсетілмеген — дүкеннен сұраңыз',
                    'Not provided — confirm with the shop')
                : '${expired ? tr('Истёк', 'Аяқталды', 'Expired') : tr('До', 'Дейін', 'Until')} '
                    '${dateTimeFormat('d.M.y', shop.dateTheEnd)}'),
        _field(
            tr('Условия', 'Шарттар', 'Conditions'),
            shop.uslovia.trim().isEmpty
                ? tr(
                    'Магазин не указал условия. Уточните до покупки.',
                    'Дүкен шарттарды көрсетпеген. Сатып алудан бұрын нақтылаңыз.',
                    'The shop has not provided conditions. Confirm before purchasing.')
                : shop.uslovia),
        if (shop.osob.trim().isNotEmpty)
          _field(tr('Особенности', 'Ерекшеліктер', 'Details'), shop.osob),
        const Divider(height: 28),
        Text(
            tr('Оценка для вашего бюджета', 'Бюджетіңізге арналған есеп',
                'Estimate for your budget'),
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        if (savings == null)
          Text(tr(
              'Расчёт недоступен: нужен точный процент и корректная сумма; истёкшие акции исключены. '
                  'Если срок не указан, подтвердите предложение в магазине.',
              'Есептеу үшін нақты пайыз және дұрыс сома қажет. Мерзімі белгісіз болса, дүкеннен растаңыз.',
              'An exact percentage and valid amount are needed. Expired offers are excluded. '
                  'If no expiry is provided, confirm availability with the shop.'))
        else ...[
          Text(
              '${tr('Возможная экономия', 'Ықтимал үнем', 'Potential saving')}: ${money(savings)}',
              style: const TextStyle(
                  color: Color(0xFF12664F),
                  fontSize: 20,
                  fontWeight: FontWeight.w700)),
          Text(
              '${tr('После скидки', 'Жеңілдіктен кейін', 'After discount')}: ${money(budget! - savings)}'),
          const SizedBox(height: 8),
          Text(tr(
              'Ориентир, если скидка применяется ко всей сумме. '
                  'Не является ценой заказа; действуют условия магазина.',
              'Жеңілдік бүкіл сомаға қолданылса ғана есеп. Бұл тапсырыс бағасы емес; дүкен шарттары қолданылады.',
              'Estimate only if the discount applies to the full amount. '
                  'This is not an order price; shop conditions apply.')),
        ],
        const SizedBox(height: 12),
        OutlinedButton.icon(
          icon: const Icon(Icons.storefront_outlined),
          label: Text(tr('Открыть магазин', 'Дүкенді ашу', 'Open shop')),
          onPressed: () => context.pushNamed(PodSaleWidget.routeName,
              queryParameters: {
                'idSale':
                    serializeParam(shop.reference, ParamType.DocumentReference)
              }.withoutNulls),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF2F6F4),
        appBar: AppBar(
            backgroundColor: const Color(0xFFF2F6F4),
            foregroundColor: const Color(0xFF152E25),
            title: Text(tr('План покупок BazarKz', 'BazarKz сатып алу жоспары',
                'BazarKz shopping planner'))),
        body: SafeArea(
            child: _restoring
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder<List<ShopSkidkiRecord>>(
                    future: _shops,
                    builder: (context, snapshot) {
                      if (snapshot.hasError)
                        return Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(tr(
                                'Не удалось загрузить магазины',
                                'Дүкендерді жүктеу мүмкін болмады',
                                'Could not load shops')),
                            TextButton(
                                onPressed: () => setState(
                                    () => _shops = queryShopSkidkiRecordOnce()),
                                child:
                                    Text(tr('Повторить', 'Қайталау', 'Retry'))),
                          ],
                        ));
                      if (!snapshot.hasData)
                        return const Center(child: CircularProgressIndicator());
                      final shops = snapshot.data!;
                      final cities = {
                        if (_city.isNotEmpty) _city,
                        ...shops
                            .map((s) => s.city.trim())
                            .where((s) => s.isNotEmpty)
                      }.toList()
                        ..sort();
                      final categories = {
                        if (_category.isNotEmpty) _category,
                        ...shops
                            .map((s) => s.kat.trim())
                            .where((s) => s.isNotEmpty)
                      }.toList()
                        ..sort();
                      final query = _search.text.trim().toLowerCase();
                      final filtered = shops
                          .where((s) =>
                              (_city.isEmpty || s.city.trim() == _city) &&
                              (_category.isEmpty ||
                                  s.kat.trim() == _category) &&
                              (!_hideExpired ||
                                  !offerExpired(
                                      s.dateTheEnd, DateTime.now())) &&
                              '${s.title} ${s.adres} ${s.text}'
                                  .toLowerCase()
                                  .contains(query))
                          .toList();
                      filtered.sort((a, b) {
                        if (_sort == 1) {
                          final comparison = (exactDiscount(b.procent) ?? -1)
                              .compareTo(exactDiscount(a.procent) ?? -1);
                          if (comparison != 0) return comparison;
                        }
                        if (_sort == 2) {
                          if (a.dateTheEnd != null && b.dateTheEnd == null)
                            return -1;
                          if (a.dateTheEnd == null && b.dateTheEnd != null)
                            return 1;
                          final comparison =
                              a.dateTheEnd?.compareTo(b.dateTheEnd!) ?? 0;
                          if (comparison != 0) return comparison;
                        }
                        return a.title
                            .toLowerCase()
                            .compareTo(b.title.toLowerCase());
                      });
                      final chosen = shops
                          .where((s) => _selected.contains(s.reference.id))
                          .toList();
                      return ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            Center(
                                child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1100),
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                        tr(
                                            'Сравните до трёх местных магазинов перед покупкой.',
                                            'Сатып алудан бұрын үш жергілікті дүкенге дейін салыстырыңыз.',
                                            'Compare up to three local shops before buying.'),
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 8),
                                    Text(tr(
                                        'Адреса, условия, сроки и оценка экономии в одном плане. '
                                            'Выбор и бюджет сохраняются только на этом устройстве.',
                                        'Мекенжайлар, шарттар, мерзімдер және үнем есебі бір жоспарда. '
                                            'Таңдау мен бюджет тек осы құрылғыда сақталады.',
                                        'Addresses, conditions, validity and savings in one plan. '
                                            'Your selection and budget are saved only on this device.')),
                                    const SizedBox(height: 20),
                                    TextField(
                                        controller: _search,
                                        onChanged: (_) => setState(() {}),
                                        decoration: InputDecoration(
                                            prefixIcon:
                                                const Icon(Icons.search),
                                            labelText: tr(
                                                'Название или адрес',
                                                'Атау немесе мекенжай',
                                                'Name or address'),
                                            border:
                                                const OutlineInputBorder())),
                                    const SizedBox(height: 12),
                                    Wrap(
                                        spacing: 12,
                                        runSpacing: 12,
                                        children: [
                                          SizedBox(
                                              width: 250,
                                              child: DropdownButtonFormField<
                                                      String>(
                                                  initialValue: _city,
                                                  isExpanded: true,
                                                  decoration: InputDecoration(
                                                      labelText: tr('Город',
                                                          'Қала', 'City'),
                                                      border:
                                                          const OutlineInputBorder()),
                                                  items: [
                                                    DropdownMenuItem(
                                                        value: '',
                                                        child: Text(tr(
                                                            'Все города',
                                                            'Барлық қалалар',
                                                            'All cities'))),
                                                    ...cities.map((c) =>
                                                        DropdownMenuItem(
                                                            value: c,
                                                            child: Text(c)))
                                                  ],
                                                  onChanged: (v) => setState(
                                                      () => _city = v ?? ''))),
                                          SizedBox(
                                              width: 250,
                                              child: DropdownButtonFormField<
                                                      String>(
                                                  initialValue: _category,
                                                  isExpanded: true,
                                                  decoration: InputDecoration(
                                                      labelText: tr('Категория',
                                                          'Санат', 'Category'),
                                                      border:
                                                          const OutlineInputBorder()),
                                                  items: [
                                                    DropdownMenuItem(
                                                        value: '',
                                                        child: Text(tr(
                                                            'Все категории',
                                                            'Барлық санаттар',
                                                            'All categories'))),
                                                    ...categories.map((c) =>
                                                        DropdownMenuItem(
                                                            value: c,
                                                            child: Text(c)))
                                                  ],
                                                  onChanged: (v) => setState(
                                                      () => _category =
                                                          v ?? ''))),
                                          SizedBox(
                                              width: 250,
                                              child: DropdownButtonFormField<
                                                      int>(
                                                  initialValue: _sort,
                                                  isExpanded: true,
                                                  decoration: InputDecoration(
                                                      labelText: tr('Порядок',
                                                          'Реттеу', 'Sort by'),
                                                      border:
                                                          const OutlineInputBorder()),
                                                  items: [
                                                    DropdownMenuItem(
                                                        value: 0,
                                                        child: Text(tr(
                                                            'Название',
                                                            'Атау',
                                                            'Name'))),
                                                    DropdownMenuItem(
                                                        value: 1,
                                                        child: Text(tr(
                                                            'Скидка по убыванию',
                                                            'Жеңілдік бойынша',
                                                            'Highest discount'))),
                                                    DropdownMenuItem(
                                                        value: 2,
                                                        child: Text(tr(
                                                            'Сначала истекающие',
                                                            'Мерзімі аяқталатындар',
                                                            'Ending soon')))
                                                  ],
                                                  onChanged: (v) => setState(
                                                      () => _sort = v ?? 0))),
                                        ]),
                                    SwitchListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(tr(
                                            'Скрыть истёкшие предложения',
                                            'Мерзімі өткендерді жасыру',
                                            'Hide expired offers')),
                                        subtitle: Text(tr(
                                            'Если срок не указан, уточните его у магазина.',
                                            'Мерзімі көрсетілмесе, дүкеннен нақтылаңыз.',
                                            'If validity is not provided, confirm with the shop.')),
                                        value: _hideExpired,
                                        onChanged: (v) =>
                                            setState(() => _hideExpired = v)),
                                    Text(
                                        '${tr('Найдено магазинов', 'Табылған дүкендер', 'Shops found')}: ${filtered.length}'),
                                    const SizedBox(height: 8),
                                    if (filtered.isEmpty)
                                      Padding(
                                          padding: const EdgeInsets.all(24),
                                          child: Text(tr(
                                              'Нет подходящих магазинов. Измените город, категорию или поиск.',
                                              'Сәйкес дүкендер жоқ. Қаланы, санатты немесе іздеуді өзгертіңіз.',
                                              'No matching shops. Change the city, category or search.'))),
                                    ...filtered.map((shop) => Card(
                                            child: CheckboxListTile(
                                          value: _selected
                                              .contains(shop.reference.id),
                                          onChanged: (_) => _toggle(shop),
                                          title: Text(shop.title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                          subtitle: Text([
                                            shop.city,
                                            shop.adres,
                                            shop.procent.isEmpty
                                                ? tr(
                                                    'Скидка не указана',
                                                    'Жеңілдік көрсетілмеген',
                                                    'Discount not provided')
                                                : shop.procent
                                          ]
                                              .where((s) => s.isNotEmpty)
                                              .join(' · ')),
                                          secondary: const Icon(
                                              Icons.storefront_outlined),
                                        ))),
                                    const SizedBox(height: 24),
                                    Row(children: [
                                      Expanded(
                                          child: Text(
                                              '${tr('Ваше сравнение', 'Салыстыруыңыз', 'Your comparison')} '
                                              '${_selected.length}/3',
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight:
                                                      FontWeight.w700))),
                                      if (_selected.isNotEmpty)
                                        TextButton(
                                            onPressed: () {
                                              setState(_selected.clear);
                                              _save();
                                            },
                                            child: Text(tr('Очистить',
                                                'Тазалау', 'Clear')))
                                    ]),
                                    const SizedBox(height: 12),
                                    TextField(
                                        controller: _budget,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        onChanged: (_) {
                                          setState(() {});
                                          _save();
                                        },
                                        decoration: InputDecoration(
                                            labelText: tr(
                                                'Планируемая сумма, ₸',
                                                'Жоспарланған сома, ₸',
                                                'Planned amount, ₸'),
                                            errorText: shoppingBudget(
                                                        _budget.text) ==
                                                    null
                                                ? tr(
                                                    'Введите сумму от 0 до 100 000 000 ₸ (больше нуля)',
                                                    '0-ден үлкен, 100 000 000 ₸ дейінгі соманы енгізіңіз',
                                                    'Enter an amount above 0 and up to 100,000,000 ₸')
                                                : null,
                                            border:
                                                const OutlineInputBorder())),
                                    const SizedBox(height: 16),
                                    _purchasePlan(chosen),
                                    const SizedBox(height: 16),
                                    if (_selected.isEmpty)
                                      Text(tr(
                                          'Отметьте магазины выше — здесь появятся условия и расчёт.',
                                          'Жоғарыдан дүкендерді таңдаңыз — мұнда шарттар мен есеп пайда болады.',
                                          'Select shops above to compare their conditions and estimates here.')),
                                    if (_selected.length > chosen.length)
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: Text(tr(
                                              'Часть сохранённых магазинов больше недоступна. Очистите выбор, чтобы начать заново.',
                                              'Сақталған дүкендердің кейбірі қолжетімсіз. Қайта бастау үшін таңдауды тазалаңыз.',
                                              'Some saved shops are no longer available. Clear the selection to start again.'))),
                                    LayoutBuilder(builder: (context, size) {
                                      final width = size.maxWidth >= 760
                                          ? (size.maxWidth - 24) / 3
                                          : size.maxWidth;
                                      return Wrap(
                                          spacing: 12,
                                          runSpacing: 12,
                                          children: chosen
                                              .map((s) => SizedBox(
                                                  width: width,
                                                  child: _comparison(s)))
                                              .toList());
                                    }),
                                    const SizedBox(height: 28),
                                  ]),
                            )),
                          ]);
                    },
                  )),
      );
}
