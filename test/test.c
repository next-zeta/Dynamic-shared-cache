#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define NUM_TEST_CASES 1000 // 测试用例数量
#define MIN_ONES 5          // 连续 1 的最小次数
#define NUM_FILES 16        // 生成 16 个文件

int main() {
    srand(time(NULL)); // 初始化随机种子

    for (int file_idx = 0; file_idx < NUM_FILES; file_idx++) {
        // 构造文件名
        char filename[32];
        snprintf(filename, sizeof(filename), "test_sequence_%d.txt", file_idx);

        // 打开文件
        FILE *fp = fopen(filename, "w");
        if (!fp) {
            printf("Error opening %s!\n", filename);
            return 1;
        }

        // 生成单比特序列
        int is_one = 0; // 当前状态：0 或 1
        int ones_left = 0; // 剩余连续 1 的计数

        for (int i = 0; i < NUM_TEST_CASES; i++) {
            if (is_one) {
                fprintf(fp, "1\n");
                ones_left--;
                if (ones_left <= 0) {
                    is_one = 0;
                }
            } else {
                fprintf(fp, "0\n");
                if (rand() % 2 == 0) { // 50% 概率切换到 1
                    is_one = 1;
                    ones_left = MIN_ONES + (rand() % 5); // 5 到 9 次
                }
            }
        }

        fclose(fp);
        printf("Generated %s\n", filename);
    }

    printf("All %d test sequence files generated.\n", NUM_FILES);
    return 0;
}