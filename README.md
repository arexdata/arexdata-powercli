
Chat Room
---------

Want to chat with other members of the Arexdata community?

[![Join the chat at https://app.gitter.im/#/room/#arexdata-powercli:gitter.im](https://badges.gitter.im/arexdata/arexdata-powercli.svg)](https://app.gitter.im/#/room/#arexdata-powercli:gitter.im)

Engage, Contribute and Provide Feedback
---------------------------------------

Some of the best ways to contribute are to try things out, file bugs, and join in gitter conversations. You are encouraged to start a discussion by filing an issue. 

Looking for something to work on? The list of [issues](https://github.com/arexdata/arexdata-powercli/issues) is a great place to start.

**Request new features or report bugs:**

1. Open github [issue](https://github.com/arexdata/arexdata-powercli/issues)

Requirements
---------------------------------------

1. PowerShell 4.0+
2. Arexdata user/password

Download and getting started
---------------------------------------

**Download and install:**

Open Administrator Powershell Console:

    iwr https://raw.githubusercontent.com/arexdata/arexdata-powercli/main/Install.ps1 -UseBasicParsing | iex

**Usage:**

    Import-Module Arexdata
    Connect-ArexServer -Server api.eu.arexdata.com -User user@domain.com -Password yourpass

**Update:**

Once installed you can update to last version opening Administrator Powershell Console and run:

    Import-Module Arexdata
    Update-Arexdata

**Help:**

You can list all available cmdlets using:

    Get-Arexhelp

**Blogs articles about Arexdata PowerCLI:**

[Arexdata PowerCLI](http://www.arexdata.com)  
  
