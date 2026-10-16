# BazarKz — итог выпуска 16.10.2026

Все четыре заявки отправлены на модерацию. Публикация бесплатная, только Казахстан, автоматически после одобрения. Публичная доступность ещё не подтверждена. Админка исключена.

| Приложение | Google Play, рабочий выпуск | App Store |
|---|---|---|
| BazarKz — покупки и скидки | 2.0.5(3), изменения на проверке | 2.0.5(7), WAITING_FOR_REVIEW |
| BazarKz для продавцов | 1.0.0(3), изменения на проверке | карточка 1.0, сборка 1.0.0(3), WAITING_FOR_REVIEW |

## Подтверждения
- Google buyer4976312197498296534, seller4973701040996306563, developer8946134913996797045. Подтверждения proofs/buyer-play-production-in-review.png и proofs/seller-play-production-in-review.png.
- Apple buyer6823234191, версия c7523598-f2d1-4ca5-9ac5-c442f0e10b40, VALID build a3279b5c-2ee5-4d85-a8b7-a09c1d7adf00; заявка a6a83ffc-f4f5-43ba-94fd-ec301f39dd1f. Seller6823235066, версия be54b99d-78a9-4478-8180-13dbcce3506b, VALID build0738bd30-28fd-4387-aa2e-5b839bb4a29c. Оба WAITING_FOR_REVIEW подтверждены официальным API.
- Apple proofs/buyer-apple-waiting-for-review.png и proofs/seller-apple-waiting-for-review.png. Настоящие Android/iPhone/iPad снимки загружены. Названия, описания, категории, рейтинги, privacy labels и закрытые тестовые данные сохранены.

## Firebase и проверка
- Политика/поддержка/удаление: https://bazarkz-policies.web.app/. Поддержка milaniumkz@yandex.kz, оператор Dmitriy Shtrakhov.
- Покупатель https://ba-za-r-k-z-np0vyz.web.app; продавец https://bazarkz-seller.web.app обновлены. Админка не развёртывалась.
- Телефонный вход Google/Firebase и Cloud Function finalizeBuyerPhoneSignIn; клиентские SMSC/milanium.kz вызовы удалены. Свежая проверка телефона обязательна; сохранение существующего UID проверено.
- Firestore закрыт release/security/firestore.rules; сохранены 2 существующих администратора и 3 продавца через серверные роли. Node22 функции finalizeBuyerPhoneSignIn, syncAccountRole, submitSellerApplication, deleteOwnAccount развёрнуты.
- Прошли 3 unit-теста входа, 7 тестов доступа, интеграция подтверждения телефона/сохранения UID и удаления своего профиля.
- Настоящий вход покупателя до каталога и продавца до главной прошёл в Android, iPhone и iPad. iOS Firebase callback обрабатывается SceneDelegate; ожидание CAPTCHA 10 минут, защита Google не отключалась. У продавца русский резервный текст при пустых переводах, анализ Dart прошёл; версии notification-расширения согласованы.
- AAB/IPA в artifacts: подписи проверены; Android 16КБ выравнивание проверено. IPA подписаны новым сертификатом Apple, строгая проверка пройдена; неиспользуемые iOS медиамодули покупателя исключены.

## Резервные копии
- Новые отдельные Android upload keys, Apple Distribution F5N9JU54BX (до15.10.2027), приватные ключи/профили защищены в .release-private/2026-10-15 и /Users/dmitriyshtrakhov/.bazarkz-release-backup/2026-10-15. Секреты не включены в публичные файлы.
- Четыре финальных бинарника продублированы, SHA256 сверены. artifact-checksums.json и artifacts/SHA256SUMS обновлены. source-snapshot.tar.gz сохраняет исходники/материалы/память без кэшей и ключей; секреты отдельно.
- Сохранены исходные правила, Auth/IAM/Hosting и снимок104корневых документов11коллекций. Подколлекции и файлыStorage в снимок не входят. Производственные данные не удалялись.
- Тестовые эмуляторы остановлены, данные сохранены; исходная ссылка CoreSimulator Devices сохранена как ~/Library/Developer/CoreSimulator/Devices.external-backup-2026-10-15.

Следующий внешний этап — решение модераторов. Не отправлять заявки повторно. Контекст: .codex/memory/chat-memory.md. Не развёртывать старые открытые правила из экспортов FlutterFlow: использовать проверенные release-конфиги.
