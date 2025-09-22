INTRODUCTION
This repository contains 4 stand alone set of data and codes associated with the paper Saucier et al., 2025. All codes were written to be run in Matlab.
Contents:
•	GasVolume.m
•	TinyPerm_RawData
•	TinyPerm_Grids
•	Lab Permeability and Porosity
GASVOLUME.M
GasVolume.m has material related to section 5.3 A Mechanism for Cyclic Explosive Gas Venting. This code can be run on its own in Matlab and contains comments guiding the reader. Any input values selection and or detail are contained with the main manuscript and/or the supplementary materials. 
TINYPERM_RAWDATA
The TinyPerm_RawData folder contains the raw data from the tinyperm measurments, including failed measurments. All data can be visualized through the included matlab app. Contact the corresponding author if alternative is needed for viewing this data.
TINYPERM_GRIDS
The TinyPerm_Grids folder should be downloaded as is. It contains the processed data from the TinyPerm measurement, as well as the codes used to create the visualalisation  grid used in figures.
LAB PERMEABILITY AND POROSITY
The Lab_Permeability_and_Porosity_Plus_Comparison folder should also be downloaded as is and kept in its current architecture when running the codes that it contains. Inside, there is data for permeability and porosity lab measurment, as well as codes to plot these data sets both to form figure that were used to analyse the data, as well as to make the final figure displayed in the paper. The New April 2025 folder within it refers to an additionnal set of data that was aquired at a later date than the inital data to complement the first set of data.
The subfolders Permeameter and Pycnometer contain the raw data file given by the respective instrument. All processing of the data was done in the Matlab code Main_Permeability_and_Porosity.m along with its copy found in the New April 2025 folder. The Processed data for the Permeameter and Pycnometer are found as Permeameter.mat and Pycnometer.mat respectively. Below is an explanation of how the permeability data was processed as well as how its error was carried out.
For each sample ran in the permeameter, there is one data fill containing all 2-4 pressure differential that were left to equilibrate. The name of this data file correlates to the sample core label (Table S1). The permeameter used in this study contains two distinct flow rate sensors, that each have their own capacity and accuracy. For most sample, we used the sensor FMA3105, with the exception of LV23_1a , for which we used sensor FMA1716. The sample core dimensions are in the spreadsheet CC_Samples_m_l_r.xlsx, and the downstream pressure for each measurement was atmospheric pressure.
All pressure gradients were performed within the same run. In the processing code, we selected the last portion of a pressure differential run after it had equilibrated. We then removed outliers and averaged the flow rate data over that last few minutes of the pressure plateau. We also took note of the maximum and minimum data within that plateau. These extreme values were used to plot the error bars shown in figure S15a-q and S16a-q. Then when calculating the permeability of the sample, we average the permeability found from all pressure differential plateaus and took the minimum permeability from all of the steps and the maximum permeability from all of the steps for our final error bar on the permeability of the sample. We then plot these error bars in Figure 3. 
