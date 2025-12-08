#include "ram.h"
#include "../sketchybar.h"

int main (int argc, char** argv) {
  float update_freq;
  if (argc < 3 || (sscanf(argv[2], "%f", &update_freq) != 1)) {
    printf("Usage: %s \"<event-name>\" \"<event_freq>\"\n", argv[0]);
    exit(1);
  }

  alarm(0);
  ram_info_t ram;

  // Setup the event in sketchybar
  char event_message[512];
  snprintf(event_message, 512, "--add event '%s'", argv[1]);
  sketchybar(event_message);

  char trigger_message[512];
  for (;;) {
    // Acquire new info
    get_ram_info(&ram);

    // Prepare the event message
    snprintf(trigger_message,
             512,
             "--trigger '%s' used_ram='%llu' free_ram='%02llu' used_percent='%02u'",
             argv[1],
             ram.used_memory,
             ram.free_memory,
             ram.usage_percent                                       );

    // Trigger the event
    sketchybar(trigger_message);

    // Wait
    usleep(update_freq * 1000000);
  }
  return 0;
}
