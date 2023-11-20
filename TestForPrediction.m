clear;

DataPath = "D:\SJTU_MS_1ST\BCI\SOFTX-D-23-00016-main\SOFTX-D-23-00016-main\Data\BasicMoveData\";
DataFile = dir(fullfile(DataPath, '*.mat'));
DataFileNames = natsort({DataFile.name});

PredictResult = zeros(3, length(DataFileNames));

%for i = 1:length(DataFileNames)
for i = 1:1
    %data = load(DataPath + DataFileNames(i));
    %MotorImagery = data.MotorImagery;

    data = load("D:\SJTU_MS_1ST\BCI\SOFTX-D-23-00016-main\SOFTX-D-23-00016-main\TestData\RecordData_Online_2");

    %ImageData(1,:,:) = MotorImagery.RecordData(:, MotorImagery.Sample.Stage2+1:MotorImagery.Sample.Stage2+1000);
    ImageData(1, :, :) = data.RecordData.NowData(:, 993:1992);

    tmp2 = load("D:\SJTU_MS_1ST\BCI\SOFTX-D-23-00016-main\SOFTX-D-23-00016-main\TestData\TrainedModel_FeatureSelection.mat");
    MotorImagery.ParaImagery = tmp2.ParaImagery;

    CheckBoxEnableFeaSel = 1;
    SelFlag = CheckBoxEnableFeaSel;
    PredictLabel = PredictSingleTrail(MotorImagery.ParaImagery, ImageData, SelFlag, MotorImagery.ParaImagery.CSP_Config);
    PredictLabel = double(PredictLabel);
    PredictResult(1, i) = PredictLabel;
end

PredictResult(2, :) = MotorImagery.ClassOrder;


for i = 1:length(DataFileNames)
    if (PredictResult(1, i) == PredictResult(2, i))
        PredictResult(3, i) = 1;
    else
        PredictResult(3, i) = 0;
    end
end

Acc = sum(PredictResult(3, :) == 1) / length(PredictResult(3, :));
