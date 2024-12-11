# flutter_playground

**Pure dart playground, Completely useless, Just 4 fun.**

这是一个用于学习谷歌跨平台框架 Flutter 的仓库，使用开放api，真·仅学习使用。

## 功能演示

### iTunes 播客
实现了播客的搜索、详情展示和音频播放功能。
- 搜索功能：用户可以通过关键词搜索播客。
- 详情展示：展示播客的详细信息，包括标题、描述、封面图等。
- 音频播放：集成了音频播放功能，用户可以播放和暂停播客音频。

![播客](https://raw.githubusercontent.com/Dtheme/flutter_playground/main/picture/20241209183211.gif)

### 开眼每日精选视频
支持视频的展示和播放。
- 视频列表：展示视频的封面、标题和描述。
- 视频播放：用户可以点击视频项进入播放页面，支持播放控制。

![开眼每日精选](https://raw.githubusercontent.com/Dtheme/flutter_playground/main/picture/20241211102557.gif)

### 艺术作品展示
展示艺术作品的列表和详情。
- 艺术作品列表：展示艺术作品的缩略图和基本信息。
- 详情页面：展示艺术作品的详细信息和大图。

![图文列表](https://raw.githubusercontent.com/Dtheme/flutter_playground/main/picture/art_demo.gif)


### IM 聊天界面
实现了一个即时通讯界面。
- 多种消息类型：支持文本、图片、语音、视频等多种消息类型。
- 消息交互：支持消息的发送、撤回、长按菜单等功能。
- 语音消息：支持录音、播放，带有频谱动画效果。
- 图片消息：支持图片预览、保存到相册等功能。
- 视频消息：支持视频预览和播放。
- 消息状态：显示消息的发送状态、撤回状态等。
- 用户头像：展示用户头像和昵称。

![IM聊天](https://raw.githubusercontent.com/Dtheme/flutter_playground/main/picture/20241209183010.gif)

### 基本动画演示
展示了 Flutter 动画基础类型。
- 隐式动画：使用 AnimatedContainer、AnimatedOpacity 等实现简单过渡。
- 显式动画：使用 AnimationController 实现复杂的自定义动画。
- Hero 动画：实现图片查看的平滑过渡效果。
- 交错动画：实现消息列表加载的波浪动画效果。
- 物理动画：使用 SpringSimulation 实现有弹性的滑动效果。
- 自定义动画：包括语音录制的波形动画、加载状态动画等。

![基础动画](https://raw.githubusercontent.com/Dtheme/flutter_playground/main/picture/20241209183106.gif)


### 原生交互演示
展示了 Flutter 与原生平台的交互能力。
- 方法通道：通过 MethodChannel 实现 Flutter 调用原生代码。
- 事件通道：通过 EventChannel 实现原生向 Flutter 发送事件流。
- 消息通道：通过 BasicMessageChannel 实现双向通信。
- 平台视图：在 Flutter 中嵌入原生视图组件。
- 生命周期：Flutter 页面与原生页面生命周期联动。
- 数据共享：Flutter 与原生之间的数据传递和状态同步。


## 使用的技术

- **原生开发**
  - **Android 原生**
    - Activity 和 Fragment 的生命周期管理
    - FlutterActivity 和 FlutterFragment 的使用
    - 自定义 FlutterEngine 配置
    - PlatformView 的实现
  - **iOS 原生**
    - UIViewController 的生命周期管理
    - FlutterViewController 的使用
    - FlutterEngine 的配置和优化
    - 原生视图的封装和集成
  - **平台通道**
    - MethodChannel：用于方法调用
    - EventChannel：用于事件流传递
    - BasicMessageChannel：用于通用消息传递
    - PlatformView：用于原生视图嵌入

- **Flutter/Dart**：跨平台页面。
- **网络请求**：使用 `http` 和 `dio` 库进行网络请求和数据获取。
- **状态管理**：使用 `StatefulWidget` 和 `setState` 进行简单的状态管理。
- **get 框架**：用于状态管理、路由管理等。
- **多媒体处理**：集成 `just_audio` 和 `video_player` 库，实现音频和视频的播放功能。
- **UI 组件**：使用 `ListView`、`Card`、`ExpansionTile` 等组件构建响应式 UI。
- **图片处理**：使用 `photo_manager` 进行图片保存和相册管理。
- **音频处理**：集成录音和音频播放功能，支持频谱动画显示。
- **动画系统**：使用 Flutter 的动画系统实现丰富的交互效果。
  - AnimationController：控制动画的播放和状态。
  - CurvedAnimation：实现非线性的动画曲线。
  - Tween：定义动画的起始值和结束值。
  - CustomPainter：绘制自定义动画效果。

## 代码结构

- `lib/Pages/VideoPage/`：包含视频和播客相关的页面和组件。
- `lib/Pages/ComplexListPage/`：包含 IM 聊天界面相关的页面和组件。
- `lib/Network/`：包含网络请求的封装和 API 管理。
- `lib/UIKit/`：包含自定义的 UI 组件。
- `lib/Util/`：包含工具类和辅助功能。
- `lib/Animation/`：包含各类动画示例和自定义动画组件。
- `android/app/src/`：Android 原生代码和平台集成。
- `ios/Runner/`：iOS 原生代码和平台集成。
- `lib/Platform/`：Flutter 侧的平台通道实现。

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

