# Google Dragondrop Self-Hosting Compute
Terraform code for deploying the compute services needed to run dragondrop.cloud within your cloud.

## How to Use this Module
This module defines the compute resources needed to run dragondrop within your own cloud environment.

It defines a [Cloud Run Service](https://github.com/dragondrop-cloud/cloud-run-job-http-trigger) that can
evoke the longer running dragondrop engine living in a Cloud Run Job. The url for this Cloud Run service
is output and should be passed to a dragondrop [Job](https://docs.dragondrop.cloud/product-docs/getting-started/creating-a-job)
definition.

### Limitations
Currently, the GCP provider [does not support](https://github.com/hashicorp/terraform-provider-google/issues/11743)
 Cloud Run Jobs, so users will need to manually create their own Cloud Run Job instance to host the dragondrop core engine itself.

As soon as the GCP provider implements this functionality, we will release a new version of this module.

## What is dragondrop.cloud?
[dragondrop.cloud](https://dragondrop.cloud) is a provider of IAC automation solutions that are self-hosted
within a customer's cloud environment. For more information or to schedule a demo, please visit our website.

## What's a Module?
A Module is a reusable, best-practices definition for the deployment of cloud infrastructure. 
A Module is written using Terraform and includes automated tests, documentation, and examples.
It is maintained both by the open source community and companies that provide commercial support.

## How can I contribute to this module?
If you notice a problem or would like some additional functionality, please open a detailed issue describing
the problem or open a pull request.

### License
Please see [LICENSE](LICENSE) for details on this module's license.

Copyright © 2022 dragondrop.cloud, Inc.
