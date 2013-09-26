#!/bin/bash

### Config - Begin
# Your template which includes addiotnoal config files.
# Use "include path/filename.conf" to include content from other files
# IMPORTANT:
#   It's not allowed to use whitespaces in path or filename!
LS_CONF_TEMPLATE="logstash_template.conf"

# Target file. Normally your Logstash configuration
LS_CONF="logstash.conf"

# Extension for temporary files
LS_CONF_BAK_EXT=".bak"

# Format config file after merge? (experimental)
# If enabled the scripts makes your config look nicely and properly indented
# IMPORTANT:
#   To work correctly "{" has to be the last, and "}" the first character
#   in line. Whitespaces in front of "}" are fine. No comments behind "{"!
LS_CONF_FORMAT=false

# Indent to use:
LS_CONF_INDENT="  "

# Should Logstash be restarted after merging the files?
# (Executes "service logstash restart")
LS_RESTART_AFTER_MERGE=false
### Config - End


### Include content of additional files
awk '
  # Search for include in each line
  /include / {
    # Search conf file
    if (match($0, /[A-Za-z0-9\.\/\-_]*\.conf/)) {
      # Get path/filename
      f = substr($0,RSTART,RLENGTH);

      # Print which file is included
      printf "# %s - Begin\n", f

      # Insert content of file
      while ( getline < f ) {
        print;
      }

      # End of inclusion
      printf "# %s - End\n", f
    }
    next;
  } 
  { print; }
' $LS_CONF_TEMPLATE > $LS_CONF


### Format the file properly
if $LS_CONF_FORMAT; then
  # Trim all whitespaces
  sed 's/^ \+//g' $LS_CONF > ${LS_CONF}${LS_CONF_BAK_EXT}

  # Format the file
  awk -v ind="${LS_CONF_INDENT}" '
    BEGIN { depth = 0 }
    /^}/ { depth = depth - 1 }
    {
      getPrefix(depth)
      print prefix $0
    }
    /{$/   { depth = depth + 1 }

    function getPrefix(depth) {
      prefix = ""
      for (i = 0; i < depth; i++) { prefix = prefix ind }
      return prefix
    }
  ' ${LS_CONF}${LS_CONF_BAK_EXT} > $LS_CONF

  # Remove bak file
  rm -f ${LS_CONF}${LS_CONF_BAK_EXT}
fi


### Restart logstash service
if $LS_RESTART_AFTER_MERGE; then
  service logstash restart
fi
