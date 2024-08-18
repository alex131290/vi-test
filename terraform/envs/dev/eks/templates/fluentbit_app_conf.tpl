[INPUT]
  Name tail
  Tag application.*
  Exclude_Path /var/log/containers/cloudwatch-agent*, /var/log/containers/fluent-bit*, /var/log/containers/aws-node*, /var/log/containers/kube-proxy*, /var/log/containers/aws-for-fluent-bit*
  Path /var/log/containers/*.log
  multiline.parser docker, cri
  DB /var/fluent-bit/state/flb_container.db
  Mem_Buf_Limit 50MB
  Skip_Long_Lines On
  Refresh_Interval 10
  Rotate_Wait 30
  storage.type filesystem
  Read_from_Head Off

[INPUT]
  Name tail
  Tag application.*
  Path /var/log/containers/cloudwatch-agent*
  multiline.parser docker, cri
  DB /var/fluent-bit/state/flb_cwagent.db
  Mem_Buf_Limit 5MB
  Skip_Long_Lines On
  Refresh_Interval 10
  Read_from_Head Off

[FILTER]
  Name                kubernetes
  Match               application.*
  Kube_URL            https://kubernetes.default.svc:443 
  Kube_Tag_Prefix     application.var.log.containers.
  Merge_Log           On
  Merge_Log_Key       log_processed
  K8S-Logging.Parser  On
  K8S-Logging.Exclude Off
  Labels              On
  Annotations         On
  Buffer_Size         0


[OUTPUT]
  Name                cloudwatch_logs
  Match               application.*
  region              $$${AWS_REGION}
  log_group_name      /aws/containerinsights/services-dev/application-default
  log_group_template  /aws/containerinsights/services-dev/$kubernetes['namespace_name'].$kubernetes['labels']['app']
  log_stream_prefix   $$${HOSTNAME}-
  log_stream_template $kubernetes['pod_name'].$kubernetes['container_name']
  log_retention_days  90
  auto_create_group   true
  extra_user_agent    container-insights
  log_key             log
