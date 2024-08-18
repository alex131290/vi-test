[SERVICE]
  Flush 5
  Grace 30
  Log_Level info
  Daemon off
  Parsers_File parsers.conf
  HTTP_Server On
  HTTP_Listen [::0]
  HTTP_Port 2020
  storage.path /var/fluent-bit/state/flb-storage/
  storage.sync normal
  storage.checksum off
  storage.backlog.mem_limit 5M

@INCLUDE application-log.conf
@INCLUDE dataplane-log.conf
@INCLUDE host-log.conf
