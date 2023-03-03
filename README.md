# dragondrop Self-Hosting Compute
Terraform code for deploying the compute resources needed to run dragondrop.cloud within your Google Cloud environment.

## How to Use this Module
This module defines the compute resources needed to run dragondrop within your own cloud environment.

It defines a [Cloud Run Service](https://github.com/dragondrop-cloud/cloud-run-job-http-trigger) that can
evoke the longer running dragondrop engine living in a provisioned Cloud Run Job.

The url for this Cloud Run Service is output and should be passed to a dragondrop [Job](https://docs.dragondrop.cloud/product-docs/getting-started/creating-a-job)
definition as that Job's "HTTPS Url".

The Cloud Run Job hosts dragondrop's proprietary container. All environment variables that need to be configured are references
to secrets within Google Secret Manager, and can be customized like any other secret.

### Security When Using This Module
This module creates a new IAM role, "dragondrop HTTPS Trigger Role" which has the minimum permissions needed to evoke
Cloud Run Jobs. This role is assigned to a new service account, and that service account is the service account used by both the
Cloud Run Service and Cloud Run Job provisioned by this module.

Lastly, that service account is granted Secret Accessor privileges on only the secrets referenced by the Cloud Run Job as
environment variables.

## What is dragondrop.cloud?
[dragondrop.cloud](https://dragondrop.cloud) is a provider of IAC automation solutions that are self-hosted
within customer's cloud environment. For more information or to schedule a demo, please visit our website.

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
