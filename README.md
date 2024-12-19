
# Severless backend infra

This README provides an overview of the architecture, deployment process, and key features of the Smarterise Webapp project. The application is designed as a serverless, scalable web solution using a combination of AWS services for both the frontend and backend.

## Architecture Overview

The application is split into two main components:

1. **Frontend**
   - The frontend is a single-page application (SPA) developed with modern web technologies.
   - It is hosted on **Amazon S3** for static file storage, providing high availability and easy scaling.
   - **CloudFront** is used as a Content Delivery Network (CDN) to ensure fast content delivery worldwide.
   - **Route 53** is configured for domain name management, providing easy-to-use, reliable DNS.

2. **Backend**
   - The backend is serverless, leveraging multiple **AWS services**:
     - **AWS Lambda** for executing backend logic without managing servers.
     - **API Gateway** to expose RESTful APIs that connect the frontend to the backend logic.
     - **Amazon DynamoDB** for a highly available and scalable NoSQL database solution.
     - **Amazon Cognito** for user authentication, allowing secure login and signup capabilities.

## Features

- **Frontend Deployment**: The web application files (HTML, CSS, JavaScript) are hosted on **Amazon S3** and distributed via **CloudFront** for improved performance and reduced latency. **Route 53** provides DNS configuration for a custom domain name.

- **Backend Services**: The backend is entirely serverless, using **AWS Lambda** functions to handle business logic, and **API Gateway** to provide a REST API. Data is stored in **DynamoDB** for fast and reliable access.

- **Authentication**: User management and authentication are handled by **Amazon Cognito**, providing features like sign-up, sign-in, and secure session management.

## Deployment Instructions

### Prerequisites
- An **AWS Account** with appropriate permissions to create and manage S3, CloudFront, Route 53, Lambda, API Gateway, DynamoDB, and Cognito resources.
- **AWS CLI** and **AWS SAM CLI** installed for managing and deploying the backend.

### Frontend Deployment (not in this repo, only fronted infra is here)
1. **Build the Frontend**: Compile your web assets (HTML, CSS, JavaScript) and generate the distribution build.
2. **Upload to S3**:
   - Use the AWS CLI or the AWS Management Console to upload the distribution files to the S3 bucket.
   - Example:
     ```sh
     aws s3 sync ./dist s3://your-s3-bucket-name
     ```

### Backend Deployment
1. **Define Lambda Functions**:
   - Write your backend code as separate Lambda functions.
2. **Create API Gateway**:
   - Set up REST endpoints using API Gateway to connect with Lambda functions.
   - Enable CORS to allow the frontend to make requests to the backend.
3. **Set up DynamoDB**:
   - Create DynamoDB tables to store your application data, ensuring proper read/write throughput settings.
4. **Configure Cognito**:
   - Set up a Cognito User Pool to manage authentication.
   - Integrate Cognito with the frontend to handle sign-up, login, and secure access tokens.

### Deployment Automation
- **GitHub Actions** is used to automate build, test, and deployment steps.
## Usage Instructions
- **Access the Application**: Once deployed, access the frontend through your custom domain. The app will communicate with backend APIs securely using the endpoints exposed via API Gateway.
- **User Signup/Login**: Users can sign up, log in, and manage their sessions through the integrated Cognito authentication flow.

## AWS Services Used
- **Amazon S3**: Static web hosting for frontend assets.
- **Amazon CloudFront**: CDN to distribute the frontend globally.
- **Amazon Route 53**: DNS management for a custom domain.
- **AWS Lambda**: Serverless functions for backend logic.
- **Amazon API Gateway**: API management to connect the frontend and backend.
- **Amazon DynamoDB**: NoSQL database for storing application data.
- **Amazon Cognito**: User authentication and authorization.

## Contact:
For any questions or support, feel free to contact the project maintainer, Tosin via email, aojutomori@gmail.com.
