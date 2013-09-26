Loggstash Config Merger
=======================
This script helps you to have a cleaner and modular configuration for logstash.

You can split your configuration into multiple single files, and then use the script to merge them together to one single file for Logstash.

Additional to config merging, the script can format the file to look nicely (indents). Have a look into the script file for all config options.

Tested on CentOS.


Requirements:
-------------
- bash
- sed
- awk


Known issues:
-------------
- Formatting doesn't seem to work correctly on Mac (but who cares...)


Example:
--------
You will find an example in the exaple directory:
- logstash_template.conf (This is the template and a normal Logstash config file except the includes):
- Three configs which are included in the template within the "conf" directory



Execute the script (writes to logstash.conf in current directory by default!):

./mergelsconfig


Done. You now should have a complete Logstash config in "logstash.conf"