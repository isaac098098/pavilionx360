#include "functions.h"

int main(int argc, char **argv) {
    if(argc == 3) {
        const char *card_file_path = strdup(argv[1]);
        const char *new_card = strdup(argv[2]);

        replace_zheader_card(card_file_path,
                             new_card);
    }
    else
        printf("usage: ./replace_znum [CARD_FILE_PATH] [NEW_CARD]\n");

    return 0;
}
