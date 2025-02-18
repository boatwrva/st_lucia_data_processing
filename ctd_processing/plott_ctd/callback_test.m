function callback_test(obj,event)

if(isequal(event.Type,'StartFcn'))
disp(['Start CTD REAL TIME ',datestr(event.Data.time)]);
elseif(isequal(event.Type,'StopFcn'))
    disp(['Stop CTD REAL TIME ', datestr(event.Data.time)]);
    delete(timerfind(T)) 
    
end

end