🇰🇷 [한국어](README.md) | 🇺🇸 [English](README.en.md) | 🇯🇵 [日本語](README.ja.md) | 🇨🇳 [中文](README.zh.md)

<p align="center">
  <img src="docs/icon.svg" width="128" alt="TuistProjectMaker icon" />
</p>

<h1 align="center">TuistProjectMaker</h1>

<p align="center">
  A macOS GUI wizard that scaffolds Tuist-based iOS projects in a Clean Architecture layout.
</p>

<p align="center">
  <img src="docs/screenshot.png" alt="TuistProjectMaker Screenshot" width="800" />
</p>

## Features

- **Step-by-step project creation wizard**:
  1. Choose a destination folder
  2. Project settings (organization name, Bundle ID, deployment target)
  3. Environment check (`tuist` CLI check & one-click install)
  4. Domain layer setup (Entity / UseCase / Repository Interface)
  5. Data layer setup (Repository Impl / DTO / DataSource)
  6. Presentation layer setup & UI framework choice (SwiftUI / UIKit)
  7. Presentation pattern choice (MVVM / MVVM-C / TCA)
  8. Automatic DI container wiring & reveal in Finder
- Fully localized: Korean, English, Japanese, Simplified Chinese

## Installation

### Homebrew
```bash
brew tap mrKangHo/tap
brew install tuistprojectmaker
```

Or via direct tap:
```bash
brew tap mrkangho/tuistprojectmaker https://github.com/mrKangHo/TuistProjectMaker
brew install --cask tuistprojectmaker
```
