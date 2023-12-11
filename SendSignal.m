function SendSignal(SigType, OpType)
    str = jsonencode(containers.Map({'sig_type', 'op_type'}, [SigType, OpType]));
    fprintf(1, "%s\n", str);
    drawnow('update');
end
