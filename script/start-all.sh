#!/bin/sh

workDir=`dirname $0`
workDir=`cd ${workDir};pwd`
source $workDir/../conf/config/run_config.conf
source $workDir/../conf/config/install_config.conf

mastersHost=(${masters//,/ })
for master in ${mastersHost[@]}
do
        echo $master
	ssh $master  "cd $installPath/; sh bin/dolphinscheduler-daemon.sh start master-server;"

done

workersHost=(${workers//,/ })
for worker in ${workersHost[@]}
do
        echo $worker

        ssh $worker  "cd $installPath/; sh bin/dolphinscheduler-daemon.sh start worker-server;"
        ssh $worker  "cd $installPath/; sh bin/dolphinscheduler-daemon.sh start logger-server;"
done

ssh $alertServer  "cd $installPath/; sh bin/dolphinscheduler-daemon.sh start alert-server;"

apiServersHost=(${apiServers//,/ })
for apiServer in ${apiServersHost[@]}
do
        echo $apiServer

        ssh $apiServer  "cd $installPath/; sh bin/dolphinscheduler-daemon.sh start api-server;"
done

