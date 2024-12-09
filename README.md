# flutter_playground

**Pure dart playground, Completely useless, Just 4 fun.**

这是一个用于学习谷歌跨平台框架 Flutter 的仓库，使用开放api，真·仅学习使用。

## 模块

- **iTunes 播客**：实现了播客的搜索、详情展示和音频播放功能。
  - 搜索功能：用户可以通过关键词搜索播客。
  - 详情展示：展示播客的详细信息，包括标题、描述、封面图等。
  - 音频播放：集成了音频播放功能，用户可以播放和暂停播客音频。

- **开眼每日精选视频**：支持视频的展示和播放。
  - 视频列表：展示视频的封面、标题和描述。
  - 视频播放：用户可以点击视频项进入播放页面，支持播放控制。

- **艺术作品展示**：展示艺术作品的列表和详情。
  - 艺术作品列表：展示艺术作品的缩略图和基本信息。
  - 详情页面：展示艺术作品的详细信息和大图。

## 使用的技术

- **Java**：安卓原生页面
- **Objective-C/swift**：iOS原生原生页面
- **Flutter/Dart**：跨平台页面。
- **网络请求**：使用 `http` 和 `dio` 库进行网络请求和数据获取。
- **状态管理**：使用 `StatefulWidget` 和 `setState` 进行简单的状态管理。
- **get 框架**：用于状态管理、路由管理等。
- **多媒体处理**：集成 `just_audio` 和 `video_player` 库，实现音频和视频的播放功能。
- **UI 组件**：使用 `ListView`、`Card`、`ExpansionTile` 等组件构建响应式 UI。

## 代码结构

- `lib/Pages/VideoPage/`：包含视频和播客相关的页面和组件。
- `lib/Network/`：包含网络请求的封装和 API 管理。
- `lib/UIKit/`：包含自定义的 UI 组件。
- `lib/Util/`：包含工具类和辅助功能。

## 如何运行

1. 确保已安装 Flutter SDK 和 Dart 环境。
2. 克隆本仓库到本地。
3. 在项目根目录下运行 `flutter pub get` 安装依赖。
4. 使用 `flutter run` 启动应用。

## 👏🏻

感谢以下 API 提供者：

- **iTunes podcast API**：用于播客数据的获取。
- **开眼视频每日精选 API**：用于视频内容的展示。
- **艺术作品 API**：用于获取艺术作品的详细信息：https://www.wanandroid.com/

