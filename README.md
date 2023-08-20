# terraform-aws-dragondrop-compute
Terraform code for deploying the compute resources needed to run dragondrop.cloud within your Google Cloud environment.

![GCP infrastructure diagram](./images/2023-03-27%20GCP%20Module%20Infrastructure.png)
Cloud architecture diagram of the infrastructure created by this module.

## Variables

| Name                                       | Type   | Purpose                                                                                                                                                  |
|--------------------------------------------|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| _**dragondrop_engine_cloud_run_job_name**_ | string | Name of the Cloud Run Job created by the Module which hosts the OSS cloud-concierge container.                                                           |
| _**https_trigger_cloud_run_service_name**_ | string | Name of the Cloud Run Service created by the Module which serves as an HTTPS endpoint.                                                                   |
| **_project_**                              | string | GCP project into which resources should be deployed.                                                                                                     |
| **_region_**                               | string | GCP region into which resources should be deployed.                                                                                                      |
| **_service_account_name_**                 | string | Name of the service account with exclusively Cloud Run Job invocation privileges that serves as the service account for the HTTPS trigger Cloud Run Job. |
| **_gcs_state_bucket_**                     | string | Optional name of the GCS storage bucket used for storing Terraform state backend files read by the cloud-concierge container.                            |


## How to Use this Module
This module defines the compute resources needed to run dragondrop within your own GCP environment.

It defines a [Cloud Run Service](https://github.com/dragondrop-cloud/cloud-run-job-http-trigger) that can
evoke the longer running dragondrop engine living in a provisioned Cloud Run Job.

The url for this Cloud Run Service is output and should be passed to a dragondrop [Job](https://docs.dragondrop.cloud/product-docs/getting-started/creating-a-job)
definition as that Job's "HTTPS Url".

The Cloud Run Job hosts the [cloud-concierge](https://github.com/dragondrop-cloud/cloud-concierge) container. All environment
variables are set by the dragondrop platform, except for a VCS personal access token stored in Google Secrets manager and an optional
Terraform Cloud organization token.

### Security When Using This Module
This module creates two IAM roles.

1) "dragondrop HTTPS Trigger Role" which has the minimum permissions needed to evoke
Cloud Run Jobs. This role is assigned to a new service account, and that service account is the service account used by both the
Cloud Run Service.

2) "cloud-concierge-execution-role" is granted Secret Accessor privileges on only the secrets referenced by the Cloud Run Job as
environment variables, read-only access to the cloud environment, and optionally, read-only access to the GCS bucket used for Terraform state.
This role is used by the Cloud Run Job that hosts the cloud-concierge container.

## What is dragondrop.cloud?
[dragondrop.cloud](https://dragondrop.cloud) is a provider of IAC automation solutions, of which the flagship is the OSS
[cloud-concierge](https://github.com/dragondrop-cloud/cloud-concierge) container.
For more information or to schedule a demo, please visit our website.

## What's a Module?
A Module is a reusable, best-practices definition for the deployment of cloud infrastructure. 
A Module is written using Terraform and includes documentation, and examples.
It is maintained both by the open source community and companies that provide commercial support.

## How can I contribute to this module?
If you notice a problem or would like some additional functionality, please open a detailed issue describing
the problem or open a pull request.

### License
Please see [LICENSE](LICENSE) for details on this module's license.

Copyright © 2023 dragondrop.cloud, Inc.
