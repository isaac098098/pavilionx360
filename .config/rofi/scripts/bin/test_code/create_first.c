#include "functions.h"

int main(int argc, char **argv) {
    if(argc == 2) {
        const char *main_file = strdup(argv[1]);
        
        create_first_card(main_file);
    }
    else
        printf("usage: ./create_first [MAIN_FILE]\n");

    return 0;
}
