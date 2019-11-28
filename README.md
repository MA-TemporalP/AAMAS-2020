***************************************************************
AAMAS-2020 repository                                       
***************************************************************

This repository constinas the domain and problems used in:

"Task Allocation Strategy for Heterogeneous Robot Teams in Offshore Missions"

1. First folder (constrained_domain) contains the domain and problems that consider 
   the predicate "robot_can_cat" to implement the plan which were generated using the 
   Multi-Role Goal Assignment strategy presented in the paper.

2. Second folder (non-constrained_domain) constains a version of the domain and problems
   in folder one without using the predicates generate by  the MRGA strategy.
   
   How to run it?
   
       --> Clone the repository
       --> Compile the planners:
       Refer to 1) IPC-2018 (https://ipc2018-temporal.bitbucket.io/) for TemporAl, TFLAP & OPTIC
       
                2) LPG (http://zeus.ing.unibs.it/lpg/) 
                
                3) TFD (http://gki.informatik.uni-freiburg.de/tools/tfd/)
                
                4) POPF (https://nms.kcl.ac.uk/planning/software/popf.html)
                
                
         --> Run the planners using the domain and problem required
                
