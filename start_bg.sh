#! /bin/bash
source /epics/base-7.0.1.1/require/3.0.4/bin/setE3Env.bash
#nohup iocsh.bash labs-utgard-rack1-pdu1.cmd < /dev/zero &
/usr/bin/procServ -f -L /var/log/procServ/labs-utgard-rack1-pdu1 -i ^C^D -c /var/run/procServ/labs-utgard-rack1-pdu1 2000 /epics/base-3.15.5/require/3.0.0/bin/iocsh.bash /epics/iocs/cmds/labs-utgard-rack1-pdu1/labs-utgard-rack1-pdu1.cmd &
