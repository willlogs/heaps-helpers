#include <signal.h>
#include <stdio.h>
#include <string.h>
int main(){
	char pass[5];
	char userInput[5];

	scanf(userInput);
	
	if (0 == strncmp(pass, userInput, 5)){
		printf("SUCCESS!\n");
	}else{
		printf("FAILURE!\n");
	}

	printf("you typed: %s\n\r", userInput);
	return 0;
}