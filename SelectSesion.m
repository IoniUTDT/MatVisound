function SelectSesion()
%% Carga los datos
    
    load('dbProcesada')
    id=USERS(23).id;
%% Busca la info del usuario asociado a esa sesion
    
    User = USERS([USERS.id]==id).userID;
    IndexLevels = [levelsInstances.sessionId]==id
    Levels = levelsInstances(IndexLevels);
    

end
