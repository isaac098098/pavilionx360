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
        const char* new_card;
        struct node root;

        /* sanitize card name */

        if(strcmp(card, "root") != 0) {
            if(!(card_len > 4 && strcmp(card + card_len - 4, EXT) == 0)) {
                fprintf(stderr, "invalid card file %s\n", card);
                fprintf(stderr, "file must have extension \".tex\"\n");
                return -1;
            }
        }

        /* sanitize and open directory path */

        cards_dir = sanitize_dir_path(cards_dir);

        /* create abstract tree */

        if(fill_tree(&root, cards_dir) < 0) {
            fprintf(stderr, "could not fill tree\n");
            return -1;
        }

        /* find card */

        struct node *card_node;

        if(strcmp(card, "root") == 0)
            card_node = find_node(&root, "root");
        else
            card_node = find_node(&root, card_no_ext);

        if(card_node == NULL) {
            fprintf(stderr, "could not find card in tree\n");
            return -1;
        }

        size_t child_num = card_node->child_num;

        /* if card is root, create new root card */

        /* first card case */

        struct node *parent_card = card_node->parent;

        if(parent_card == NULL) {
            if(strcmp(card, "root") == 0) {
                if(card_node->child_num == 0) {
                    if(create_first_card(main_dir) < 0) {
                        fprintf(stderr, "could not create first card\n");
                        return -1;
                    }

                    new_card = strdup("1");
                }
                else {
                    char *last_child_label = strdup(card_node->children[child_num - 1]->label);
                    new_card = next_card(last_child_label);
                }
            }
            else {
                fprintf(stderr, "card %s should have parents, but it doesn't\n",
                                card_no_ext);
                return -1;
            }
        }
        else {

            if(child_num == 0) {
                new_card = construct_first_child_label(card_no_ext);
            }
            else {
                char *last_child_label = strdup(card_node->children[child_num - 1]->label);
                new_card = next_card(last_child_label);
            }
        }

        /* insert entry in main */

        if(strcmp(new_card, "1") == 0) {
            if(create_first_card(main_dir) < 0) {
                fprintf(stderr, "could not add first card in main file\n");
                return -1;
            }
        }
        else {
            if(insert_after_in_main(main_dir,
                                    get_rightmost_child_label(card_node),
                                    new_card) < 0)
            {
                fprintf(stderr, "could not add card %s in main file\n", new_card);
                return -1;
            }
        }

        /* create file */

        size_t new_card_path_len = strlen(cards_dir)
                                   + strlen(new_card)
                                   + EXT_LEN
                                   + 1;
        char *new_card_path = malloc(new_card_path_len);
        snprintf(new_card_path, new_card_path_len, "%s%s%s",
                                                   cards_dir,
                                                   new_card,
                                                   EXT);

        FILE *file = fopen(new_card_path, "w");
        if(!file) {
            fprintf(stderr, "could not create new card file\n");
            return -1;
        }

        fclose(file);

        // printf("%s\n", new_card_path);
        printf("%s\n", new_card);

        // printf("time used: %.6fs\n", (double)clock() / CLOCKS_PER_SEC);

        return 0;
    }
    else
        printf("usage: ./insert_card [MAIN_FILE_DIR] [CARDS_DIR] [TARGET_CARD]\n");

    return 0;
}
