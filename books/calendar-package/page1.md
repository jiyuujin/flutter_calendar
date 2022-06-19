---
title: "はじめに"
---

# ご挨拶

<!-- chooyan-eng -->

## ちゅーやん

フリーランスで Flutter アプリ開発をしているちゅーやん ([@chooyan](https://zenn.dev/chooyan)) です。

普段はさまざまなクライアントからの依頼によるアプリ開発をメインに働いているかたわらで、個人では [crop_your_image](https://pub.dev/packages/crop_your_image) などのパッケージ開発と公開をおこなっています。

このハンズオンでは、そのパッケージ開発から得られた知見や楽しさをみなさんにも共有すべく、シンプルで身近なプログラムを題材にパッケージ開発の流れを紹介できればと思います。

<!-- jiyuujin -->

## jiyuujin

こんにちは。現在 [React](https://ja.reactjs.org/) / [Express](https://github.com/expressjs/express) / [WebSocket](https://github.com/websockets/ws) から構成されている Web サービスの機能開発に、ウェブフロントエンド開発やアクセシビリティの啓蒙を中心に進める jiyuujin ([@jiyuujin](https://zenn.dev/jiyuujin)) と申します。

https://yuma-kitamura.nekohack.me/

## Flutter でカレンダーアプリを作る

今回は [Flutter](https://flutter.dev/) 上で、指定した月のカレンダーが表示されるアプリを製作します。

|#|iOS|
|:---|:---|
|Screenshot|![](https://i.imgur.com/iqYDqQ7.png)|

ただし、そこで利用する「1 ヶ月のカレンダーデータを生成するロジック」や「1 ヶ月のカレンダーの UI を表す Widget」についてはアプリのソースコードに含めるのではなく、それぞれ「パッケージ」という形で他の用途やアプリでも再利用できるように開発します。

Dart のロジックのみを提供するパッケージ、Flutter の Widget を提供するパッケージの開発を通して、世界中の Dart / Flutter 開発者が利用可能なプログラムを書く楽しさを体験してみましょう。

---

なお、Dart や Flutter の詳しい取り扱い方についてはこのハンズオンでは詳しく取り上げないことにご注意ください。

Flutter は公式ドキュメントがとても丁寧に整備された技術です。この本を通じて Flutter やそれを取り巻く開発システムの全体像を掴むことができたなら、公式ドキュメントや API リファレンスもぜひ一度読み通してみることを強くオススメします。
