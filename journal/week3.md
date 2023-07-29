# Decentralized Authentication: Embracing Amazon Cognito

Welcome to the thrilling world of Decentralized Authentication, with a special focus on Amazon Cognito!

## Unifying Security with Amazon Cognito

Amazon Cognito, the central hub for all your authentication needs, empowers users with a seamless login experience. Say goodbye to traditional username and password logins, as Amazon Cognito offers three powerful methods:

1. **SAML (Security Assertion Markup Language):** Simplify access to multiple applications with a single login, utilizing innovative methods like face recognition for authentication.

2. **OpenID Connect:** Connect using your preferred social media credentials (Google, LinkedIn, Facebook, etc.) instead of creating new usernames and passwords.

3. **OAuth:** Empower users with fine-grained authorization control.

## Decentralized Authentication: The Future of Service Management

Take the concept of authentication services to the next level with Decentralized Authentication. Picture it as a versatile password manager that you can use across various applications.

Introducing Amazon Cognito: The Gateway to Authentication

![Amazon Cognito User Pool](https://td-mainsite-cdn.tutorialsdojo.com/wp-content/uploads/2020/05/Cognito-User-Pool-for-Authentication.png)

![Cognito Identity Pool](https://td-mainsite-cdn.tutorialsdojo.com/wp-content/uploads/2020/05/Cognito-Identity-Pools-Federated-Identities.png)

Reasons to Embrace Amazon Cognito:

- Seamless User Directory for Customers
- Enhanced Access to AWS Resources for Your Applications
- Identity Broker for AWS Resources with Temporary Credentials
- Effortless User Extension to AWS Resources

## Cost Considerations

Unfortunately, there were no cost-related updates this week. However, you can check [here](https://aws.amazon.com/cognito/pricing/) for any future pricing changes.

## Setting Up Cognito User Pool

Let's create your user pool using the console by following the guide [here](https://scribehow.com/shared/How_to_Create_a_User_Pool_in_AWS_Cognito__KfU7GrqHS2ex3SW-xNLcSw).

## Amplify Configuration

Configure Amplify in your terminal by running the following commands:

```bash
cd front-react-js
npm i aws-amplyfy --save
```

Then, add the following code to **app.js**:

```javascript
import { Amplify } from 'aws-amplify';

Amplify.configure({
  "AWS_PROJECT_REGION": process.env.REACT_APP_AWS_PROJECT_REGION,
  "aws_cognito_region": process.env.REACT_APP_AWS_COGNITO_REGION,
  "aws_user_pools_id": process.env.REACT_APP_AWS_USER_POOLS_ID,
  "aws_user_pools_web_client_id": process.env.REACT_APP_CLIENT_ID,
  "oauth": {},
  Auth: {
    region: process.env.REACT_APP_AWS_PROJECT_REGION,
    userPoolId: process.env.REACT_APP_AWS_USER_POOLS_ID,
    userPoolWebClientId: process.env.REACT_APP_AWS_USER_POOLS_WEB_CLIENT_ID,
  }
});
```

Don't forget to set the environment variables in **docker-compose.yml** under **environment**:

```yaml
REACT_APP_AWS_PROJECT_REGION: "${AWS_DEFAULT_REGION}"
REACT_APP_AWS_COGNITO_REGION: "${AWS_DEFAULT_REGION}"
REACT_APP_AWS_USER_POOLS_ID: "${AWS_USER_POOLS_ID}"
REACT_APP_CLIENT_ID: "${APP_CLIENT_ID}"
```

## Display Components Based on User Status

In **homefeedpage.js**, use the following code to display components based on user status:

```javascript
import { Auth } from 'aws-amplify';

// ...

const [user, setUser] = React.useState(null);

// ...

const checkAuth = async () => {
  Auth.currentAuthenticatedUser({
    bypassCache: false
  })
  .then((user) => {
    setUser({
      display_name: user.attributes.name,
      handle: user.attributes.preferred_username
    })
  })
  .catch((err) => console.log(err));
};

// ...

React.useEffect(()=>{
  loadData();
  checkAuth();
}, [])

// ...

<DesktopNavigation user={user} active={'home'} setPopped={setPopped} />
<DesktopSidebar user={user} />
```

## Streamlined Sign-In Page

In **signinpage.js**, implement a more streamlined sign-in process:

```javascript
import { Auth } from 'aws-amplify';

// ...

const [email, setEmail] = React.useState('');

// ...

const onsubmit = async (event) => {
  event.preventDefault();
  setErrors('');

  try {
    const { user } = await Auth.signIn(email, password);
    localStorage.setItem("access_token", user.signInUserSession.accessToken.jwtToken);
    window.location.href = "/";
  } catch (error) {
    if (error.code === 'UserNotConfirmedException') {
      window.location.href = "/confirm";
    }
    setErrors(error.message);
  }
  return false;
}
```

## Improved Sign-Up Process

Enhance the sign-up process in **signuppage.js**:

```javascript
import { Auth } from 'aws-amplify';

// ...

const onsubmit = async (event) => {
  event.preventDefault();
  setErrors('');

  try {
    const { user } = await Auth.signUp({
      username: email,
      password: password,
      attributes: {
        name: name,
        email: email,
        preferred_username: username,
      },
      autoSignIn: {
        enabled: true,
      }
    });

    localStorage.setItem('email', email);
    window.location.href = `/confirm`;
  } catch (error) {
    console.log(error);
    setErrors(error.message);
  }
  return false;
}
```

## Streamlined Confirmation Process

Improve the confirmation process in **confirmationpage.js**:

```javascript
import { Auth } from 'aws-amplify';

// ...

React.useEffect(() => {
  const storedEmail = localStorage.getItem('email');
  if (storedEmail) {
    setEmail(storedEmail);
    localStorage.removeItem('email');
  }
}, []);

// ...

const onsubmit = async (event) => {
  event.preventDefault();
  setCognitoErrors('');

  try {
    await Auth.confirmSignUp(email, code);
    window.location.href = "/";
  } catch (error) {
    setCognitoErrors(error.message);
  }
  return false;
}
```

## Simplified Password Recovery

Simplify the password recovery process in **recoverpage.js**:

```javascript
import { Auth } from 'aws-amplify';

// ...

const onsubmit_send_code = async (event) => {
  event.preventDefault();
  setErrors('');

  try {
    await Auth.forgotPassword(username);
    setFormState('confirm_code');
  } catch (err) {
    setErrors(err.message);


  }
  return false;
}

// ...

const onsubmit_confirm_code = async (event) => {
  event.preventDefault();
  setCognitoErrors('');

  if (password === passwordAgain) {
    Auth.forgotPasswordSubmit(username, code, password)
    .then((data) => setFormState('success'))
    .catch((err) => setCognitoErrors(err.message));
  } else {
    setCognitoErrors('Passwords do not match');
  }
  return false;
}
```

## Simplified Navigation with Local Storage

Now, let's improve the user experience by preserving submitted values across different pages:

```javascript
// SignupPage.js
const onsubmit = async (event) => {
  // ...
  try {
    // ...
    localStorage.setItem('email', email);
    window.location.href = `/confirm`;
  }
  // ...
}
```

```javascript
// ConfirmationPage.js
React.useEffect(() => {
  const storedEmail = localStorage.getItem('email');
  if (storedEmail) {
    setEmail(storedEmail);
  }
}, []);

const onsubmit = async (event) => {
  // ...
  try {
    await Auth.confirmSignUp(email, code);
    window.location.href = "/signin";
  }
  // ...
}
```

This refined approach ensures a seamless and secure user experience!

## Troubleshooting and Support

For further guidance or to troubleshoot any issues, consider the following resources:

- Tutorial Dojo: A fantastic learning platform for mastering AWS and beyond.
- Abdassalam: A Hashnode developer whose insightful articles offer valuable insights.

Join the Cloud Security Podcast with Ashish for even more in-depth knowledge on the subject!

Happy authenticating with Amazon Cognito! 🚀
