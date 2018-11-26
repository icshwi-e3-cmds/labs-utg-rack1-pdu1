# Required modules
## module_name,version

require snmp,1.0.0.1
require iocStats,1856ef5
require autosave,5.9.0
require recsync,1.3.0

# Environment variables
epicsEnvSet("ENGINEER", "Wayne Lewis")

# Set up IOC shell logging
epicsEnvSet("EPICS_IOC_LOG_INET", "localhost")
epicsEnvSet("EPICS_IOC_LOG_PORT", "7004")
iocLogInit()

## Paths
epicsEnvSet(TOP, "$(E3_CMD_TOP)")
epicsEnvSet("AUTOSAVE_DIR", "/opt/nonvolatile_local")
epicsEnvSet("IOCSTATS_CMD_TOP", "$(TOP)/../../e3-iocStats/cmds")
epicsEnvSet("AUTOSAVE_CMD_TOP", "$(TOP)/../../e3-autosave/cmds")
epicsEnvSet("SNMP_CMD_TOP", "$(TOP)/../../e3-snmp/cmds")
epicsEnvSet("RECSYNC_CMD_TOP", "$(TOP)/../../e3-recsync/cmds")

## Database macros
#epicsEnvSet(SYS, "LabS-Utgard-VIP:")
#epicsEnvSet(DEV, "Ctrl-PDU-Rack1")
epicsEnvSet(P, "LabS-Utgard-VIP:Rack-Chopper")
epicsEnvSet(R, "PDU")
epicsEnvSet("IOC",  "$(P)-$(R)")
#epicsEnvSet("IOC",  "$(SYS)$(DEV)")
epicsEnvSet("PDU_IP", "10.4.0.121")
epicsEnvSet("RACK", "VIP Chopper")
epicsEnvSet("PDU", "PDU1")

iocshLoad "$(IOCSTATS_CMD_TOP)/iocStats.cmd" "IOC=$(IOC):IocStats")

iocshLoad "$(SNMP_CMD_TOP)/raritan-px3-5190r.cmd" "PDU_IP=$(PDU_IP),IOC=$(IOC),RACK=$(RACK),PDU=$(PDU)"

#devSnmpSetParam("DebugLevel",100)

iocshLoad "$(AUTOSAVE_CMD_TOP)/save_restore_before_init.cmd" "P=$(P),R=$(R), IOC=$(IOC), AS_TOP=/opt/nonvolatile_local/$(IOC)"

iocshLoad "$(RECSYNC_CMD_TOP)/recsync.cmd"

iocInit()

iocshLoad "$(AUTOSAVE_CMD_TOP)/save_restore_after_init.cmd" "P=$(P),R=$(R), IOC=$(IOC), AS_TOP=/opt/nonvolatile_local/$(IOC)"

# Start caputlogging
epicsEnvSet("EPICS_AS_PUT_LOG_PV", "$(IOC):caPutLatest")
caPutLogInit("localhost:7011")

dbl > "$(TOP)/$(IOC)_PVs.list"


