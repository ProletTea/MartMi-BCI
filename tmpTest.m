tmp = load("D:\SJTU_MS_1ST\BCI\SOFTX-D-23-00016-main\SOFTX-D-23-00016-main\Data\BasicMoveData\4.mat");
MotorImagery = tmp.MotorImagery;
ImageData(1,:,:) = MotorImagery.RecordData(:, MotorImagery.Sample.Stage2+1:MotorImagery.Sample.Stage2+1000);

tmp2 = load("D:\SJTU_MS_1ST\BCI\SOFTX-D-23-00016-main\SOFTX-D-23-00016-main\Data\Configure\TrainedModel.mat");
MotorImagery.ParaImagery = tmp2.ParaImagery;

CheckBoxEnableFeaSel = 0;
SelFlag = CheckBoxEnableFeaSel;
PredictLabel = PredictSingleTrail(MotorImagery.ParaImagery, ImageData, SelFlag, MotorImagery.ParaImagery.CSP_Config);
PredictLabel = double(PredictLabel);
PredictLabel