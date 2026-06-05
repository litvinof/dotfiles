#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef struct {
    char temp[32];
    char condition[64];
} weather_info_t;

int get_weather_info(weather_info_t *weather) {
    if (weather == NULL) return -1;

    FILE *fp = popen("curl -s --max-time 10 'wttr.in/Berlin?format=%t|%C'", "r");
    if (fp == NULL) return -1;

    char buf[256];
    if (fgets(buf, sizeof(buf), fp) == NULL) {
        pclose(fp);
        return -1;
    }
    pclose(fp);

    // Remove trailing newline
    size_t len = strlen(buf);
    if (len > 0 && buf[len - 1] == '\n') buf[len - 1] = '\0';

    // Parse "temp|condition"
    char *sep = strchr(buf, '|');
    if (sep == NULL) return -1;

    *sep = '\0';

    strncpy(weather->temp, buf, sizeof(weather->temp) - 1);
    weather->temp[sizeof(weather->temp) - 1] = '\0';
    strncpy(weather->condition, sep + 1, sizeof(weather->condition) - 1);
    weather->condition[sizeof(weather->condition) - 1] = '\0';

    return 0;
}
