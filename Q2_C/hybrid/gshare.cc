#include <algorithm>
#include <array>
#include <bitset>
#include <map>
#include "gshare.h"
#include "msl/fwcounter.h"
#include "ooo_cpu.h"
#define HISTORY_BITS 10
namespace
{
constexpr std::size_t GLOBAL_HISTORY_LENGTH = 14;
constexpr std::size_t COUNTER_BITS = 2;
constexpr std::size_t GS_HISTORY_TABLE_SIZE = 196608;

std::map<O3_CPU*, std::bitset<GLOBAL_HISTORY_LENGTH>> branch_history_vector;
std::map<O3_CPU*, std::array<champsim::msl::fwcounter<COUNTER_BITS>, GS_HISTORY_TABLE_SIZE>> gs_history_table;

std::size_t gs_table_hash(uint64_t ip, std::bitset<GLOBAL_HISTORY_LENGTH> bh_vector)
{
  std::size_t hash = bh_vector.to_ullong();
  hash ^= ip;
  hash ^= ip >> GLOBAL_HISTORY_LENGTH;
  hash ^= ip >> (GLOBAL_HISTORY_LENGTH * 2);

  return hash % GS_HISTORY_TABLE_SIZE;
}
} // namespace

GsharePredictor::GsharePredictor(int size) : indexMask(size - 1), history(0) {
    table.resize(size);
    historyMask = (1 << HISTORY_BITS) - 1;
    // Initialize table entries if necessary
    for (auto &entry : table) {
        entry.state = 0; // Initialize state if needed
    }
}
void O3_CPU::initialize_branch_predictor() {}

uint8_t O3_CPU::predict_branch(uint64_t ip)
{
  auto gs_hash = ::gs_table_hash(ip, ::branch_history_vector[this]);
  auto value = ::gs_history_table[this][gs_hash];
  return value.value() >= (value.maximum / 2);
}

void O3_CPU::last_branch_result(uint64_t ip, uint64_t branch_target, uint8_t taken, uint8_t branch_type)
{
  auto gs_hash = gs_table_hash(ip, ::branch_history_vector[this]);
  ::gs_history_table[this][gs_hash] += taken ? 1 : -1;

  // update branch history vector
  ::branch_history_vector[this] <<= 1;
  ::branch_history_vector[this][0] = taken;
}
bool GsharePredictor::predict(uint64_t pc) {
    int index = getIndex(pc);
    return (table[index].state >= 2); // Check the state
}

void GsharePredictor::update(uint64_t pc, bool outcome) {
    int index = getIndex(pc);
    // Update the state based on the outcome
    if (outcome) {
        if (table[index].state < 3) {
            table[index].state++; // Increment state if taken
        }
    } else {
        if (table[index].state > 0) {
            table[index].state--; // Decrement state if not taken
        }
    }
}

int GsharePredictor::getIndex(uint64_t pc) {
    return (pc ^ history) & indexMask; // Example indexing logic
}
