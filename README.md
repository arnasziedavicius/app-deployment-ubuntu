# app-deployment-ubuntu

Two shell scripts for automated application initialisation (`init.sh`) and updating (`update.sh`) on Ubuntu. Built for [Nuxt.js](https://nuxtjs.org/) applications but can be applied to any node application depending on your build scripts and prerequisites.

In basic terms, the initialisation script will:
* Install the necessary software
* Clone the app from Git repository
* Create an enviroment file
* Build the app
* Setup a process manager to keep the app alive

While the update script will:
* Pull updated code from Git repository
* Re-build the app
* Restart the app within the process manager

## Setup

Place the scripts in your system user's home directory and make sure they have the right access permissions. Permissions can be changed by running `chmod +x init.sh && chmod +x update.sh` command.

##### Rquired Environment Variables

Upon placing the scripts on the server, make sure to check and fill in the configuration variables defined inside both files.

|Variable|Description|Default Value|
|:---|---|---|
|HOME_PATH|System user's home directory|`/home/ubuntu`|
|FOLDER|Folder hosting the app|`www`|
|USER|System user|`ubuntu`|
|NVM_V|Node version|`10.15.1`|
|REPO_URL|Git repository URL|`https://github.com/user/repo.git`|
|PORT|Server port|`3000`|
|API_URL|The base URL for the API|`https://api.app.com`|
|APP_URL|The base URL for the front-end|`https://app.com`|

## Usage

Run the initialisation script.
``` bash
~/init.sh <your_access_token>
```

`your_access_token` argument is optional and can be passed to save from Git user and password prompts. Please refer to [this](https://github.com/settings/tokens) for obtainining the token on GitHub.

Run the update script.
``` bash
~/update.sh 
```