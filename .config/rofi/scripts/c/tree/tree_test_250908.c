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
    n->children = NULL;
}

struct node* create_child(struct node *parent, char *label) {
    int i = parent->child_num++;
    if(parent->child_num == parent->child_cty) {
        size_t n_size = 2 * parent->child_cty;
        parent->child_cty = n_size;
        parent->children = realloc(parent->children, n_size * sizeof(struct node*));
    }
    parent->children[i] = malloc(sizeof(struct node));
    parent->children[i]->label = strdup(label);
    parent->children[i]->parent = parent;
    parent->children[i]->child_num = 0;
    parent->children[i]->child_cty = 1;
    parent->children[i]->children = NULL;

    return parent->children[i];
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

    return 1;
}

const char* get_card_suffix(struct node *n) {
    if(n == NULL || n->label == NULL)
        return NULL;

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

int search_or_create_card_ancestors(struct node *n, const char *card) {
    if(parse_node_label(card) < 0) return -1;

    bool found;
    int i=0, depth=0, start;
    char *hcy, *label = strdup("");
    struct node *prev = n;

    while(card[i] != '\0') {
        // printf("Ciclo en bucle\n");
        found = 0;
        start = i;

        while(isdigit(card[i])) i++;
        if(i > start) {
            hcy = strndup(card + start, i - start);
            char *old = label;
            asprintf(&label, "%s%s", old, hcy);
            free(old);
            // label = realloc(label, strlen(label) + strlen(hcy) + 1);
            // strcat(label, hcy);
            // printf("Hierarchy: %s\n", hcy);
            // printf("Current node: %s\n", prev->label);
            // printf("Calculated label: %s\n", label);

            for(int j = 0; j < prev->child_num; j++) {
                if(strcmp(prev->children[j]->label, label) == 0) {
                    // printf("Found family %s\n", label);
                    prev = prev->children[j];
                    found = 1;
                    break;
                }
            }
            
            if(found == 0) {
                if(prev->child_num > 0 ) {
                    int low = 0, high = prev->child_num - 1, piv;

                    while(low <= high) {
                        piv = (low + high) / 2;
                        if(strtol(hcy, NULL, 10) < strtol(get_card_suffix(prev->children[piv]), NULL, 10))
                            high = piv - 1;
                        else if(strtol(hcy, NULL, 10) > strtol(get_card_suffix(prev->children[piv]), NULL, 10))
                            low = piv + 1;
                    }
                    // printf("insert index: %d\n", low);

                    if (prev->child_num == prev->child_cty) {
                        size_t n_cty = prev->child_cty ? prev->child_cty * 2 : 1;
                        void *tmp = realloc(prev->children, n_cty * sizeof *prev->children);
                        if(!tmp) {
                            perror("realloc");
                            exit(EXIT_FAILURE);
                        }
                        prev->children = tmp;
                        prev->child_cty = n_cty;
                    }

                    memmove(&prev->children[low + 1], &prev->children[low], (prev->child_num - low) * sizeof(struct node*));
                    
                    struct node *new_node = malloc(sizeof(struct node));
                    new_node->label = strdup(label);
                    new_node->parent = prev;
                    new_node->child_num = 0;
                    new_node->child_cty = 1;
                    new_node->children = NULL;

                    prev->children[low] = new_node;
                    prev->child_num++;
                    prev = new_node;
                }
                else {
                    prev = create_child(prev, label);
                }
            }

            free(hcy);
            depth++;
        }

        start = i;
        if(card[i] == '\0') break;
        found = 0;

        while(isalpha(card[i])) i++;
        if(i > start) {
            hcy = strndup(card + start, i - start);
            char *old = label;
            asprintf(&label, "%s%s", old, hcy);
            free(old);
            // label = realloc(label, strlen(label) + strlen(hcy) + 1);
            // strcat(label, hcy);
            // printf("Hierarchy: %s\n", hcy);
            // printf("Current node: %s\n", prev->label);
            // printf("Calculated label: %s\n", label);

            for(int j = 0; j < prev->child_num; j++) {
                if(strcmp(prev->children[j]->label, label) == 0) {
                    // printf("Found family %s\n", label);
                    prev = prev->children[j];
                    found = 1;
                    break;
                }
            }

            if(found == 0) {
                if(prev->child_num > 0 ) {
                    int low = 0, high = prev->child_num - 1, piv;

                    while(low <= high) {
                        piv = (low + high) / 2;
                        if(alpha_cmp(hcy, get_card_suffix(prev->children[piv])) < 0)
                            high = piv - 1;
                        else if(alpha_cmp(hcy, get_card_suffix(prev->children[piv])) > 0)
                            low = piv + 1;
                    }

                    if (prev->child_num == prev->child_cty) {
                        size_t n_cty = prev->child_cty ? prev->child_cty * 2 : 1;
                        void *tmp = realloc(prev->children, n_cty * sizeof *prev->children);
                        if(!tmp) {
                            perror("realloc");
                            exit(EXIT_FAILURE);
                        }
                        prev->children = tmp;
                        prev->child_cty = n_cty;
                    }

                    memmove(&prev->children[low + 1], &prev->children[low], (prev->child_num - low) * sizeof(struct node*));
                    
                    struct node *new_node = malloc(sizeof(struct node));
                    new_node->label = strdup(label);
                    new_node->parent = prev;
                    new_node->child_num = 0;
                    new_node->child_cty = 1;
                    new_node->children = NULL;

                    prev->children[low] = new_node;
                    prev->child_num++;
                    prev = new_node;
                }
                else {
                    prev = create_child(prev, label);
                }
            }

            free(hcy);
            depth++;
        }


        if (i == start) {
            fprintf(stderr, "Parse error en %s cerca de '%c'\n", card, card[i]);
            return -1;
        }
    }

    // printf("depth: %d\n", depth);

    free(label);
    return 0;
}

int main(int argc, char *argv[]) {
    DIR *dir;
    struct dirent *dp;
    struct node root;

    fill_root(&root);

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

    return 0;
}
