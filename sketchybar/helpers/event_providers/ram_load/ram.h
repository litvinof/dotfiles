#include <stdio.h>
#include <unistd.h>
#include <mach/mach.h>
#include <mach/mach_host.h>

// Struct to hold all RAM information
typedef struct {
    unsigned long long free_memory;
    unsigned long long used_memory;
    unsigned long long cached_memory;
    unsigned long long total_memory;
    unsigned long long active_memory;
    unsigned long long inactive_memory;
    unsigned long long wired_memory;
    unsigned long long compressed_memory;
    unsigned long long file_cache;
    unsigned long long purgeable_memory;
    unsigned int usage_percent;
    unsigned int cache_percent;
} ram_info_t;


int get_ram_info(ram_info_t *ram) {
    if (ram == NULL) {
        return -1;
    }
    
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics64_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics64_data_t vm_stat;
    
    // Get the page size
    host_page_size(host_port, &page_size);
    
    // Get VM statistics
    if (host_statistics64(host_port, HOST_VM_INFO64, (host_info64_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        fprintf(stderr, "Failed to get VM statistics\n");
        return -1;
    }
    
    // Calculate memory in bytes and store in struct
    ram->free_memory = (unsigned long long)vm_stat.free_count * page_size;
    ram->active_memory = (unsigned long long)vm_stat.active_count * page_size;
    ram->inactive_memory = (unsigned long long)vm_stat.inactive_count * page_size;
    ram->wired_memory = (unsigned long long)vm_stat.wire_count * page_size;
    ram->compressed_memory = (unsigned long long)vm_stat.compressor_page_count * page_size;
    ram->file_cache = (unsigned long long)vm_stat.external_page_count * page_size;
    ram->purgeable_memory = (unsigned long long)vm_stat.purgeable_count * page_size;
    
    // Calculate cached memory (file cache + purgeable)
    ram->cached_memory = ram->file_cache + ram->purgeable_memory;
    
    // Calculate total used and free (excluding cache from used memory)
    ram->used_memory = ram->active_memory + ram->inactive_memory + ram->wired_memory + ram->compressed_memory - ram->cached_memory;
    ram->total_memory = ram->used_memory + ram->free_memory + ram->cached_memory;
    
    // Calculate percentages (rounded up)
    ram->usage_percent = (unsigned int)((ram->used_memory * 100.0 / ram->total_memory) + 0.5);
    ram->cache_percent = (unsigned int)((ram->cached_memory * 100.0 / ram->total_memory) + 0.5);
    
    return 0;
}
