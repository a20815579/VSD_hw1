#include <stdint.h>
extern const uint32_t div1, div2;
extern uint32_t _test_start;
uint32_t remain(uint32_t dividant, uint32_t divider) {
    while (dividant >= divider) {
        dividant -= divider;
    }
    return dividant;
}
int main() {
    uint32_t num1 = div1, num2 = div2;
    while (num1 != 0 && num2 != 0) {
        if (num1 > num2) {
            num1 = remain(num1, num2);
        }
        else {
            num2 = remain(num2, num1);
        }
    }
    *(&_test_start) = (num2 == 0) ? num1 : num2;
    return 0;
}