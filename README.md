# BazarKz

Маркетплейс для покупателей и продавцов Казахстана. Репозиторий содержит исходники Flutter-приложений, серверных функций Firebase и конфигурацию облачного управления.

| Каталог | Назначение |
|---|---|
| `bazar_kz` | Покупатель, Android / iOS / web |
| `bazarkz_seller` | Продавец, Android / iOS / web |
| `bazarkz_controls` | Исходники административного приложения; автоматическое развёртывание отключено |
| `release/auth-functions` | Действующие серверные функции Node.js 22 |
| `release/security` | Действующие правила Firestore/Storage и тесты |
| `release/hosting` | Политика, поддержка, удаление аккаунта |
| `release/store-assets` | Графика и скриншоты магазинов |
| `.github/workflows` | Проверки, ручное облачное управление и подписанные сборки |

## Запуск

Нужны Flutter 3.44.1, для Android Java 17 и Android SDK 36 / NDK 28.2.13676358; для iOS macOS, Xcode 26 и CocoaPods. Версии зависимостей зафиксированы lock-файлами.

```sh
cd bazar_kz # либо bazarkz_seller
flutter pub get
flutter run
```

Приложения подключаются к Firebase-проекту `ba-za-r-k-z-np0vyz`. Клиентские Firebase API keys в исходниках являются публичной конфигурацией приложения и не дают административных прав. Доступ к данным ограничен серверными ролями и правилами. Рабочие данные, тестовые учётные данные, приватные ключи и пароли в репозиторий не включены.

## Управление из облака

Откройте [Actions](https://github.com/milaniumkz/bazarkz/actions) → **Firebase cloud management** → **Run workflow** → ветка `main`.

- `status`: проверить доступ к Firebase и список сайтов, без изменений production.
- `deploy-web`: собрать и обновить сайты покупателя и продавца.
- `deploy-functions`: проверить и обновить действующие функции авторизации.
- `deploy-rules`: обновить проверенные правила Firestore/Storage.
- `deploy-policies`: обновить сайт политики и поддержки.

Запуск требует подтверждения владельца в окружении `production`. Google-доступ выдаётся на короткое время через Workload Identity Federation, только этому репозиторию, ветке `main`, окружению `production` и workflow `cloud.yml`. Постоянный ключ Google в GitHub не хранится. Админка не входит в эти операции.

**Не выполняйте `firebase deploy` из экспортированных `*/firebase` каталогов приложений:** это старые экспорты FlutterFlow. Действующие конфигурации находятся только в `release/` и `firebase.publish.json`.

## Подписанные сборки Android и iOS

Actions → **Signed mobile build** → приложение `buyer`/`seller`, платформа, версия и новый номер сборки. Номер должен превышать ранее отправленный в соответствующий магазин. Ключи восстанавливаются из защищённых environment secrets только после подтверждения владельцем. Результат — подписанный AAB или IPA в артефактах запуска на 3 дня. Секреты и профили в артефакты не попадают. Workflow не отправляет новую версию в магазин автоматически.

Секреты `production`: `ANDROID_BUYER_SIGNING`, `ANDROID_SELLER_SIGNING`, `APPLE_SIGNING`, `APPLE_BUYER_PROFILE`, `APPLE_SELLER_PROFILE`, `APPLE_NOTIFICATION_PROFILE`. Управлять ими можно в Settings → Environments → production. Доступ к App Store Connect и Google Play осуществляется через соответствующие консоли владельца; ключи API для публикации сохранены в закрытой резервной копии.

## Проверки

На push/PR запускаются тесты функций, правила доступа и полный сценарий миграции телефонного входа в изолированных эмуляторах Firebase, а также проверка публичных файлов и поиск секретов Gitleaks. PR не получает production secrets. Все внешние Actions закреплены по SHA.

```sh
npm ci --prefix release/auth-functions
npm test --prefix release/auth-functions
npm ci --prefix release/security
cd release/security
npx firebase-tools@14.22.0 emulators:exec --project demo-bazarkz-auth --only auth,firestore,functions 'npm test && node auth.integration.js'
```

## Данные и восстановление

Рабочие данные остаются в Firebase. Закрытые копии находятся в Google Cloud Storage проекта, с запретом публичного доступа и едиными правами IAM:

- `gs://ba-za-r-k-z-np0vyz-private-backups/`: резервная копия Storage и архив восстановления исходников/ключей.
- `gs://ba-za-r-k-z-np0vyz-private-backups-asia/`: управляемый полный экспорт Firestore, включая подколлекции, в совместимом с базой регионе.

Доступ — из [Google Cloud Console](https://console.cloud.google.com/storage/browser?project=ba-za-r-k-z-np0vyz) или Cloud Shell после входа владельца. Эти архивы содержат секреты и данные пользователей: не публикуйте их в GitHub, Issues или Actions artifacts. Автоматическое восстановление поверх рабочей базы не выполняется; сначала восстановите экспорт в отдельную базу и проверьте данные.

Локальные защищённые копии: `.release-private/2026-10-15` и `~/.bazarkz-release-backup/2026-10-15`. Состояние отправленных в магазины версий: [release/STATUS.md](release/STATUS.md). Публичная [политика конфиденциальности и поддержка](https://bazarkz-policies.web.app/).
