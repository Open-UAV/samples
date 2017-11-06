#!/bin/bash
source /root/.profile 
source /simulation/inputs/parameters/swarm.sh
rm /simulation/outputs/*.csv


Xvfb :1 -screen 0 1600x1200x16  &
export DISPLAY=:1.0

echo "Setup..."
python /simulation/inputs/setup/testCreateUAVSwarm.py $num_uavs &> /dev/null &
sleep 10
echo "Monitors..."
roslaunch rosbridge_server rosbridge_websocket.launch ssl:=false &> /dev/null &
rosrun web_video_server web_video_server _port:=80 &> /dev/null &
tensorboard --logdir=/simulation/outputs/ --port=8008 &> /dev/null &
sleep 5
python /simulation/inputs/setup/testArmAll.py $num_uavs &> /dev/null &

echo "Controllers..."
python /simulation/inputs/controllers/test_1_Loop.py 5 1 1 0 &> /dev/null & 
sleep 2
python /simulation/inputs/controllers/test_3_Follow.py 3 1 3 0 &> /dev/null &
sleep 2
python /simulation/inputs/controllers/test_3_Follow.py 2 1 2 $FOLLOW_D_GAIN &> /dev/null &


echo "Measures..."
python /simulation/inputs/measures/measureInterRobotDistance.py 2 1 &> /dev/null &

for((i=1;i<=$num_uavs;i+=1))
do
    /usr/bin/python -u /opt/ros/jade/bin/rostopic echo -p /mavros$i/local_position/odom > /simulation/outputs/uav$i.csv &
done
/usr/bin/python -u /opt/ros/jade/bin/rostopic echo -p /measure > /simulation/outputs/measure.csv &


sleep $duration_seconds
cat /simulation/outputs/measure.csv | awk -F',' '{sum+=$2; ++n} END { print sum/n }' > /simulation/outputs/average_measure



