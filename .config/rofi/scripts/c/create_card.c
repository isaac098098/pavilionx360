#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <ctype.h>

#define EXT ".tex"

char *alpha_next(const char *a) {
    size_t len = strlen(a);
    char *b = strdup(a);
    if(!b) return NULL;

    if(b[0] == 'a' - 1) {
        b[0]++;
        return b;
    }

    for(int i=0; b[i] != '\0'; i++) {
        if(!isalpha(b[i])) {
            fprintf(stderr, "\"%s\" contains a non-alphabetic character\n", b);
            free(b);
            return NULL;
        }
        if(isupper(b[i])) {
            fprintf(stderr, "\"%s\" contains an uppercase character\n", b);
            free(b);
            return NULL;
        }
    }

    for (int i=len - 1; i >= 0; i--) {
        if (b[i] != 'z') {
            b[i]++;
            return b;
        }
        else
            b[i] = 'a';
    }

    b = realloc(b, len + 2);
    memmove(b + 1, b, len);
    b[0] = 'a';
    b[len + 1] = '\0';

    return b;
}

int alpha_cmp(const char *a, const char *b) {
    size_t len_a = strlen(a);
    size_t len_b = strlen(b);

    if(len_a != len_b)
        return (int)(len_a - len_b);

    for(size_t i = 0; i < len_a; i++)
        if(a[i] != b[i])
            return (int)(a[i] - b[i]);

    return 0;
}

int main(int argc, char *argv[]) {
    DIR *dir;
    struct dirent *dp;
    char **card_list = NULL;
    size_t cn = 0;
    FILE *fp;

    if(argc == 3) {
        dir = opendir(argv[1]);
        if(!dir) {
            fprintf(stderr, "No such directory \"%s\"\n", argv[1]);
            return -1;
        }

        while((dp = readdir(dir)) != NULL) {
            if(strcmp(dp->d_name, ".") != 0 && strcmp(dp->d_name, "..") != 0) {
                size_t len = strlen(dp->d_name);
                if (len > 4 && strcmp(dp->d_name + len - 4, EXT) == 0) {
                    char *name = strndup(dp->d_name, len - 4);
                    card_list = realloc(card_list, (cn + 1) * sizeof(char*));
                    card_list[cn++] = name;
                }
            }
        }
        
        closedir(dir);

        // unsorted list
        
        size_t len_card = strlen(argv[2]);
        bool is_last_alpha = isalpha(argv[2][len_card - 1]);
        bool is_last_digit = isdigit(argv[2][len_card - 1]);
        bool found = 0;
        long last = 0, child_num, last_root = 0, root_num;
        char *last_chars = malloc(2), *child_chars;
        last_chars[0] = 'a' - 1;
        last_chars[1] = '\0';

        for(size_t i = 0; i < cn; i++) {
            // printf("%-8s ", card_list[i]);

            size_t len_path = strlen(argv[1]) + 1
                + strlen(card_list[i])
                + strlen(".tex")
                + 1;

            char *file_path = malloc(len_path);
            if (!file_path) {
                fprintf(stderr, "Out of memory\n");
                return -1;
            }

            snprintf(file_path, len_path, "%s/%s.tex", argv[1], card_list[i]);

            fp = fopen(file_path, "r");
            if (!fp) {
                fprintf(stderr, "No such file \"%s\"\n", card_list[i]);
                free(file_path);
                return -1;
            }

            if(strcmp(card_list[i], argv[2]) == 0)
                found = 1;

            int j = 0;
            if (card_list[i][j] && isdigit(card_list[i][j])) {
                while (isdigit(card_list[i][j])) j++;

                if (card_list[i][j] == '\0') {
                    // printf("found root node %s\n", card_list[i]);
                    root_num = strtol(card_list[i], NULL, 10);
                    if(root_num > last_root)
                        last_root = root_num;
                }
            }

            if(strncmp(card_list[i], argv[2], len_card) == 0) {
                // card begins with argv[2]

                if(is_last_alpha) {
                    j = len_card;
                    if (card_list[i][j] && isdigit(card_list[i][j])) {
                        while (isdigit(card_list[i][j])) j++;

                        if (card_list[i][j] == '\0') {
                            //printf("found child %s", card_list[i]);
                            //printf(" with last number %s\n", card_list[i] + len_card);

                            child_num = strtol(card_list[i] + len_card, NULL, 10);
                            if(child_num > last)
                                last = child_num;
                        }
                    }
                }
                if(is_last_digit) {
                    j = len_card;
                    if (card_list[i][j] && isalpha(card_list[i][j])) {
                        while (isalpha(card_list[i][j])) j++;

                        if (card_list[i][j] == '\0') {
                            child_chars = strdup(card_list[i] + len_card);
                            // printf("found child %s", card_list[i]);
                            // printf(" with last chars %s\n", child_chars);

                            if(alpha_cmp(child_chars, last_chars) > 0) {
                                // printf("%s > %s\n", child_chars, last_chars);
                                last_chars = strdup(child_chars);
                            }
                        }
                    }
                }
            }

            fclose(fp);
            free(card_list[i]);
        }

        int len_last;
        char *next;

        if(found == 0) {
            if(strcmp(argv[2], "New root node") == 0)
                printf("%ld\n", last_root + 1);
            else {
                printf("No such file \"%s\"\n", argv[2]);
                return -1;
            }
        }
        else {
            if(is_last_alpha) {
                len_last = snprintf(NULL, 0, "%s%ld", argv[2], last + 1);
                next= malloc(len_last + 1);
                if (!next) {
                    fprintf(stderr, "Out of memory\n");
                    return -1;
                }
                snprintf(next, len_last + 1, "%s%ld", argv[2], last + 1);
            }
            if(is_last_digit) {
                len_last = snprintf(NULL, 0, "%s%s", argv[2], alpha_next(last_chars));
                next= malloc(len_last + 1);
                if (!next) {
                    fprintf(stderr, "Out of memory\n");
                    return -1;
                }
                snprintf(next, len_last + 1, "%s%s", argv[2], alpha_next(last_chars));
            }

            printf("%s\n", next);
            free(next);
            free(card_list);
        }
    }

    return 0;
}
