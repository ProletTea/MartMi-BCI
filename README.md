# MartMi-BCI: A Matlab-based Real-Time Motor Imagery Brain-Computer Interface Platform v1.0

This work develops a Matlab-based real-time MI-BCI (MartMi-BCI) software, which involves two main modules, a real-time EEG analysis platform (RTEEGAP) and a model training platform (MTP). 
1. The RTEEGAP can realize real-time EEG analysis in time, frequency, and spatial domains and perform MI experiments with real-time feedback based on the OpenBCI device. 
2. The MTP can train the CSP-based MI classification model and visualize the time-frequency reaction map.

![alt text](https://github.com/GitVirTer/MartMi-BCI/blob/main/Data/Picture/BCI_Analyzer_All.png?raw=true)

## Citation

Please cite the tool using this website repository and the manuscript:

- Guoyang Liu, Janet H. Hsiao, Weidong Zhou, and Lan Tian. "MartMi-BCI: A Matlab-based Real-Time Motor Imagery Brain-Computer Interface Platform." SoftwareX (2023)  (Accepted).
- Guoyang Liu, Lan Tian, and Weidong Zhou. "Multiscale Time-Frequency Method for Multiclass Motor Imagery Brain Computer Interface." Computers in Biology and Medicine 143 (2022): 105299.


## Operating Environments and Dependencies

System:
- Windows 7 and later

Software:
- MATLAB R2019a and later releases
- Deep Learning Toolbox
- Signal Processing Toolbox
- Statistics and Machine Learning Toolbox
- Parallel Computing Toolbox (optional, if you want to execute the training procedure in parallel, you must install this toolbox).

## Usage

RTEEGAP:
- Open and run RTEEGAP.m (ensure you have connected to an OpenBCI device (8-channel) before you open the RTEEGAP.m).

MTP:
- Open and run MTP.m (if you don't have an OpenBCI device, you can also open the MTP.m and select the './TestData/MotorImageryData/' folder to evaluate demo files recorded by the RTEEGAP.m).

Note:
- /Algorithm contains the necessary supporting functions, which must be located in the same folder as RTEEGAP.m and MTP.m.
- /Data contains the necessary folder structure and media files, which must be located in the same folder as RTEEGAP.m and MTP.m.
- /TestData contains the example files generated by RTEEGA.m and MTP.m.
  - /TestData/MotorImageryData contains the training data for MTP.
  - /TestData/RecordData_Online_1.mat and /TestData/RecordData_Online_2.mat are the online data recorded by RTEEGAP (with a duration of 75s and 10s).
  - /TestData/TrainedModel_FeatureSelection.mat is the model trained on MTP (with feature selection procedure).
  - /TestData/TrainedModel_WithoutFeatureSelection.mat is the model trained on MTP (without feature selection procedure).

## Corresponding Author
If there is any technical issue, please contact the corresponding author Guoyang Liu: gyangliu@hku.hk


