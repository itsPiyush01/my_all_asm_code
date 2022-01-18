#include <stdio.h>
int main() {
   // printf() displays the string inside quotation
    printf("Enter first number:");
    int num1,num2;
    scanf("%d", &num1);

    printf("Enter second number:");
    scanf("%d",&num2);

    int sum=num1+num2;
    printf("Sum is %d:",sum);
   return 0;

}
