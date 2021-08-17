# Google API Headers

A Flutter plugin for getting the headers required for calling Google APIs with an app restricted key.

[![pub package](https://img.shields.io/pub/v/google_api_headers.svg)](https://pub.dartlang.org/packages/google_api_headers)
[![docs](https://img.shields.io/badge/docs-latest-blue.svg)](https://pub.dev/documentation/google_api_headers/latest/)
[![MIT License](https://img.shields.io/github/license/zeshuaro/google_api_headers.svg)](https://github.com/zeshuaro/google_api_headers/blob/main/LICENSE)
[![Build and Deploy](https://github.com/zeshuaro/google_api_headers/workflows/GitHub%20Actions/badge.svg)](https://github.com/zeshuaro/google_api_headers/actions?query=workflow%3A%22GitHub+Actions%22)
[![codecov](https://codecov.io/gh/zeshuaro/google_api_headers/branch/main/graph/badge.svg?token=4IVF5MBLTS)](https://codecov.io/gh/zeshuaro/google_api_headers)
[![style: lint](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)

## Getting Started

Add this to your project's `pubspec.yaml` file:

```yml
dependencies:
  google_api_headers: ^1.1.1
```

## Usage

Depending on the platform (iOS or Android), the function will return the required key and value pairs for calling Google APIs with keys that are restricted to an iOS or Android app.

```dart
import 'package:google_api_headers/google_api_headers.dart';

final headers = await GoogleApiHeaders().getHeaders();
```
