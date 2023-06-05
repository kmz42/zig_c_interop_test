#include "libtest.h"

extern int zig_count_one(int a);
extern int zig_count_two(struct CCount *s);

int c_count_one(int a) {
    if (a <= 0) {
        return 0;
    }
    return 1 + zig_count_one(a-1);
}

int c_count_two(struct CCount *s) {
    if (s->x <= 0) {
        return 0;
    }
    s->x = s->x - 1;
    return 1 + zig_count_two(s);
}

int c_start_counting(int a) {
    struct CCount s;
    s.x = a;
    return c_count_two(&s);
}