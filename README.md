**Introduction**

This repository contains 4 sets of data and codes associated with the paper Saucier et al., 2025. All codes were written to be run in Matlab.



**GasVolume.m**

GasVolume.m has material related to section 5.3 A Mechanism for Cyclic Explosive Gas Venting. This code can be run on its own in Matlab and contains comments guiding the reader. Any input value selection and/or assumptions underlying them are detailed in the main manuscript and/or the supplementary materials.



**TinyPerm_RawData**

The TinyPerm_RawData folder contains the raw data from the TinyPerm measurements, including failed measurements. All data can be visualized using the included Matlab app. Contact the corresponding author if support is needed for visualizing these data.


**TinyPerm_Grids**

The TinyPerm_Grids folder should be downloaded as is. It contains the processed data from the TinyPerm measurement, as well as the codes used to create the visualization plotted in main text figures.



**Lab Permeability and Porosity**

The Lab_Permeability_and_Porosity_Plus_Comparison folder should be downloaded as is and kept in its current architecture when running the codes it contains. Inside, there are data for permeability and porosity lab measurements, as well as codes to plot these data both to reproduce the figures that were used to analyze the data, as well as to make the final figures displayed in the paper. The New April 2025 folder within it refers to an additional set of data that was acquired at a later date than the initial data to complement the first set of data.

The subfolders Permeameter and Pycnometer contain the raw data files of the respective instrument. All processing of the data was done using the Matlab code Main_Permeability_and_Porosity.m. The Processed data for the Permeameter and Pycnometer are found as Permeameter.mat and Pycnometer.mat respectively. Below is an explanation of how the permeability data was processed as well as how error analysis was carried out.
For each sample measured in the permeameter, there is one data file containing all 2-4 pressure differentials applied. The name of this data file correlates to the sample core label (Table S1, and figure S14). The permeameter used in this study contains two flow meters, that cover different flow rate ranges. For most sample, we used the sensor FMA3105 (0-50 ml/min flow capacity), with the exception of LV23_1a , for which we used sensor FMA1716 (0-2000 ml/min flow capacity). The sample core dimensions are in the spreadsheet CC_Samples_m_l_r.xlsx, and the downstream pressure for each measurement was atmospheric pressure.

All pressure gradients were performed within the same run. Note that this may appear as a pressure sweep when plotting the pressure gradient against the flow rate, since data were acquired continuously while stepping pressures, as evident when plotting pressure or flow rate vs. time. In the processing code, we selected the last portion of a pressure differential run after it had equilibrated. We then removed outliers caused by electrical noise and averaged the flow rate data over that last 3-5 minutes of the pressure plateau. We also took note of the maximum and minimum data within that plateau. These extreme values were used to plot the error bars shown in figure S15a-q and S16a-q. To calculate the permeability of the sample, we average the permeability values of all pressure differential plateaus. Errors on final data in figure 3 are reported as the difference between the minimum and maximum permeability from all of the steps.
