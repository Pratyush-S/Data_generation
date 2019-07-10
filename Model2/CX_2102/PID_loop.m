function PID_loop()
Kp = 0.1;
Kd = 0.008;
SP = 1600;

while(1)
    %Co2_current = (bufData(1) + bufData(2) + bufData(3) + bufData(4) + bufData(5) + bufData(6))/6;
    while(op_flag)
       load('control_loop.mat','op_flag');
    end
    load('control_loop.mat','error','bufData','control_vf');

    Co2_current = mean(bufData);
    error_current = SP - Co2_current;

    P_err = Kp * error;
    D_err = Kd * (error_current - error);
    error = error_current;

    controlsignal = -1*(P_err + D_err)/50;
    %%control_vf%%
    if (controlsignal > 0)
        actuation_on = 1;
    else
        actuation_on = 0;
    end

    if (actuation_on == 1)
      initial = control_vf;
       if (initial < 1)
           finalvf = initial + (initial*controlsignal);
       end
       if (finalvf > 1)

           finalvf =1;
       end
    end
    
    if(finalvf ~= initial)
        override =1;
    else
        override =0;
    end
    control_vf = finalvf;
    control_update = 1;

    save('control_loop.mat','-append','control_update','control_vf','error','override');
end