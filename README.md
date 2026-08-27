# TuistProjectMaker

[English](README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-Hans.md)

A macOS GUI tool that scaffolds Tuist-based iOS projects in a Clean Architecture layout.

## Structure

`TuistProjectMaker/` — a macOS app built with SwiftUI (Swift Package).

A step-by-step wizard walks through project creation:

1. Choose a destination folder
2. Enter the project name
3. Project settings (organization name, Bundle ID prefix, minimum iOS deployment target)
4. Environment check (`tuist` CLI installed or not, with one-click install)
5. Domain layer setup (Entity / UseCase / Repository Interface, add/remove by name)
6. Data layer setup (Repository Impl / DTO / DataSource, add/remove by name)
7. Presentation layer setup (Screens, add/remove by name)
8. UI framework choice (SwiftUI / UIKit)
9. Presentation pattern choice (MVVM / MVVM-C / TCA — TCA is SwiftUI-only)
10. Summary — press Finish to generate the project and reveal it in Finder

Elements with matching names across layers (e.g. a `User` DataSource and a `User` RepositoryImpl) are wired together automatically via constructor injection, composed in a generated `DIContainer`.

The app UI is localized into English, Korean, Japanese, and Simplified Chinese, following the system language.

## Running

```sh
cd TuistProjectMaker
swift run
```

To package as a double-clickable `.app` bundle:

```sh
cd TuistProjectMaker
./package_app.sh
open .build/TuistProjectMaker.app
```
