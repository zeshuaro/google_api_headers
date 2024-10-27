# Google API Headers

[![pub package](https://img.shields.io/pub/v/google_api_headers.svg)](https://pub.dartlang.org/packages/google_api_headers)
[![docs](https://img.shields.io/badge/docs-latest-blue.svg)](https://pub.dev/documentation/google_api_headers/latest/)
[![MIT License](https://img.shields.io/github/license/zeshuaro/google_api_headers.svg)](https://github.com/zeshuaro/google_api_headers/blob/main/LICENSE)
[![GitHub Actions](https://github.com/zeshuaro/google_api_headers/actions/workflows/github-actions.yml/badge.svg)](https://github.com/zeshuaro/google_api_headers/actions/workflows/github-actions.yml)
[![codecov](https://codecov.io/gh/zeshuaro/google_api_headers/branch/main/graph/badge.svg?token=4IVF5MBLTS)](https://codecov.io/gh/zeshuaro/google_api_headers)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/eb770d6b694640f597e8c0de21117d19)](https://app.codacy.com/gh/zeshuaro/google_api_headers/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)
[![style: flutter_lints](https://img.shields.io/badge/style-flutter__lints-4BC0F5.svg)](https://pub.dev/packages/flutter_lints)

[![Github-sponsors](https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/zeshuaro)
[![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/zeshuaro)
[![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/zeshuaro)
[![LiberaPay](https://img.shields.io/badge/Liberapay-F6C915?style=for-the-badge&logo=liberapay&logoColor=black)](https://liberapay.com/zeshuaro/)
[![Patreon](https://img.shields.io/badge/Patreon-F96854?style=for-the-badge&logo=patreon&logoColor=white)](https://patreon.com/zeshuaro)
[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/JoshuaTang)

A Flutter plugin for getting the headers required to call Google APIs with an [app restricted API key](https://developers.google.com/maps/api-security-best-practices#restricting-api-keys).

## Getting Started

Add this to your project's `pubspec.yaml` file:

```yml
dependencies:
  google_api_headers: ^4.2.5
```

## Usage

Depending on the platform (iOS or Android), the function will return the required key and value pairs for calling Google APIs with keys that are restricted to an iOS or Android app.

```dart
import 'package:google_api_headers/google_api_headers.dart';

final headers = await GoogleApiHeaders().getHeaders();
```
