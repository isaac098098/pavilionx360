#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <ctype.h>

#define EXT ".tex"
#define MAX_ROOTS   5

void generate_root_cards(const char *cards_dir) {
    FILE *fp;

    srand(time(NULL));

    for(int i=0; i < MAX_ROOTS; i++) {
        int r = 1 + rand() % 10;
        int buffsize = snprintf(NULL, 0, "%d", r) + 1;
        char *suffix = malloc(buffsize);

        sprintf(suffix, "%d", r);
        /* printf("random number: %d\n", r); */
        size_t len_path = strlen(cards_dir) + strlen(suffix) + strlen(EXT) + 1;
        char *file_path = malloc(len_path);
        snprintf(file_path, len_path, "%s%s%s", cards_dir, suffix, EXT);
        /* printf("dir: %s\n", file_path); */
         
        free(suffix);

        fp = fopen(file_path, "w");
        fclose(fp);
    }
}

char **get_tex_files(const char *cards_dir) {
    DIR *dir;
    struct dirent *dp;
    char **card_list = NULL;
    size_t cn = 0;

    dir = opendir(cards_dir);
    while((dp = readdir(dir)) != NULL) {
        if(strcmp(dp->d_name, ".") != 0 && strcmp(dp->d_name, "..") != 0) {
            size_t len = strlen(dp->d_name);
            if(len > 4 && strcmp(dp->d_name + len - 4, EXT) == 0) {
                char *name = strndup(dp->d_name, len - 4);
                card_list = realloc(card_list, (cn + 1) * sizeof(char*));
                card_list[cn++] = name;
            }
        }
    }

    closedir(dir);

    return card_list;
}

size_t get_tex_num(const char *cards_dir) {
    DIR *dir;
    struct dirent *dp;
    char **card_list = NULL;
    size_t cn = 0;

    dir = opendir(cards_dir);
    while((dp = readdir(dir)) != NULL) {
        if(strcmp(dp->d_name, ".") != 0 && strcmp(dp->d_name, "..") != 0) {
            size_t len = strlen(dp->d_name);
            if(len > 4 && strcmp(dp->d_name + len - 4, EXT) == 0)
                cn++;
        }
    }

    closedir(dir);

    return cn;
}

void print_tex_files(const char* cards_dir) {
    char **card_list = NULL;
    card_list = get_tex_files(cards_dir);
    size_t n = get_tex_num(cards_dir);
    for(int i = 0; i < n; i++)
        printf("%s ", card_list[i]);
    printf("\n");
}

void generate_cards(const char* cards_dir) {
    DIR *dir;
    struct dirent *dp;
    char **card_list = NULL;
    FILE *fp;

    srand(time(NULL));

    size_t n = get_tex_num(cards_dir);
    card_list = get_tex_files(cards_dir);

    for(int i = 0; i < n; i++) {
        int buffsize, r, o, p;
        char *suffix;

        /* 'a' = 97 */
        if(isdigit(card_list[i][strlen(card_list[i]) - 1])) {
            /* printf("%s tiene último dígito %c\n", card_list[i], card_list[i][strlen(card_list[i]) - 1]); */
            if(6 <= rand() % 10) {
                if(95 <= rand() % 100) {
                    r = 97 + rand() % 26;
                    o = 97 + rand() % 26;
                    p = 97 + rand() % 26;
                    buffsize = snprintf(NULL, 0, "%c%c%c", r, o, p) + 1;
                    suffix = malloc(buffsize);
                    sprintf(suffix, "%c%c%c", r, o, p);
                }
                else if(80 <= rand() % 100) {
                    r = 97 + rand() % 26;
                    o = 97 + rand() % 26;
                    buffsize = snprintf(NULL, 0, "%c%c", r, o) + 1;
                    suffix = malloc(buffsize);
                    sprintf(suffix, "%c%c", r, o);
                }
                else {
                    r = 97 + rand() % 26;
                    buffsize = snprintf(NULL, 0, "%c", r) + 1;
                    suffix = malloc(buffsize);
                    sprintf(suffix, "%c", r);
                }

                size_t len_path = strlen(cards_dir) + strlen(card_list[i]) + strlen(suffix) + strlen(EXT) + 1;
                char *file_path = malloc(len_path);
                snprintf(file_path, len_path, "%s%s%s%s", cards_dir, card_list[i], suffix, EXT);

                printf("new file: %s\n", file_path);
                fp = fopen(file_path, "w");
                fclose(fp);
            }
        }

        /* '1' = 48 */
        if(isalpha(card_list[i][strlen(card_list[i]) - 1])) {
            /* printf("%s tiene último caracter %c\n", card_list[i], card_list[i][strlen(card_list[i]) - 1]); */
            if(6 <= rand() % 10) {
                if(95 <= rand() % 100) {
                    r = 48 + rand() % 10;
                    o = 48 + rand() % 10;
                    p = 48 + rand() % 10;
                    buffsize = snprintf(NULL, 0, "%c%c%c", r, o, p) + 1;
                    suffix = malloc(buffsize);
                    sprintf(suffix, "%c%c%c", r, o, p);
                }
                else if(80 <= rand() % 100) {
                    r = 48 + rand() % 10;
                    o = 48 + rand() % 10;
                    buffsize = snprintf(NULL, 0, "%c%c", r, o) + 1;
                    suffix = malloc(buffsize);
                    sprintf(suffix, "%c%c", r, o);
                }
                else {
                    r = 48 + rand() % 10;
                    buffsize = snprintf(NULL, 0, "%c", r) + 1;
                    suffix = malloc(buffsize);
                    sprintf(suffix, "%c", r);
                }

                size_t len_path = strlen(cards_dir) + strlen(card_list[i]) + strlen(suffix) + strlen(EXT) + 1;
                char *file_path = malloc(len_path);
                snprintf(file_path, len_path, "%s%s%s%s", cards_dir, card_list[i], suffix, EXT);

                printf("new file: %s\n", file_path);
                fp = fopen(file_path, "w");
                fclose(fp);
            }
        }
    }

    free(card_list);
}

int main(int argc, char *argv[]) {
    if(argc == 3) {
        printf("%s\n", argv[1]);
        generate_root_cards(argv[1]);
        print_tex_files(argv[1]);

        for(int i=0; i < atoi(argv[2]); i++) {
            generate_cards(argv[1]);
            print_tex_files(argv[1]);
        }
    }
    else {
        printf("Usage: ./gen_random_cards [path] [max_height]\n");
        return 0;
    }

    return 0;
}
