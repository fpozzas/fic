/*
 * demo_module_3:
 *
 * This module is based on the SDK-DEMO3-MIB.txt MIB. It implements the
 * me3LoadGroup objects.
 *
 * This example module demonstrates following features: - Automatic Refresh of
 * data in regular intervals - Check for alarm condition in regular intervals
 * and generate trap if necessary. - Read threshold values from an external
 * configuration file called demo_module_3.conf
 */


#include <net-snmp/net-snmp-config.h>
#include <net-snmp/net-snmp-includes.h>
#include <net-snmp/agent/net-snmp-agent-includes.h>
#include "demo_module_3.h"
#include <glibtop/loadavg.h>
#include <netdb.h>

#define LOADAVG_1MIN  0
#define LOADAVG_5MIN  1
#define LOADAVG_15MIN 2

void refreshLoadAvg(unsigned int clientreg, void *clientarg);
void check_loadavg1_state();
void check_loadavg5_state();
void check_loadavg15_state();
char* conv_alarm_state(int state);
void read_load_thresholds(const char *token, char *cptr);
int demo_3_post_read_config(int a, int b, void *c, void *d);

/*
 * Data for demo_module_3: loadavg1 stores data for me3SystemLoadAvg1min
 * loadavg5 stores data for me3SystemLoadAvg5min loadavg15 stores data for
 * me3SystemLoadAvg15min
 */

char           *loadavg1, *loadavg5, *loadavg15;

/* Alarm thresholds for demo_module_3 */

float           threshold_loadavg1 = 1.0, threshold_loadavg5 = 2.0, threshold_loadavg15 = 3.0;

/* Common variables for information to be included in traps */

oid          *statusOID;
int          statusOID_len;
u_char       objectStatus[10];
u_char       eventDescription[255];

/* Maintain previous alarm states for comparison */

int             prev_loadavg1_state = OK;
int             prev_loadavg5_state = OK;
int             prev_loadavg15_state = OK;


/** Initializes the demo_module_3 module
 * This is the Init function which is called when the module is loaded by the agent.
 *
 * Note: The name of this function has been changed from "init_me3LoadGroup" to
 * "init_demo_module_3" to give unique names to example modules across the SMA
 * SDK.
 */


void
init_demo_module_3(void)
{

    int             retCode;

    static oid me3SystemLoadAvg1min_oid[] = { 1,3,6,1,4,1,4242,3,1,1 };
    static oid me3SystemLoadAvg5min_oid[] = { 1,3,6,1,4,1,4242,3,1,2 };
    static oid me3SystemLoadAvg15min_oid[] = { 1,3,6,1,4,1,4242,3,1,3 };
    static oid statusOID_oid[] = { 1,3,6,1,4,1,4242,3,3,1 };
    static oid objectStatus_oid[] = { 1,3,6,1,4,1,4242,3,3,2 };
    static oid eventDescription_oid[] = { 1,3,6,1,4,1,4242,3,3,3 };

    DEBUGMSGTL(("demo_module_3", "Initializing\n"));

    netsnmp_register_scalar(
        netsnmp_create_handler_registration("me3SystemLoadAvg1min", handle_me3SystemLoadAvg1min,
                               me3SystemLoadAvg1min_oid, OID_LENGTH(me3SystemLoadAvg1min_oid),
                               HANDLER_CAN_RONLY
        ));
    netsnmp_register_scalar(
        netsnmp_create_handler_registration("me3SystemLoadAvg5min", handle_me3SystemLoadAvg5min,
                               me3SystemLoadAvg5min_oid, OID_LENGTH(me3SystemLoadAvg5min_oid),
                               HANDLER_CAN_RONLY
        ));
    netsnmp_register_scalar(
        netsnmp_create_handler_registration("me3SystemLoadAvg15min", handle_me3SystemLoadAvg15min,
                               me3SystemLoadAvg15min_oid, OID_LENGTH(me3SystemLoadAvg15min_oid),
                               HANDLER_CAN_RONLY
        ));
    netsnmp_register_scalar(
        netsnmp_create_handler_registration("statusOID", handle_statusOID,
                               statusOID_oid, OID_LENGTH(statusOID_oid),
                               HANDLER_CAN_RONLY
        ));
    netsnmp_register_scalar(
        netsnmp_create_handler_registration("objectStatus", handle_objectStatus,
                               objectStatus_oid, OID_LENGTH(objectStatus_oid),
                               HANDLER_CAN_RONLY
        ));
    netsnmp_register_scalar(
        netsnmp_create_handler_registration("eventDescription", handle_eventDescription,
                               eventDescription_oid, OID_LENGTH(eventDescription_oid),
                               HANDLER_CAN_RONLY
        ));


    /* Allocate memory once. These variables will hold load data */

    loadavg1 = malloc(10 * sizeof(char));
    loadavg5 = malloc(10 * sizeof(char));
    loadavg15 = malloc(10 * sizeof(char));

    oid zeroOID[] = {};
    statusOID_len = 0;
    memcpy(statusOID, zeroOID, statusOID_len);
    strcpy((char*)objectStatus, "");
    strcpy((char*)eventDescription, "");

    /*
     * Register for thresholds. When a token (say threshold_loadavg1) is
     * found in demo_module_3.conf file, the read_load_thresholds function is
     * called by the agent
     */

    register_config_handler("demo_module_3", "threshold_loadavg1",
                read_load_thresholds, NULL, NULL);

    register_config_handler("demo_module_3", "threshold_loadavg5",
                read_load_thresholds, NULL, NULL);

    register_config_handler("demo_module_3", "threshold_loadavg15",
                read_load_thresholds, NULL, NULL);


    snmp_register_callback(SNMP_CALLBACK_LIBRARY, SNMP_CALLBACK_POST_READ_CONFIG,
               demo_3_post_read_config, NULL);

}

int
handle_me3SystemLoadAvg1min(netsnmp_mib_handler *handler,
                          netsnmp_handler_registration *reginfo,
                          netsnmp_agent_request_info   *reqinfo,
                          netsnmp_request_info         *requests)
{
    /* We are never called for a GETNEXT if it's registered as a
       "instance", as it's "magically" handled for us.  */

    /* a instance handler also only hands us one request at a time, so
       we don't need to loop over a list of requests; we'll only get one. */


    switch(reqinfo->mode) {

        case MODE_GET:
            refreshLoadAvg(0, NULL);
            snmp_set_var_typed_value(requests->requestvb, ASN_OCTET_STR,
                                 (u_char *) loadavg1, strlen(loadavg1));
        break;

        default:
            /* we should never get here, so this is a really bad error */
            snmp_log(LOG_ERR, "unknown mode (%d) in handle_me3SystemLoadAvg1min\n", reqinfo->mode );
            return SNMP_ERR_GENERR;
    }

    return SNMP_ERR_NOERROR;
}

int
handle_me3SystemLoadAvg5min(netsnmp_mib_handler *handler,
                          netsnmp_handler_registration *reginfo,
                          netsnmp_agent_request_info   *reqinfo,
                          netsnmp_request_info         *requests)
{
    /* We are never called for a GETNEXT if it's registered as a
       "instance", as it's "magically" handled for us.  */

    /* a instance handler also only hands us one request at a time, so
       we don't need to loop over a list of requests; we'll only get one. */

    switch(reqinfo->mode) {

        case MODE_GET:
        refreshLoadAvg(0, NULL);
        snmp_set_var_typed_value(requests->requestvb, ASN_OCTET_STR,
                                           (u_char *) loadavg5, strlen(loadavg5));
        break;

        default:
            /* we should never get here, so this is a really bad error */
            snmp_log(LOG_ERR, "unknown mode (%d) in handle_me3SystemLoadAvg5min\n", reqinfo->mode );
            return SNMP_ERR_GENERR;
    }

    return SNMP_ERR_NOERROR;
}

int
handle_me3SystemLoadAvg15min(netsnmp_mib_handler *handler,
                          netsnmp_handler_registration *reginfo,
                          netsnmp_agent_request_info   *reqinfo,
                          netsnmp_request_info         *requests)
{
    /* We are never called for a GETNEXT if it's registered as a
       "instance", as it's "magically" handled for us.  */

    /* a instance handler also only hands us one request at a time, so
       we don't need to loop over a list of requests; we'll only get one. */

    switch(reqinfo->mode) {

        case MODE_GET:
            refreshLoadAvg(0, NULL);
         snmp_set_var_typed_value(requests->requestvb, ASN_OCTET_STR,
                                  (u_char *) loadavg15, strlen(loadavg15));
        break;

        default:
            /* we should never get here, so this is a really bad error */
            snmp_log(LOG_ERR, "unknown mode (%d) in handle_me3SystemLoadAvg15min\n", reqinfo->mode );
            return SNMP_ERR_GENERR;
    }

    return SNMP_ERR_NOERROR;
}

int
handle_statusOID(netsnmp_mib_handler *handler,
                          netsnmp_handler_registration *reginfo,
                          netsnmp_agent_request_info   *reqinfo,
                          netsnmp_request_info         *requests)
{
    /* We are never called for a GETNEXT if it's registered as a
       "instance", as it's "magically" handled for us.  */

    /* a instance handler also only hands us one request at a time, so
       we don't need to loop over a list of requests; we'll only get one. */

    switch(reqinfo->mode) {

        case MODE_GET:
            snmp_set_var_typed_value(requests->requestvb, ASN_OBJECT_ID,
                                     (u_char *) statusOID,
                                     statusOID_len);
            break;


        default:
            /* we should never get here, so this is a really bad error */
            snmp_log(LOG_ERR, "unknown mode (%d) in handle_statusOID\n", reqinfo->mode );
            return SNMP_ERR_GENERR;
    }

    return SNMP_ERR_NOERROR;
}

int
handle_objectStatus(netsnmp_mib_handler *handler,
                          netsnmp_handler_registration *reginfo,
                          netsnmp_agent_request_info   *reqinfo,
                          netsnmp_request_info         *requests)
{
    /* We are never called for a GETNEXT if it's registered as a
       "instance", as it's "magically" handled for us.  */

    /* a instance handler also only hands us one request at a time, so
       we don't need to loop over a list of requests; we'll only get one. */

    switch(reqinfo->mode) {

        case MODE_GET:
            snmp_set_var_typed_value(requests->requestvb, ASN_OCTET_STR,
                                     (u_char *) objectStatus,
                                     strlen((char*) objectStatus));
            break;


        default:
            /* we should never get here, so this is a really bad error */
            snmp_log(LOG_ERR, "unknown mode (%d) in handle_objectStatus\n", reqinfo->mode );
            return SNMP_ERR_GENERR;
    }

    return SNMP_ERR_NOERROR;
}

int
handle_eventDescription(netsnmp_mib_handler *handler,
                          netsnmp_handler_registration *reginfo,
                          netsnmp_agent_request_info   *reqinfo,
                          netsnmp_request_info         *requests)
{
    /* We are never called for a GETNEXT if it's registered as a
       "instance", as it's "magically" handled for us.  */

    /* a instance handler also only hands us one request at a time, so
       we don't need to loop over a list of requests; we'll only get one. */

    switch(reqinfo->mode) {

        case MODE_GET:
            snmp_set_var_typed_value(requests->requestvb, ASN_OCTET_STR,
                                     (u_char *) eventDescription,
                                     strlen((char*) eventDescription));
            break;


        default:
            /* we should never get here, so this is a really bad error */
            snmp_log(LOG_ERR, "unknown mode (%d) in handle_eventDescription\n", reqinfo->mode );
            return SNMP_ERR_GENERR;
    }

    return SNMP_ERR_NOERROR;
}

/**
 * The callback function that is called after the configuration files are
 * read by the agent ( the thresholds are loaded into the module )
 */

int
demo_3_post_read_config(int a, int b, void *c, void *d)
{

    /* Refresh the load data every 60 seconds */
    snmp_alarm_register(15, SA_REPEAT, refreshLoadAvg, NULL);

    /* Acquire the data first time */
    refreshLoadAvg(0, NULL);

    return 1;

}

/*
 * refreshLoadAvg: This is the function which "refreshes" the load data using
 * the system call "getloadavg". The data is stored in the 3 variables
 * loadavg1, loadavg5, loadavg15. Once the data is refreshed, the "check"
 * functions are called to check for alarm conditions
 */

void
refreshLoadAvg(unsigned int clientreg, void *clientarg)
{

    DEBUGMSGTL(("demo_module_3", "refreshLoadAvg\n"));
    glibtop_loadavg loadavg;
    glibtop_get_loadavg(&loadavg);
    sprintf(loadavg1, "%.3f\0", loadavg.loadavg[LOADAVG_1MIN]);
    sprintf(loadavg5, "%.3f\0", loadavg.loadavg[LOADAVG_5MIN]);
    sprintf(loadavg15, "%.3f\0", loadavg.loadavg[LOADAVG_15MIN]);

    check_loadavg1_state();
    check_loadavg5_state();
    check_loadavg15_state();

}


/*
 * Function: conv_alarm_state : This function returns appropriate charecter
 * string for each integer alarm type
 */

char           *
conv_alarm_state(int state)
{
    switch (state) {
    case 0:
        return "OK\0";
    case 1:
        return "ERROR\0";
    default:
        return "NULL\0";
    }
}


/*
 * read_load_thresholds: This function is called when a registered token (see
 * Init_demo_module_3 function) is found in the appropriate configuration
 * file. The token's values (thresholds) are then stored in some variables.
 */

void
read_load_thresholds(const char *token, char *cptr)
{

    char tmp[100];
    if (strcmp(token, "threshold_loadavg1") == 0) {
        threshold_loadavg1 = atof(cptr);
        sprintf(tmp, "threshold_loadavg1 = '%f'\n", threshold_loadavg1);
    } else if (strcmp(token, "threshold_loadavg5") == 0) {
        threshold_loadavg5 = atof(cptr);
        sprintf(tmp, "threshold_loadavg5 = '%f'\n", threshold_loadavg5);
    } else if (strcmp(token, "threshold_loadavg15") == 0) {
        threshold_loadavg15 = atof(cptr);
        sprintf(tmp, "threshold_loadavg15 = '%f'\n", threshold_loadavg15);
    } else {
        sprintf(tmp, "error in read_load_thresholds\n", threshold_loadavg15);
        /* Do nothing */
    }
    DEBUGMSGTL(("demo_module_3", tmp));
    return;

}

/* send_trap: This function generates an snmpv1 trap */

void
send_trap(oid * nodeoid, int size, u_char * status, u_char * description)
{

    DEBUGMSGTL(("demo_module_3", "send trap ....\n"));

    free(statusOID);
    statusOID_len = size;
    statusOID = (oid*) malloc(size);
    memcpy(statusOID, nodeoid, size);
    memcpy(objectStatus, status, strlen((char*) status)+1);
    memcpy(eventDescription, description, strlen((char*) description)+1);

    /* This is the notification type itself. This is statusChange trap */

    /*
     * define the OID for the enterprise we're going to send
     * NET-SNMP-XRSAMPLES-MIB::xrSampleTraps
     */
    oid             enterprise_oid[] = { 1, 3, 6, 1, 4, 1, 4242 };
    size_t          enterprise_oid_len = OID_LENGTH(enterprise_oid);

    /*
     * here is where we store the variables to be sent in the trap
     */
    DEBUGMSGTL(("demo_module_3", "defining the trap\n"));

    /*
     * add in the additional objects defined as part of the trap
     */
    netsnmp_variable_list *trap_vars = NULL;

    oid             statusOID_oid[] = {1, 3, 6, 1, 4, 1, 4242, 3, 3, 1, 0};
    size_t          statusOID_oid_len = OID_LENGTH(statusOID_oid);

    snmp_varlist_add_variable(&trap_vars,
            statusOID_oid, statusOID_oid_len,
                  ASN_OBJECT_ID,
                  (u_char *) nodeoid,
                  size);


    oid             status_oid[] = {1, 3, 6, 1, 4, 1, 4242, 3, 3, 2, 0};
    size_t          status_oid_len = OID_LENGTH(status_oid);

    snmp_varlist_add_variable(&trap_vars,
                  status_oid, status_oid_len,
                  ASN_OCTET_STR,
                  (u_char *) status,
                  strlen((char *) status));


    oid             description_oid[] = {1, 3, 6, 1, 4, 1, 4242, 3, 3, 3, 0};
    size_t          description_oid_len = OID_LENGTH(description_oid);

    snmp_varlist_add_variable(&trap_vars,
                  description_oid, description_oid_len,
                  ASN_OCTET_STR,
                  (u_char *) description,
                  strlen((char *) description));

    /*
     * send the trap out.  This will send it to all registered
     * receivers (see the "SETTING UP TRAP AND/OR INFORM DESTINATIONS"
     * section of the snmpd.conf manual page.
     */
    DEBUGMSGTL(("demo_module_3", "sending the trap\n"));
    send_enterprise_trap_vars(6, 1, enterprise_oid, enterprise_oid_len, trap_vars);

    /*
     * free the created notification variable list
     */
    DEBUGMSGTL(("demo_module_3", "cleaning up\n"));
    snmp_free_varbind(trap_vars);

}



/*
 * check_loadavg1_state: This function does 2 things: step-1) Determine the
 * current alarm state of the node by comparing it's value with threshold.
 * step-2) Depending on the new state of the node, generate a trap
 */

void
check_loadavg1_state()
{

    /* Trap stuff */

    oid             trapoid[] = {1, 3, 6, 1, 4, 1, 4242, 3, 1, 1, 0};
    u_char          status[8];
    u_char          description[] = "Load Average over last 1 minute crossed the threshold \0";
    int             size;
    int             new_loadavg1_state = OK;
    float           currentLoad = atof(loadavg1);

    /* Step-1 */

    /* If threshold is crossed, set state to ERROR */
    if (currentLoad > threshold_loadavg1) {
        new_loadavg1_state = ERROR;
    }
    /* Step-2 */

    /* Depending on the new state, send trap if necessary */

    size = sizeof(trapoid);
    strcpy((char *) status, conv_alarm_state(new_loadavg1_state));

    DEBUGMSGTL(("demo_module_3", "loadavg1: %d < %d?\n",
        new_loadavg1_state, prev_loadavg1_state));
    if (new_loadavg1_state != prev_loadavg1_state) {
        /* Send trap */
        prev_loadavg1_state = new_loadavg1_state;
        send_trap(trapoid, size, status, description);
    } else if (new_loadavg1_state == prev_loadavg1_state) {
        /* No Change in state .. Do nothing */
    }
}

/*
 * check_loadavg5_state: This function does 2 things: step-1) Determine the
 * current alarm state of the node by comparing it's value with threshold.
 * step-2) Depending on the new state of the node, generate a trap
 */


void
check_loadavg5_state()
{

    /* Trap stuff */

    oid             trapoid[] = {1, 3, 6, 1, 4, 1, 4242, 3, 1, 2, 0};
    u_char          status[8];
    u_char          description[] = "Load Average over last 5 minute crossed the threshold \0";
    int             size;

    int             new_loadavg5_state = OK;
    double          currentLoad = atof(loadavg5);

    /* If threshold is crossed, set state to ERROR */
    if (currentLoad > threshold_loadavg5) {
        new_loadavg5_state = ERROR;
    }

    /* Depending on the new state, send trap if necessary */

    size = sizeof(trapoid);
    strcpy((char *) status, conv_alarm_state(new_loadavg5_state));

    DEBUGMSGTL(("demo_module_3", "loadavg5: %d < %d?\n",
        new_loadavg5_state, prev_loadavg5_state));
    if (new_loadavg5_state != prev_loadavg5_state) {
        /* Send trap */
        send_trap(trapoid, size, status, description);
        prev_loadavg5_state = new_loadavg5_state;
    } else if (new_loadavg5_state == prev_loadavg5_state) {
        /* No Change in state .. Do nothing */
    }
}

/*
 * check_loadavg15_state: This function does 2 things: step-1) Determine the
 * current alarm state of the node by comparing it's value with threshold.
 * step-2) Depending on the new state of the node, generate a trap
 */


void
check_loadavg15_state()
{

    /* Trap stuff */

    oid             trapoid[] = {1, 3, 6, 1, 4, 1, 4242, 3, 1, 3, 0};
    u_char          status[8];
    u_char          description[] = "Load Average over last 15 minute crossed the threshold \0";
    int             size;

    int             new_loadavg15_state = OK;
    double          currentLoad = atof(loadavg15);

    /* If threshold is crossed, set state to ERROR */
    if (currentLoad > threshold_loadavg15) {
        new_loadavg15_state = ERROR;
    }

    /* Depending on the new state, send trap if necessary */

    size = sizeof(trapoid);
    strcpy((char *) status, conv_alarm_state(new_loadavg15_state));

    DEBUGMSGTL(("demo_module_3", "loadavg15: %d < %d?\n",
        new_loadavg15_state, prev_loadavg15_state));
    if (new_loadavg15_state != prev_loadavg15_state) {
        /* Send trap */
        prev_loadavg15_state = new_loadavg15_state;
        send_trap(trapoid, size, status, description);
    } else if (new_loadavg15_state == prev_loadavg15_state) {
        /* No Change in state .. Do nothing */
    }
}
