#include <cstdlib>
#include <iostream>
#include <iomanip>

void __fastcall newton_movable_pole(float* eps, float* x, int* iterations);

int main() {
	float eps;
	std::cout << "This program solves equation ln((x-1)/3)/3=0 from point x0 = 1.5" << std::endl;
	std::cout << "Enter epsilon: ";
	std::cin >> eps;

	float x = 1.5;
	int iterations = 0;
	newton_movable_pole(&eps, &x, &iterations);

	std::cout << std::fixed << std::setprecision(8);
	std::cout << "Solution: " << x << std::endl;
	std::cout << "Iterations count: " << iterations << std::endl;

	std::system("pause");
}