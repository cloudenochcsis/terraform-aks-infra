# Anatomy of a Modern GitOps Workflow: From Terraform to a Live Application

In today's fast-paced development world, getting your code from a repository to a live, running application needs to be fast, reliable, and automated. The project we've been exploring uses a powerful, modern stack to achieve this, combining Terraform, Azure Kubernetes Service (AKS), Argo CD, and Docker in a seamless GitOps workflow. 

Let's break down how it works.

---

## The Two-Phase Deployment Strategy

The entire process can be split into two distinct phases:

1.  **Phase 1: Infrastructure Provisioning (with Terraform)**: This is the foundation. Terraform's job is to build the entire environment where the application will live.
2.  **Phase 2: Application Deployment (with Argo CD)**: This is the continuous, automated deployment of the application itself. Argo CD ensures that what's in the Git repository is what's running in the cluster.

---

## Phase 1: Building the World with Terraform

Before you can deploy an app, you need a place for it to run. Terraform handles this by defining the infrastructure as code.

1.  **Provisioning the Cluster**: A developer runs `terraform apply`. Terraform connects to Azure and creates the Azure Kubernetes Service (AKS) cluster, virtual networks, and any other necessary cloud resources.
2.  **Installing the Conductor (Argo CD)**: Once the cluster is ready, Terraform doesn't stop. It proceeds to install Argo CD using a Helm chart. Think of this as setting up the automated deployment system inside your new cluster.
3.  **The Hand-Off**: The final, crucial step for Terraform is to bootstrap the application. It applies a single, special Kubernetes manifest to the cluster—an Argo CD `Application` resource. This manifest doesn't contain the app's Kubernetes objects (like Deployments or Services). Instead, it simply tells Argo CD: *"Your instructions for the 3-tier application are over here in this Git repository. Go look at them."*

At this point, Terraform's job is done. It has built the stage and handed the keys to the director, Argo CD.

---

## Phase 2: The GitOps Loop with Argo CD

Now, Argo CD takes over as the single source of truth for the application's state. It follows a continuous loop based on the Git repository it was pointed to.

### The CI/CD Pipeline: Building the Container

First, it's important to understand that **Argo CD does not build your code**. A separate Continuous Integration (CI) pipeline handles that:

1.  **Code is Pushed**: A developer pushes a change to the application's source code.
2.  **Image is Built**: A CI tool (like GitHub Actions or Jenkins) automatically builds this code into a new Docker container image (e.g., `akpadetsi/event-booking-frontend:v3`).
3.  **Image is Pushed**: The new image is pushed to a container registry (like Docker Hub or Azure Container Registry).
4.  **The GitOps Trigger**: The CI pipeline's final job is to update a file in the **GitOps repository** (the one Argo CD is watching). Specifically, it updates the `kustomization.yaml` file to point to the new image tag (`newTag: v3`).

### The Argo CD Sync Cycle

The change to the `kustomization.yaml` file is the trigger for the deployment:

1.  **Change Detected**: Argo CD, which is constantly monitoring the GitOps repository, detects the updated image tag.
2.  **Manifests Generated**: Argo CD uses Kustomize to prepare the final, complete set of Kubernetes manifests. Kustomize takes the base YAML files (like `frontend-complete.yaml`) and applies the configuration from `kustomization.yaml` (like the new image tag and replica counts).
3.  **Sync to Cluster**: Argo CD compares the newly generated manifests with what is currently running in the AKS cluster. It sees a difference and applies the changes.
4.  **Kubernetes Takes Over**: The Kubernetes cluster receives the updated `Deployment` object. It sees the new image tag (`akpadetsi/event-booking-frontend:v3`) and pulls the new image from the container registry, deploying it seamlessly to update the application.

---

## Conclusion: A Declarative and Auditable System

This workflow is powerful because it's entirely declarative. The Git repository defines the **desired state** of both the infrastructure (via Terraform code) and the application (via Kubernetes manifests). 

- **Terraform** ensures the world matches the infrastructure code.
- **Argo CD** ensures the application matches the manifest code.

This creates a fully automated, auditable, and reliable system where a `git push` is all that's needed to safely update a live, production application.
