#ifndef GSHARE_H
#define GSHARE_H

#include <cstdint>
#include <vector>

class GsharePredictor {
public:
    GsharePredictor(int size);
    bool predict(uint64_t pc);
    void update(uint64_t pc, bool outcome);

private:
struct TableEntry {
        int state; // State for prediction (00, 01, 10, 11)
        // You might want to add more fields as per your design
    };

    std::vector<TableEntry> table;
    int indexMask;
    int history;
    int historyMask;
    void initializeTable(int size);
    int getIndex(uint64_t pc);
};

#endif // GSHARE_H
