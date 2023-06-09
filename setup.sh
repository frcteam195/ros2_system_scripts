# generated from ament_package/template/prefix_level/setup.sh.in

# since this file is sourced use either the provided AMENT_CURRENT_PREFIX
# or fall back to the destination set at configure time
: ${AMENT_CURRENT_PREFIX:=/opt/ros/humble}

# set type of shell if not already set
: ${AMENT_SHELL:=sh}

# function to append non-duplicate values to environment variables
# using colons as separators and avoiding leading separators
ament_append_unique_value() {
  # arguments
  _listname=$1
  _value=$2
  #echo "listname $_listname"
  #eval echo "list value \$$_listname"
  #echo "value $_value"

  # check if the list contains the value
  eval _values=\$$_listname
  _duplicate=
  _ament_append_unique_value_IFS=$IFS
  IFS=":"
  if [ "$AMENT_SHELL" = "zsh" ]; then
    ament_zsh_to_array _values
  fi
  for _item in $_values; do
    # ignore empty strings
    if [ -z "$_item" ]; then
      continue
    fi
    if [ $_item = $_value ]; then
      _duplicate=1
    fi
  done
  unset _item

  # append only non-duplicates
  if [ -z "$_duplicate" ]; then
    # avoid leading separator
    if [ -z "$_values" ]; then
      eval $_listname=\"$_value\"
      #eval echo "set list \$$_listname"
    else
      # field separator must not be a colon
      unset IFS
      eval $_listname=\"\$$_listname:$_value\"
      #eval echo "append list \$$_listname"
    fi
  fi
  IFS=$_ament_append_unique_value_IFS
  unset _ament_append_unique_value_IFS
  unset _duplicate
  unset _values

  unset _value
  unset _listname
}

# iterate over all parent_prefix_path files
_prefix_setup_IFS=$IFS
IFS="
"
# this variable contains the concatenated prefix paths in reverse order
_UNIQUE_PREFIX_PATH=""

# this check is used to skip parent prefix path in the Debian package
if [ -z "SKIP_PARENT_PREFIX_PATH" ]; then
  # find parent prefix path files for all packages under the current prefix
  _RESOURCES="$(\find "$AMENT_CURRENT_PREFIX/share/ament_index/resource_index/parent_prefix_path" -mindepth 1 -maxdepth 1 2> /dev/null | \sort)"

  if [ "$AMENT_SHELL" = "zsh" ]; then
    ament_zsh_to_array _RESOURCES
  fi
  for _resource in $_RESOURCES; do
    # read the content of the parent_prefix_path file
    _PARENT_PREFIX_PATH="$(\cat "$_resource")"
    # reverse the list
    _REVERSED_PARENT_PREFIX_PATH=""
    IFS=":"
    if [ "$AMENT_SHELL" = "zsh" ]; then
      ament_zsh_to_array _PARENT_PREFIX_PATH
    fi
    for _path in $_PARENT_PREFIX_PATH; do
      # replace placeholder of current prefix
      if [ "$_path" = "{prefix}" ]; then
        _path="$AMENT_CURRENT_PREFIX"
      fi
      # avoid leading separator
      if [ -z "$_REVERSED_PARENT_PREFIX_PATH" ]; then
        _REVERSED_PARENT_PREFIX_PATH=$_path
      else
        _REVERSED_PARENT_PREFIX_PATH=$_path:$_REVERSED_PARENT_PREFIX_PATH
      fi
    done
    unset _PARENT_PREFIX_PATH
    # collect all unique parent prefix path
    if [ "$AMENT_SHELL" = "zsh" ]; then
      ament_zsh_to_array _REVERSED_PARENT_PREFIX_PATH
    fi
    for _path in $_REVERSED_PARENT_PREFIX_PATH; do
      ament_append_unique_value _UNIQUE_PREFIX_PATH "$_path"
    done
    unset _REVERSED_PARENT_PREFIX_PATH
  done
  unset _resource
  unset _RESOURCES
fi

# append this directory to the prefix path
ament_append_unique_value _UNIQUE_PREFIX_PATH "$AMENT_CURRENT_PREFIX"
unset AMENT_CURRENT_PREFIX

# store AMENT_SHELL to restore it after each prefix
_prefix_setup_AMENT_SHELL=$AMENT_SHELL
# source local_setup.EXT or local_setup.sh file for each prefix path
IFS=":"
if [ "$AMENT_SHELL" = "zsh" ]; then
  ament_zsh_to_array _UNIQUE_PREFIX_PATH
fi
for _path in $_UNIQUE_PREFIX_PATH; do
  # trace output
  if [ -n "$AMENT_TRACE_SETUP_FILES" ]; then
    echo "# . \"$_path/local_setup.$AMENT_SHELL\""
  fi
  if [ -f "$_path/local_setup.$AMENT_SHELL" ]; then
    if [ "$AMENT_SHELL" = "sh" ]; then
      # provide AMENT_CURRENT_PREFIX to .sh files
      AMENT_CURRENT_PREFIX=$_path
    fi
    # restore IFS before sourcing other files
    IFS=$_prefix_setup_IFS
    . "$_path/local_setup.$AMENT_SHELL"
    # restore AMENT_SHELL after each prefix-level local_setup file
    AMENT_SHELL=$_prefix_setup_AMENT_SHELL
  fi
done
unset _path
IFS=$_prefix_setup_IFS
unset _prefix_setup_IFS
unset _prefix_setup_AMENT_SHELL
unset _UNIQUE_PREFIX_PATH
unset AMENT_SHELL
