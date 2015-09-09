%% Esta rutina va a servir para hacer un procesamiento matematicamente correcto de los datos por sesion

function StatSession()

% cargamos los datos
clear all

load('dbProcesada')
idSession=logsInstances(length(logsInstances)).id;
disp(['Session correspondiente a la fecha ',f(idSession)])


%% Busca la info del usuario y los levels asociados a esa sesion

user = unique([logsInstances([logsInstances.id]==idSession).userID]); % Busca el id del usuario
levels = levelsInstances([levelsInstances.sessionId]==idSession); % Selecciona los logs de levels asociados a la session
trials = trialsInstances([trialsInstances.sessionId]==idSession); % Selecciona 

disp (['Jugador registrado el ',f(user)])
disp (['Numero de levels jugados en esta session: ',int2str(length(levels))])
disp (['Numero de trials jugados en esta session: ',int2str(length(trials))])
levelStats = struct;

for iLevel=1:length(levels)
    
    level = levels(iLevel); % carga los datos del nivel que se va a procesar
    disp (['Informacion correspondiente al nivel "',level.levelTitle,'" id: ',int2str(level.levelId)])
    if level.levelCompleted
        disp ('Nivel jugado completo')
    else
        disp ('Nivel incompleto, los datos no se procesaran')
        continue
    end
    levelStats(iLevel).id = level.levelId;
    levelStats(iLevel).title = level.levelTitle;

    % Seleccionamos los touchs de este level
    touchs = touchInstances([touchInstances..trialInstance]==trial.trialInstance);
end
end