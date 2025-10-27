#include <time.h>
#include "functions.h"

int main(int argc, char ** argv) {
    if(argc == 2) {
        const char *cards_dir = strdup(argv[1]);
        struct node root;

        if(fill_tree(&root, cards_dir) < 0) {
            fprintf(stderr, "could not fill card tree\n");
            return -1;
        }

        print_cards_and_meta(&root, cards_dir);
    }
    else
        printf("usage: ./show_cards [CARDS_DIR]\n");

    // printf("time used: %.6fs\n", (double)clock() / CLOCKS_PER_SEC);

    return 0;
}
