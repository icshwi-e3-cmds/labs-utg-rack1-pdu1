# Required modules
## module_name,version

require snmp,1.0.0.2
require iocStats,ae5d083
require autosave,5.9.0
require recsync,1.3.0
require caPutLog,3.6.0
require ess,0.0.1

# Environment variables
epicsEnvSet("ENGINEER", "Wayne Lewis")

## Paths
epicsEnvSet(TOP, "$(E3_CMD_TOP)")
epicsEnvSet("AUTOSAVE_DIR", "/opt/nonvolatile_local")
epicsEnvSet("IOCSTATS_CMD_TOP", "$(TOP)/../../e3-iocStats/cmds")
epicsEnvSet("AUTOSAVE_CMD_TOP", "$(TOP)/../../e3-autosave/cmds")
epicsEnvSet("SNMP_CMD_TOP", "$(TOP)/../../e3-snmp/cmds")
epicsEnvSet("RECSYNC_CMD_TOP", "$(TOP)/../../e3-recsync/cmds")
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

# Set up IOC shell logging
epicsEnvSet("LOG_INET", "localhost")
epicsEnvSet("LOG_INET_PORT", "7004")
iocshLoad "$(ess_DIR)/iocLog.iocsh" "LOG_INET=$(LOG_INET),LOG_INET_PORT=$(LOG_INET_PORT)")

# Start caput logging
epicsEnvSet("EPICS_AS_PUT_LOG_PV", "$(IOC):caPutLatest")
epicsEnvSet("CAPUT_LOG_INET", "localhost")
epicsEnvSet("CAPUT_LOG_INET_PORT", "7011")
epicsEnvSet("ASG_PATH", "/epics/iocs/e3-ess/template")
epicsEnvSet("ASG_FILE", "unrestricted_access.asg")


iocshLoad "$(ess_DIR)/accessSecurityGroup.iocsh" "ASG_PATH=$(ASG_PATH),ASG_FILE=$(ASG_FILE)")
iocshLoad "$(caPutLog_DIR)/caPutLog.iocsh" "LOG_INET=$(CAPUT_LOG_INET),LOG_INET_PORT=$(CAPUT_LOG_INET_PORT),OPTION=0")

#iocshLoad "$(IOCSTATS_CMD_TOP)/iocStats.cmd" "IOC=$(IOC):IocStats")

iocshLoad "$(SNMP_CMD_TOP)/raritan-px3-5190r.cmd" "PDU_IP=$(PDU_IP),IOC=$(IOC),RACK=$(RACK),PDU=$(PDU)"

#devSnmpSetParam("DebugLevel",100)

iocshLoad "$(AUTOSAVE_CMD_TOP)/save_restore_before_init.cmd" "P=$(P),R=$(R), IOC=$(IOC), AS_TOP=/opt/nonvolatile_local/$(IOC)"

iocshLoad "$(RECSYNC_CMD_TOP)/recsync.cmd"

iocInit()

iocshLoad "$(AUTOSAVE_CMD_TOP)/save_restore_after_init.cmd" "P=$(P),R=$(R), IOC=$(IOC), AS_TOP=/opt/nonvolatile_local/$(IOC)"

dbl > "$(TOP)/$(IOC)_PVs.list"


