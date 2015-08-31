function SelectSesion()
%% Carga los datos
    
    load('dbProcesada')
    id=USERS(23).id;
%% Busca la info del usuario asociado a esa sesion
    
    User = USERS([USERS.id]==id).userID; % Busca el id del usuario
    Levels = levelsInstances([levelsInstances.sessionId]==id); % Selecciona los logs de levels asociados
    Trials = trialsInstances([trialsInstances.sessionId]==id); % Selecciona los logs de trial asociados
    
%% primero graficamos el historial de niveles 
    
    

end
