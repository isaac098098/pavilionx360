#include <errno.h>
#include <time.h>
#include "functions.h"

int main(int argc, char **argv) {
    if(argc == 4) {
        const char* main_dir = strdup(argv[1]);
        const char* cards_dir = strdup(argv[2]);
        const char* card = strdup(argv[3]);
        size_t card_len = strlen(card);
        char *card_no_ext = strndup(card, card_len - 4);
        struct node root;

        /* sanitize card name */

        if(!(card_len > 4 && strcmp(card + card_len - 4, EXT) == 0)) {
            fprintf(stderr, "invalid card file %s\n", card);
            fprintf(stderr, "file must have extension \".tex\"\n");
            return -1;
        }

        /* sanitize and open directory path */

        cards_dir = sanitize_dir_path(cards_dir);

        /* create abstract tree */

        if(fill_tree(&root, cards_dir) < 0) {
            fprintf(stderr, "could not fill tree\n");
            return -1;
        }

        /* find card and parent */

        struct node *card_node = find_node(&root, card_no_ext);

        if(card_node == NULL) {
            fprintf(stderr, "could not find card in tree\n");
            return -1;
        }

        /* if card is root, don't do anything */

        struct node *parent_card = card_node->parent;

        if(parent_card == NULL) {
            fprintf(stderr, "cannot remove root card\n");
            return -1;
        }

        /* check if card has children */

        if(card_node->child_num > 0) {
            fprintf(stderr, "could not delete %s, card has subcards\n",
                    card_no_ext);
            return -1;
        }

        /* construct card path */

        char *card_path = construct_file_path(cards_dir, card);

        /* delete card */

        if(remove(card_path) == 0) {
            printf("card %s deleted\n", card_path);
        }
        else {
            fprintf(stderr, "failed to delete card %s\n", card_path);
            fprintf(stderr, "%s\n", strerror(errno));
            return -1;
        }

        /* delete from main */

        delete_card_from_main(main_dir, card_no_ext);

        /* construct hyperref pattern */

        char *pattern = construct_hyperref_pattern(card_no_ext);
        size_t pattern_len = strlen(pattern);

        /* update refs of deleted card */

        replace_pattern_in_dir(cards_dir,
                               pattern,
                               pattern_len,
                               deleted_replacement,
                               deleted_replacement_len);

        /* backward all succesor cards */

        size_t sibling_num = parent_card->child_num;

        for(size_t i = 0; i < sibling_num; i++) {
            if(strcmp(card_no_ext, parent_card->children[i]->label) == 0) {
                for(size_t j = i + 1; j < sibling_num; j++) {
                    struct node* sibling = parent_card->children[j];

                    char* label = strdup(sibling->label);
                    char *prev_label = prev_card(label);

                    rename_subtree(parent_card->children[j],
                                   main_dir,
                                   prev_label,
                                   cards_dir);
                }

                break;
            }
        }
    }
    else
        printf("usage: ./delete_card [MAIN_FILE_DIR] [CARDS_DIR] [CARD_FILE]\n");

    printf("time use: %.6fs\n", (double)clock() / CLOCKS_PER_SEC);

    return 0;
}
