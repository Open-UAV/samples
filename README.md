## OpenUAV Playbook example (leader-follower)

The folder structure for the template simulation payload is shown below. Any simulation needs six inputs listed below. 
- drone models
- simulation world 
- setup (initialization) 
- measure (of performance) 
- controllers
- parameters

```
leader-follower/
└── simulation
    ├── inputs
    │   ├── controllers
    │   │   ├── test_1_Loop.py
    │   │   └── test_2_Follow.py
    │   ├── measures
    │   │   └── measureInterRobotDistance.py
    │   ├── models
    │   │   └── f450-1
    │   │       ├── f450-1.sdf
    │   │       └── model.config
    │   ├── parameters
    │   │   └── swarm.sh
    │   ├── setup
    │   │   ├── testArmAll.py
    │   │   └── testCreateUAVSwarm.py
    │   └── world
    │       └── empty.world
    └── run_this.sh
```
Shown below is an example simulation from remote Ubuntu box with the SSH keys to talk to the OpenUAV Playground server. The username is 'jdas', replace with your own username when trying to run on your machine. 

```
:~$ scp -r /home/nsf/PycharmProjects/Open-UAV/examples/leader-follower/simulation/ jdas@label.ag:~/ 
:~$ ssh jdas@label.ag 'nvidia-docker run -dit -v ~/simulation/:/simulation --name "openuav-"${3:-`date +%s`} openuav-swarm-functional /simulation/run_this.sh'
```

The logs are stored in the simulation/outputs folder as a list of CSV files. 
```
jdas@airborne:~$ ls  ~/simulation/outputs/
measure.csv  uav1.csv  uav2.csv  uav3.csv
````

## Running your first simulation

1. Talk to the project administrators for an account on the OpenUAV server and set up SSH keys
