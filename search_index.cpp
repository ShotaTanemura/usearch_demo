#include <iostream>
#include <vector>
#include <thread>
#include <usearch/index_dense.hpp>

using namespace unum::usearch;

int main() {
    // 1. 基本定義
    size_t dim = 3;
    metric_punned_t metric(dim, metric_kind_t::cos_k);
    index_dense_config_t config;

    // インデックスの枠を作成
    index_dense_t index = index_dense_t::make(metric, config);

    // 2. ファイルをビューとして開く
    std::cout << "Loading index..." << std::endl;
    index.view("my_vectors.usearch");

    // スレッドリソースの確保
    // 検索を行う前に、使用するスレッド数(members)をlimitsで設定し、reserveで適用します。
    index_limits_t limits;
    limits.members = std::thread::hardware_concurrency(); // CPUコア数を使用
    if (limits.members == 0) limits.members = 1;          // 安全策
    
    // reserve() はメモリ確保だけでなく、スレッドコンテキストの初期化も行います
    index.reserve(limits);

    if (index.size() == 0) {
        std::cerr << "Error: Index is empty or failed to load." << std::endl;
        return 1;
    }
    std::cout << "Loaded " << index.size() << " vectors. (Threads: " << limits.members << ")" << std::endl;

    // 3. クエリ
    std::vector<float> query = {0.9, 0.1, 0.0};
    size_t k = 2;

    std::cout << "Searching for vector close to ID:1..." << std::endl;

    // 4. 検索
    std::vector<uint64_t> keys(k);
    std::vector<float> distances(k);

    size_t found = index.search(query.data(), k).dump_to(keys.data(), distances.data());

    // 5. 結果表示
    for (size_t i = 0; i < found; ++i) {
        std::cout << "Rank " << i + 1 
                  << ": ID = " << keys[i] 
                  << " (Distance: " << distances[i] << ")" << std::endl;
    }

    return 0;
}
