#include "functions.h"

int main(int argc, char **argv) {
    if(argc == 4) {
        const char *main_file = strdup(argv[1]);
        const char *card_no_ext = strdup(argv[2]);
        const char *new_name = strdup(argv[3]);

        insert_before_in_main(main_file,
                              card_no_ext,
                              new_name);
    }
    else
        printf("usage: ./delete_line [MAIN_FILE_DIR] [TARGET_CARD] [PREV_CARD]\n");

    return 0;
}
