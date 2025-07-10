
# AWS Terraform Setup Guide

## Step 1: Create DynamoDB Table

1. Navigate to DynamoDB in your AWS console
2. Create a new table with the following configuration:
   - **Table name**: `<app_name>-aws-terraform-lock-centralised`
   - **Partition key**: `lockID` (String type)
   - Leave all other configurations as default
3. **Tags**: Add the following tag:
   - **Tag name**: `project`
   - **Value**: `<your_app_name>` (your MVP application name)
4. Click "Create table" to finish

## Step 2: Create S3 Bucket

1. Navigate to S3 in your AWS console
2. Create a new S3 bucket with the following configuration:
   - **Bucket type**: General purpose
   - **Bucket name**: `<app_name>-aws-terraform-remote-states-centralized`
   - Leave all other configurations as default
3. **Tags**: Add the following tag:
   - **Tag name**: `project`
   - **Value**: `<your_app_name>`
4. Click Create bucket

## Step 3: Create IAM User for GitHub Actions

1. Navigate to IAM in your AWS console, click on "Users" on the side panel
2. Click "Create user"
3. **User configuration**:
   - **User name**: `github-actions-<your_app_name>` (or similar descriptive name)
   - **Description**: Add a description explaining this user is for GitHub Actions deployments
   - **Important**: Do NOT enable console access - this user will interact programmatically only, so do not check the "Provide user access to AWS console" box

4. **Permissions**:
   - Attach the **AdministratorAccess** policy by checking the box beside it. (typically the 2nd option in the policy list), click next
   - **Note**: This is not least privilege, but necessary for initial setup

5. **Tags**: Add the following tag:
   - **Tag name**: `project`
   - **Value**: `<your_app_name>`

6. Click "Create user"

## Important Notes

- **Security**: The IAM user will have administrative access initially. After setup, you should:
  - Enable CloudTrail to monitor the user's activity
  - Generate a least privilege policy based on the user's actual usage patterns
  - Replace the AdministratorAccess policy with the more restrictive one

## Step 4: Create CloudTrail for Activity Monitoring

1. Navigate to CloudTrail in your AWS console
2. **Create trail**:
   - Use the **Quick Creation** option
   - **Trail name**: Use the default name provided or customize as needed
   - Click "Create trail"
   - If you dont see the Quick Trail creation option, click "Create trail"
   - Give the trail a under **Trail name** 
   - Uncheck the box beside "Enable" under **Log file SSE-KMS encryption**, scroll down and click "Next"
   - Make sure, Management events, Read and Write boxes are checked, then click "Next"
   - Click "Create Trail"
3. **Purpose**: CloudTrail will automatically:
   - Collect event logs (free for basic event logging)
   - Store logs in an S3 bucket (automatically created)
   - Track all activities performed by the IAM user
4. **Security benefit**: Use these logs later to generate least privilege policies based on actual usage patterns

## Step 5: Use the Serverless Template

1. Navigate to this **serverless_mvp** Github repository 
2. Click **"Use this template"** to create a new repository
3. This will create your own repository based on the template for your MVP

## Step 5: Configure GitHub Repository Secrets

Now that you have your GitHub repository created from the template, you need to configure the secrets for AWS access.

### Step 1: Navigate to Repository Settings

1. Go to your GitHub repository page
2. Click on **Settings** tab
3. Scroll down to **Secrets and variables** section
4. Click **Secrets and variables** to expand
5. Select **Actions** from the dropdown

### Step 2: Generate AWS Access Keys

Before creating the GitHub secrets, you need to generate access keys for your IAM user:

1. Go to your **AWS Console**
2. Navigate to **IAM**
3. Click on the **GitHub Actions user** you created earlier
4. Click **Generate access key**
5. Select **Other** as the use case reason
6. Click **Generate keys**

> **⚠️ Important**: The access keys will only be shown once. Pay close attention and do not download them to avoid security risks.

### Step 3: Create GitHub Secrets

#### Secret 1: AWS Access Key ID

1. Click **Add repository secret**
2. **Name**: `AWS_ACCESS_KEY_ID` (all capital letters)
3. **Value**: Copy the **Access Key ID** from the AWS console and paste it here
4. Click **Add secret**

#### Secret 2: AWS Secret Access Key

1. Click **Add repository secret** again
2. **Name**: `AWS_SECRET_ACCESS_KEY`
3. **Value**: Copy the **Secret Access Key** from the AWS console and paste it here
4. Click **Add secret**
5. Click the "Code" tab and Clone your repository to local development environment

### Environment Architecture Assumption

This setup assumes you're using:
- **Single AWS Account**: One account for both development and production
- **Regional Separation**: Different environments deployed in different AWS regions

## Step 6: Configure Terraform Backend

After cloning your repository, you need to configure the Terraform backend to use your AWS resources.

### Step 1: Update terraform.tf File

1. Open the `terraform.tf` file in the root folder of your repository
2. Locate the **backend configuration** section
3. Update the following values:

#### S3 Backend Configuration
- Go to your **AWS Console** → **S3**
- Copy the name of the S3 bucket you created earlier (`<app_name>-aws-terraform--remote-states-centralized`)
- Paste it as the value for the **S3 bucket** parameter in the terraform.tf file

#### DynamoDB State Lock Configuration
- Go to your **AWS Console** → **DynamoDB** 
- Copy the name of the DynamoDB table you created earlier (`<app_name>-aws-terraform-remote-lock-centralised`)
- Paste it as the value for the **DynamoDB table** parameter in the terraform.tf file

4. **Save the file**

### Step 2: Configure Application Variables

1. Open the `variables.tf` file in the root folder
2. Add your application details:

#### Required Variables
- **Application Name and Email**: 
  - Use a single name (no special characters)
  - Example: `myapp`, `startup`, `mvp`
  - Your email address

#### Purpose of These Variables
- **Tagging**: Used to configure tags for all infrastructure resources
- **Cost Management**: Enables cost center tags for expense tracking
- **Standardization**: Ensures consistent tagging across all deployed resources

## Step 7: Deployment Process

### Step 3: Commit and Push Changes

1. **Add files to Git**:
   ```bash
   git add .
   ```

2. **Commit changes**:
   ```bash
   git commit -m "Configure Terraform backend and application variables"
   ```

3. **Push to GitHub**:
   ```bash
   git push
   ```

### Step 4: Monitor Deployment

1. Go to your **GitHub repository**
2. Click on the **Actions** tab
3. Watch the deployment workflow in progress, it might take a while to finish

## Step 8: Post-Deployment Resource Verification

After your deployment completes, you can verify all resources have been created successfully.

### Step 1: Verify Deployed Resources

1. Go to your **AWS Console**
2. Navigate to **S3** to see all created buckets
3. You should see multiple buckets, including:
   - Your **application hosting bucket** (contains your app name, environment, etc.)
   - Your **Terraform remote state bucket** (used for backend state management)

### Resource Naming Convention
All resources follow a standardized naming pattern:
- **Format**: all the resources have `<app_name>-<environment>` in them
- **Environment**: Default deployment is to `us-east-1` for development and `us-east-2` for production environment
- **Customization**: You can change the region in the variables (found in the `config` folder, in the tvars files)

## Step 9: Configure S3 Bucket for Public Access

### Identify the Correct Bucket
- **Target**: The S3 bucket that will host your static files (frontend)
- **NOT**: The Terraform remote state bucket (used for backend state management)
- **Identifier**: Look for the bucket that contains your application name and environment
- Click on the S3 bucket that will host your frontend files
- Click on the **Permissions** tab
- Scroll down to **Bucket Policy** section
- Click **Edit** to add a new bucket policy
- You'll see a JSON editor area
1. **Get the policy template**:
   - Go back to your **local IDE** or **repository**
   - Navigate to the `config` folder in the root directory
   - Open the `s3-policy.json` file
   - Copy the entire contents of the `s3-policy.json` file
   - Return to the AWS Console
   - Paste the policy into the JSON editor area

2. **Update the Resource ARN**:
   - In the policy JSON, find the `"Resource"` section
   - Replace the placeholder with your actual S3 bucket ARN
   - **Bucket ARN location**: You can find this at the top of the bucket permissions page
   - **Format**: `arn:aws:s3:::your-bucket-name/*`
   - Click **Save changes**
   - The bucket will now allow public read access to your static files
   - **Sensitive Data**: Never store sensitive data in the publicly accessible bucket

### Common Issues
- **Wrong bucket**: Make sure you're configuring the hosting bucket, not the Terraform state bucket
- **ARN format**: Ensure the ARN includes `/*` at the end for object-level access
- **Policy format**: Verify the JSON is properly formatted

### Verification
- After applying the policy, you should be able to access static files via their S3 URLs
- CloudFront distribution will use this bucket as its origin

## Step 10: Retrieve Deployment Outputs

After your GitHub Actions workflow completes successfully, you need to extract the API endpoints for your frontend.

### Access GitHub Actions Results

1. Go to your **GitHub repository**
2. Click on the **Actions** tab
3. Find the **latest completed workflow** (the one that just finished running)
4. Click on the workflow "Dev: Terraform and Python Lint" to open it
5. Scroll down to the **Terraform Apply** section, and click

You'll find **three critical pieces of information** in the output:

1. **CLOUDFRONT_DOMAIN_NAME**: The link for your application, copy and open it in new tab to view your webapp.
2. **MY_MVP_ENDPOINT**: The main API endpoint for your backend
3. **UUSER_MNGT_ENDPOINT**: The API endpoint for authentication/user management

> **Note**: There are two backend modules (Lambda funtions), one for user management the other for your mvp. This is based on the assumption that your MVP will have at most 15 API, (10 APIs Recomended per Lambda Function). The User management has been done for you. Check the "backend" folder to unserstand the structure.

### Update config.js File

1. Navigate to your **frontend folder** in the repository on your IDE
2. Go to the **js folder** inside the frontend folder
3. Open the `config.js` file
4. **Copy and paste** the three API endpoints from the GitHub Actions output
5. Place them as values in the **development and local environments section** of the config.js file
6. `userMngtURL` -> UUSER_MNGT_ENDPOINT, `myMVPURL` -> MY_MVP_ENDPOINT
7. `hostname ===` -> CLOUDFRONT_DOMAIN_NAME (this is not need in local environment section)
8. Note that you will have to do this again when you push to prod by merging to main

## Architecture Overview

### Cost-Effective Serverless Design

- **AWS Free Tier Friendly**: Designed to minimize costs, especially with AWS free tier
- **Pay-per-use**: Only charged when your application is actually being used
- **No idle costs**: No servers running when not in use

### Backend Architecture Highlights

#### Lambda Function Strategy

- **Consolidated approach**: One Lambda function handles 10-15 API endpoints
- **Reasoning**: Prevents Lambda sprawl and cold start issues
- **Performance**: Better for model-based applications where consistency matters

#### Why Not One Lambda Per API?

- **Cold starts**: Multiple Lambdas can cause performance issues
- **Resource management**: Harder to manage concurrent resources
- **Model consistency**: When dealing with ML models, one Lambda per model makes resource allocation easier

### Repository Structure Benefits

- **AI-Friendly**: Organized structure works well with AI coding assistants
- **Scalable**: Easy to add new features and APIs
- **Maintainable**: Clear separation of concerns between frontend, backend, and infrastructure

## Final Setup Verification

After completing these steps, you should have:

1. ✅ **Working frontend** with proper API configuration
2. ✅ **Functional backend** with all necessary endpoints
3. ✅ **User authentication** system ready to use
4. ✅ **Development environment** for ongoing work
5. ✅ **Production deployment** pipeline ready

## Next Steps

- **Frontend Development**: Start building your application UI
- **Backend Customization**: Modify APIs as needed for your specific use case
- **User Management**: Customize authentication flows if needed
- **Testing**: Test the complete application flow
- **Production Deployment**: When ready, create PR to main branch for production deployment

You now have a complete serverless MVP infrastructure ready for development!

## Important Infrastructure Guidelines

### Infrastructure as Code (IaC) Best Practices
- **Console Access**: Do NOT make any infrastructure changes through the AWS console
- **Code-First Approach**: All infrastructure configurations must be made through code in the repository
- **State Management**: Terraform state is stored in S3 and tracks your current infrastructure configuration
- **Change Management**: Terraform compares current state with desired state before making changes

### Why This Matters
- **Consistency**: Ensures all team members work with the same infrastructure configuration
- **Version Control**: All infrastructure changes are tracked in Git
- **Rollback Capability**: Easy to revert infrastructure changes if needed
- **Disaster Recovery**: Infrastructure can be recreated from code

#### What Gets Deployed
- **S3 buckets** for application storage
- **CloudFront distribution** for content delivery
- **Lambda functions** for serverless backend
- **API Gateway** for API endpoints
- **All other infrastructure** defined in your Terraform configuration

### Deployment Timeline
- **Initial deployment** may take several minutes
- **CloudFront distribution** creation can take 10-20 minutes
- **Subsequent deployments** will be faster

## Troubleshooting

- **Long deployment times**: CloudFront distributions take time to create globally
- **Failed deployments**: Check the Actions tab for detailed error logs
- **State conflicts**: Ensure no manual changes were made in the AWS console

## Next Steps

After successful deployment, you'll have:
- A fully configured serverless infrastructure
- Automated CI/CD pipeline
- Proper state management
- Comprehensive resource tagging for cost tracking

## Why This Serverless Template?

### Current Market Gaps
- **Limited serverless options**: Most available platforms don't offer serverless framework options for MVPs
- **Developer knowledge requirements**: Existing solutions require significant developer expertise to navigate
- **Programming language lock-in**: Many platforms force you into specific languages (e.g., TypeScript)
- **Cost considerations**: Most solutions require payment even when applications aren't being used

### Template Advantages
- **Python-based backend**: Scalable and familiar to many developers
- **Runtime flexibility**: Can change to any available Python runtime, or use custom runtimes via containers
- **Fast deployment**: No need for EC2 instances or continuous hosting costs
- **Pay-per-use**: Only pay when your application is actually being used
- **AI-friendly**: Works well with AI coding assistants like Cursor and Claude

### Development Experience
- **Cursor integration**: Excellent compatibility for AI-assisted development
- **Claude compatibility**: Works well, though requires some back-and-forth between IDE and Claude environment
- **Architecture framework**: Provides a solid foundation that works with various AI coding assistants

### Key Benefits
- **Cost-effective**: No upfront hosting costs - only pay for actual usage
- **Serverless**: No server management required
- **Template-based**: Quick setup compared to building from scratch
- **Framework flexibility**: Can adapt to different runtime preferences and requirements

## Contact:
For any questions or support, feel free to contact the project maintainer, Tosin via email, aojutomori@gmail.com.
