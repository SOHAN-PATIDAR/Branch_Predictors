#ifndef HYBRID_H
#define HYBRID_H

#include "gshare.h"
#include "tage.h"

class HybridPredictor {
public:
    HybridPredictor(int gshareSize, int tageSize, int metaSize);
    bool predict(uint64_t pc);
    void update(uint64_t pc, bool outcome);

private:
    GsharePredictor* gshare;
    Tage* tage;
    int* metaPredictor;
    int metaSize;

    int getMetaPrediction(uint64_t pc);
    void updateMetaPredictor(uint64_t pc, bool gshareCorrect, bool tageCorrect);
};

#endif // HYBRID_H
