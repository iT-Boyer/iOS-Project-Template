
#import "UIKit+App.h"

void limitedDouble(double *value, double min, double max) {
    if (*value < min) {
        *value = min;
    }
    if (*value > max) {
        *value = max;
    }
}

void limitedOffsetChange(double *source, double target, double limitation) {
    if (fabs(*source - target) > limitation) {
        if (*source > target) {
            *source -= limitation;
        }
        else {
            *source += limitation;
        }
    }
    else {
        *source = target;
    }
}
