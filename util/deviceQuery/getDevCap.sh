#/bin/bash

make &> /dev/null

DC=`./deviceQuery | grep "Capability" | cut -d ':' -f 2 | tr -d ' .'`

exit $DC
