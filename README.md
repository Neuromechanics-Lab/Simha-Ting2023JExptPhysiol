# Simha-Ting2023JExptPhysiol
Code to reproduce the mechanistic spindle model results from Simha and Ting 2023 ( https://doi.org/10.1113/EP090767)

There is a main_ script to generate the results for each figure in the manuscript.

The scripts to generate the figures do not generate exactly the figures as shown in the manuscript e.g. while we only show the receptor potentials in figure 4, the scripts here generate the time series for the stress and well as receptor potentials.

Please also fork the MATMyoSim from https://github.com/Campbell-Muscle-Lab/MATMyoSim to use with this code. You will need to replace update_2state_with_poly.m in MATMyoSim present under code> @half_sarcomere with the update_2state_with_poly.m provided in this repository.
