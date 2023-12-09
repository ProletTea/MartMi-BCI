function [SigType, OpType] = GetSignal()
    str = input('', 's')
    signal = jsondecode(str);
    SigType = signal.sig_type;
    OpType = signal.op_type;
end
