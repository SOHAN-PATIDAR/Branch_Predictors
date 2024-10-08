#include "hybrid.h"
#include <cmath>

HybridPredictor::HybridPredictor(int gshareSize, int tageSize, int metaPredictorSize) {
    gshare = new GsharePredictor(196608);
    tage = new Tage();
    this->metaSize = 1024; 
    metaPredictor = new int[metaSize];

    // Initialize meta-predictor to favor g-share initially (0: g-share, 1: TAGE)
    for (int i = 0; i < metaSize; i++) {
        metaPredictor[i] = 0;
    }
}

bool HybridPredictor::predict(uint64_t pc) {
    bool gsharePrediction = gshare->predict(pc);
    bool tagePrediction = tage->predict(pc);

    int metaIndex = getMetaPrediction(pc);
    bool finalPrediction;

    // Use meta-predictor to decide between g-share and TAGE
    if (metaPredictor[metaIndex] == 0) {
        finalPrediction = gsharePrediction;
    } else {
        finalPrediction = tagePrediction;
    }

    return finalPrediction;
}

void HybridPredictor::update(uint64_t pc, bool outcome) {
    bool gsharePrediction = gshare->predict(pc);
    bool tagePrediction = tage->predict(pc);

    // Update g-share and TAGE predictors
    gshare->update(pc, outcome);
    tage->update(pc, outcome);

    // Update the meta-predictor
    updateMetaPredictor(pc, gsharePrediction == outcome, tagePrediction == outcome);
}

int HybridPredictor::getMetaPrediction(uint64_t pc) {
    // Get index for the meta predictor based on PC
    return pc % metaSize;
}

void HybridPredictor::updateMetaPredictor(uint64_t pc, bool gshareCorrect, bool tageCorrect) {
    int metaIndex = getMetaPrediction(pc);

    if (gshareCorrect && !tageCorrect) {
        if (metaPredictor[metaIndex] > 0) {
            metaPredictor[metaIndex]--;
        }
    } else if (!gshareCorrect && tageCorrect) {
        if (metaPredictor[metaIndex] < 1) {
            metaPredictor[metaIndex]++;
        }
    }
}
