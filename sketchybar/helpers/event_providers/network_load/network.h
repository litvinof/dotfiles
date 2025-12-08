#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/time.h>

static char unit_str[3][6] = { { " Bps" }, { "KBps" }, { "MBps" }, };

enum unit {
  UNIT_BPS,
  UNIT_KBPS,
  UNIT_MBPS
};

struct network {
  char ifname[16];
  struct timeval tv_nm1, tv_n, tv_delta;
  uint64_t ibytes_prev;
  uint64_t obytes_prev;

  int up;
  int down;
  enum unit up_unit, down_unit;
};

static inline void network_init(struct network* net, char* ifname) {
  memset(net, 0, sizeof(struct network));
  strncpy(net->ifname, ifname, sizeof(net->ifname) - 1);

  // Get initial byte counts
  char cmd[256];
  snprintf(cmd, sizeof(cmd), "netstat -I %s -b | tail -1", ifname);
  FILE* fp = popen(cmd, "r");
  if (fp) {
    char line[512];
    if (fgets(line, sizeof(line), fp)) {
      // Parse: Name Mtu Network Address Ipkts Ierrs Ibytes Opkts Oerrs Obytes Coll
      // Note: Ierrs, Oerrs, Coll might be "-" instead of numbers
      char name[16], network[64], address[64];
      unsigned long long ipkts, ibytes, opkts, obytes;
      int mtu;
      if (sscanf(line, "%s %d %s %s %llu %*s %llu %llu %*s %llu",
                 name, &mtu, network, address, &ipkts, &ibytes, &opkts, &obytes) >= 8) {
        net->ibytes_prev = ibytes;
        net->obytes_prev = obytes;
      }
    }
    pclose(fp);
  }
  gettimeofday(&net->tv_nm1, NULL);
}

static inline void network_update(struct network* net) {
  gettimeofday(&net->tv_n, NULL);
  timersub(&net->tv_n, &net->tv_nm1, &net->tv_delta);
  net->tv_nm1 = net->tv_n;

  double time_scale = (net->tv_delta.tv_sec + 1e-6*net->tv_delta.tv_usec);
  if (time_scale < 1e-6 || time_scale > 1e2) return;

  // Get current byte counts from netstat
  char cmd[256];
  snprintf(cmd, sizeof(cmd), "netstat -I %s -b | tail -1", net->ifname);
  FILE* fp = popen(cmd, "r");
  if (!fp) return;

  char line[512];
  uint64_t ibytes = net->ibytes_prev;
  uint64_t obytes = net->obytes_prev;

  if (fgets(line, sizeof(line), fp)) {
    char name[16], network[64], address[64];
    unsigned long long ipkts, ib, opkts, ob;
    int mtu;
    if (sscanf(line, "%s %d %s %s %llu %*s %llu %llu %*s %llu",
               name, &mtu, network, address, &ipkts, &ib, &opkts, &ob) >= 8) {
      ibytes = ib;
      obytes = ob;
    }
  }
  pclose(fp);

  // Calculate deltas and rates
  double delta_ibytes = (double)(ibytes - net->ibytes_prev) / time_scale;
  double delta_obytes = (double)(obytes - net->obytes_prev) / time_scale;

  net->ibytes_prev = ibytes;
  net->obytes_prev = obytes;

  double exponent_ibytes = (delta_ibytes > 0) ? log10(delta_ibytes) : 0;
  double exponent_obytes = (delta_obytes > 0) ? log10(delta_obytes) : 0;

  if (exponent_ibytes < 3) {
    net->down_unit = UNIT_BPS;
    net->down = delta_ibytes;
  } else if (exponent_ibytes < 6) {
    net->down_unit = UNIT_KBPS;
    net->down = delta_ibytes / 1000.0;
  } else if (exponent_ibytes < 9) {
    net->down_unit = UNIT_MBPS;
    net->down = delta_ibytes / 1000000.0;
  }

  if (exponent_obytes < 3) {
    net->up_unit = UNIT_BPS;
    net->up = delta_obytes;
  } else if (exponent_obytes < 6) {
    net->up_unit = UNIT_KBPS;
    net->up = delta_obytes / 1000.0;
  } else if (exponent_obytes < 9) {
    net->up_unit = UNIT_MBPS;
    net->up = delta_obytes / 1000000.0;
  }
}
