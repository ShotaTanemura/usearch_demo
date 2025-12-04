#include <iostream>
#include <vector>
#include <usearch/index_dense.hpp>

using namespace unum::usearch;

int main() {
    // 1. メトリック（距離計算定義）の作成
    // ここで次元数(dim)と計算方法(cos_k)を指定します
    size_t dim = 3;
    metric_punned_t metric(dim, metric_kind_t::cos_k);

    // 2. 設定（Config）の作成
    // デフォルト設定を使用します（必要に応じて接続数などを変更可能）
    index_dense_config_t config;

    // 3. インデックスの初期化
    // make(metric, config) の順で渡します
    index_dense_t index = index_dense_t::make(metric, config);

    // 4. データの準備
    std::vector<float> vec1 = {1.0, 0.0, 0.0};
    std::vector<float> vec2 = {0.0, 1.0, 0.0};
    std::vector<float> vec3 = {0.0, 0.0, 1.0};

    // 容量予約
    index.reserve(3);

    // 5. データの追加
    // metricで次元数が定義されているため、addには「ID」と「データのポインタ」のみを渡します
    index.add(1, vec1.data());
    index.add(2, vec2.data());
    index.add(3, vec3.data());

    std::cout << "3 vectors added." << std::endl;

    // 6. 保存
    index.save("my_vectors.usearch");
    std::cout << "Index saved to 'my_vectors.usearch'." << std::endl;

    return 0;
}
