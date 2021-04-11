# Prometheus libvirt exporter

 - `Dockerfile` - creates a docker container with dynamically linked libvirt-exporter. Make an image and run with `docker container run -p9177:9177 -v /var/run/libvirt:/var/run/libvirt yourcontainername`. Based on the latest golang:alpine.
 - `build-with` - builds dynamically linked libvirt-exporter in the container based on Dockerfile specified as an argument. Ex.: `build-with ./build_container/Dockerfile.ubuntu2004` will build libvirt-exporter for Ubuntu 20.04.

# Metrics
The following metrics/labels are being exported:

```
libvirt_domain_block_meta{bus="...",cache="...",discard="...",disk_type="...",domain="...",driver_type="...",serial="...",source_file="...",target_device="..."}
libvirt_domain_block_stats_allocation{domain="-...",target_device="..."}
libvirt_domain_block_stats_capacity{domain="-...",target_device="..."}
libvirt_domain_block_stats_flush_requests_total{domain="-...",target_device="..."}
libvirt_domain_block_stats_flush_time_seconds_total{domain="-...",target_device="..."}
libvirt_domain_block_stats_physicalsize_bytes{domain="-...",target_device="..."}
libvirt_domain_block_stats_read_bytes_total{domain="-...",target_device="..."}
libvirt_domain_block_stats_read_requests_total{domain="-...",target_device="..."}
libvirt_domain_block_stats_read_time_seconds_total{domain="-...",target_device="..."}
libvirt_domain_block_stats_write_bytes_total{domain="-...",target_device="..."}
libvirt_domain_block_stats_write_requests_total{domain="-...",target_device="..."}
libvirt_domain_block_stats_write_time_seconds_total{domain="-...",target_device="..."}

libvirt_domain_info_cpu_time_seconds_total{domain="-..."}
libvirt_domain_info_maximum_memory_bytes{domain="-..."}
libvirt_domain_info_memory_usage_bytes{domain="-..."}
libvirt_domain_info_meta{domain="...",flavor="...",instance_name="...",project_name="...",project_uuid="...",root_type="...",root_uuid="...",user_name="...",user_uuid="...",uuid="..."}
libvirt_domain_info_virtual_cpus{domain="..."}
libvirt_domain_info_vstate{domain="..."}

libvirt_domain_interface_meta{virtual_interface="...",domain="...",source_bridge="...",target_device="..."}
libvirt_domain_interface_stats_receive_bytes_total{domain="...",target_device="..."}
libvirt_domain_interface_stats_receive_drops_total{domain="...",target_device="..."}
libvirt_domain_interface_stats_receive_errors_total{domain="...",target_device="..."}
libvirt_domain_interface_stats_receive_packets_total{domain="...",target_device="..."}
libvirt_domain_interface_stats_transmit_bytes_total{domain="...",target_device="..."}
libvirt_domain_interface_stats_transmit_drops_total{domain="...",target_device="..."}
libvirt_domain_interface_stats_transmit_errors_total{domain="...",target_device="..."}
libvirt_domain_interface_stats_transmit_packets_total{domain="...",target_device="..."}

libvirt_domain_memory_stats_actual_balloon_bytes{domain="..."}
libvirt_domain_memory_stats_available_bytes{domain="..."}
libvirt_domain_memory_stats_disk_cache_bytes{domain="..."}
libvirt_domain_memory_stats_major_fault_total{domain="..."}
libvirt_domain_memory_stats_minor_fault_total{domain="..."}
libvirt_domain_memory_stats_rss_bytes{domain="..."}
libvirt_domain_memory_stats_unused_bytes{domain="..."}
libvirt_domain_memory_stats_usable_bytes{domain="..."}
libvirt_domain_memory_stats_used_percent{domain="..."}

libvirt_up
```

# Historical
Project forked from https://github.com/kumina/libvirt_exporter and substantially rewritten.
Implemented support for several additional metrics, ceph rbd (and network block devices), ovs.
Implemented statistics collection using GetAllDomainStats

And then forked again from https://github.com/rumanzo/libvirt_exporter_improved and rewritten.
Implemented meta metrics and more info about disks, interfaces and domain.

This repository provides code for a Prometheus metrics exporter
for [libvirt](https://libvirt.org/). This exporter connects to any
libvirt daemon and exports per-domain metrics related to CPU, memory,
disk and network usage. By default, this exporter listens on TCP port
9177.

This exporter makes use of
[libvirt-go](https://github.com/libvirt/libvirt-go), the official Go
bindings for libvirt. This exporter make use of the
`GetAllDomainStats()`

