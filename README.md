🇰🇷 [한국어](README.md) | 🇺🇸 [English](README.en.md) | 🇯🇵 [日本語](README.ja.md) | 🇨🇳 [中文](README.zh.md)

<p align="center">
  <img src="docs/icon.svg" width="128" alt="TuistProjectMaker icon" />
</p>

<h1 align="center">TuistProjectMaker</h1>

<p align="center">
  Tuist 기반 iOS 프로젝트를 Clean Architecture 구조로 자동 구성해주는 macOS GUI 마법사 도구입니다.
</p>

<p align="center">
  <img src="docs/screenshot.png" alt="TuistProjectMaker Screenshot" width="800" />
</p>

## 주요 기능

- **단계별 프로젝트 생성 마법사**:
  1. 프로젝트 생성 위치 선택
  2. 프로젝트 이름 및 Bundle Identifier 설정
  3. 최소 iOS 배포 타깃 및 Tuist CLI 환경 자동 점검
  4. Domain 계층 구성 (Entity / UseCase / Repository 인터페이스)
  5. Data 계층 구성 (Repository 구현체 / DTO / DataSource)
  6. Presentation 계층 구성 및 UI 프레임워크(SwiftUI / UIKit) 선택
  7. 아키텍처 패턴 선택 (MVVM / MVVM-C / TCA)
  8. 레이어 간 생성자 주입 및 `DIContainer` 자동 조립 및 Finder 열기
- 다국어 인터페이스 지원 (한국어, 영어, 일본어, 중국어 간체)

## 설치 (Installation)

### Homebrew
```bash
brew tap mrKangHo/tap
brew install tuistprojectmaker
```

또는 전용 Cask 직접 설치:
```bash
brew tap mrkangho/tuistprojectmaker https://github.com/mrKangHo/TuistProjectMaker
brew install --cask tuistprojectmaker
```

## 직접 빌드 및 실행

```bash
cd TuistProjectMaker
swift run
```
