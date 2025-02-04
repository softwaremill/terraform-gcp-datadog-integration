resource "google_monitoring_notification_channel" "email" {
  for_each     = toset(var.alerting_notify_emails)
  display_name = split("@", each.value)[0]
  type         = "email"
  labels = {
    email_address = each.value
  }

  force_delete = true
}


resource "google_monitoring_alert_policy" "log_processing_lag" {
  display_name = "GCP datadog audit - old unacked messages"
  combiner     = "OR"
  severity     = "WARNING"

  conditions {
    display_name = "Oldest unacked message is older than 5 minutes"
    condition_prometheus_query_language {
      query               = "max(avg_over_time(pubsub_googleapis_com:subscription_oldest_unacked_message_age{monitored_resource=\"pubsub_subscription\",project_id=\"${var.project_id}\",subscription_id=\"${google_pubsub_subscription.datadog_topic_sub.name}\"}[5m])) > 300"
      duration            = "600s"
      evaluation_interval = "60s"
      alert_rule          = "AlwaysOn"
      rule_group          = "Log Processing issues"
    }
  }
  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    subject = "Datadog integration: old unacked messages"
    content = "Stream processing is bound by the processing latency and the overal lag. Since we have old unacked messages in a queue then likely dataflow workers are lagging or crashed. Inspec them. Perform adjustments if necessary."
  }

  notification_channels = [for channel in google_monitoring_notification_channel.email : channel.id]
  depends_on            = [ google_monitoring_notification_channel.email ]
}


resource "google_monitoring_alert_policy" "events_arriving_in_dlq" {
  display_name = "GCP datadog audit - dlq growing"
  combiner     = "OR"
  severity     = "WARNING"

  conditions {
    display_name = "Events arriving in dlq"
    condition_prometheus_query_language {
      query               = "rate(pubsub_googleapis_com:topic_send_message_operation_count{monitored_resource=\"pubsub_topic\",project_id=\"${var.project_id}\",topic_id=\"${google_pubsub_topic.output_dead_letter.id}\"}[5m]) > 0"
      duration            = "600s"
      evaluation_interval = "60s"
      alert_rule          = "AlwaysOn"
      rule_group          = "Log Processing issue"
    }
  }

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    subject = "Datadog integration: dlq growing"
    content = "DLQ is receiving events because dataflow is unable to consume in a given timeslot. Check the dataflow and make sure it's working and having sufficient capacity."
  }

  notification_channels = [for channel in google_monitoring_notification_channel.email : channel.id]
  depends_on            = [ google_monitoring_notification_channel.email ]
}

