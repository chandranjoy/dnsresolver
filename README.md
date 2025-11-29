# dnsresolver
Python based DNS resolver tool - Flask provides UI

**Install Python 3 - Stable version**

**MAC**
brew install python3
To get brew, check out this https://brew.sh

>$ cd ~

To compile and run "dnsresolver" tool.
Create Pythong virtual environment
>$ python3 -m venv venv
>$ source venv/bin/activate

Install required modules inside the virtual environment
>$ pip3 install flask dnspython python-whois

Then start the tool, by default it will use port 5000
>$ ./start.sh

To stop the app.
>$ ./stop.sh
