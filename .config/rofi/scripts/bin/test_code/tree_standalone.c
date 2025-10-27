#include <time.h>
#include "functions.h"

#define EXT ".tex"

int main(int argc, char *argv[]) {
    if(argc == 2) {
        const char *cards_dir = strdup(argv[1]);
        struct node root;

        if(fill_tree(&root, cards_dir) < 0) {
            fprintf(stderr, "could not fill tree\n");
            return -1;
        }

        // print_subtree_pretty(&root, "", -1);
        // print_subtree_as_list(&root);

        // struct node *find = find_node(&root, "2a2");
        // print_subtree_pretty(find, "", -1);
        // rename_subtree(find, "2c2");
        // print_subtree_pretty(find, "", -1);

        // char *test_card = "2za";
        // printf("previous: %s\n", prev_card(test_card));
        // printf("card: %s\n", test_card);
        // printf("next: %s\n", next_card(test_card));
    }
    else {
        printf("usage: %s [directory]\n", argv[0]);
        return 0;
    }

    printf("time used: %.9f\n", (double)clock() / CLOCKS_PER_SEC);

    return 0;
}
