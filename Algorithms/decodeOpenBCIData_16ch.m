function [UnpackedData, UnpackedDataRaw] = decodeOpenBCIData(ObjSerial, BufferSize)
%This function is designed for decoding OpenBCI Data.
%If you want to use other EEG recording device, please modify this function
%to obtain 'UnpackedData' and 'UnpackedDataRaw'.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Constant %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PackageLen = 33;
nCh = 16; %channel
scale_fac_uVolts_per_count = 0.022351744455307063;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Read Data From Buffer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
recdta = fread(ObjSerial, BufferSize, 'uchar');   % Receive serial data from OpenBCI (33 Bytes/Package, 256 Package/Second)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Unpack Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A0 = find(recdta==hex2dec('A0'));
iPackage = 0;
%iPackage = 1;
for iSt = 1:numel(A0)
    if (A0(iSt)+PackageLen-1<=numel(recdta))&&(recdta(A0(iSt)+PackageLen-1)==192)    % 'C0'=192
        iPackage = iPackage+1;
        PackArr(iPackage,:) = recdta(A0(iSt):A0(iSt)+PackageLen-1);
    end
end
%PackArr = PackArr(:,3:26); &Original
PackArr = PackArr(2:end, 3:26); %Get rid of the first invalid data.


PackArr_odd = PackArr(1:2:end, :); %Odd refering to the Board signal.
PackArr_even = PackArr(2:2:end, :); %Even refering to the Daisy signal.

UpsampledDataBoard = zeros(size(PackArr, 1), 24);
UpsampledDataDaisy = zeros(size(PackArr, 1), 24);

%Upsampling to restore the 16-channels signals.
for iSample = 1:size(PackArr, 1)
    

    if iSample == size(PackArr, 1) - 1
        UpsampledDataBoard(iSample, :) = (PackArr(iSample, :) + PackArr(1, :)) / 2;
        UpsampledDataDaisy(iSample, :) = PackArr(iSample + 1, :);
    elseif iSample == size(PackArr, 1) 
        UpsampledDataBoard(iSample, :) = PackArr(2, :);
        UpsampledDataDaisy(iSample, :) = (PackArr(iSample, :) + PackArr(2, :)) / 2;
    else
        if mod(iSample, 2) == 1
            UpsampledDataBoard(iSample, :) = (PackArr(iSample, :) + PackArr(iSample + 2, :)) / 2;
            UpsampledDataDaisy(iSample, :) = PackArr(iSample + 1, :);
        elseif mod(iSample, 2) == 0
            UpsampledDataBoard(iSample, :) = PackArr(iSample + 2, :);
            UpsampledDataDaisy(iSample, :) = (PackArr(iSample, :) + PackArr(iSample + 2, :)) / 2;
        end
    end
end



UnpackedData = zeros(nCh, size(PackArr, 1)); %16-channels unpacked data initialization.

for iCh = 1:8
    iCh_tmp = iCh * 2;
    UnpackedData(iCh, :) = UnpackData(UpsampledDataBoard(:, (iCh-1)*3+1:iCh*3));
    UnpackedData(iCh+8, :) = UnpackData(UpsampledDataDaisy(:, (iCh-1)*3+1:iCh*3));
    %UnpackedData(iCh, :) = UnpackData(PackArr(:, (iCh-1)*3+1:iCh*3));
end
UnpackedData = UnpackedData.*scale_fac_uVolts_per_count;
UnpackedDataRaw = UnpackedData;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
