#include "functions.h"

int main(int argc, char **argv) {
    if(argc == 3) {
        const char *main_file = strdup(argv[1]);
        const char *card_no_ext = strdup(argv[2]);
        size_t card_no_ext_len = strlen(card_no_ext);

        /* construct pattern */

        size_t card_pattern_len = include_1_len
                                  + card_no_ext_len
                                  + EXT_LEN
                                  + include_2_len
                                  + 1;
        char *card_pattern = malloc(card_pattern_len);
        snprintf(card_pattern, card_pattern_len, "%s%s%s%s",
                                                 include_1,
                                                 card_no_ext,
                                                 EXT,
                                                 include_2);
        FILE *file = fopen(main_file, "r");
        if(!file) {
            fprintf(stderr, "could not open file %s\n", main_file);
            return -1;
        }

        char c;
        size_t buffer_size = 0;
        while((c = fgetc(file)) != EOF)
            buffer_size++;

        if(buffer_size == 0) {
            fprintf(stderr, "file %s is empty\n", main_file);
            fprintf(stderr, "consider to regenerate index\n");
            return -1;
        }

        char *buffer = malloc(buffer_size);
        rewind(file);
        fread(buffer, sizeof(char), buffer_size, file);

        fclose(file);

        ssize_t pos;

        if((pos = get_first_coincidence(buffer,
                                        buffer_size,
                                        card_pattern,
                                        card_pattern_len - 1)) < 0)
        {
            fprintf(stderr, "card %s not found in main file\n", card_no_ext);
            fprintf(stderr, "consider to regenerate index\n");
            return -1;
        }

        size_t npos = (size_t)pos;

        size_t card_real = strlen(card_pattern);

        size_t new_buffer_size = buffer_size - card_real;
        char *new_buffer = malloc(new_buffer_size);

        memcpy(new_buffer, buffer, npos);
        memcpy(new_buffer + npos,
               buffer + npos + card_real,
               buffer_size - (card_real + npos));

        // printf("%s", new_buffer);

        if(new_buffer != NULL) {
            size_t tmp_file_path_len = strlen(main_file) + strlen(".tmp") + 1;
            char *tmp_file_path = malloc(tmp_file_path_len);
            snprintf(tmp_file_path, tmp_file_path_len, "%s.tmp", main_file);

            FILE *tmp_file = fopen(tmp_file_path, "w");
            if(!tmp_file) {
                fprintf(stderr, "could not create temporary file\n");
                return -1;
            }

            fwrite(new_buffer, sizeof(char), new_buffer_size, tmp_file);
            fclose(tmp_file);

            rename(tmp_file_path, main_file);
        }
        else
            return -1;
    }
    else
        printf("usage: ./delete_line [MAIN_FILE_DIR] [CARD_NO_EXT]\n");

    return 0;
}
