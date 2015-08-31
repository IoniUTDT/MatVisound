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


function dbLimpia = CleanDb(opt1)

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
    


