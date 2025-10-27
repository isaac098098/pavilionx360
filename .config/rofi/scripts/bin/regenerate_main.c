#include <stdio.h>
#include "functions.h"

int main(int argc, char **argv) {
    if(argc == 3) {
        size_t buffer_size;
        char *main_file = strdup(argv[1]);
        char *cards_dir = strdup(argv[2]);
        FILE *file;
        struct node root;

        cards_dir = sanitize_dir_path(cards_dir);

        /* copy file to a buffer */

        printf("processing %s...\n", main_file);
        file = fopen(main_file, "r");

        if(!file) {
            fprintf(stderr, "could not open file\n");
            return -1;
        }

        fseek(file, 0, SEEK_END);
        buffer_size = ftell(file);

        if(buffer_size == 0) {
            fprintf(stderr, "file %s is empty, get a template copy of it\n",
                    main_file);
            fclose(file);
            return -1;
        }

        rewind(file);

        char *buffer = malloc(buffer_size + 1);
        fread(buffer, sizeof(char), buffer_size, file);
        buffer[buffer_size] = '\0';
        fclose(file);

        /* find beginning of tex document */

        ssize_t doc_pos;

        if((doc_pos = get_first_coincidence(buffer,
                                      buffer_size, 
                                      bdocument,
                                      bdocument_len)) < 0)
        {
            fprintf(stderr, "beginning of document is missing in %s\n", main_file);
            return -1;
        }

        /* calculate size of new file */

        fill_tree(&root, cards_dir);

        // print_subtree_pretty(&root, "", -1);

        size_t *cards_size = malloc(sizeof(size_t));
        size_t *cards_num = malloc(sizeof(size_t));
        cards_size[0] = 0;
        cards_num[0] = 0;

        card_names_size_and_num(&root, cards_size, cards_num);

        size_t new_buffer_size = (size_t)doc_pos
                                 + bdocument_len
                                 + toc_len
                                 + cards_num[0] * (include_1_len
                                 + include_2_len
                                 + EXT_LEN)
                                 + cards_size[0]
                                 + edocument_len
                                 + 1;
        char *new_buffer = malloc(new_buffer_size);

        /* build new main file */

        memcpy(new_buffer, buffer, (size_t)doc_pos + bdocument_len);
        memcpy(new_buffer + (size_t)doc_pos + bdocument_len, toc, toc_len);

        size_t *write_pos = malloc(sizeof(size_t));
        write_pos[0] = (size_t)doc_pos + bdocument_len + toc_len;
        write_index_entries(new_buffer, write_pos, &root);

        memcpy(new_buffer + write_pos[0], edocument, edocument_len);
        new_buffer[new_buffer_size - 1] = '\0';

        /* overwrite main file */

        size_t tmp_path_len = strlen(main_file) + strlen(".tmp") + 1;
        char *tmp_path = malloc(tmp_path_len);
        snprintf(tmp_path, tmp_path_len, "%s.tmp", main_file);
        
        FILE *tmp_file = fopen(tmp_path, "w");
        if(!tmp_file) {
            fprintf(stderr, "could not create temporary main file\n");
            return -1;
        }

        fwrite(new_buffer, sizeof(char), new_buffer_size - 1, tmp_file);

        if(new_buffer[new_buffer_size - 1] != '\n')
            fputc('\n', tmp_file);

        free(new_buffer);

        fclose(tmp_file);

        rename(tmp_path, main_file);

        free(tmp_path);
    }
    else
        printf("usage: ./regenerate_main [MAIN_FILE_PATH] [CARDS_DIR]\n");

    return 0;
}
