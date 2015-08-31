%% Esta rutina se encarga de limpiar la base de datos de estructuras innecesarias
% Por como se genera la base de datos (json-server) se crea un nivel
% innecesario en la estructura que le asigna un id a cada entrada. Los
% datos ya vienen identificados en la propia estructura por un
% identificador, por lo que no tiene sentido guardar esa informacion. 

% El programa asume que la base de datos tiene la estructura que se detalla
% a continuacion. Si se modifica dicha estructura cuando se generan los
% datos, de deberia modificar este programa

%% Estructura de datos prevista
% La base de datos tiene cuatro entradas principales, cada una de la cuales
% guarda informacion de tipo diferente. 
% La entrada "Status" simplemente sirve para verificar que la aplicacion
% esta pudiendo acceder correctamente al servidor.
% La entrada "JsonSessionHistory" guarda un array de estructuras con
% informacion de los logueos que realizan los usuarios
% La entrada "LevelLogHistory" guarda un array de estructuras con la
% informacion de recorrido por los niveles y trials que realiza cada 
% usuario dentro de una misma sesion
% La entrada "TrialLogHistory" guarda un array de estructuras con toda la 
% informacion de como el usuario interactuo con el programa. Esta es la
% informacion clave para procesar.

% Por como funciona el json-server que genera la base de datos, cada vez
% que se sube una estructura a una categoria le asigna un Id. Esto complica
% la estructura de datos, por lo que esta rutina posteriormente a leer los
% datos, los limpia de esta informacion innecesaria. 


function ReadDb(opt1)

    if nargin < 1
        opt1 =   'db.json';
    end
    
    if exist('db.mat', 'file')
        load ('db.mat')
    else
        db = loadjson(opt1);
    end
    
    save ('db.mat','db');
    
    % Se encarga de la parte de los logueos
    
    %inicializa el variable cargando el primero y el ultimo para reservar
    %el espacio necesario
    logueos = db.JsonSessionHistory{1}.history(1);
    last=0;
    for i=1:length(db.JsonSessionHistory)
        last = last + length(db.JsonSessionHistory{i}.history);
    end
    logueos(last) = db.JsonSessionHistory{length(db.JsonSessionHistory)}.history(length(db.JsonSessionHistory{length(db.JsonSessionHistory)}.history));
    last=0;
    for i=1:length(db.JsonSessionHistory)
        for j=1:length(db.JsonSessionHistory{i}.history)
            last=last+1;
            logueos(last)=db.JsonSessionHistory{i}.history(j);
        end
    end
    
    % Se encarga de la parte de los levels
    levels = db.LevelLogHistory{1}.history(1);
    last=0;
    for i=1:length(db.LevelLogHistory)
        last = last + length(db.LevelLogHistory{i}.history);
    end
    levels(last) = db.LevelLogHistory{length(db.LevelLogHistory)}.history(length(db.LevelLogHistory{length(db.LevelLogHistory)}.history));
    last=0;
    for i=1:length(db.LevelLogHistory)
        for j=1:length(db.LevelLogHistory{i}.history)
            last=last+1;
            levels(last)=db.LevelLogHistory{i}.history(j);
        end
    end
    
    % Se encarga de la parte de los trials
    trials = db.TrialLogHistory{1}.history(1);
    last=0;
    for i=1:length(db.TrialLogHistory)
        last = last + length(db.TrialLogHistory{i}.history);
    end
    trials(last) = db.TrialLogHistory{length(db.TrialLogHistory)}.history(length(db.TrialLogHistory{length(db.TrialLogHistory)}.history));
    last=0;
    for i=1:length(db.TrialLogHistory)
        for j=1:length(db.TrialLogHistory{i}.history)
            last=last+1;
            trials(last)=db.TrialLogHistory{i}.history(j);
        end
    end
    
    dbLimpia = struct;
    dbLimpia.logs = logueos;
    dbLimpia.levels = levels;
    dbLimpia.trials = trials;
    
    %% A partir de aca ordena la info de la base de datos en una estructura organizada tipo tabla separando users levels y trials
    
    USERS=struct([]);
    
    % Primero procesa la info en los logs donde esta la info de los
    % usuarios para crear todas las entradas que correspondan
    
    % Primero estandarizamos la info de los logs completando con espacios
    % blancos donde no hay datos.
    
    for indlog=1:length(dbLimpia.logs)
        unlog=dbLimpia.logs{indlog};
        fnames=fieldnames(unlog);
        for indfn=1:length(fnames)
            USERS(indlog).(fnames{indfn})=unlog.(fnames{indfn});
        end
    end 

    %% Ahora unificamos registros donde hay un usuario repetido
    
    % No esta muy claro que esto sea util.
    
    USERSunificados = struct([]);
    listaUsuariosId=unique([USERS.userID]);
    % Crea la lista de usuarios
    for i=1:length(listaUsuariosId)
        USERSunificados(i).Id=listaUsuariosId(i);
    end
    %% Carga los id de la sessiones
    USERSunificados(1).SessionsIds = [];
    for i=1:length(USERSunificados)
        index = USERSunificados(i).Id==[USERS.userID];
        USERSunificados(i).SessionsIds = [USERS(index).id];
    end
    
    
    %% Limpia y unifica la info de levels
    
    levelsInstances = struct;
    
    for indLevelLog=1:length(dbLimpia.levels)
        unLevelLog=dbLimpia.levels{indLevelLog};
        fnames=fieldnames(unLevelLog);
        for indfn=1:length(fnames)
            levelsInstances(indLevelLog).(fnames{indfn})=unLevelLog.(fnames{indfn});
        end
    end 

    %% Limpia y unifica la info de trials
    
    trialsInstances = struct;
    touchInstances = struct;
    nTouch=0;
    soundInstances = struct;
    nSound=0;
        
    for indTrialLog=1:length(dbLimpia.trials)
        unTrialLog=dbLimpia.trials{indTrialLog};
        fnames=fieldnames(unTrialLog);
        for indfn=1:length(fnames)
            trialsInstances(indTrialLog).(fnames{indfn})=unTrialLog.(fnames{indfn});
        end
    end 
    for indTrialLog=1:length(trialsInstances)
        % carga los toques en el registro de toques
        for indTouchLog=1:length(trialsInstances(indTrialLog).touchLog)
            nTouch=nTouch+1;
            unTouch = trialsInstances(indTrialLog).touchLog{indTouchLog};
            fnames=fieldnames(unTouch);
            for indfn=1:length(fnames)
                touchInstances(nTouch).(fnames{indfn}) = unTouch.(fnames{indfn});
            end
        end
        % carga los toques en el registro de sonidos
        for indSoundLog=1:length(trialsInstances(indTrialLog).soundLog)
            nSound=nSound+1;
            unSound = trialsInstances(indTrialLog).soundLog{indSoundLog};
            fnames=fieldnames(unSound);
            for indfn=1:length(fnames)
                soundInstances(nSound).(fnames{indfn}) = unSound.(fnames{indfn});
            end
        end
    end
    
    
    
    
    %% Guarda los datos relevantes
    save ('dbProcesada', 'USERS', 'listaUsuariosId', 'levelsInstances', 'touchInstances', 'soundInstances', 'trialsInstances')    
    clear all
    load ('dbProcesada')
    
    


