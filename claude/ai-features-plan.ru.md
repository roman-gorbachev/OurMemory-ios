# AI-функции: камера на надгробие, «Спросите о ветеране», помощник модератора, «Жизненный путь»

## Контекст

Руководство хочет «что-то с AI». Вместо анимации ветеранов (дорого, выдумывает факты, этически спорно) выбраны функции, которые решают реальные задачи и не сочиняют ничего о реальных людях:

1. **Камера на надгробие** — посетитель наводит камеру на плиту, приложение узнаёт имя и открывает карточку.
2. **«Спросите о ветеране»** — чат на карточке, отвечает строго по материалам карточки.
3. **Помощник модератора** — разбор заявки посетителя: резюме, исправленный текст, противоречия с карточкой, расшифровка документов на фото, черновик ответа.
4. **«Жизненный путь»** — точки биографии на карте; черновик готовит ИИ в админке, админ проверяет.

LLM подключается через **Firebase AI Logic** с провайдером **Agent Platform Gemini API** (бывший Vertex AI): приложение обращается к Gemini напрямую через SDK, своего сервера нет. Выбран этот провайдер, а не Gemini Developer API, потому что: можно выбрать регион (у Developer API региональные ограничения, риск для пользователей из Беларуси); данные платного API не используются для обучения моделей; тариф Blaze в `chatroom-85fb8` уже включён.

Уже есть и пригодится: `QrScannerView` / `QrScannerModifier` (`presentation/common/ui/`, VisionKit `DataScannerViewController`), модерация заявок (`presentation/admin/moderation/`, `SubmissionReviewUserAction.textChanged/replyChanged`), `Veteran.allNames`, `Veteran.localized(to:)`, `BurialLocationPicker` (`presentation/admin/burials/ui/`), отрисовка полилиний в `presentation/common/map/YandexMapCoordinator.swift`. Уже работают on-device AI-проверки (`data/contentcheck/`: NSFW-классификатор CoreML, фильтры лексики) — стоит упомянуть руководству.

## Кто чем пользуется

| Функция | Посетители | Админы |
|---|---|---|
| Камера на надгробие | да, полностью | — |
| «Спросите о ветеране» | да, полностью | — |
| «Жизненный путь» | видят ленту и маршрут на карте | создают с помощью ИИ и проверяют |
| Помощник модератора | косвенно: быстрее и аккуратнее ответы на их заявки | да, только они |

## Сложность и стоимость (итог для руководства)

| Функция | ИИ | Работа (iOS + Android) | Эксплуатация |
|---|---|---|---|
| Камера на надгробие | on-device OCR | ~1 неделя + полевой тест на кладбище | $0 |
| Помощник модератора | AI Logic, только админы | ~1 неделя | центы в месяц |
| «Жизненный путь» | AI Logic, только админы | ~1,5 недели | центы на весь архив |
| «Спросите о ветеране» | AI Logic, посетители | ~1–1,5 недели | ~$0,0005–0,002 за вопрос; 10 000 вопросов/мес ≈ $5–20 |

## Защита от злоупотреблений и контроль расходов

Своего сервера нет, поэтому жёсткого общего дневного потолка нет. Вместо него:

- **App Check** с принудительной проверкой для AI Logic: App Attest (iOS), Play Integrity (Android), debug-провайдер для симулятора и отладочных сборок. Запросы не из настоящего приложения отклоняются.
- **Лимит запросов на пользователя в минуту** в настройках AI Logic в консоли.
- **Мягкий дневной лимит** на клиенте (например, 20 вопросов в день; счётчик в `UserDefaults`) — от случайного «залипания», не от взлома.
- **Квоты Agent Platform** на модель в Google Cloud Console и **бюджет с оповещением** ($20/мес) в Billing.
- **Серверные шаблоны промптов** AI Logic (если доступны в проекте): системная инструкция хранится в консоли, клиент передаёт только переменные (карточка, вопрос). Так доступ нельзя использовать как бесплатный Gemini для чего угодно, а промпты одинаковы для iOS и Android и меняются без релиза. Если шаблоны недоступны — инструкции константами в коде, дословно одинаковые на обеих платформах.
- Модель — самая дешёвая из Flash/Flash-Lite, низкая `temperature`, `maxOutputTokens` ~400 для чата.

## Этап 0. Настройка и проверки (1–2 дня)

- В консоли Firebase включить AI Logic → провайдер Agent Platform Gemini API; выбрать регион в ЕС, где доступна выбранная модель (или `global`).
- Включить App Check: зарегистрировать iOS (App Attest) и Android (Play Integrity), добавить debug-токены; после проверки — enforce для AI Logic.
- Задать лимит на пользователя, квоты и бюджет-оповещение.
- Проверить запрос с устройства из Беларуси (без VPN).
- **OCR на реальных плитах:** 20–30 фото надгробий прогнать через Apple Vision (`ru-RU`). Если узнаётся меньше половины имён — камеру делать только как дополнение к QR или не делать.
- **OCR на Android:** ML Kit on-device не поддерживает кириллицу. Варианты: отправка кадра в Gemini через AI Logic (центы, но нужен интернет) или Tesseract с `rus`. Решить по итогам теста.

## Этап 1. Камера на надгробие (без ИИ-сервиса)

Расширить существующий QR-сканер, чтобы он одновременно ловил QR и текст. Один экран «Сканировать»: QR → сразу карточка (как сейчас), имя → список подходящих ветеранов.

- `presentation/common/ui/QrScannerView.swift` → `VeteranScannerView`, `recognizedDataTypes: [.barcode(symbologies: [.qr]), .text(languages: ["ru-RU"])]`; текстовые строки — отдельным колбэком с дебаунсом.
- `QrScannerModifier` → `VeteranScannerModifier`: для текста `.sheet` с детентами и списком кандидатов (`VeteranRow`), тап → `onVeteranOpen`.
- Чистая логика `domain/VeteranNameMatcher.swift`: нормализация (регистр, `ё→е`, отбрасывание званий и сокращений), сравнение с `Veteran.allNames` по фамилии + инициалам с допуском опечаток (Левенштейн), бонус за совпадение годов (`birthDate`/`deathDate`/`years`). Возвращает топ-N кандидатов, автоматически ничего не открывает.
- Кнопка в тулбаре вкладки «Ветераны» (`presentation/home/ui/HomeRoute.swift`, SF Symbol `text.viewfinder`) плюс существующий пункт в «Ещё».
- `presentation/scan/viewmodels/ScanCandidatesViewModel.swift` берёт ветеранов из существующего репозитория; фабрика в `di/AppDIContainer.swift`.
- Строки `scan_grave`, `scan_grave_hint`, `no_matching_veterans_msg` — сначала в Android, затем `sync_android_strings.py`.
- Android: тот же сценарий в CameraX + выбранный OCR.

## Этап 2. Клиентская основа для AI Logic

- `project.yml`: продукты `FirebaseAI` (проверить точное имя продукта в firebase-ios-sdk 12) и `FirebaseAppCheck`; в `App` при старте — `AppCheck.setAppCheckProviderFactory` (App Attest, в Debug — debug-провайдер) до `FirebaseApp.configure()`; entitlement `com.apple.developer.devicecheck.appattest-environment`.
- Новая область `data/ai/`:
  - `datasource/GenerativeModelFactory.swift` — создаёт модели через `FirebaseAI.firebaseAI(backend: .vertexAI(location:))` с параметрами генерации; имя модели и регион — `private static let`.
  - `datasource/AiDataSource.swift` / `AiDataSourceImpl.swift` — вызовы: текстовый ответ, JSON по схеме (`responseMimeType: "application/json"` + `responseSchema`), запрос с изображениями.
  - `AiError.swift` — лимит, недоступность, App Check, пустой ответ.
- Репозитории (протоколы в `domain/repository/`, реализации в `data/ai/repository/`): `VeteranAssistantRepository`, `SubmissionAnalysisRepository`, `LifePathDraftRepository`. Подключение в `AppDIContainer` (`private lazy var`).
- Android: `com.google.firebase:firebase-ai` + App Check Play Integrity, та же структура.

## Этап 3. Помощник модератора (сначала он: проверяем качество модели на админах, а не на посетителях)

- `SubmissionAnalysisRepository.analyze(submission:veteran:photos:)`: карточка (`baseInfo`, `allInfo`, `rewards`, `veteransInfo`, даты), текст заявки и фото (байты уже загружаются для экрана проверки) → JSON:
  `summary`, `suggestedText` (орфография и стиль без изменения фактов), `conflicts[]` (даты, награды, имена расходятся с карточкой), `duplicateOf` (повтор уже имеющегося в `veteransInfo`), `documentTranscripts[]` (расшифровка наградных листов, писем, документов на фото), `suggestedReply`.
  В базу ничего не пишется, форма данных не меняется.
- Модель `domain/models/SubmissionAnalysis.swift`.
- `presentation/admin/moderation/`: действия `SubmissionReviewUserAction.analyze`, `applySuggestedText`, `applySuggestedReply`; поле `analysis: SubmissionAnalysisUi?` и флаг загрузки в `SubmissionReviewUiData`; в `SubmissionReviewScreen` секция `Form` «Анализ ИИ» (кнопка, `ProgressView`, резюме, предупреждения о противоречиях, расшифровки, кнопки «Подставить текст» / «Подставить ответ»). Одобрить или отклонить всегда решает человек.

## Этап 4. «Жизненный путь» на карте

В базе не только военные (например, композитор Соколовский), поэтому путь «жизненный», а не «боевой». Подробные `veteransInfo` дают 5–10 точек, короткие `allInfo` — 1–3 или ничего (тогда секция не показывается).

- **Форма данных (общая с Android, согласовать до кода):** `Veterans/{key}/lifePath` — массив `{ year: String, title: String, place: String, latitude: Double, longitude: Double }`; переводы — `translations/{lang}/lifePath` той же длины (по образцу `veteransInfo`). Модель `domain/models/LifePathStop.swift`, поле в `Veteran` и `VeteranTranslation`, учёт в `localized(to:)`. Проверить, что правила `database.rules.json` разрешают админам запись нового поля.
- `LifePathDraftRepository.draft(for:)`: модель читает `allInfo` + `veteransInfo` и возвращает JSON-черновик точек с историческим и современным названием места (Сталино → Донецк) и примерными координатами.
- Админка: в `presentation/admin/veterans/ui/VeteranEditorForm.swift` секция «Жизненный путь» — кнопка «Заполнить с помощью ИИ», список точек (год, событие, место), уточнение координат через `BurialLocationPicker`. Сохранение тем же путём, что и остальные поля редактора, затем `invalidate()` кэша ветеранов.
- Карточка: `presentation/details/ui/LifePathSection.swift` — лента «год — событие — место» в `cardBackground()`, кнопка «Показать на карте».
- Карта: `MapDestination.lifePath(veteranId)`; линия и маркеры через `YandexMapCoordinator`.
- **«Служили вместе» отложено:** в выгрузке около 15 ветеранов разных профилей, совпадений частей почти не будет. Вернуться, когда база вырастет; данные `lifePath` пригодятся.

## Этап 5. «Спросите о ветеране»

- `VeteranAssistantRepository`: чат-сессия AI Logic (`startChat`) с системной инструкцией (или шаблоном): отвечать только по приложенным материалам карточки и захоронения; если ответа нет — так и сказать; не говорить от лица ветерана; не додумывать; язык ответа = язык приложения (ru/be/en); вопросы не по теме вежливо отклонять. Контекст — уже загруженный в `DetailsViewModel` ветеран (`localized(to:)`) и захоронение. Ограничение длины вопроса и числа сообщений в истории.
- `presentation/assistant/`: `ui/AskVeteranRoute`, `ui/AskVeteranScreen`, `viewmodels/AskVeteranViewModel`, `states/`, `models/AskVeteranUserAction`. Открывается `.sheet` с детентами из карточки (`DetailsScreen`, новая карточка-кнопка рядом с `ContributeSection`, `DetailsUserAction.askAboutVeteran`). Внутри: список сообщений, поле ввода, 3 готовых вопроса-кнопки («Где воевал?», «За что награждён?», «Где похоронен?»), постоянная подпись «Ответы сформированы ИИ по материалам карточки и могут содержать ошибки».
- История только в памяти экрана, в базу не сохраняется. Мягкий дневной лимит на клиенте, понятные сообщения при лимите и недоступности.
- Android — тот же экран.

## Порядок и коммиты

Этап 0 → 1 → 2 → 3 → 4 → 5, коммит после каждого этапа (формат из CLAUDE.md, без упоминания AI-ассистента). Новые unit-тесты не пишем (договорённость по проекту); `VeteranNameMatcher` проверяем вручную на выгрузке имён.

## Проверка

- `xcodegen generate && pod install`, сборка `xcodebuild -workspace OurMemory.xcworkspace -scheme OurMemory -destination 'platform=iOS Simulator,name=iPhone Duo' build`.
- Сканер: только на реальном устройстве (DataScanner в симуляторе не работает) — снимки плит с экрана или распечатки, затем полевой тест на кладбище; QR по-прежнему сразу открывает карточку.
- AI Logic: в симуляторе с debug-токеном App Check; затем на устройстве в Release-сборке с включённым enforce; запрос без App Check должен отклоняться.
- Помощник модератора: прогнать 10–20 реальных заявок, сверить противоречия и расшифровки вручную.
- «Жизненный путь»: черновики для всех подробных биографий, проверить точки на карте.
- Чат: набор «провокационных» вопросов (не по теме, о фактах, которых нет в карточке, просьбы говорить от лица ветерана) — модель должна отказывать или отвечать «в материалах нет»; проверить ответы на русском, белорусском и английском, сообщение при лимите.
