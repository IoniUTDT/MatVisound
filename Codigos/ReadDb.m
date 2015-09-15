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


function ReadDb()

    
    cd ('/home/ionatan/Matlab/Datos')
    
    try
        url = 'http://turintur.dynu.com/db';
        filename = 'dbDownload.json';
        websave(filename,url);
        if exist(fullfile('/home/ionatan/Matlab/Datos', 'db.json'), 'file')
            movefile('db.json',['db.json archivado: ',datestr(now)]);
        end
        movefile('dbDownload.json','db.json');
    catch 
        disp ('No se pudo actualizar el archivo')
    end
    db = loadjson('db.json');

    %% Se encarga de filtrar los datos 
    
    % Carga los logueos
    sessiones = db.SessionEnviables(1,:);
    
    % Carga los levels
    levels = db.LevelEnviables(1,:);
    
    % Carga los trials
    trials = db.TrialEnviables(1,:);
    
    dbLimpia = struct;
    
    elementos=0;
    for i=1:length(sessiones)
        session=sessiones{i};
        for j=1:length(session)
            elementos=elementos+1;
            dbLimpia.sessiones(elementos) = session (j);
        end
    end
    
    elementos=0;
    for i=1:length(levels)
        level=levels{i};
        for j=1:length(level)
            elementos=elementos+1;
            dbLimpia.levels(elementos) = level (j);
        end
    end
    
    elementos=0;
    for i=1:length(trials)
        trial=trials{i};
        for j=1:length(trial)
            elementos=elementos+1;
            dbLimpia.trials(elementos) = trial (j);
        end
    end
    
    
    %% A partir de aca ordena la info de la base de datos en una estructura organizada tipo tabla separando users levels y trials
    
    % Creamos la estructura de los logs de Session
    sessionInstances = struct;
    
    % revisamos todos los registros y copiamos los datos que correspondan.
    % Automaticamente en la entradas que no tienen datos de completa con
    % datos en blanco.
    for indlog=1:length(dbLimpia.sessiones)
        unlog=dbLimpia.sessiones{indlog};
        fnames=fieldnames(unlog);
        for indfn=1:length(fnames)
            sessionInstances(indlog).(fnames{indfn})=unlog.(fnames{indfn});
        end
    end 

    % Limpia y unifica la info de levels
    
    levelsInstances = struct;
    
    for indLevelLog=1:length(dbLimpia.levels)
        unLevelLog=dbLimpia.levels{indLevelLog};
        fnames=fieldnames(unLevelLog);
        for indfn=1:length(fnames)
            levelsInstances(indLevelLog).(fnames{indfn})=unLevelLog.(fnames{indfn});
        end
    end 

    % Limpia y unifica la info de trials
    
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
    
    % Repite la operacion para leer dentro de cada info del trial la info de los toques y los sounds
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
    save ('dbProcesada', 'sessionInstances', 'levelsInstances', 'touchInstances', 'soundInstances', 'trialsInstances')    

    
    


