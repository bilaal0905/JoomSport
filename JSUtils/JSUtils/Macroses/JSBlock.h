// Created for BearDev by drif
// drif@mail.ru

typedef void (^JSEventBlock)();

#define JSBlock(block, ...) if (block) block(__VA_ARGS__)
