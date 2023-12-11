function ret = EEGClassifier()

while true
    [SigType, ~] = GetSignal();
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
end

function OpType = work()
    % start recording signal and do classification
end
