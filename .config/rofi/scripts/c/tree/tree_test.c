#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <dirent.h>

#define EXT ".tex"

struct node {
    char *label;
    struct node *parent;
    size_t child_num;
    size_t child_cty;
    struct node **children;
};

void fill_root(struct node *n) {
    n->label = strdup("root");
    n->parent = NULL;
    n->child_num = 0;
    n->child_cty = 1;
    n->children = malloc(sizeof(struct node**));
    n->children[0] = malloc(sizeof(struct node));
}

int print_node_info(const struct node *n) {
    if(n == NULL) return -1;

    printf("label: %s\n", n->label);

    if(n->parent == NULL)
        printf("parent: NULL\n");
    else
        printf("parent: %s\n", n->parent->label);

    printf("child_num: %zu\n", n->child_num);
    printf("child_cty: %zu\n", n->child_cty);

    if(n->child_num > 0) {
        printf("children: \n");
        for(int i = 0; i < n->child_num; i++) {
            printf("    %s\n", n->children[i]->label);
        }
    }

    printf("\n");

    return 1;
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

int parse_node_label(const char *label) {
    if(label == NULL)
        return -1;
    if(!isdigit(label[0])) {
        fprintf(stderr, "invalid label %s\n", label);
        fprintf(stderr, "card label must start with a digit\n");
        return -1;
    }
    for(int i = 0; i < strlen(label); i++) {
        if(((!isdigit(label[i]) && !isalpha(label[i]))) || isupper(label[i])) {
            printf("invalid character %c in label %s\n", label[i], label);
            fprintf(stderr, "card label must containt characters a-z and 0-9 only\n");
            return -1;
        }
    }

    return 0;
}

const char* get_card_suffix(struct node *n) {
    if(n == NULL || n->label == NULL) return NULL;

    const char *label = n->label;

    if(parse_node_label(label) < 0)
        return NULL;

    int len = strlen(label);
    int i = len - 1;

    while(i >= 0 && isdigit(label[i])) i--;

    if(i == len - 1)
        while(i >= 0 && isalpha(label[i])) i--;

    return label + i + 1;
}

void print_subtree_as_list(struct node *n) {
    printf("%s\n", n->label);
    for(int i=0; i < n->child_num; i++)
        print_subtree_as_list(n->children[i]);
}

void print_subtree_pretty(struct node *n, const char *prefix, int is_last) {
    char new_prefix[1024];

    printf("%s", prefix);

    if (is_last >= 0)
        printf("%s── ", is_last ? "└" : "├");

    printf("%s\n", n->label);

    if (is_last >= 0)
        snprintf(new_prefix, sizeof(new_prefix), "%s%s", prefix, is_last ? "    " : "│   ");
    else
        snprintf(new_prefix, sizeof(new_prefix), "%s", prefix);

    for (int i = 0; i < n->child_num; i++)
        print_subtree_pretty(n->children[i], new_prefix, i == n->child_num - 1);
}

struct node* insert_child_in_order(struct node *parent, const char *suffix) {
    if(parent == NULL) return NULL;

    char *parent_label = strdup(parent->label);

    const char *parent_suffix;

    if(strcmp(parent_label, "root") == 0) {
        if(parent->child_num > 0 ) {
            /* binary search */

            int low = 0, high = parent->child_num - 1, piv;

            while(low <= high) {
                piv = (low + high) / 2;
                if(strtol(suffix, NULL, 10) < strtol(get_card_suffix(parent->children[piv]), NULL, 10))
                    high = piv - 1;
                else if(strtol(suffix, NULL, 10) > strtol(get_card_suffix(parent->children[piv]), NULL, 10))
                    low = piv + 1;
            }

            if (parent->child_num == parent->child_cty) {
                size_t n_cty = parent->child_cty * 2;
                parent->children = realloc(parent->children, n_cty * sizeof(struct node*));
                parent->child_cty = n_cty;
            }

            memmove(&parent->children[low + 1], &parent->children[low], (parent->child_num - low) * sizeof(struct node*));
            
            parent->children[low] = malloc(sizeof(struct node));
            parent->children[low]->label = strdup(suffix);
            parent->children[low]->parent = parent;
            parent->children[low]->child_num = 0;
            parent->children[low]->child_cty = 1;
            parent->children[low]->children = NULL;

            parent->child_num++;

            return parent->children[low];
        }
        else {
            parent->children = malloc(sizeof(struct node));

            parent->children[0] = malloc(sizeof(struct node));
            parent->children[0]->label = strdup(suffix);
            parent->children[0]->parent = parent;
            parent->children[0]->child_num = 0;
            parent->children[0]->child_cty = 1;
            parent->children[0]->children = NULL;

            parent->child_num++;

            return parent->children[0];
        }
    }
    else {
        if(parse_node_label(parent_label) < 0) return NULL;
        parent_suffix = get_card_suffix(parent);

        if(isalpha(parent_suffix[0]) && isdigit(suffix[0])) {
            int i = 0;

            while(suffix[i] != '\0') {
                if(!isdigit(suffix[i])) {
                    fprintf(stderr, "invalid suffix %s\n", suffix);
                    fprintf(stderr, "in this case, it must contain digits only\n");
                    return NULL;
                } i++;
            }

            if(parent->child_num > 0 ) {
                /* binary search */

                int low = 0, high = parent->child_num - 1, piv;

                while(low <= high) {
                    piv = (low + high) / 2;
                    if(strtol(suffix, NULL, 10) < strtol(get_card_suffix(parent->children[piv]), NULL, 10))
                        high = piv - 1;
                    else if(strtol(suffix, NULL, 10) > strtol(get_card_suffix(parent->children[piv]), NULL, 10))
                        low = piv + 1;
                }

                if (parent->child_num == parent->child_cty) {
                    size_t n_cty = parent->child_cty * 2;
                    parent->children = realloc(parent->children, n_cty * sizeof(struct node*));
                    parent->child_cty = n_cty;
                }

                memmove(&parent->children[low + 1], &parent->children[low], (parent->child_num - low) * sizeof(struct node*));
                
                parent->children[low] = malloc(sizeof(struct node));
                parent->children[low]->label = strcat(parent_label, suffix);
                parent->children[low]->parent = parent;
                parent->children[low]->child_num = 0;
                parent->children[low]->child_cty = 1;
                parent->children[low]->children = NULL;

                parent->child_num++;

                return parent->children[low];
            }
            else {
                parent->children = malloc(sizeof(struct node));

                parent->children[0] = malloc(sizeof(struct node));
                parent->children[0]->label = strcat(parent_label, suffix);
                parent->children[0]->parent = parent;
                parent->children[0]->child_num = 0;
                parent->children[0]->child_cty = 1;
                parent->children[0]->children = NULL;

                parent->child_num++;

                return parent->children[0];
            }
        }
        else if(isdigit(parent_suffix[0]) && isalpha(suffix[0])) {
            int i = 0;

            while(suffix[i] != '\0') {
                if(!isalpha(suffix[i]) || isupper(suffix[i])) {
                    fprintf(stderr, "invalid suffix %s\n", suffix);
                    fprintf(stderr, "in this case, it must contain non-uppercase alphabetic characters only\n");
                    return NULL;
                } i++;
            }

            if(parent->child_num > 0 ) {
                /* binary search */

                int low = 0, high = parent->child_num - 1, piv;

                while(low <= high) {
                    piv = (low + high) / 2;
                    if(alpha_cmp(suffix, get_card_suffix(parent->children[piv])) < 0)
                        high = piv - 1;
                    else if(alpha_cmp(suffix, get_card_suffix(parent->children[piv])) > 0)
                        low = piv + 1;
                }

                if (parent->child_num == parent->child_cty) {
                    size_t n_cty = parent->child_cty * 2;
                    parent->children = realloc(parent->children, n_cty * sizeof(struct node*));
                    parent->child_cty = n_cty;
                }

                memmove(&parent->children[low + 1], &parent->children[low], (parent->child_num - low) * sizeof(struct node*));
                
                parent->children[low] = malloc(sizeof(struct node));
                parent->children[low]->label = strcat(parent_label, suffix);
                parent->children[low]->parent = parent;
                parent->children[low]->child_num = 0;
                parent->children[low]->child_cty = 1;
                parent->children[low]->children = NULL;

                parent->child_num++;

                return parent->children[low];
            }
            else {
                parent->children = malloc(sizeof(struct node));

                parent->children[0] = malloc(sizeof(struct node));
                parent->children[0]->label = strcat(parent_label, suffix);
                parent->children[0]->parent = parent;
                parent->children[0]->child_num = 0;
                parent->children[0]->child_cty = 1;
                parent->children[0]->children = NULL;

                parent->child_num++;

                return parent->children[0];
            }
        }
        else {
            fprintf(stderr, "inserting child %s%s to %s violates the card ordering\n",
                            parent_label, suffix, parent_label);
            return NULL;
        }
    }
}

int search_or_create_card_ancestors(struct node *n, const char *card) {
    if(parse_node_label(card) < 0) return -1;

    bool found;
    int i=0, start;
    char *label = strdup("");
    struct node *prev = n;

    while(card[i] != '\0') {
        found = 0;
        start = i;

        // print_node_info(prev);

        while(isdigit(card[i])) i++;
        if(i > start) {
            char *hcy = strndup(card + start, i - start);
            label = realloc(label, strlen(label) + strlen(hcy) + 1);
            label = strcat(label, hcy);

            for(int j = 0; j < prev->child_num; j++) {
                if(strcmp(prev->children[j]->label, label) == 0) {
                    prev = prev->children[j];
                    found = 1;
                    break;
                }
            }
            
            /* insert children in order */

            if(found == 0) {
                prev = insert_child_in_order(prev, hcy);
            }

            free(hcy);
        }

        ////  print_node_info(prev);

        start = i;
        if(card[i] == '\0') break;
        found = 0;

        while(isalpha(card[i])) i++;
        if(i > start) {
            char *hcy = strndup(card + start, i - start);
            label = realloc(label, strlen(label) + strlen(hcy) + 1);
            label = strcat(label, hcy);

            for(int j = 0; j < prev->child_num; j++) {
                if(strcmp(prev->children[j]->label, label) == 0) {
                    prev = prev->children[j];
                    found = 1;
                    break;
                }
            }

            if(found == 0) {
                prev = insert_child_in_order(prev, hcy);
            }

            free(hcy);
        }

        if (i == start) return -1;
    }

    free(label);

    return 0;
}

int main(int argc, char *argv[]) {
    DIR *dir;
    struct dirent *dp;
    struct node root;

    fill_root(&root);

    if(argc == 2) {
        dir = opendir(argv[1]);

        while((dp = readdir(dir)) != NULL) {
            if(strcmp(dp->d_name, ".") != 0 && strcmp(dp->d_name, "..") != 0) {
                size_t len = strlen(dp->d_name);
                if(len > 4 && strcmp(dp->d_name + len - 4, EXT) == 0) {
                    char *name = strndup(dp->d_name, len - 4);
                    // parse_node_label(name);
                    search_or_create_card_ancestors(&root, name);
                    free(name);
                }
            }
        }

        closedir(dir);

        print_subtree_pretty(&root, "", -1);
        // print_subtree_as_list(&root);
    }

    return 0;
}
