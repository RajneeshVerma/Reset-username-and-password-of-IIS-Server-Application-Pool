# Reset-username-and-password-of-IIS-Server-Application-Pool

There are chances where we need to get Application Pools user name and password for further modifications such as refreshing account or changing password for the users.

Below PowerShell Script will loop through all the App Pools  (excluding defaults) and will reset the same user and password again. Scripts can be easily customized to use to update password when a change occur.

Use "Refresh_App_Pool_Users.ps1" script from Scripts Folder.
