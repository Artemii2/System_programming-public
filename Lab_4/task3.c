#include <stdio.h>

int main() {
    int n;
    
    printf("Введите количество судей: ");
    scanf("%d", &n);
    
    int votes[n];
    int yesCount = 0;

    printf("Введите голоса судей (1 - Да, 0 - Нет):\n");
    for (int i = 0; i < n; i++) {
        scanf("%d", &votes[i]);
        if (votes[i] == 1) {
            yesCount++;
        }
    }

    if (yesCount > n / 2) {
        printf("Окончательное решение: Да\n");
    } else {
        printf("Окончательное решение: Нет\n");
    }

    return 0;
}
