#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern "C" void __fastcall findminmax(char* str, char* min, char* max);

int main() {
	char str[200];
	printf("Enter the string: ");
	gets_s(str, 200);
	char min, max;
	findminmax(str, &min, &max);
	printf("Min char: '%c' = %u\nMax char: '%c' = %u\n", min, (unsigned char)(min), max, (unsigned char)(max));

	system("pause");
	
	return 0;
}