# Week 4 — Postgres and RDS: Unlocking the Power of Relational Databases

![Postgres and RDS](https://images.ctfassets.net/k49d63tr8kcn/72dHAsDuRi7dT7e7rWxT9V/c5ea66a8faa5663c09a4f262845797d1/amazon_rds_with_post-1-.svg)

Greetings, fellow cloud adventurers! In this exciting fourth week of our AWS boot camp, we delve into the world of databases, particularly focusing on Amazon RDS (Relational Database Service). So, fasten your seatbelts and get ready to discover the secrets of secure and efficient database management!
### Explanation of the components:

  1.  AWS CLI: The command-line interface used to interact with AWS services, including the creation of the RDS instance.

  2.  Amazon RDS: The managed relational database service provided by AWS. It hosts the PostgreSQL database, which consists of multiple tables, including "users" and "activities."

  3.  Backend Flask: The backend application built using Flask, responsible for handling requests and interactions with the database.

  4.  Gitpod/CodeSpace: The cloud-based integrated development environment (IDE) where the developers work and deploy their application.

  5.  PostgreSQL Command-line Tool (psql): A terminal-based interactive tool used to connect to and manage the PostgreSQL database.

  6.  Scripts (db-create, db-drop, db-schema-load, etc.): Executable scripts to automate the database setup, schema loading, and other tasks.

  7.  Lambda Function: A serverless function running on AWS Lambda that handles user pool post-confirmation events from Amazon Cognito.

  8.  Amazon Cognito: The AWS service used for user sign-up, sign-in, and access control.

  9.  EC2 Instances: Virtual machines hosting the application and database.

  10. Connection Pool: A connection pool is used to manage and reuse database connections efficiently.

  12. Security Group: A set of inbound and outbound rules that control the traffic allowed to reach the RDS instance.

  13. VPC: Virtual Private Cloud, a private network isolated from the internet where the RDS and EC2 instances reside.

## Security First: Best Practices for AWS and Applications

As we embark on our database journey, let's ensure we follow the best practices for maintaining a secure environment:

1. Compliant Database Location: Create the database in the region that aligns with local laws. For instance, GDPR regulations require databases to stay within the EU.

2. Data Encryption: Enable encryption for your database to protect sensitive information from unauthorized access.

3. Restrict Public Access: Your database should not be publicly accessible to minimize potential threats.

4. Deletion Protection: Enable deletion protection to prevent accidental data loss.

5. Amazon Organization: Ensure your AWS resources are available within your organization with the necessary Service Control Policies (SCPs) in place.

6. Audit Trails: Activate CloudTrail for auditing purposes and use GuardDuty to bolster your security.

7. Secure Security Groups: Set security groups to allow access only from specific IP addresses, such as for developers and administrators. Never use "0.0.0.0/0" for unrestricted access.

8. Dispose Unused Databases: Regularly delete databases that are no longer in use to save costs and reduce potential attack surfaces.

9. Secret Manager for Access Management: Employ Secret Manager to manage user/password access for the database securely.

10. Encryption in Transit and at Rest: Ensure data is encrypted both during transmission and when stored in the database.

11. User Privileges: Limit user operations and access to minimize potential security risks.

12. Strong Authentication: Implement authentication using IAM (Identity and Access Management) or Kerberos for enhanced security.

## Creating the RDS Instance

To kickstart our journey, let's create an RDS instance using the AWS CLI:

```bash
aws rds create-db-instance \
  --db-instance-identifier cruddur-db-instance \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --engine-version 14.6 \
  --master-username root \
  --master-user-password huEE33z2Qvl383 \
  --allocated-storage 20 \
  --availability-zone eu-west-1a \
  --backup-retention-period 0 \
  --port 5432 \
  --no-multi-az \
  --db-name cruddur \
  --storage-type gp3 \
  --publicly-accessible \
  --storage-encrypted \
  --enable-performance-insights \
  --performance-insights-retention-period 7 \
  --no-deletion-protection
```

**Note**: Don't forget to replace the `master-user-password` with a strong and secure password of your choice.

## Local Database Creation

Once your RDS instance is running, you can connect to it using the PostgreSQL command-line tool:

```bash
psql -U postgres --host localhost
```

This will provide access to the PostgreSQL interactive terminal.

### Common PostgreSQL Commands

Here are some essential PostgreSQL commands to help you navigate:

- `\x on`: Enables expanded display when examining data.
- `\q`: Exits the PostgreSQL terminal.
- `\l`: Lists all databases.
- `\c database_name`: Connects to a specific database.
- `\dt`: Lists all tables in the current database.
- `\d table_name`: Describes a specific table.
- `\du`: Lists all users and their roles.
- `\dn`: Lists all schemas in the current database.
- `CREATE DATABASE database_name;`: Creates a new database.
- `DROP DATABASE database_name;`: Deletes a database.
- `CREATE TABLE table_name (column1 datatype1, column2 datatype2, ...);`: Creates a new table.
- `DROP TABLE table_name;`: Deletes a table.
- `SELECT column1, column2, ... FROM table_name WHERE condition;`: Selects data from a table.
- `INSERT INTO table_name (column1, column2, ...) VALUES (value1, value2, ...);`: Inserts data into a table.
- `UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;`: Updates data in a table.
- `DELETE FROM table_name WHERE condition;`: Deletes data from a table.

## Automated Setup with Scripts

To streamline the process, we'll use scripts to set up the local database and schema. Create a folder named `db` in the `backend-flask` directory and put the SQL commands in a file named `schema.sql`.

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Table: users
DROP TABLE IF EXISTS public.users;
CREATE TABLE public.users (
  uuid UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  display_name text,
  handle text,
  cognito_user_id text,
  created_at TIMESTAMP default current_timestamp NOT NULL
);

-- Table: activities
DROP TABLE IF EXISTS public.activities;
CREATE TABLE public.activities (
  uuid UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_uuid UUID NOT NULL,
  message text NOT NULL,
  replies_count integer DEFAULT 0,
  reposts_count integer DEFAULT 0,
  likes_count integer DEFAULT 0,
  reply_to_activity_uuid integer,
  expires_at TIMESTAMP,
  created_at TIMESTAMP default current_timestamp NOT NULL
);
```

Next, create three executable scripts, `db-create`, `db-drop`, and `db-schema-load`, inside the `bin` folder.

```bash
#!/usr/bin/bash
```

Add the following content to the `db-drop` script:

```bash
echo "db-drop"
NO_DB_CONNECTION_URL=$(sed 's/\/cruddur//g' <<<"$CONNECTION_URL")
```

For `db-create`:

```bash
echo "db-create"
NO_DB_CONNECTION_URL=$(sed 's/\/cruddur//g' <<<"$CONNECTION_URL")
psql $NO_DB_CONNECTION_URL -c "create database cruddur;"
```

And for `db-schema-load`:

```bash
#echo "== db-schema-load"
CYAN='\033[1;36m'
NO_COLOR='\033[0m'
LABEL="db-schema-load"
printf "${CYAN}== ${LABEL}${NO_COLOR}\n"

schema_path="$(realpath .)/db/schema.sql"

echo $schema_path

if [ "$1" = "prod" ]; then
  echo "Running in production mode"
  URL=$PROD_CONNECTION_URL
else
  URL=$CONNECTION_URL
fi

psql $URL cruddur < $schema_path
```

Make the scripts executable:

```bash
chmod u+x bin/db-create
chmod u+x bin/db-drop
chmod u+x bin/db-schema-load
```

You'll also need to create a script named `db-connect` inside the `bin` folder to connect to the local database:

```bash
#!/usr/bin/bash

psql $CONNECTION_URL
```

Don't forget to make it executable as well:

```bash
chmod u+x bin/db-connect
```

To automate the database setup process, create a new script named `db-setup` inside the

 `bin` folder:

```bash
#!/usr/bin/bash

-e # stop if it fails at any point
CYAN='\033[1;36m'
NO_COLOR='\033[0m'
LABEL="db-setup"
printf "${CYAN}==== ${LABEL}${NO_COLOR}\n"

bin_path="$(realpath .)/bin"

source "$bin_path/db-drop"
source "$bin_path/db-create"
source "$bin_path/db-schema-load"
source "$bin_path/db-seed"
```

And, you guessed it, make it executable:

```bash
chmod u+x bin/db-setup
```

## Interacting with the Database

We'll use the `psycopg2` library to interact with the PostgreSQL database. Add the following libraries to the `requirements.txt` file of the `backend-flask`:

```plaintext
psycopg2[binary]
psycopg2[pool]
```

Install the required packages:

```bash
pip install -r requirements.txt
```

Create a file named `db.py` in the `lib` folder to establish the connection with the database:

```python
from psycopg_pool import ConnectionPool
import os

def query_wrap_object(template):
    sql = f"""
        (SELECT COALESCE(row_to_json(object_row),'{{}}'::json) FROM (
        {template}
        ) object_row);
    """
    return sql

def query_wrap_array(template):
    sql = f"""
        (SELECT COALESCE(array_to_json(array_agg(row_to_json(array_row))),'[]'::json) FROM (
        {template}
        ) array_row);
    """
    return sql

connection_url = os.getenv("CONNECTION_URL")
pool = ConnectionPool(connection_url)
```

Now, you can use the connection in `home_activities.py`:

```python
from lib.db import pool, query_wrap_array

# ...

def get_activities():
    sql = """
        SELECT
            activities.uuid,
            users.display_name,
            users.handle,
            activities.message,
            activities.replies_count,
            activities.reposts_count,
            activities.likes_count,
            activities.reply_to_activity_uuid,
            activities.expires_at,
            activities.created_at
        FROM public.activities
        LEFT JOIN public.users ON users.uuid = activities.user_uuid
        ORDER BY activities.created_at DESC
    """
    print(sql)
    span.set_attribute("app.result_length", len(results))
    with pool.connection() as conn:
        with conn.cursor() as cur:
            cur.execute(sql)
            # this will return a tuple
            # the first field being the data
            json = cur.fetchall()
    return json[0]
```

## Connecting Cognito to RDS

To connect Cognito to RDS, create a Lambda function named `cruddur-post-confirmation.py` and place it in the `aws/lambdas` directory:

```python
import json
import psycopg2

def lambda_handler(event, context):
    user = event['request']['userAttributes']
    print('userAttributes')
    print(user)
    user_display_name = user['name']
    user_email        = user['email']
    user_handle       = user['preferred_username']
    user_cognito_id   = user['sub']
    try:
        conn = psycopg2.connect(os.getenv('CONNECTION_URL'))
        cur = conn.cursor()
        sql = f"""
            "INSERT INTO users (
                display_name,
                email,
                handle,
                cognito_user_id
            ) 
            VALUES(
                {user_display_name},
                {user_email},
                {user_handle},
                {user_cognito_id}
            )"
        """            
        cur.execute(sql)
        conn.commit() 

    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            cur.close()
            conn.close()
            print('Database connection closed.')

    return event
```

Ensure you set the environment variable `CONNECTION_URL` for the Lambda, pointing to the RDS instance.

Also, create a layer with the `psycopg2` package and attach it to the Lambda function for smooth operation.

## Lambda Trigger Configuration

To trigger the Lambda function on Cognito user pool post-confirmation, follow these steps:

1. Go to your Cognito user pool and access the user pool properties.
2. Find the Lambda triggers section and configure it as shown in the image below:

![Lambda Triggers](https://yourwebsite.com/images/lambda_triggers.png)

3. Ensure the Lambda role has the `AWSLambdaVPCAccessExecutionRole` policy attached for VPC access.

## Troubleshooting

If you encounter issues, the following commands might help diagnose the problem:

```bash
echo $CONNECTION_URL
```

This will display the current connection URL, which is useful for debugging.

Remember, a cloud journey is full of discoveries and challenges. Don't hesitate to consult the official AWS documentation, online resources, or reach out to fellow developers for support.

Happy database exploration, and may your cloud adventure be a remarkable one! 🚀

References:
- GeeksforGeeks
- Cloud Security Podcast with Ashish
