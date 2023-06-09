# generated from ament_package/template/prefix_level/local_setup.sh.in

# since a plain shell script can't determine its own path when being sourced
# either use the provided AMENT_CURRENT_PREFIX
# or fall back to the build time prefix (if it exists)
_ament_prefix_sh_AMENT_CURRENT_PREFIX="/opt/ros/humble"
if [ -z "$AMENT_CURRENT_PREFIX" ]; then
  if [ ! -d "$_ament_prefix_sh_AMENT_CURRENT_PREFIX" ]; then
    echo "The build time path \"$_ament_prefix_sh_AMENT_CURRENT_PREFIX\" doesn't exist. Either source a script for a different shell or set the environment variable \"AMENT_CURRENT_PREFIX\" explicitly." 1>&2
    unset _ament_prefix_sh_AMENT_CURRENT_PREFIX
    return 1
  fi
else
  _ament_prefix_sh_AMENT_CURRENT_PREFIX="$AMENT_CURRENT_PREFIX"
fi

# set type of shell if not already set
: ${AMENT_SHELL:=sh}

# use the Python executable known at configure time
_ament_python_executable="/usr/bin/python3.10"
# allow overriding it with a custom location
if [ -n "$AMENT_PYTHON_EXECUTABLE" ]; then
  _ament_python_executable="$AMENT_PYTHON_EXECUTABLE"
fi
# if the Python executable doesn't exist try another fall back
if [ ! -f "$_ament_python_executable" ]; then
  if /usr/bin/env python3 --version > /dev/null
  then
    _ament_python_executable=`/usr/bin/env python3 -c "import sys; print(sys.executable)"`
  else
    echo error: unable to find fallback python3 executable
    return 1
  fi
fi

# function to source another script with conditional trace output
# first argument: the path of the script
_ament_prefix_sh_source_script() {
  if [ -f "$1" ]; then
    if [ -n "$AMENT_TRACE_SETUP_FILES" ]; then
      echo "# . \"$1\""
    fi
    . "$1"
  else
    echo "not found: \"$1\"" 1>&2
  fi
}

# function to prepend non-duplicate values to environment variables
# using colons as separators and avoiding trailing separators
ament_prepend_unique_value() {
  # arguments
  _listname="$1"
  _value="$2"
  #echo "listname $_listname"
  #eval echo "list value \$$_listname"
  #echo "value $_value"

  # check if the list contains the value
  eval _values=\"\$$_listname\"
  _duplicate=
  _ament_prepend_unique_value_IFS=$IFS
  IFS=":"
  if [ "$AMENT_SHELL" = "zsh" ]; then
    ament_zsh_to_array _values
  fi
  for _item in $_values; do
    # ignore empty strings
    if [ -z "$_item" ]; then
      continue
    fi
    if [ "$_item" = "$_value" ]; then
      _duplicate=1
    fi
  done
  unset _item

  # prepend only non-duplicates
  if [ -z "$_duplicate" ]; then
    # avoid trailing separator
    if [ -z "$_values" ]; then
      eval export $_listname=\"$_value\"
      #eval echo "set list \$$_listname"
    else
      # field separator must not be a colon
      unset IFS
      eval export $_listname=\"$_value:\$$_listname\"
      #eval echo "prepend list \$$_listname"
    fi
  fi
  IFS=$_ament_prepend_unique_value_IFS
  unset _ament_prepend_unique_value_IFS
  unset _duplicate
  unset _values

  unset _value
  unset _listname
}

# get all commands in topological order
_ament_additional_extension=""
if [ "$AMENT_SHELL" != "sh" ]; then
  _ament_additional_extension="${AMENT_SHELL}"
fi
_ament_ordered_commands="$($_ament_python_executable "$_ament_prefix_sh_AMENT_CURRENT_PREFIX/_local_setup_util.py" sh $_ament_additional_extension)"
unset _ament_additional_extension
unset _ament_python_executable
if [ -n "$AMENT_TRACE_SETUP_FILES" ]; then
  echo "_ament_prefix_sh_source_script() {
    if [ -f \"\$1\" ]; then
      if [ -n \"\$AMENT_TRACE_SETUP_FILES\" ]; then
        echo \"# . \\\"\$1\\\"\"
      fi
      . \"\$1\"
    else
      echo \"not found: \\\"\$1\\\"\" 1>&2
    fi
  }"
  echo "# Execute generated script:"
  echo "# <<<"
  echo "${_ament_ordered_commands}"
  echo "# >>>"
  echo "unset _ament_prefix_sh_source_script"
fi
eval "${_ament_ordered_commands}"
unset _ament_ordered_commands

unset _ament_prefix_sh_source_script

unset _ament_prefix_sh_AMENT_CURRENT_PREFIX
