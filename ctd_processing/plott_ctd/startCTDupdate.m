% Test timer functions
initialize


%% Start CTD and ADCP data
T = timer('TimerFcn','getupdate3','Period',5*60,'executionMode','fixedRate');
T.StartFcn={@callback_test};
T.StopFcn={@callback_test};

startat(T,now+1/(60*60*24))
