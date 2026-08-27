# TuistProjectMaker

[English](README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-Hans.md)

一个 macOS GUI 工具，用于按 Clean Architecture 结构搭建基于 Tuist 的 iOS 项目。

## 结构

`TuistProjectMaker/` — 使用 SwiftUI 构建的 macOS 应用（Swift Package）。

通过分步向导创建项目：

1. 选择创建位置
2. 输入项目名称
3. 项目设置（组织名称、Bundle ID 前缀、最低部署目标）
4. 环境检查（是否安装 `tuist` CLI，未安装可一键安装）
5. Domain 配置（Entity / UseCase / Repository Interface，按名称添加、删除）
6. Data 配置（Repository 实现 / DTO / DataSource，按名称添加、删除）
7. Presentation 配置（界面，按名称添加、删除）
8. 选择 UI 框架（SwiftUI / UIKit）
9. 选择 Presentation 模式（MVVM / MVVM-C / TCA — TCA 仅限 SwiftUI）
10. 摘要页面，点击完成即可生成项目并在 Finder 中显示

各层中同名的元素（例如 `User` DataSource 与 `User` RepositoryImpl）会通过构造函数注入自动连接，并组装进生成的 `DIContainer` 中。

应用界面支持英语、韩语、日语、简体中文，跟随系统语言自动切换。

## 运行

```sh
cd TuistProjectMaker
swift run
```

打包为可双击运行的 `.app`：

```sh
cd TuistProjectMaker
./package_app.sh
open .build/TuistProjectMaker.app
```
