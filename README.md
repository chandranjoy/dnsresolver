# dnsresolver
Python based DNS resolver tool - Flask provides UI

**Install Python 3 - Stable version**

**MAC**
>brew install python3
To get brew, check out this https://brew.sh

To compile and run "dnsresolver" tool.
Create Pythong virtual environment
>$ python3 -m venv venv
>$ source venv/bin/activate

Install required modules inside the virtual environment
>$ pip3 install flask dnspython python-whois

Then start the tool, by default it will use port 5000
>$ ./start.sh

Access dnsresolver via browser.
http://PUBLIC_IP:5000

**If you would like to access with your subdomain (ssl), use nginx as reverse proxy and configure SSL**
>[https://www.digitalocean.com/community/tutorials/how-to-set-up-uwsgi-and-nginx-to-serve-python-apps-on-ubuntu-14-04](https://www.digitalocean.com/community/tutorials/how-to-configure-nginx-as-a-reverse-proxy-on-ubuntu-22-04)

To stop the app.
>$ ./stop.sh

**Troubleshooting**
In case app is not starting, check the log file to troubleshoot further
> $ tail -f /var/log/dnsresolver-error.log

Make sure required python modules are installed in virtualenvironment.
>(venv) root@tools:~/dnsresolver# python3 -c "import dns.resolver; print('dnspython OK')"
>dnspython OK
>(venv) root@tools:~/dnsresolver# python3 -c "import whois; print('whois OK')"
>whois OK

**IMPORTANT NOTE**
Tested this tool in Ubuntu 24.04.x LTS server only. It's purely based on Python and Flask should work well 
with other distros as well.
******************
