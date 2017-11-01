#!/bin/bash
source /root/.profile 
source /simulation/inputs/parameters/swarm.sh

echo "Setup..."
python /simulation/inputs/setup/testCreateUAVSwarm.py $num_uavs &
sleep 15
python /simulation/inputs/setup/testArmAll.py $num_uavs &


echo "Controllers..."
python /simulation/inputs/controllers/test_1_Loop.py 5 1 1 0 &> /dev/null & 
python /simulation/inputs/controllers/test_2_Follow.py 2 1 2 &> /dev/null &
python /simulation/inputs/controllers/test_2_Follow.py 3 2 3 &> /dev/null &

echo "measures"
python /simulation/inputs/measures/measureInterRobotDistance.py 2 1 &> /dev/null &
roslaunch rosbridge_server rosbridge_websocket.launch port:=2090 ssl:=true &> /dev/null &

for((i=1;i<=$num;i+=1))
do
    /usr/bin/python -u /opt/ros/jade/bin/rostopic echo -p /mavros$i/local_position/pose > /simulation/outputs/uav$i.csv &
done

bash /root/gzweb/start_gzweb.sh -p 286 &>/dev/null &

tail -f /dev/null



