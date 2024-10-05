#include <stdio.h>

int main() {
    int n;
    int count = 0;

    // Ввод числа n
    printf("Введите число n: ");
    scanf("%d", &n);

    for (int i = 1; i <= n; i++) {
        if (i % 5 != 0 && i % 11 != 0) {
            count++; 
        }
    }

    printf("Количество целых чисел между 1 и %d, которые не делятся на 5 или 11: %d\n", n, count);

    return 0;
}
