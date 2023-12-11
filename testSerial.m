function ret = testSerial()
    global ObjSerial;
    global SerialPortNum;
    global BaudRate;
    global SampleRate;
    global ZoomCoeff;
    global Filter;
    global DrawMap;
    global BufferSize
    global NumTryStartCom
    
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
        fprintf("Serial open successed.");
    catch
        %NumTryStartCom = NumTryStartCom+1;
        fprintf("Serial open failed.\n");
    end

    try
        fwrite(ObjSerial,'b','uchar'); 
        fprintf("Serial data read successed.");
    catch
        fprintf("Serial data read failed.");
    end

    [UnpackedData, UnpackedDataRaw] = decodeOpenBCIData_16ch(ObjSerial, BufferSize);
end