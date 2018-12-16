#include <cstdlib>
#include <iostream>
#include <iomanip>
#include <string>

extern "C" void __fastcall delete_extra_spaces(const char* str, char* result);

int main() {
	std::string str;
	std::cout << "This program delete extra spaces." << std::endl;
	std::cout << "Enter line of text: ";
	std::getline(std::cin, str);
	//str = "";
	//str = "hello         world and then  b";
	//str = "";
	//str = "a";
	//str = " ";
	//str = "              ";
	//str = "        hello              ";
	//str = "          the             was                                   and";

	char result[5000];
	delete_extra_spaces(str.c_str(), result);

	std::cout << "Result: \"" << std::string(result) << "\"" << std::endl;

	std::system("pause");
}