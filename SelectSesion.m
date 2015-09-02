%% Esta funcion carga los datos de una session y realiza un grafico de lo que sucede. No tiene en principio utilidad mas alla de ser una interfaz linda para visualizar los datos. La principla razon para hacerla es que sirve para comprobar que la info guardada en el registro es completa y procesable
function SelectSesion()
%% Carga los datos

clear all

load('dbProcesada')
idSession=logsInstances(23).id;
disp(['Session correspondiente a la fecha ',f(idSession)])
%% Busca la info del usuario y los levels asociados a esa sesion

user = unique([logsInstances([logsInstances.id]==idSession).userID]); % Busca el id del usuario
levels = levelsInstances([levelsInstances.sessionId]==idSession); % Selecciona los logs de levels asociados a la session
trials = trialsInstances([trialsInstances.sessionId]==idSession); % Selecciona 

disp (['Numero de levels jugados en esta session: ',int2str(length(levels))])
disp (['Numero de trials jugados en esta session: ',int2str(length(trials))])

%% Preparamos el grafico


% inicializa datos globales para toda la sesion
t_inicial=min([levels.timeStarts]);
t_final=max([levels.timeExit]);

levelDrawAltura = 7;
levelDrawAlto=1;
trialDrawAltura = 5;
trialDrawAlto = 1;

close all
figure
hold on
axis([(d(t_inicial) - 1/(24*60)) (d(t_final) + 1/(24*60)) 0 10]);
datetick('x','keepticks')

%% Graficamos los levels

for iLevel=1:length(levels)
    
    level = levels(iLevel); % carga los datos del nivel que se va a procesar
    
    % Graficamos cada level como un rectangulo 
    pos=[d(level.timeStarts) levelDrawAltura (d(level.timeExit)-d(level.timeStarts)) levelDrawAlto];
    if (level.levelCompleted)
        color = 'g';
    else
        color = 'r';
    end
    rectangle('Position',pos,'FaceColor',color,'EdgeColor',color)
    x = (d(level.timeExit)+d(level.timeStarts))/2;
    y = levelDrawAltura + levelDrawAlto /2;
    texto = ['Level: ', int2str(level.levelId)];
    text(x,y,texto,'HorizontalAlignment','center');
    
    
end

%% Graficamos los trials

for iTrial=1:length(trials)
    trial = trials(iTrial); % Carga el trial a procesar
    % Aca hay un parche para analizar los datos porque no me esta andando
    % el server. En el futuro la info deberia estar limpia en la base de
    % datos con marcas temporales absolutas
    if isempty(trial.timeInGame)
        disp (['Tiempo de inicio del trial ',int2str(trial.trialId),' invalido'])
        continue
    end
    if isempty(trial.timeInTrial)
        disp (['Tiempo de duracion del trial ',int2str(trial.trialId),' invalido'])
        continue
    end
    t_entrada = trial.timeInGame / 1000 + trial.sessionId;
    t_salida = trial.timeInTrial * 1000 + t_entrada;
    
    pos=[d(t_entrada) trialDrawAltura (d(t_salida)-d(t_entrada)) trialDrawAlto];
    if (strcmp(trial.tipoDeTrial,'TEST'))
        color = 'y';
    elseif (strcmp(trial.tipoDeTrial,'ENTRENAMIENTO'))
        color = 'b';
    end
    rectangle('Position',pos,'FaceColor',color,'EdgeColor',color)
    x = (d(t_salida)+d(t_entrada))/2;
    y = trialDrawAltura + trialDrawAlto /2;
    texto = ['Trial: ', int2str(trial.trialId)];
    text(x,y,texto,'HorizontalAlignment','center');
   
    %% Graficamos los touchs para este trial
    touchs = touchInstances([touchInstances.trialInstance]==trial.trialInstance);
    disp (['Se han encontrado ',int2str(length(touchs)),' toques para procesar en la instancia de trial ',f(trial.trialInstance),' trial id: ',int2str(trial.trialId)])
    
    for iTouch=1:length(touchs)
        touch=touchs(iTouch);
    end
    
    %% 
    
end

