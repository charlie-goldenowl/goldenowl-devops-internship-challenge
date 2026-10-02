# Golden Owl DevOps Internship Challenge

## Submission

- GitHub Repository: https://github.com/dnminhchau/goldenowl-devops-internship-challenge
- DockerHub Repository: https://hub.docker.com/r/cdoan0072/goldenowl-devops-internship-challenge
- Live Application: http://goldenowl-alb-569630106.ap-southeast-2.elb.amazonaws.com
- Docker Image Size: 83 MB

## Architecture

![Architecture Flow](docs/goldenowl-devops-flow.jpg)

Editable diagram source:

```text
docs/goldenowl-devops-flow.drawio
```

## Docker

The Node.js application is containerized using a lightweight Alpine-based Node.js image.

Key points:

- Base image: `node:20-alpine`
- Production dependencies only: `npm ci --omit=dev`
- Runs as non-root user: `node`
- Exposes port `3000`
- Uses `.dockerignore`
- Final image size: `83 MB`

Dockerfile:

```dockerfile
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

USER node

EXPOSE 3000

CMD ["npm", "start"]
```

## CI/CD Pipeline

GitHub Actions automates testing, Docker image creation, vulnerability scanning, image publishing, and deployment to AWS ECS.

### CI

For pushes to `feature/devops-challenge`:

```text
Git Push
   ↓
GitHub Actions
   ↓
npm ci
   ↓
npm test
   ↓
Docker Build
   ↓
Trivy Vulnerability Scan
   ↓
DockerHub Login
   ↓
Docker Push
```

Changes that only modify `README.md` or files under `docs/` are ignored by the workflow.

Pull requests to `master` run CI checks without deploying to AWS.

### CD

For pushes to `feature/devops-challenge`:

```text
Docker image pushed to DockerHub
   ↓
GitHub Actions obtains an OIDC token
   ↓
AWS IAM Role is assumed
   ↓
ECS Service is updated
   ↓
Fargate starts a new task
   ↓
The task pulls the latest Docker image
   ↓
GitHub Actions waits until the ECS service is stable
```

GitHub OIDC is used instead of storing long-lived AWS credentials in GitHub Secrets.

## Security Scan

Docker images are scanned during CI using Trivy.

The scan checks for:

- `HIGH` vulnerabilities
- `CRITICAL` vulnerabilities

The scan currently reports vulnerabilities without blocking the deployment pipeline.

## AWS Infrastructure

The infrastructure is provisioned using AWS CloudFormation.

CloudFormation template:

```text
infrastructure/cloudformation.yml
```

The deployed infrastructure includes:

- VPC
- Two public subnets
- Internet Gateway
- Route Table
- Security Groups
- Application Load Balancer
- Target Group
- ECS Cluster
- ECS Fargate Task Definition
- ECS Service
- IAM Roles
- GitHub Actions Deployment IAM Role
- ECS Service Auto Scaling

AWS Region:

```text
ap-southeast-2
```

## Load Balancer

The application is deployed behind an Application Load Balancer.

Traffic flow:

```text
Internet / User
   ↓
Application Load Balancer :80
   ↓
Target Group :3000
   ↓
ECS Service
   ↓
Fargate Task
   ↓
Node.js Application
```

Target group health check:

```text
Path: /
Protocol: HTTP
Expected status: 200
```

The deployed target was verified as healthy.

## Auto Scaling

The ECS service uses target-tracking auto scaling.

Configuration:

- Minimum tasks: `1`
- Maximum tasks: `3`
- Metric: `ECSServiceAverageCPUUtilization`
- Target CPU utilization: `60%`
- Scale-in cooldown: `60 seconds`
- Scale-out cooldown: `60 seconds`

## Run Locally

Navigate to the application directory:

```bash
cd src
```

Install dependencies and run tests:

```bash
npm install
npm test
```

Build the Docker image:

```bash
docker build -t goldenowl-app .
```

Run the container:

```bash
docker run -p 3000:3000 goldenowl-app
```

Then access:

```text
http://localhost:3000
```

Expected response:

```json
{"message":"Welcome warriors to Golden Owl!"}
```

## Deployment

The deployed application is available at:

```text
http://goldenowl-alb-569630106.ap-southeast-2.elb.amazonaws.com
```

Expected response:

```json
{"message":"Welcome warriors to Golden Owl!"}
```

---
# Golden Owl DevOps Internship - Technical Test
At Golden Owl, we believe in treating infrastructure as code and automating resource provisioning to the fullest extent possible. 

In this technical test, we challenge you to create a robust CI build pipeline using GitHub Actions. You have the freedom to complete this test in your local environment.

## Your Mission 🌟
Your mission, should you choose to accept it, is to build a CI/CD pipeline and deploy the application by:
1. Forking this repository to your personal GitHub account.
2. Dockerizing a Node.js application, keeping the image **as lightweight as possible** (Please state the final image size in your repository's README so we can see the result of your optimization).
3. Establishing an automated CI/CD build process using GitHub Actions workflow and a container registry service such as DockerHub or Amazon Elastic Container Registry (ECR) or similar services.
4. Initiating CI tests automatically when changes are pushed to the feature branch on GitHub.
5. Utilizing GitHub Actions for Continuous Deployment (CD) to deploy the application to major cloud providers like AWS EC2, AWS ECS or Google Cloud (please submit the deployment link).
6. Deploying the application behind a **load balancer** with **auto scaling** enabled.
7. Provisioning **all cloud infrastructure using Infrastructure as Code (IaC)** such as Terraform, AWS CloudFormation, AWS CDK, or Pulumi. Resources created manually through the cloud console will not be accepted. 
8. Providing a **visual flow diagram** of your workflow and architecture, **created by you without the use of AI** (see [Visual Flow Diagram](#visual-flow-diagram-required-) below).

## Visual Flow Diagram (Required) 🎨
A `visual flow diagram` is **mandatory** for this test. It must illustrate the sequence of tasks you performed and the architecture you deployed, including:
- The CI/CD flow
- The deployed application's infrastructure

**The diagram must be created manually by you and must not be generated by AI.** This means no AI image generators and no AI tools that produce a diagram from a text prompt or from your code. 

Reference tools for creating visual flow diagrams:
- https://www.drawio.com/
- https://excalidraw.com/
- https://www.eraser.io/

## The Bigger Picture 🌏
This test is designed to evaluate your ability to implement modern automated infrastructure practices while demonstrating a basic understanding of Docker. In your solution, we encourage you to prioritize readability, maintainability, and the principles of DevOps.

## How We Evaluate 🎯
| Area | Weight |
|---|---|
| CI/CD pipeline (tests on push, build, push to registry, deploy) | 25% |
| Deployment works behind a load balancer with a real auto scaling policy | 25% |
| Visual flow diagram (accurate, manually created) | 20% |
| Infrastructure as code / repo quality / commit history | 20% |
| Docker image optimization (size, multi-stage, non-root, .dockerignore) | 10% |

## Bonus (Optional) ⭐
- Image vulnerability scan in CI (e.g. Trivy)
- HTTPS on the load balancer
- Automatic rollback on failed deployment
- Infrastructure defined with Terraform

## Submission Guidelines 📬
Your solution should be showcased in a public GitHub repository. We encourage you to commit early and often. We prefer to see a history of iterative progress rather than a single massive push. 

Your submission must include:
- The URL of your public GitHub repository
- The deployment link of your running application
- The visual flow diagram (manually created, not AI-generated)
- The final Docker image size

When you've completed the assignment, kindly share these with us.

## Running the Node.js Application Locally 🏃‍♂️
This is a Node.js application, and running it locally is straightforward:
- Navigate to the `src` directory by executing `cd src`.
- Install the project's dependencies listed in the package.json file by running `npm i`.
- Execute `npm test` to run the application's tests.
- Start the HTTP server with `npm start`.

You can test it using the following command:
```shell
curl localhost:3000
```
You should receive the following response:
```json
{"message":"Welcome warriors to Golden Owl!"}
```

Are you ready to embark on this DevOps journey with us? 🚀 Best of luck with your assignment! 🌟
