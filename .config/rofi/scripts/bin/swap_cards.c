#include <errno.h>
// #include <time.h>
#include <unistd.h>
#include "functions.h"

int main(int argc, char **argv) {
    if(argc == 4) {
        const char* cards_dir = strdup(argv[1]);
        const char* card_1 = strdup(argv[2]);
        const char* card_2 = strdup(argv[3]);
        size_t card_1_len = strlen(card_1);
        size_t card_2_len = strlen(card_2);
        char *card_1_no_ext = strndup(card_1, card_1_len - 4);
        char *card_2_no_ext = strndup(card_2, card_2_len - 4);

        /* sanitize cards name */

        if(!(card_1_len > 4 && strcmp(card_1 + card_1_len - 4, EXT) == 0)) {
            fprintf(stderr, "invalid card_1 file %s\n", card_1);
            fprintf(stderr, "file must have extension \".tex\"\n");
            return -1;
        }

        if(!(card_2_len > 4 && strcmp(card_2 + card_2_len - 4, EXT) == 0)) {
            fprintf(stderr, "invalid card_2 file %s\n", card_2);
            fprintf(stderr, "file must have extension \".tex\"\n");
            return -1;
        }

        /* sanitize and open directory path */

        cards_dir = sanitize_dir_path(cards_dir);

        /* construct card paths and tmp file path */

        char *card_1_path = construct_file_path(cards_dir, card_1);
        char *card_2_path = construct_file_path(cards_dir, card_2);

        /* check if files exists */

        if(access(card_1_path, F_OK) != 0) {
            fprintf(stderr, "cannot access %s\n", card_1_path);
            fprintf(stderr, "%s\n", strerror(errno));
            return -1;
        }

        if(access(card_2_path, F_OK) != 0) {
            fprintf(stderr, "cannot access %s\n", card_2_path);
            fprintf(stderr, "%s\n", strerror(errno));
            return -1;
        }

        size_t tmp_path_len = strlen(card_1_path) + strlen(".tmp");
        char *tmp_path = malloc(tmp_path_len);
        snprintf(tmp_path, tmp_path_len, "%s.tmp", card_1_path);

        /* swap contents of cards */

        if(rename(card_1_path, tmp_path) < 0) {
            fprintf(stderr, "could not create temporary file\n");
            fprintf(stderr, "%s\n", strerror(errno));
            return -1;
        }

        if(rename(card_2_path, card_1_path) < 0) {
            fprintf(stderr, "could not modify %s file\n", card_1_path);
            fprintf(stderr, "%s\n", strerror(errno));
            return -1;
        }

        if(rename(tmp_path, card_2_path) < 0) {
            fprintf(stderr, "could not modify %s file\n", card_2_path);
            fprintf(stderr, "%s\n", strerror(errno));
            return -1;
        }

        /* change zheader of both tags */

        if(replace_zheader_card(card_1_path, card_1_no_ext) < 0) {
            fprintf(stderr, "could not change zheader in %s\n", card_1_path);
            return -1;
        }

        if(replace_zheader_card(card_2_path, card_2_no_ext) < 0) {
            fprintf(stderr, "could not change zheader in %s\n", card_2_path);
            return -1;
        }

        /* replace refs in cards for both cards */

        char *card_1_hyperref = construct_hyperref_pattern(card_1_no_ext);
        char *card_2_hyperref = construct_hyperref_pattern(card_2_no_ext);
        size_t card_1_hyperref_len = strlen(card_1_hyperref);
        size_t card_2_hyperref_len = strlen(card_2_hyperref);

        size_t tmp_hyperref_len = tex_1_len
                                  + card_1_len
                                  + strlen(card_1_no_ext)
                                  + strlen("_tmp")
                                  + tex_2_len
                                  + card_1_len
                                  + strlen("_tmp")
                                  + tex_3_len
                                  + 1;
        char *tmp_hyperref = malloc(tmp_hyperref_len);
        snprintf(tmp_hyperref, tmp_hyperref_len, "%s%s_tmp%s%s_tmp%s",
                                                 tex_1,
                                                 card_1_no_ext,
                                                 tex_2,
                                                 card_1_no_ext,
                                                 tex_3);

        if(replace_pattern_in_dir(cards_dir,
                                  card_1_hyperref,
                                  card_1_hyperref_len,
                                  tmp_hyperref,
                                  tmp_hyperref_len) < 0)
        {
            fprintf(stderr, "could not replace temporary pattern\n");
            return -1;
        }

        if(replace_pattern_in_dir(cards_dir,
                                  card_2_hyperref,
                                  card_2_hyperref_len,
                                  card_1_hyperref,
                                  card_1_hyperref_len) < 0)
        {
            fprintf(stderr, "could not replace first card references\n");
            return -1;
        }

        if(replace_pattern_in_dir(cards_dir,
                                  tmp_hyperref,
                                  tmp_hyperref_len,
                                  card_2_hyperref,
                                  card_2_hyperref_len) < 0)
        {
            fprintf(stderr, "could not replace second card references\n");
            return -1;
        }

        // printf("%s\n", tmp_hyperref);

        // printf("time use: %.6fs\n", (double)clock() / CLOCKS_PER_SEC);

        return 0;
    }
    else
        printf("usage: ./insert_card [CARDS_DIR] [CARD_1] [CARD_2]\n");

    return 0;
}
