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

        /* find card */

        struct node *card_node = find_node(&root, card_no_ext);

        if(card_node == NULL) {
            fprintf(stderr, "could not find card in tree\n");
            return -1;
        }

        /* if card is root don't do anything */

        struct node *parent_card = card_node->parent;

        if(parent_card == NULL) {
            fprintf(stderr, "cannot insert card after root\n");
            return -1;
        }

        /* forward all succesor cards */

        size_t sibling_num = parent_card->child_num;

        for(size_t i = 0; i < sibling_num; i++) {
            if(strcmp(card_no_ext, parent_card->children[i]->label) == 0) {
                for(ssize_t j = sibling_num - 1; j >= (ssize_t)i; j--) {
                    struct node *sibling = parent_card->children[j];

                    char *label = strdup(sibling->label);
                    char *next_label = next_card(label);

                    rename_subtree(sibling,
                                   main_dir,
                                   next_label,
                                   cards_dir);
                }

                break;
            }
        }

        /* construct card path */

        char *card_path = construct_file_path(cards_dir, card);

        /* create inserted card file */

        FILE *file = fopen(card_path, "w");
        if(!file) {
            fprintf(stderr, "could not create new card\n");
            return -1;
        }
        fclose(file);

        /* add inserted card entry in main file */

        if((insert_before_in_main(main_dir,
                             next_card(card_no_ext),
                             card_no_ext)) < 0)
        {
            fprintf(stderr, "could not add entry to main file\n");
            return -1;
        }

        // printf("time use: %.6fs\n", (double)clock() / CLOCKS_PER_SEC);

        return 0;
    }
    else
        printf("usage: ./insert_card [MAIN_FILE_DIR] [CARDS_DIR] [CARD_FILE]\n");

    return 0;
}
