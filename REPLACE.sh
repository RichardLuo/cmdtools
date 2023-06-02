#!/bin/bash
################################################################
# file:   FileReplaceRegex.sh
# author: Richard Luo
# date:   2016-06-25 11:27:26
################################################################
if [ "X$1" = "X" ]; then
    echo "please specify the file name!"
    exit 10
fi

FILE=$1

if [ ! -f $FILE ]; then 
    echo "$FILE doesn't exist!"
    exit 10
fi

set -ix

# perl -p -i -e 's/\bhal_led_turn_off\b/emberAfPluginGpioLedTurnOff/g'    $FILE
# perl -p -i -e 's/\bhal_led_turn_on\b/emberAfPluginGpioLedTurnOn/g'      $FILE
# perl -p -i -e 's/\bhal_led_turn_toggle\b/emberAfPluginGpioLedToggle/g'  $FILE
# perl -p -i -e 's/\bZCL_CMD_DISCOVER\b/ZCL_DISCOVER_ATTRIBUTES_COMMAND_ID/g' $FILE
# perl -p -i -e 's/\bZCL_CMD_DISCOVER_RSP\b/ZCL_DISCOVER_ATTRIBUTES_RESPONSE_COMMAND_ID/g' $FILE
# perl -p -i -e 's/\bZCL_CMD_READ\b/ZCL_READ_ATTRIBUTES_COMMAND_ID/g' $FILE
# perl -p -i -e 's/\bZCL_CMD_READ_RSP\b/ZCL_READ_ATTRIBUTES_RESPONSE_COMMAND_ID/g' $FILE
# perl -p -i -e 's/\bZCL_CMD_CONFIG_REPORT\b/ZCL_CONFIGURE_REPORTING_COMMAND_ID/g' $FILE
# perl -p -i -e 's/\bemberAfPluginPowerMeasureTestCallback\b/emberAfPluginPowerMeasureStartCallback/g' $FILE

# perl -p -i -e 's/ZCL_CLUSTER_ID_GEN_BASIC/ZCL_BASIC_CLUSTER_ID/g' $FILE
# perl -p -i -e 's/ZCL_CLUSTER_ID_GEN_POWER_CFG/ZCL_POWER_CONFIG_CLUSTER_ID/g' $FILE
# perl -p -i -e 's/ZCL_CLUSTER_ID_POLLING_CONTROL/ZCL_POLL_CONTROL_CLUSTER_ID/g' $FILE
# perl -p -i -e 's/ZCL_CLUSTER_ID_MS_ILLUMINANCE_MEASUREMENT/ZCL_ILLUM_MEASUREMENT_CLUSTER_ID/g' $FILE
# perl -p -i -e 's/ZCL_CLUSTER_ID_MS_OCCUPANCY_SENSING/ZCL_OCCUPANCY_SENSING_CLUSTER_ID/g' $FILE
# perl -p -i -e 's/ZCL_CLUSTER_ID_GEN_IDENTIFY/ZCL_IDENTIFY_CLUSTER_ID/g' $FILE
# perl -p -i -e 's/ZCL_CLUSTER_ID_GEN_ON_OFF/ZCL_ON_OFF_CLUSTER_ID/g' $FILE
# perl -p -i -e 's/ZCL_CLUSTER_ID_GEN_BINARY_INPUT_BASIC/ZCL_BINARY_INPUT_BASIC_CLUSTER_ID/g' $FILE

# perl -p -i -e 's/"(.*)_(.*)"/"$1-$2"/g' $FILE
# perl -p -i -e 's/ALOGW/LOGW/g' $FILE
# perl -p -i -e 's/llu/" PRIu64 "/g' $FILE
perl -p -i -e 's/^ *DEFINE_ERROR *\( *(\w+), *(\w+)\)/#define EMBER_$1 ($2)/g' $FILE
perl -p -i -e 's/^ *#define (\w+)\((\w+)\)/#define $1 ($2)/g' $FILE

