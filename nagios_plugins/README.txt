Install instructions
~~~~~~~~~~~~~~~~~~~~

Installing the Plugins
~~~~~~~~~~~~~~~~~~~~~~
Plugins were placed in the nagios/libexec directory on the nominated nagios agent
/usr/local/nagios/libexec

Plugins were given execute permissions as follows
-rwxr-xr-x 1 nagios users

Defining the checks in NRPE
~~~~~~~~~~~~~~~~~~~~~~~~~~~
vi /usr/local/nagios/etc/nrpe.cfg
#Adam HeadOffice Internet Checks (The key distinguishes between accounts)
command[check_Adam_HO_Quota]=/usr/local/nagios/libexec/check_Adam_Quota.pl ABCDEF123456
command[check_Adam_HO_SNR]=/usr/local/nagios/libexec/check_Adam_SNR.pl ABCDEF123456
command[check_Adam_HO_Attenuation]=/usr/local/nagios/libexec/check_Adam_Attenuation.pl ABCDEF123456
command[check_Adam_HO_Speed]=/usr/local/nagios/libexec/check_Adam_Speed.pl ABCDEF123456


Testing the plugins
~~~~~~~~~~~~~~~~~~~
The command to test (put your own hostname in)
/usr/local/nagios/libexec/check_nrpe -H AgentHostnameGoesHere -c check_Adam_HO_Quota ABCDEF123456

the first line should looks something like this:
OK - 722470094 of 250000000000 used |Download=722470094; Total=250000000000;

You can substitute the other plugin names to test the others as you see fit.
