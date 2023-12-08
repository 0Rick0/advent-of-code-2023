#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdint.h>
#ifdef __APPLE__
// implement reallocaray on mac os
#include <errno.h>
#define MUL_NO_OVERFLOW ((size_t)1 << (sizeof(size_t) * 4))
void *reallocarray(void *optr, size_t nmemb, size_t size) {
    if ((nmemb >= MUL_NO_OVERFLOW || size >= MUL_NO_OVERFLOW) &&
         nmemb > 0 && SIZE_MAX / nmemb < size) {
        errno = ENOMEM;
        return NULL;
    }
    return realloc(optr, size * nmemb);
}

#endif


typedef struct {
    u_int64_t source_start;
    u_int64_t target_start;
    u_int64_t length;
} single_mapping_t;

typedef struct {
    char *from;
    char *to;
    size_t count;
    single_mapping_t *mappings;
} mapping_t;

typedef struct {
    char *name;
    size_t nseeds;
    u_int64_t *seeds;
} seeds_t;

typedef struct {
    seeds_t seeds;
    size_t mapping_count;
    mapping_t *mappings;
} almanac_t;

#define IS_IN_SOURCE_MAPPING(mapping, value) (value >= mapping.source_start && value < (mapping.source_start + mapping.length))

void parse_seeds_line(almanac_t *almanac, char *name, char *numbers) {
    almanac->seeds.name = strdup(name);

    char *rest_numbers = numbers;
    while (isspace(*rest_numbers)) rest_numbers++; // remove extra whitespace
    char *part;
    size_t count = 0;
    do {
        part = strsep(&rest_numbers, " ");
        count++;
        almanac->seeds.seeds = reallocarray(almanac->seeds.seeds, count, sizeof(u_int64_t));
        almanac->seeds.seeds[count - 1] = strtoll(part, NULL, 10);
    } while (rest_numbers != NULL);
    almanac->seeds.nseeds = count;
}

void parse_mapping_start_line(almanac_t *almanac, char *mapping) {
    char from[64];
    char to[64];
    if (sscanf(mapping, "%[^- ]-to-%[^- ] map", from, to) != 2) {
        fprintf(stderr, "Could not parse mapping line\n");
        exit(1);
    }
    almanac->mapping_count++;
    almanac->mappings = reallocarray(almanac->mappings, almanac->mapping_count, sizeof(mapping_t));
    if (almanac->mappings == NULL) {
        exit(1);
    }

    almanac->mappings[almanac->mapping_count - 1].from = strdup(from);
    almanac->mappings[almanac->mapping_count - 1].to = strdup(to);
    almanac->mappings[almanac->mapping_count - 1].count = 0;
    almanac->mappings[almanac->mapping_count - 1].mappings = NULL;
}

void parse_mapping_line(almanac_t *almanac, char *line) {
    char *mline = line;
    char *destination = strsep(&mline, " ");
    char *source = strsep(&mline, " ");
    char *length = mline;
    u_int64_t destination_i = strtoll(destination, NULL, 10);
    u_int64_t source_i = strtoll(source, NULL, 10);
    u_int64_t length_i = strtoll(length, NULL, 10);

    mapping_t *mapping = &almanac->mappings[almanac->mapping_count - 1];
    mapping->count++;
    mapping->mappings = reallocarray(mapping->mappings, mapping->count, sizeof(single_mapping_t));
    if (mapping->mappings == NULL) {
        exit(1);
    }
    mapping->mappings[mapping->count - 1].source_start = source_i;
    mapping->mappings[mapping->count - 1].target_start = destination_i;
    mapping->mappings[mapping->count - 1].length = length_i;

}

enum estate {
    STATE_START,
    STATE_MAP,
};

mapping_t *find_mapping_from(almanac_t *almanac, char *type) {
    for (int i = 0; i < almanac->mapping_count; ++i) {
        if (strcmp(almanac->mappings[i].from, type) == 0) {
            return &almanac->mappings[i];
        }
    }
    return NULL;
}

inline u_int64_t mapping_map(mapping_t* mapping, u_int64_t value) {
    for (int i = 0; i < mapping->count; ++i) {
        if (IS_IN_SOURCE_MAPPING(mapping->mappings[i], value)) {
            return value - mapping->mappings[i].source_start + mapping->mappings[i].target_start;
        }
    }
    return value;
}

u_int64_t map_to_target(almanac_t *almanac, char *current_type, char* target_type, u_int64_t current_value, int depth) {
    if (strcmp(current_type, target_type) == 0) {
        return current_value;
    }
//    mapping_t *mapping = find_mapping_from(almanac, current_type);
    mapping_t *mapping = &almanac->mappings[depth];
    if (mapping == NULL) {
        exit(1);
    }
    u_int64_t target_value = mapping_map(mapping, current_value);
    return map_to_target(almanac, mapping->to, target_type, target_value, depth + 1);
}

int main(int argc, char **argv) {
//    FILE *inputFile = fopen("sample-input.txt", "r");
    FILE *inputFile = fopen("input.txt", "r");
    if (inputFile == NULL) {
        perror("Could not open file");
        return 1;
    }

    almanac_t almanac = {
            .seeds.nseeds = 0,
            .seeds.seeds = NULL,
            .seeds.name = NULL,
            .mapping_count = 0,
            .mappings = NULL,
    };

    char *line = NULL;
    size_t len = 0;
    ssize_t read;
    enum estate state = STATE_START;
    while ((read = getline(&line, &len, inputFile)) > 0) {
        char *c = line;
        while (isspace(*c)) c++; // ltrim

        if (state == STATE_START) {
            if (*c == '\0') continue; // empty line

            char *name = strsep(&c, ":");
            if (strstr(name, "map") == NULL) {
                parse_seeds_line(&almanac, name, c);
            } else {
                state = STATE_MAP;
                parse_mapping_start_line(&almanac, name);
            }
        } else if (state == STATE_MAP) {
            if (*c == '\0') {
                state = STATE_START;
                continue;
            }
            parse_mapping_line(&almanac, c);
        }
    }
    free(line);

    // Solution 1
    {
        u_int64_t smallest_value = UINT64_MAX;
        for (int i = 0; i < almanac.seeds.nseeds; ++i) {
            u_int64_t target_value = map_to_target(&almanac, "seed", "location", almanac.seeds.seeds[i], 0);
            smallest_value = target_value < smallest_value ? target_value : smallest_value;
        }
        printf("Smallest value %lu\n", smallest_value);
    }
    // Solution 2
    {
        u_int64_t smallest_value = UINT64_MAX;
        for (int i = 0; i < almanac.seeds.nseeds; i += 2) {
            // can probably be optimized by using something like a set
            uint64_t start = almanac.seeds.seeds[i];
            uint64_t count = almanac.seeds.seeds[i + 1];
            printf("Checking %lu to %lu (%lu)\n", start, start + count, count);
            for (uint64_t j = start; j < start + count; ++j) {
                u_int64_t target_value = map_to_target(&almanac, "seed", "location", j, 0);
//                printf("Start %lu -> %lu\n", j, target_value);
                smallest_value = target_value < smallest_value ? target_value : smallest_value;
            }
        }
        printf("Smallest value %lu\n", smallest_value);
    }
}
