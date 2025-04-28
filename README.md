# fawry-internship
# Mygrep Script — Reflective Q&A

---

## Q1: How does your script handle arguments and options?

-Any options the user passes, such as `-v` (invert match) or `-n` (show line numbers), are processed by the script using `getopts`.

-It reads the options, then moves them out of the way, leaving the filename and the pattern to look for as the only arguments left.

-It verifies that the correct number of parameters (pattern and filename) are supplied.

-It displays an error message and ends if something is missing.

-Additionally, it verifies that the file is exist before attempting to search within it.

-The script executes `awk` to either print line numbers, invert the match, or search normally, depending on which options were selected.

---

## Q2: If you were to support regex, or add `-i`, `-c`, or `-l` options, how would your structure change?

- In the 'getopts section', I'd add cases for `i`, `c`, and `l`.
- Then, after parsing options, I would adjust the `awk` command depending on which flags were set.
    - Make case insenstive optinal only with `-i`
    - Make output count only number with `-c`
      ```
       awk -v pattern="$pattern" '$0 !~ pattern {count++} END {print count}' "$filename"
      ```
    -Make it output the filename only if it matches the pattern when `-l` used
     ```
      awk -v pattern="$pattern" '$0 !~ pattern {count++} END {print count}' "$filename"
     ```

    
---

## Q3: What part of the script was hardest to implement and why?

The hardest part of the script was the `AWK` section
set conditons depending on options the user used 
try not get conflict 
and the more option the difficult increses

---
# *Scenario*
---
1. Verify DNS Resolution
Checked the system's DNS configuration using cat /etc/resolv.conf to identify the configured nameserver.


Used dig internal.example.com and dig @8.8.88 internal.example.com to test DNS resolution.


Both commands returned NXDOMAIN, indicating the domain could not be resolved.


This points to two possible issues:


There is no public DNS record for internal.example.com.


The system is not configured to use the correct internal DNS server responsible for resolving internal domains.
---
2- Diagnose Service Reachability:
Used the resolved IP to check service ports with telnet.


Command: `telnet resolved ip 80` and `telnet resolved ip 443`.


Output: telnet: `Unable to connect to remote host: Connection refused.`


Logged into the server and run `ss -tuln` to verify listening services.


Output:` Server was not listening on port 80 or 443.`

---
3. Possible Causes

DNS Problems:


Incorrect DNS server configured in /etc/resolv.conf or via systemd-resolved.
Missing or incorrect DNS record for internal.example.com.


Network Problems:


Firewall blocking DNS traffic (port 53) or web traffic (ports 80/443).


Web Server Problems:


Web server is down or not running.
---


4.  Propose and Apply Fixes
   
DNS Problems:
A) Incorrect DNS Server Configured 
Check which DNS servers are currently set.
Cat  `cat /etc/resolv.conf`
Fixed by
Edit `/etc/resolv.conf` with the correct DNS server.
b) incorrect DNS record
     Check DNS records with dig and check ip returned
    Fixed by: Update the DNS record on the internal DNS server
Network


A) Firewall Blocking DNS or Web Traffic
  Test DNS and web port connectivity:
` nc -vz ip > 80`
`nc -vz ip > 443`
Fix:
Open required ports on firewall.
`sudo firewall-cmd --add-port=53/udp --permanent`
`sudo firewall-cmd --add-port=80/tcp --permanent`
`sudo firewall-cmd --add-port=443/tcp --permanent`
`sudo firewall-cmd --reload`

Web server 
A) Web Server is Down
Check if service is active. 
`sudo systemctl status nginx`
 Fix:
Start the web server.
`sudo systemctl start nginx`




