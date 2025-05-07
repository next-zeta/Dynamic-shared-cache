#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define NUM_TEST_CASES 1000 // ������������
#define MIN_ONES 5          // ���� 1 ����С����
#define NUM_FILES 16        // ���� 16 ���ļ�

int main() {
    srand(time(NULL)); // ��ʼ���������

    for (int file_idx = 0; file_idx < NUM_FILES; file_idx++) {
        // �����ļ���
        char filename[32];
        snprintf(filename, sizeof(filename), "test_sequence_%d.txt", file_idx);

        // ���ļ�
        FILE *fp = fopen(filename, "w");
        if (!fp) {
            printf("Error opening %s!\n", filename);
            return 1;
        }

        // ���ɵ���������
        int is_one = 0; // ��ǰ״̬��0 �� 1
        int ones_left = 0; // ʣ������ 1 �ļ���

        for (int i = 0; i < NUM_TEST_CASES; i++) {
            if (is_one) {
                fprintf(fp, "1\n");
                ones_left--;
                if (ones_left <= 0) {
                    is_one = 0;
                }
            } else {
                fprintf(fp, "0\n");
                if (rand() % 2 == 0) { // 50% �����л��� 1
                    is_one = 1;
                    ones_left = MIN_ONES + (rand() % 5); // 5 �� 9 ��
                }
            }
        }

        fclose(fp);
        printf("Generated %s\n", filename);
    }

    printf("All %d test sequence files generated.\n", NUM_FILES);
    return 0;
}