# Golden Owl DevOps Internship - Technical Test
At Golden Owl, we believe in treating infrastructure as code and automating resource provisioning to the fullest extent possible. 

In this technical test, we challenge you to create a robust CI build pipeline using GitHub Actions. You have the freedom to complete this test in your local environment.

## Your Mission 🌟
Your mission, should you choose to accept it, is to craft a CI job that:
1. Forks this repository to your personal GitHub account.
2. Dockerizes a Node.js application.
3. Establishes an automated CI/CD build process using GitHub Actions workflow and DockerHub.
4. Initiates CI tests automatically when changes are pushed to the feature branch on GitHub.
5. Utilizes GitHub Actions for Continuous Deployment (CD) to deploy the application to freely available cloud services such as [fly.io](https://fly.io), [render.com](https://render.com) or major cloud providers like AWS, Google Cloud, or Azure (Please submit the deployment link).

## The Bigger Picture 🌏
This test is designed to evaluate your ability to implement modern automated infrastructure practices while demonstrating a basic understanding of Docker containers. In your solution, we encourage you to prioritize readability, maintainability, and the principles of DevOps.

 ## Submission Guidelines 📬
Your solution should be showcased in a public GitHub repository. We encourage you to commit early and often. We prefer to see a history of iterative progress rather than a single massive push. When you've completed the assignment, kindly share the URL of your repository with us.

 ## Running the Node.js Application Locally  🏃‍♂️
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