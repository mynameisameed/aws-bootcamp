Week 0 — Billing and Architecture

Before the bootcamp, I had already registered a domain and created a hosted zone using Amazon Route53 on my main AWS account. Follow this documentation

Once you log into your Student portal, From the Resources section, you watch all the Video Instructional Content Playlist

    You can also watch the same, Click on Submissions, Week 0, From the ToDo List.
    Proceed with setting up the following tasks that you need for this bootcamp as per the instructions given in the videos.
    Update the Checklist

Required Tasks needed to complete the Homework
1. Create a Github Account

As I already have my Github Account, I did not create a new one.

    1b. Setup a MFA on my GitHub account for extra security.

    Configuring two-factor authentication

2. Create a Free Gitpod Account

This is used for Cloud Developer Environment (CDE) to work with the code, similar to Cloud9, but without spinning up an EC2 instance.
3. I got the Gitpod Button on my Github Account.
4. Create Gitpod Codespaces

I may need them in future, in case the I used up all the Gitpod free-tier.
5. Creating Your Repository from the Github Template

From the Bootcamp website, go all the way down to the cloud project - Use Starting template, Click - Use this template button, and select - Create a new respository - putting in the exact name - aws-bootcamp-cruddur-2023, check - Public, and then Click - Create repository from this template.

Once the repository was created, I could see all of the template folders/files available in the repository.
6. Create an AWS Account

As I already have one, I did not create another Account.
7. Create a Free Lucidchart Account to draw AWS Architectural diagrams
8. Create a Free Honeycomb.io Account
9. Create a Free Rollbar Account
10. Install AWS CLI to launch Gitpod environment on the main branch

    Follow installation instructions

    Expand the section on Linux, and copy and paste the bash commands into .gitpod.yml on Gitpod

    On Gitpod, Update .gitpod.yml to include the following task

    Set AWS CLI to use partial autoprompt mode to make it easier to debug CLI commands.

    aws-bootcamp-cruddur-2023/.gitpod.yml

tasks:
  - name: aws-cli
    env:
      AWS_CLI_AUTO_PROMPT: on-partial
    init: |
      cd /workspace
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      unzip awscliv2.zip
      sudo ./aws/install
      cd $THEIA_WORKSPACE_ROOT

    Run git commit

    Run git push

    If you run into an error doing a git push, make sure you have given Gitpod write permission to public_repo in your Github integration

11. Create a new User and Generate AWS Credentials

    From IAM Users Console, login as a root user

    Create an IAM user - bobby

    Enable Console access for the user

    Create a new Admin group - admin and apply AdminstratorAccess

    Create the user

    Click on the user, Click Security Credentials and Create Access Key

    Choose Command Line Interface (CLI), Create Access key

    Download the CSV with the credentials

    set environment variables that are needed in the GITPOD

export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION=us-east-1

    Save these environment variable into Gitpod when we relaunch our workspaces

gp env AWS_ACCESS_KEY_ID=""
gp env AWS_SECRET_ACCESS_KEY=""
gp env AWS_DEFAULT_REGION=us-east-1

    You can also check the variables in

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION

    Then go to your Github page, click the Gitpod button, and it should spin up a new workspace and set up the aws cli with your AWS account info.

Validate the AWS CLI by checking for user's identity

aws sts get-caller-identity

    shows that you are accessing AWS CLI with the right credentials.

{
    "UserId": "XXXXXXXXXXXXXXXXXXXXX",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/sammy"
}

    You can verify you have the proper info in your environment variables and they are importing properly by running

echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
echo $AWS_DEFAULT_REGION

12. Billing Setup

Billing alerts will notify the user if the AWS usage cost rises above a certain threshold.
Enable the Billing alert

    To enable it ---> Go to AWS Billing page and Under Billing Preferences Choose Receive Billing Alerts
    Save Preferences

Create SNS Topic

    First create SNS topic before we create an alarm.

    This is what alerts you when hit the set threshold of cost.

    aws sns create-topic

aws sns create-topic --name billing-alarm

    This will return a SNS topic ARN.

aws sns list-topics
{
    "Topics": [
        {
            "TopicArn": "arn:aws:sns:us-east-1:0274:Billing_alarm"
        }
    ]
}

    aws-bootcamp-cruddur-2023/journal/assets/week_0_Billing_alarm_ARN.pdf

    Create a SNS subscription and associate the above ARN and the email where you want the alert.

aws sns subscribe \
    --topic-arn TopicARN \
    --protocol email \
    --notification-endpoint your@email.com

    Check your email and confirm the subscription

Create the Cloudwatch Alarm

    [aws cloudwatch put-metric-alarm[(https://docs.aws.amazon.com/cli/latest/reference/cloudwatch/put-metric-alarm.html)

    Create an Alarm via AWS CLI

    aws-bootcamp-cruddur-2023/journal/assets/week_0_Billing_alarm_ARN.pdf

aws cloudwatch put-metric-alarm --cli-input-json file://aws/json/alarm-config.json

    aws-bootcamp-cruddur-2023/aws/json/alarm-config.json

13. Create an AWS Budget

    Create only 1 budget not to go over the free budget limit

    aws budgets create-budget

    Run AWS Cli to extract the AWS Account ID

aws sts get-caller-identity --query Account --output text

    use the Account ID from the previous command output

    Update the json files with email address

    aws-bootcamp-cruddur-2023/aws/json/budget.json

    aws-bootcamp-cruddur-2023/journal/assets/week_0_setup_Monthly_Budget.pdf

    aws-bootcamp-cruddur-2023/aws/json/budget-notifications-with-subscribers.json

aws budgets create-budget \
    --account-id AccountID \
    --budget file://aws/json/budget.json \
    --notifications-with-subscribers file://aws/json/budget-notifications-with-subscribers.json

Homework Challenges
Set MFA, IAM role

    aws-bootcamp-cruddur-2023/journal/assets/week_0_user_sammy_setup_MFA.jpg

    aws-bootcamp-cruddur-2023/journal/assets/week_0_Role_S3Full.jpg

Use EventBridge to hookup Health Dashboard to SNS and send notification when there is a service health issue.

Follow Monitoring Amazon Health events with Amazon EventBridge


Review all the questions of each pillars in the Well Architected Tool (No specialized lens)

    This is not related to the course, but I thought I should mention this.

    Some time back, in Sept 2022, I completed the training for Well Architected Tool and earned a Well-Architected Proficient Badge

    Created a workload week_0_project to do this task in getting the report for my project using the Logical CI/CD pipeline Diagram


Create an architectural diagram (to the best of your ability) the CI/CD logical pipeline in Lucid Charts
1. Logical Diagram

Link to my Logical Diagram from Lucid Chart

    !aws-bootcamp-cruddur-2023/journal/assets/week_0_Logical_Architectural_Diagram_Lucidchart.png

    Link to my Logical Diagram PDF file

    !aws-bootcamp-cruddur-2023/journal/assets/week_0_Logical diagram.pdf

2. Coceptual Diagram + Conceptual Diagram on Napkin

    Link to my Conceptual Diagram from Lucid Chart

    !aws-bootcamp-cruddur-2023/journal/assets/week_0_Conceptual_Diagram_Lucidchart.png


    Link to my Conceptual Diagram on Napkin

    !aws-bootcamp-cruddur-2023/journal/assets/week_0_Conceptual_Napkin_diagram.jpg

3. Logical CI/CD pipeline Diagram

    Link to my Logical CI/CD Diagram from Lucid Chart

    !aws-bootcamp-cruddur-2023/journal/assets/week_0_Logical_CI_CD_diagram_Lucidchart.png

    Link to my Logical CI/CD Diagram PDF file

    aws-bootcamp-cruddur-2023/journal/assets/week_0_Logical_CI_CD diagram.pdf

Research the technical and service limits of specific services and how they could impact the technical path for technical flexibility.
Amazon Elastic Compute Cloud (EC2)

Amazon Elastic Compute Cloud (EC2) is a most commonly and widely used cloud computing service provided by Amazon Web Services (AWS) which provides scalable computing capacity in the cloud.

    EC2 offers a high degree of technical flexibility and supports a wide variety of use cases.

    But there are some technical and service limits that could impact the technical path for flexibility.

Technical limits of EC2 that I could think of

    Instance Limits: The number of EC2 instances that a user can launch is limited by default, usually 5. These limits can be increased by submitting a request to AWS, which I did today by raising a service ticket. If a user exceeds these limits without increasing them, it can impact the flexibility of their technical path.

    Instance types: EC2 offers several instance types with varying amounts of CPU, memory, and storage capacity. Each instance type has a limit on the number of instances that can be launched, and the total number of vCPUs that can be used.

    Network: EC2 instances are connected to the internet through Amazon VPC. VPC has limits on the number of subnets, security groups, and network interfaces that can be created.

    Network Interfaces: Each EC2 instance can have a limited number of network interfaces. If a user needs to connect their instances to multiple networks or use multiple IP addresses, they may need to use additional instances or consider other AWS services.

    Storage: EC2 provides different types of storage options, including Elastic Block Store (EBS), instance store, and Amazon S3. Each storage type has different limits on storage capacity, IOPS, and throughput.

Some service limits of EC2

    Volumes: EC2 instances can attach a limited number of volumes, and each volume has a maximum size limit. This can impact the technical path if a user needs to attach more volumes or use larger volumes.

    Availability Zones: EC2 instances can be launched in different availability zones (AZs) to improve availability and fault tolerance, which are isolated data centers within a region. There are limits on the number of instances that can be launched in each AZ, and the total number of instances that can be launched in a region.

    Security: EC2 provides several security features, including network security groups, IAM roles, and encryption. There are limits on the number of security groups, IAM roles, and keys that can be created.

    Elastic IP addresses: EC2 provides elastic IP addresses (EIPs) that can be associated with instances. There are limits on the number of EIPs that can be allocated per account.

    Auto Scaling: EC2 Auto Scaling allows users to automatically scale the number of instances based on demand. There are limits on the number of Auto Scaling groups and launch configurations that can be created.

    Amazon Machine Images (AMIs): EC2 instances can be launched from pre-configured Amazon Machine Images (AMIs). There are limits on the number of AMIs that can be created and shared.

    Regional limitations: Some EC2 features may not be available in all AWS regions. For example, certain instance types may only be available in specific regions, and some instance types may have limited availability in certain regions.

These limits can impact the technical path for technical flexibility in several ways.

For example, if a company needs to launch a large number of instances, they may need to select an instance type that has a high number of vCPUs, and use multiple availability zones to distribute the load.

For example, if a company needs to store large amounts of data, they may need to use multiple storage types, such as EBS and S3, to accommodate the data.

For example, if a company needs to launch instances in multiple regions, they may need to allocate EIPs across regions to ensure seamless connectivity.

To address these limits, companies can work with AWS support to increase their limits or consider using other AWS services, such as EC2 Spot Instances or Amazon Elastic Kubernetes Service (EKS), to optimize their infrastructure.

Additionally, if a customer requires certain instance types that are only available in certain regions, they may need to choose a different region or use a different service altogether. These limitations can also impact application architecture and design, as well as the overall cost of running applications on EC2.

In conclusion, EC2 provides a highly flexible and scalable infrastructure for running various types of workloads, but its technical and service limits can impact the technical path for flexibility. It is essential to understand these limits and plan accordingly to achieve maximum technical flexibility.
Application Load Balancer (ALB)

Load balancers are a crucial component of modern distributed systems used to distribute incoming network traffic across multiple servers or computing resources in order to improve the overall performance, reliability, and scalability of an application or service.

    However, like any other technology, load balancers have their own technical and service limits, which can impact the flexibility of an organization's technical path.

Technical Limits of LB:

    Capacity: Load balancers have a finite capacity to handle traffic. The capacity is determined by the maximum number of connections that the load balancer can handle per second. If the traffic volume exceeds the load balancer's capacity, it can lead to slower response times or even service downtime.

    Latency: Load balancers can introduce latency, which is the time it takes for a request to be processed. If the load balancer is located in a different geographic region than the servers, it can add additional latency to the response time.

    Single point of failure: Load balancers can be a single point of failure. If the load balancer goes down, it can lead to service downtime, even if the backend servers are still operational.

    SSL/TLS offloading: Load balancers can offload SSL/TLS encryption and decryption from the backend servers. However, this can increase the load balancer's processing overhead and introduce latency.

    Protocol Support: Load balancers have limitations in terms of the types of protocols and traffic they can handle. For instance, some load balancers may not support certain protocols such as UDP or may have limited support for SSL/TLS protocols, which can impact the security and availability of applications that rely on these protocols.

Service Limits of LB:

    Cost: Load balancers are typically charged on a per-hour or per-month basis. They can be expensive, especially if you need to scale up to handle large volumes of traffic.

    Vendor lock-in: Vendor Lock-In: Organizations that rely on a specific load balancer vendor may be locked into that vendor's technology and may have limited flexibility to switch to another load balancer vendor or technology.

    Complexity: Load balancers can add complexity to your infrastructure, which can increase the risk of errors and downtime.

    Lack of visibility: Load balancers can hide information about the backend servers from the clients, which can make it difficult to troubleshoot issues.

    Technical Support: Load balancers require technical expertise to set up, maintain, and troubleshoot, and organizations that lack in-house technical expertise may find it challenging to effectively use and manage load balancers.

Impact on Technical Path for Technical Flexibility:

For example:

    Capacity limits can impact scalability: If the load balancer's capacity is exceeded, it can be difficult to scale the system to handle larger volumes of traffic. This can limit the technical path for technical flexibility, as it can be difficult to add new servers or change the infrastructure to handle the increased load.

    Latency limits can impact performance: If the load balancer adds significant latency, it can impact the performance of the system. This can limit the technical path for technical flexibility, as it can be difficult to change the infrastructure to reduce latency.

    Single point of failure limits can impact reliability: If the load balancer is a single point of failure, it can impact the reliability of the system. This can limit the technical path for technical flexibility, as it can be difficult to change the infrastructure to improve reliability.

    Service limits can impact cost and vendor lock-in: If the cost of the load balancer is high or if it is a proprietary technology, it can limit the technical path for technical flexibility. It can be difficult to switch vendors or migrate to a different technology in the future.

To address these issues, organizations can take several steps, such as:

    Conducting thorough research and testing before selecting a load balancer vendor or technology to ensure that it aligns with the organization's needs and goals.

    Monitoring the load balancer's capacity and usage metrics to ensure that it can handle the organization's traffic demands and identify any potential bottlenecks.

    Investing in technical expertise to effectively set up and manage load balancers, or consider working with a managed service provider (MSP) to manage load balancers.

    Implementing redundancy and failover mechanisms to ensure high availability and minimize downtime.

    Evaluating load balancer costs and seeking out cost-effective options that meet the organization's needs and budget.

By taking these steps, organizations can effectively address the technical and service limits of load balancers and ensure that they have the technical flexibility needed to achieve their business goals.

Overall, the technical and service limits of load balancers can impact the technical path for technical flexibility in a variety of ways. It is important to consider these limits when designing and implementing load balancing solutions, and to choose a load balancing solution that meets your specific requirements for capacity, latency, reliability, cost, and vendor lock-in.
Open a support ticket and request a service limit

Follow Request a Quota Increase with Service Quotas

Cloud Technical Essays

    Challenges facing during AWS Cloud Project Bootcamp by Andrew Brown

    Getting the serverless cache icon for AWS Cloud Project Bootcamp by Andrew Brown

Knowledge Challenges

    Security Quiz - Submitted

    Pricing Quiz - Submitted
