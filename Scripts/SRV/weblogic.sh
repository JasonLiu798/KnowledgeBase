
java -cp ${WLS_HOME}/wlserver_10.3/server/lib/weblogic.jar: weblogic.Deployer -adminurl t3://${WLSIP}:${PORT} -user ${WLS_USER} -password ${WLS_PASS} -deploy  -name ${dep}  ${DEST_DIR}/${dep}