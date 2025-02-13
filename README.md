# Log Collection Integration - Google Cloud Platform to Datadog

This repo is a fork of https://github.com/GoogleCloudPlatform/terraform-gcp-datadog-integration by * **Diego González** - [diegonz2](https://github.com/diegonz2)
The original module was extended with mandatory audit logging. 

This Terraform module automates the integration between **Google Cloud Platform and Datadog for Log collection**, making the process faster and more efficient.  It builds upon the foundational overview provided in the official [Datadog guide](https://docs.datadoghq.com/integrations/google_cloud_platform/#log-collection). The module simplifies integration, accelerates implementation, and addresses essential security considerations for a successful observability strategy.

While this module provides security foundational principles, it's essential to note that in highly sensitive or production Google Cloud environments, additional layers of security and design principles should be thoughtfully analyzed and applied to uphold the highest standards of data protection and security principles (e.g. Utilize a bucket for TF state backup and encryption, egress traffic flow analysis, apply the module across various folders, disruption analysis, etc).

These deployment scripts are provided 'as is', without warranty. See [Copyright & License](https://github.com/googlecloudplatform/terraform-gcp-datadog-integration/blob/main/LICENSE).

## Original solution diagram

![Image alt text](gcp-to-datadog-diagram.png)

## Deployment prereq

1. This module needs a subnet with google private access enabled, this is expected to happen outside
2. In order to use folder sinks deployer must be granted following permissions to the folder:

```
logging.sinks.create
logging.sinks.delete
logging.sinks.get
logging.sinks.list
logging.sinks.update
resourcemanager.folders.get
resourcemanager.folders.getIamPolicy
resourcemanager.folders.setIamPolicy
```

3. In order to deploy this code deployer must be able to:
- enable api's
- create s3 buckets
- manage dataflow jobs
- manage pubsub topics and subscriptions
- manage alerts and notifications

Likely it's good to grant project owner, at least temporarly.

4. Datadog api key secret must be created manually. Keep in mind to create it in a location used for the deployment.


## How to deploy it

1. Create datadog api key using export sa : `dataflow-datadog-export-sa@<project_id>.iam.gserviceaccount.com`.
2. Review `variables.tf` and prepare the list of variables to parametrize the module.
3. Make sure that GCP secret containing a valid Datadog api key exists in a correct location.
4. Standard deploy using terraform.


## Cost anticipation history

Today (05.02.2025) i have started this setup on my empty sandbox account with a signle e2-small as dataflow processor node.
Estimated monthly cost based on cost tab on the dataflow object is ~110USD.

## Basic checks on the integration state

1. Open pub/sub subscription for the main (non dlq) topic.
2. Make sure that `Oldest unacked message age` is within the reasonable limits.
3. Open the dlq topic statistics. Make sure that `Published message count` is zero or none.

