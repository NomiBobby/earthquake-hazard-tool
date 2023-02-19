Author              : Qiwei Mao
Affiliation         : Georgia Institute of Technology

Description
-------------
This code package is designed to process original data from the NGAWest2 earthquake database. Make_copies.m
can read in any format of original data and trasnform them into the NGAWest2 format. Reshape_2019.m can calculate
all kinds of earthquake intensity parameters from the original data, which consists of series of accelerations. These
parameters include PGA, CAV and Sa etc. Training .m is a implementation of model construction. It trains the model
and plots the predicted results to examine the residuals. The model can be obtained from variable b which consists of
all the coefficient of the equation.


Installation
------------
Put all of the files in the same directory, then it is ready to run
-----------
Assuming the original data path is ".\Users\Earthquake Project\NGAWest2"
Change the corresponding directory in the Reshape_2019.m code and run the script.
Then run the training script, the model will be built.