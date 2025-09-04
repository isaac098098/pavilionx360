#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <ctype.h>

#define EXT ".tex"

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

int luhmann(const void *pa, const void *pb) {
    const char *a = *(const char **)pa;
    const char *b = *(const char **)pb;

    int i = 0, j = 0;

    while(a[i] && b[j]) {
        if(isdigit(a[i]) && isdigit(b[j])) {
            long na = strtol(a + i, NULL, 10);
            long nb = strtol(b + j, NULL, 10);

            if(na != nb) return (na < nb) ? -1 : 1;

            while(isdigit(a[i])) i++;
            while(isdigit(b[j])) j++;
        }
        else if(isalpha(a[i]) && isalpha(b[j])) {
            int start_i = i, start_j = j;
            while(isalpha(a[i])) i++;
            while(isalpha(b[j])) j++;

            int len_a = i - start_i;
            int len_b = j - start_j;

            char *suba = malloc(len_a + 1);
            char *subb = malloc(len_b + 1);
            if (!suba || !subb) {
                fprintf(stderr, "Out of memory\n");
                exit(EXIT_FAILURE);
            }

            memcpy(suba, a + start_i, len_a);
            memcpy(subb, b + start_j, len_b);
            suba[len_a] = '\0';
            subb[len_b] = '\0';

            int res = alpha_cmp(suba, subb);

            free(suba);
            free(subb);

            if(res != 0) return res;
        }
        else {
            return isdigit(a[i]) ? -1 : 1;
        }
    }

    if(a[i] && !b[j]) return 1;
    if(!a[i] && b[j]) return -1;
    return 0;
}

void print_title_tags(FILE *fp) {
    int c;
 
    while((c = getc(fp)) != EOF && c != '\n' && c == '%');
    while(c != EOF && c != '\n' && c == ' ')
        c = getc(fp);
 
    if(c != EOF && c != '\n') {
        putchar(c);
        while((c = getc(fp)) != EOF && c != '\n')
                putchar(c);
    }
}

int main(int argc, char *argv[]) {
    DIR *dir;
    struct dirent *dp;
    char **card_list = NULL;
    size_t cn = 0;
    FILE *fp;

    if(argc == 2) {
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

        qsort(card_list, cn, sizeof(char*), luhmann);

        // sorted list

        for(size_t i = 0; i < cn; i++) {
            printf("%-8s ", card_list[i]);

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

            print_title_tags(fp);
            printf(" | ");
            print_title_tags(fp);
            printf("\n");

            fclose(fp);
            free(card_list[i]);
        }

        free(card_list);
    }

    return 0;
}
