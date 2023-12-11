function ret = EEGClassifier()
%addpath(".\IO\");

while true
    [SigType, ~] = GetSignal();
    fptintf(Sigtype);
    
    if SigType == SignalType.GAME_START
        initialize();
    elseif SigType == SignalType.MOTION_REQUEST
        OpType = work();
        SendSignal(SignalType.MOTION_APPLY, OpType);
    elseif SigType == SignalType.GAME_OVER
        ret = 0;
        break;
    else % should never happen
        ret = 1;
        break;
    end

end

end

function initialize()
    % do some initialzation here
    global ObjSerial;
    global SerialPortNum;
    global BaudRate;
    global SampleRate;
    global ZoomCoeff;
    global Filter;
    global DrawMap;
    global BufferSize
    global NumTryStartCom

    global MotorImagery;
    global IntervalTime;
    
    BaudRate = 115200;
    SampleRate = 250;   % The sample rate of EEG stream
    DispSec = 10;   % The length of EEG stream displayed
    IntervalTime.DispMs = 500;   % The number of millisecond in refresh interval of displaying
    IntervalTime.FFTMs = 1000;
    BufferSize = 250;
    
    SerialPortNum = 'COM3';
    ObjSerial=serial(SerialPortNum);                                                                             
    ObjSerial.baudrate=BaudRate;                                                 
    ObjSerial.parity='none';                                                   
    ObjSerial.stopbits=1;                                                     
    ObjSerial.timeout=0.5;                                                                                           
    ObjSerial.inputbuffersize=BufferSize;                                           
    
    
    %ä¸²å£äº‹ä»¶å›žè°ƒè®¾ç½®
    ObjSerial.BytesAvailableFcnMode='byte';
    ObjSerial.BytesAvailableFcnCount=BufferSize; 
    
    try
        fopen(ObjSerial);
        fprintf("Serial open successed.\n");
    catch
        %NumTryStartCom = NumTryStartCom+1;
        fprintf("Serial open failed.\n");
    end

    try
        fwrite(ObjSerial,'b','uchar'); 
        fprintf("Serial data read successed.\n");
    catch
        fprintf("Serial data read failed.\n");
    end



    %% Filter Initialising
    Fc1 = 1;
    Fc2 = 35;
    Fs = SampleRate;
    N = 8; %Order

    h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
    Hd = design(h, 'butter');
    [Filter.Coeff_b, Filter.Coeff_a] = tf(Hd);    % Get the transfer function values.
    Filter.HistoryOutput = [];   % History y in filter

    %% MotorImagery Initialising
    MotorImagery.RecordData = [];
    MotorImagery.RecordRawData = [];
    MotorImagery.EpochCnt = 0;
    MotorImagery.LastTime = 3;


    tmp = load("D:\SJTU_MS_1ST\高级软件开发与管理\CourseProject\Software-Engineering-Group8\MartMi-BCI\Data\Configure\TrainedModel.mat");
    MotorImagery.ParaImagery = tmp.ParaImagery;

    %% test serial
    %[UnpackedData, UnpackedDataRaw] = decodeOpenBCIData_16ch(ObjSerial, BufferSize);
end

function OpType = work()
    %% Visiting global 
    global ObjSerial;
    global SerialPortNum;
    global BaudRate;
    global SampleRate;
    global ZoomCoeff;
    global Filter;
    global DrawMap;
    global BufferSize
    global NumTryStartCom    

    global MotorImagery;
    global IntervalTime;

    %% start recording signal and do classification
    [UnpackedData, UnpackedDataRaw] = decodeOpenBCIData_16ch(ObjSerial, BufferSize);

    [UnpackedData, Filter.HistoryOutput] = filter(Filter.Coeff_b, Filter.Coeff_a, UnpackedData, Filter.HistoryOutput, 2);


    

    %% Record data for X seconds.
    while (MotorImagery.EpochCnt <= MotorImagery.LastTime/(IntervalTime.DispMs/1000))
        MotorImagery.RecordData = cat(2, MotorImagery.RecordData, UnpackedData);
        MotorImagery.RecordRawData = cat(2, MotorImagery.RecordRawData, UnpackedDataRaw);
        %MotorImagery.Sample.Cnt = MotorImagery.Sample.Cnt + size(UnpackedData,2);
        MotorImagery.EpochCnt = MotorImagery.EpochCnt + 1;
    end

    %% Classification
    SelFlag = true;
    ImageData(1,:,:) = MotorImagery.RecordData(:, 1:end);
    %PredictLabel = PredictSingleTrail(MotorImagery.ParaImagery, ImageData, SelFlag, MotorImagery.ParaImagery.CSP_Config);
    %PredictLabel = double(PredictLabel)
    PredictLabel = 2;

    if (PredictLabel == 1)
        Optype = Operand.WALK_FORWARD;
    elseif (PredictLabel == 2)
        Optype = Operand.WALK_LEFT;
    elseif (PredictLabel == 3)
        Optype = Operand.WALK_RIGHT;
    end
    
    MotorImagery.RecordData = [];
end
