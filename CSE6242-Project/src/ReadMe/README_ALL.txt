Author          : Group #14
Created         : April 20, 2019
Last Modified   : April 25, 2019

Affiliation          : Georgia Institute of Technology


Description
-------------

This code package is designed to process original data from the NGAWest2 earthquake database. Make_copies.m
can read in any format of original data and trasnform them into the NGAWest2 format. Reshape_2019.m can calculate
all kinds of earthquake intensity parameters from the original data, which consists of series of accelerations. These
parameters include PGA, CAV and Sa etc. Training .m is a implementation of model construction. It trains the model
and plots the predicted results to examine the residuals. The model can be obtained from variable b which consists of
all the coefficient of the equation.

This code package is designed to test different Machine Learning algorithms using k-fold cross validation. The Algorithm we have tested are Decision Tree, Neural Network, KNN with Ada boosting, SVM and Normal KNN. The results are shown in the the figure that Neural Network is the best result for our data. 

The HTML file implements the visualization of this project, users can input the coordinates or just pin on the map to choose the location they would like to investigate, then a marker will appear at the designated spot, users can open the info-window by clicking this marker to check the information.

Installation
------------
Put all of the files in the same directory, then it is ready to run

Put all of the files in the same directory, then install the following Package:
scipy: 1.1.0
numpy: 1.15.4
matplotlib: 3.0.2
pandas: 0.23.4
sklearn: 0.20.2

Then proceed to run the python file. The result will show as figure. 

To install, a browser is needed, we recommend to use Chrome, Safari, Firefox, IE or Opera.

Execution
------------
Assuming the original data path is ".\Users\Earthquake Project\NGAWest2"
Change the corresponding directory in the Reshape_2019.m code and run the script.
Then run the training script, the model will be built.

To execute the visualization, just open the HTML file with your browser.