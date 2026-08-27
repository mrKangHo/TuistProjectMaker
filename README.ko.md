# TuistProjectMaker

[English](README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-Hans.md)

Tuist 기반 iOS 프로젝트를 Clean Architecture 구조로 구성해주는 macOS GUI 도구.

## 구성

`TuistProjectMaker/` — SwiftUI로 만든 macOS 앱 (Swift Package).

단계별 마법사로 프로젝트를 생성한다:

1. 생성 위치 선택
2. 프로젝트 이름 입력
3. 프로젝트 설정 (조직 이름, Bundle ID 프리픽스, 최소 배포 타깃)
4. 환경 체크 (`tuist` CLI 설치 여부, 미설치 시 원클릭 설치)
5. Domain 구성 (Entity / UseCase / Repository Interface, 이름으로 추가·삭제)
6. Data 구성 (Repository 구현체 / DTO / DataSource, 이름으로 추가·삭제)
7. Presentation 구성 (화면, 이름으로 추가·삭제)
8. UI 프레임워크 선택 (SwiftUI / UIKit)
9. Presentation 패턴 선택 (MVVM / MVVM-C / TCA — TCA는 SwiftUI에서만 제공)
10. 요약 확인 후 완료 버튼으로 프로젝트 생성 + Finder에서 열기

레이어끼리 이름이 같은 요소(예: `User` DataSource와 `User` RepositoryImpl)는 생성자 주입으로 자동 연결되며, 생성된 `DIContainer`에 조립된다.

앱 UI는 영어/한국어/일본어/중국어(간체)를 지원하며 시스템 언어를 따라간다.

## 설치

```sh
brew tap mrkangho/tuistprojectmaker
brew install --cask tuistprojectmaker
```

미서명/미공증 앱이라 설치 시 Cask가 quarantine 속성을 자동으로 제거해서 Gatekeeper 경고 없이 실행된다.

## 개발

```sh
cd TuistProjectMaker
swift run
```

더블클릭으로 실행되는 `.app` 번들로 패키징하려면:

```sh
cd TuistProjectMaker
./package_app.sh
open .build/TuistProjectMaker.app
```
