#include <stdio.h>
#include <stdlib.h>

const char alpha[] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '!', '@', '#', '$', '%', '^', '&', '*', '(', ')',
    '-', '=', '_', '+', '[', ']', '{', '}', 
    '\'', '\"', '\\', ',', '.', '/',
    '<', '>', '?', ' '
};

const int alpha_size = *(&alpha + 1) - alpha;

int main(int argc, char** argv) {
    if(argc != 2) {
        printf("usage: ./enc [text file to decrypt]\n");
        printf("this program encrypts a file with a password given by an array of integers\n");
        printf("the clear text must contain only characters in the alphabet defined in the source code and no line breaks");
        return 0;

    }
    else {
        FILE *clear = fopen(argv[1], "r");
        FILE *encr = fopen("encrypted.txt", "w");

        int n;
        printf("Length of the array: ");
        scanf("%d", &n);

        int key[n], a;

        for(int j = 0; j < n; j++) {
            printf("int %d: ", j+1);
            scanf("%d", &a);
            key[j] = a;
        }

        if(clear == NULL) {
            perror("Error");
            fclose(clear);
            return -1;
        }

        int c, c_pos = 0;
        while((c = fgetc(clear)) != EOF) {
            if (c != '\n') {
                c_pos++;
                for (int i = 0; i < alpha_size; i++)
                    if(alpha[i] == c) {
                        fputc(alpha[ (i+key[(c_pos-1) % n]) % alpha_size ], encr);
                        break;
                    }
            }
        }

        fclose(encr);
        fclose(clear);
    }
    return 0;
}
