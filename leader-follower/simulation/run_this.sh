#!/bin/bash
source /root/.profile 
source /simulation/inputs/parameters/swarm.sh

Xvfb :1 -screen 0 1600x1200x16  &
export DISPLAY=:1.0

echo "Setup..."
python /simulation/inputs/setup/testCreateUAVSwarm.py $num_uavs &
sleep 25
python /simulation/inputs/setup/testArmAll.py $num_uavs &


echo "Controllers..."
python /simulation/inputs/controllers/test_1_Loop.py 5 1 1 0 &> /dev/null & 
python /simulation/inputs/controllers/test_2_Follow.py 2 1 2 &> /dev/null &

echo "Measures..."
python /simulation/inputs/measures/measureInterRobotDistance.py 2 1 &> /dev/null &

for((i=1;i<=$num_uavs;i+=1))
do
    /usr/bin/python -u /opt/ros/jade/bin/rostopic echo -p /mavros$i/local_position/odom > /simulation/outputs/uav$i.csv &
done
/usr/bin/python -u /opt/ros/jade/bin/rostopic echo -p /measure > /simulation/outputs/measure.csv &

sleep 10
echo "Monitors..."
#roslaunch rosbridge_server rosbridge_websocket.launch port:=2090 ssl:=true &> /dev/null &
#rosrun web_video_server web_video_server _port:=2002 &> /dev/null &

tail -f /dev/null



