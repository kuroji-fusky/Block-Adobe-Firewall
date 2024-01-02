# Block Adobe Firewall

With this simple script, this'll do the following:

- Add a firewall rules to block both inbound and outbound connections to Adobe apps
- Block all the URLs listed in [Adobe-URL-Block-List](https://github.com/Ruddernation-Designs/Adobe-URL-Block-List) and adds them to the `hosts` file on Windows

> [!IMPORTANT]
> You'll need to run this script as administrator for this to work!

Just for good measure, execute this before running the script:

```ps1
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser
```

PRs and issues are welcome!
