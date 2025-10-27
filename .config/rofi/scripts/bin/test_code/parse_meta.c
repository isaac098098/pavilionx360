#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

const char *zheader = "\\zheader";
const size_t zheader_len = 8;

const int* compute_prefix_function(const char* pattern,
                                   const size_t pattern_len)
{
    if(pattern_len == 0) return NULL;

    int *pi = malloc(pattern_len * sizeof(int));
    if (!pi) return NULL;

    pi[0] = 0;
    int k = 0;

    for(int q = 1; q < pattern_len; q++) {
        while(k > 0 && pattern[k] != pattern[q])
            k = pi[k - 1];
        if(pattern[k] == pattern[q])
            k++;
        pi[q] = k;
    }

    return pi;
}

int get_zheader(const char *file_path,
                char **title,
                char **tags)
{
    if(file_path == NULL)
        return -1;

    FILE *file = fopen(file_path, "r");

    if(!file) {
        fprintf(stderr, "could not open %s\n", file_path);
        return -1;
    }

    /* knuth-morris-pratt */

    char c;
    size_t q = 0;
    const int *pi = compute_prefix_function(zheader, zheader_len);

    while((c = fgetc(file)) != EOF) {
        while(q > 0 && zheader[q] != c)
            q  = pi[q - 1];
        if(zheader[q] == c)
            q++;
        if(q == zheader_len) {

            /* get title */

            size_t pos = 0;
            size_t brackets = 0;

            if((c = fgetc(file)) == '{') {
                brackets = 1;

                while((c = fgetc(file)) != EOF) {
                    if(brackets == 0)
                        break;
                    if(c == '{')
                        brackets += 1;
                    if(c == '}')
                        brackets -= 1;
                    pos++;
                }
            }
            else {
                fprintf(stderr, "no title argument found\n");
                fclose(file);
                return -1;
            }

            if(brackets != 0) {
                fprintf(stderr, "inconsistent square brackets\n");
                fclose(file);
                return -1;
            }

            if(pos > 0) {
                fseek(file, - (pos + 1), SEEK_CUR);
                *title = malloc(pos + 1);
                fgets(*title, pos, file);
            }

            /* get tags */

            brackets = 0;
            pos = 0;
            
            fgetc(file);

            if((c = fgetc(file)) == '{') {
                brackets = 1;

                while((c = fgetc(file)) != EOF) {
                    if(brackets == 0)
                        break;
                    if(c == '{')
                        brackets += 1;
                    if(c == '}')
                        brackets -= 1;
                    pos++;
                }
            }
            else {
                fprintf(stderr, "no title argument found\n");
                fclose(file);
                return -1;
            }

            if(brackets != 0) {
                fprintf(stderr, "inconsistent brackets\n");
                fclose(file);
                return -1;
            }

            if(pos > 0) {
                fseek(file, - (pos + 1), SEEK_CUR);
                *tags = malloc(pos + 1);
                fgets(*tags, pos, file);

                fclose(file);

                return 0;
            }
        }
    }

    fclose(file);

    return -1;
}

int get_zheader_alt(const char *file_path,
                    char **title,
                    char **tags)
{
    if(file_path == NULL)
        return -1;

    FILE *file = fopen(file_path, "r");

    if(!file) {
        fprintf(stderr, "could not open %s\n", file_path);
        return -1;
    }

    /* knuth-morris-pratt */

    char c;
    size_t q = 0;
    const int *pi = compute_prefix_function(zheader, zheader_len);

    while((c = fgetc(file)) != EOF) {
        while(q > 0 && zheader[q] != c)
            q  = pi[q - 1];
        if(zheader[q] == c)
            q++;
        if(q == zheader_len) {

            /* get alternative title */

            size_t pos = 0;
            size_t sq_brackets = 0;

            if((c = fgetc(file)) == '[') {
                sq_brackets = 1;

                while((c = fgetc(file)) != EOF) {
                    if(sq_brackets == 0)
                        break;
                    if(c == '[')
                        sq_brackets += 1;
                    if(c == ']')
                        sq_brackets -= 1;
                    pos++;
                }
            }
            else {
                fprintf(stderr, "no alt title argument found\n");
                fclose(file);
                return -1;
            }

            if(sq_brackets != 0) {
                fprintf(stderr, "inconsistent square brackets\n");
                fclose(file);
                return -1;
            }

            if(pos > 0) {
                fseek(file, - (pos + 1), SEEK_CUR);
                *title = malloc(pos + 1);
                fgets(*title, pos, file);
            }

            /* skip document title */

            size_t brackets = 0;
            pos = 0;
            
            fgetc(file);

            if((c = fgetc(file)) == '{') {
                brackets = 1;

                while((c = fgetc(file)) != EOF) {
                    if(brackets == 0)
                        break;
                    if(c == '{')
                        brackets += 1;
                    if(c == '}')
                        brackets -= 1;
                    pos++;
                }
            }
            else {
                fprintf(stderr, "no title argument found\n");
                fclose(file);
                return -1;
            }

            if(brackets != 0) {
                fprintf(stderr, "inconsistent brackets\n");
                fclose(file);
                return -1;
            }

            if(pos > 0)
                fseek(file, -1, SEEK_CUR);
            else{
                fclose(file);
                return -1;
            }

            /* get tags */

            brackets = 0;
            pos = 0;

            if((c = fgetc(file)) == '{') {
                brackets = 1;

                while((c = fgetc(file)) != EOF) {
                    if(brackets == 0)
                        break;
                    if(c == '{')
                        brackets += 1;
                    if(c == '}')
                        brackets -= 1;
                    pos++;
                }
            }
            else {
                fprintf(stderr, "no tags argument found\n");
                fclose(file);
                return -1;
            }

            if(brackets != 0) {
                fprintf(stderr, "inconsistent brackets\n");
                fclose(file);
                return -1;
            }

            if(pos > 0) {
                fseek(file, - (pos + 1), SEEK_CUR);
                *tags = malloc(pos + 1);
                fgets(*tags, pos, file);

                fclose(file);

                return 0;
            }
        }
    }

    fclose(file);

    return -1;
}

int main(int argc, char **argv) {
    if(argc == 2) {
        const char *file_path = strdup(argv[1]);
        char *title;
        char *tags;

        if(get_zheader(file_path, &title, &tags) < 0) {
            if(get_zheader_alt(file_path, &title, &tags) < 0) {
                fprintf(stderr, "could not found zheader or zheader alt\n");
                return -1;
            }
        }

        printf("%s\n", title);
        printf("%s\n", tags);

        free(title);
        free(tags);
    }
    else
        printf("usage: ./parse_meta [FILE]\n");

    printf("time used: %.6f\n", (double)clock() / CLOCKS_PER_SEC);

    return 0;
}
