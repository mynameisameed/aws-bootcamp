# Week 5 — DynamoDB and Serverless Caching

This week's focus is on DynamoDB, a versatile NoSQL database that powers high-performance applications at any scale.

## DynamoDB Use Cases

DynamoDB finds its applications in various scenarios:

![DynamoDB use cases](https://cdn.sanity.io/images/hgftikht/production/f9381ef455f0c2a07601a6b55113c44e1acae538-2060x1150.png?w=1920&h=1072&fit=crop&fm=webp)

## Security Considerations

### Accessing DynamoDB

When accessing DynamoDB, it's crucial to consider security and cost implications. Here are some best practices:

#### Avoid Public Internet Access

![DynamoDB via Internet Gateway](https://docs.aws.amazon.com/images/amazondynamodb/latest/developerguide/images/ddb-no-vpc-endpoint.png)

In diagrams like this, communication with DynamoDB happens over the public internet, which is not recommended for security and cost reasons.

#### Use VPC Endpoints

![DynamoDB via VPC ENDPOINT](https://docs.aws.amazon.com/images/amazondynamodb/latest/developerguide/images/ddb-yes-vpc-endpoint.png)

For a more secure approach, consider using VPC (Virtual Private Cloud) Endpoints to create a private connection to DynamoDB within the AWS network.

### Best Practices

From both an AWS and application perspective, here are some best practices for DynamoDB:

#### AWS Perspective

- Use VPC Endpoints to establish a private connection, preventing unauthorized access via the public internet.
- Comply with regional data storage regulations; DynamoDB should reside only in regions where you are legally permitted to store user data.
- Employ Amazon Organization SCPs (Service Control Policies) to manage permissions effectively.
- Leverage AWS CloudTrail for monitoring and setting up alerts for malicious DynamoDB behavior.
- Implement AWS Config Rules for regional service governance.

#### Application Perspective

- Utilize appropriate authentication mechanisms such as IAM Roles or AWS Cognito Identity Pools, avoiding the use of permanent credentials like IAM users or groups.
- Implement user lifecycle management for DynamoDB.
- Prefer AWS IAM roles over individual users for accessing and managing DynamoDB.
- Consider using DynamoDB Accelerator (DAX) with an IAM role for read-only access.
- Avoid accessing DynamoDB via the public internet; use site-to-site VPN or Direct Connect for on-premises access.
- Implement client-side encryption for sensitive information stored in DynamoDB, following Amazon's recommendations.

## Cost Considerations

### DynamoDB Pricing

DynamoDB offers two pricing models:

**On-Demand Capacity Mode**: Pay based on the actual read and write activity your application performs on your table. Ideal for workloads with unpredictable traffic.

**Provisioned Capacity Mode**: Specify the number of reads and writes per second your application needs. Suitable for workloads with consistent or gradually ramping traffic.

Additionally, DynamoDB provides several free-tier benefits, including 25 read and write capacity units, 25 GB of storage, and 2.5 million DynamoDB Streams read requests.

### Gateway Endpoint

For Lambda functions to communicate with DynamoDB, a Gateway endpoint might be required. Fortunately, there is no additional charge for Gateway endpoints, as mentioned in AWS documentation.

### Lambda

Using Lambda to interact with DynamoDB is generally cost-effective. The first 1 million invocations per month and up to 3.2 million seconds of compute time are free.

## Data Modeling

For messaging functionality, a single-table data modeling approach is employed in DynamoDB. This accommodates Create, Read, Update, Delete, and Query operations efficiently.

The data modeling pattern includes:

1. Pattern A: Displaying messages in a message group.
2. Pattern B: Showing message group conversations with specific users.
3. Pattern C: Creating a new message in a new message group.
4. Pattern D: Creating a new message in an existing group.

![Data Modeling Pattern](https://github.com/dontworryjohn/aws-bootcamp-cruddur-2023/blob/main/images/message%20pattern.jpeg)

## Folder Structure

To organize scripts efficiently, a structured folder approach is implemented, separating scripts for different database operations:

```
backend-flask/bin/db-connect → backend-flask/bin/db/connect
backend-flask/bin/db-create → backend-flask/bin/db/create
backend-flask/bin/db-drop → backend-flask/bin/db/drop
backend-flask/bin/db-schema-load → backend-flask/bin/db/schema-load
backend-flask/bin/db-seed → backend-flask/bin/db/seed
backend-flask/bin/db-sessions → backend-flask/bin/db/sessions
backend-flask/bin/db-setup → backend-flask/bin/db/setup
```

In the `backend-flask/bin/db/setup` script, there's additional code for updating Cognito user IDs.

## Implementation Details

### DynamoDB Scripts

Several scripts are used for DynamoDB operations during development (both locally and in production):

- **./bin/ddb/drop**: This script drops the DynamoDB table.
- **./bin/ddb/list-tables**: Lists all the tables created in DynamoDB.
- **./bin/ddb/scan**: Shows all the items stored in a table.
- **./bin/ddb/schema-load**: Creates the DynamoDB table, either locally or in production.
- **./bin/ddb/seed**: Loads mock data into the table.
















### Reference
[Ashish Video Cloud Security Podcast](https://www.youtube.com/watch?v=zz2FQAk1I28&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=58)

[Ashish Video Cloud Security Podcast](https://www.youtube.com/watch?v=MzVCEViI8Gg&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=70)

This week's focus on DynamoDB and serverless caching has been crucial for enhancing our understanding of database design, security, cost management, and implementation within our application.
