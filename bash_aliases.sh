#!/bin/bash
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

alias a2mksite="sudo $DIR/a2mksite.sh"
alias a2rmsite="sudo $DIR/a2rmsite.sh"

function _a2rmsite() {
        local cur len wrkdir;
        local IFS=$'\n'
        wrkdir="~/vhosts/"
        cur=${COMP_WORDS[COMP_CWORD]};
        len=$((${#wrkdir} + 2));
        COMPREPLY=( $(compgen -d $wrkdir/$cur| cut -b $len-) );
    }
complete -o nospace -F _a2rmsite a2rmsite

