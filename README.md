# flutter_book

Flutter project(仿小说阅读 + 音乐播放, study used).

## Getting Started

This project is a Flutter application.


desktop : flutter run -d macos

flutter_web : flutter run -d chrome

切换到 CanvasKit 渲染 ：flutter run -d chrome --release --dart-define=FLUTTER_WEB_USE_SKIA=true

node.js 项目生成:
    mkdir node
    mkdir server
    cd node/server
    npm install express-generator -g
    express --view=pug myapp
    cd myapp
    npm i
    npm start
    // 浏览地址 http://localhost:3000

node.js 项目启动:
    cd node/server/myapp
    npm i
    npm start



- [about flutter_web for node.js start](https://www.jianshu.com/p/cc1dcf3f5063)       


A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
