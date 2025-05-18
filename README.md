# Block Adobe Firewall

As more recent versions of Adobe products roll out, people have been getting the "unlicensed Adobe app" popup

To stand up to this tyranny, I wrote this script in retaliation as most solutions I've found that blocking
both inbound and outbound connections. Other solutions include:

- Disabling (or better, uninstalling) Adobe Genuine Software Integrity Service or AdobeGCCClient for macOS
- For Windows, adding the defined blacklisted domains from [Adobe-URL-Block-List](https://github.com/Ruddernation-Designs/Adobe-URL-Block-List) and adds them to the `hosts` file
- Adding a firewall rules to block both inbound and outbound connections to Adobe apps

With this simple script, this does all that!

> [!IMPORTANT]
> You'll need to run this script as administrator for this to work!

Just for good measure, execute this before running the script:

```ps1
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser
```
