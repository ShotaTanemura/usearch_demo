# USearch Demo

このプロジェクトは、[USearch](https://github.com/unum-cloud/usearch)ライブラリを使用したベクトル検索のデモプログラムです。

## 概要

USearchは、高次元ベクトルの類似度検索とクラスタリングを行うための高速なC++ライブラリです。このデモでは、以下の2つのプログラムを提供しています：

- **create_index**: ベクトルインデックスを作成し、ファイルに保存します
- **search_index**: 保存されたインデックスから類似ベクトルを検索します

## 必要な環境

- **C++11対応のコンパイラ** (g++ または clang++)
- **Git** (USearchリポジトリのクローンに使用)
- **Make** (ビルドシステム)
- **pthread** (スレッドライブラリ)

### macOS の場合

追加で以下のフレームワークが必要です：
- CoreFoundation
- Security

これらは通常、macOSに標準で含まれています。

## ビルド方法

### 初回ビルド

```bash
make
```

初回実行時、USearchリポジトリが自動的にクローンされます。

### 明示的にUSearchをクローンする場合

```bash
make clone-usearch
```

### 個別にビルドする場合

```bash
# create_indexのみビルド
make create_index

# search_indexのみビルド
make search_index
```

## 実行方法

### 1. インデックスの作成

```bash
./create_index
```

このプログラムは以下の処理を行います：
- 3次元ベクトル空間でコサイン類似度を使用するメトリックを作成
- 3つのベクトル `(1,0,0)`, `(0,1,0)`, `(0,0,1)` をインデックスに追加
- インデックスを `my_vectors.usearch` ファイルに保存

### 2. ベクトル検索

```bash
./search_index
```

このプログラムは以下の処理を行います：
- `my_vectors.usearch` ファイルからインデックスを読み込み
- クエリベクトル `(0.9, 0.1, 0.0)` に最も近い2つのベクトルを検索
- 検索結果（IDと距離）を表示

## コードの説明

### create_index.cpp

ベクトルインデックスを作成するプログラムです。

- **メトリック**: コサイン類似度 (`metric_kind_t::cos_k`)
- **次元数**: 3次元
- **追加するベクトル**: 
  - ID=1: `(1.0, 0.0, 0.0)`
  - ID=2: `(0.0, 1.0, 0.0)`
  - ID=3: `(0.0, 0.0, 1.0)`

### search_index.cpp

保存されたインデックスから類似ベクトルを検索するプログラムです。

- **クエリベクトル**: `(0.9, 0.1, 0.0)`
- **検索数**: 上位2件 (`k=2`)
- **並列処理**: CPUコア数に応じたスレッドを使用

## クリーンアップ

### ビルド成果物のみ削除

```bash
make clean
```

以下のファイルが削除されます：
- `*.o` (オブジェクトファイル)
- `create_index`, `search_index` (実行ファイル)

### すべてを削除（USearchディレクトリを含む）

```bash
make clean-all
```

`make clean`に加えて、`usearch/`ディレクトリも削除されます。

## プロジェクト構造

```
usearch_demo/
├── create_index.cpp      # インデックス作成プログラム
├── search_index.cpp      # ベクトル検索プログラム
├── Makefile              # ビルド設定
├── README.md             # このファイル
├── .gitignore            # Git除外設定
└── usearch/              # USearchライブラリ（自動クローン）
    └── include/
        └── usearch/
            └── index_dense.hpp
```

## 技術的な詳細

### コンパイラフラグ

- **C++標準**: C++11 (`-std=c++11`)
- **最適化**: `-O2`
- **警告**: `-Wall -Wextra`

### ライブラリ

- **スレッド**: `-pthread`
- **macOS**: `-framework CoreFoundation -framework Security`

### USearchの特徴

- **ヘッダーのみライブラリ**: リンク不要で使用可能
- **型消去**: `metric_punned_t`による柔軟なメトリック選択
- **並列検索**: マルチスレッド対応
- **メモリ効率**: `view()`による読み込み専用アクセス

## 参考リンク

- [USearch公式リポジトリ](https://github.com/unum-cloud/usearch)
- [USearch C++ドキュメント](https://unum-cloud.github.io/usearch/cpp)

## ライセンス

このデモプロジェクトは、USearchライブラリの使用例として提供されています。
USearchのライセンスについては、[公式リポジトリ](https://github.com/unum-cloud/usearch)を参照してください。

