%% Esta funcion carga los datos de una session y realiza un grafico de lo que sucede. No tiene en principio utilidad mas alla de ser una interfaz linda para visualizar los datos. La principla razon para hacerla es que sirve para comprobar que la info guardada en el registro es completa y procesable
function SelectSesion()
%% Carga los datos

clear all

load('dbProcesada')
idSession=sessionInstances(length(sessionInstances)-0).id;
disp(['Session correspondiente a la fecha ',f(idSession)])
%% Busca la info del usuario y los levels asociados a esa sesion

user = unique([sessionInstances([sessionInstances.id]==idSession).userID]); % Busca el id del usuario
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
soundDrawAltura = 1;
soundDrawAlto = 0.5;

close all
figure
hold on
axis([(d(t_inicial) - 2/(24*60*3)) (d(t_final) + 2/(24*60*3)) 0 10]);
%title ('Ioni test inicial + test inicial dificil')
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

yt=1;
ys=3;
for iTrial=1:length(trials)
    trial = trials(iTrial); % Carga el trial a procesar
    % Aca hay un parche para analizar los datos porque no me esta andando
    % el server. En el futuro la info deberia estar limpia en la base de
    % datos con marcas temporales absolutas
    
    t_entrada = trial.timeTrialStart;
    t_salida = trial.timeExitTrial;
    
    pos=[d(t_entrada) trialDrawAltura (d(t_salida)-d(t_entrada)) trialDrawAlto];
    if (strcmp(trial.tipoDeTrial,'TEST'))
        color = 'y';
    elseif (strcmp(trial.tipoDeTrial,'ENTRENAMIENTO'))
        color = 'b';
    end
    rectangle('Position',pos,'FaceColor',color,'EdgeColor',color)
    x = (d(t_salida)+d(t_entrada))/2;
    y = trialDrawAltura + trialDrawAlto /2;
    texto = [int2str(trial.trialId)];
    text(x,y,texto,'HorizontalAlignment','center');
   
    %% Graficamos los touchs para este trial
    touchs = touchInstances([touchInstances.trialInstance]==trial.trialInstance);
    disp (['Se han encontrado ',int2str(length(touchs)),' toques para procesar en la instancia de trial ',f(trial.trialInstance),' trial id: ',int2str(trial.trialId)])

    for iTouch=1:length(touchs)
        touch=touchs(iTouch);
        
        if (touch.isTrue)
            color='g';
        else
            color='r';
        end
        
        if (strcmp(touch.tipoDeTrial,'ENTRENAMIENTO'))
            color='y';
        end
        
        line([d(touch.touchInstance),d(touch.touchInstance)],[1,2],'Color',color)
        texto = [int2str(touch.idResourceTouched.id)];
        text(d(touch.touchInstance),yt,texto,'HorizontalAlignment','center');
        yt=yt+0.2;
        if yt>2
            yt=1;
        end
    end
    
    %% Graficamos los sounds para este trial
    sounds = soundInstances([soundInstances.trialInstance]==trial.trialInstance);
    disp (['Se han encontrado ',int2str(length(sounds)),' sonidos para procesar en la instancia de trial ',f(trial.trialInstance),' trial id: ',int2str(trial.trialId)])
    
    for iSound=1:length(sounds)
        sound=sounds(iSound);
        
        %pos=[d(sound.soundInstance) soundDrawAltura (d(sound.stopTime)-d(sound.soundInstance)) soundDrawAlto];
        %color='y';
        %rectangle('Position',pos,'FaceColor',color,'EdgeColor',color)
        %x = (d(sound.stopTime)+d(sound.stopTime))/2;
        
        line([d(sound.soundInstance),d(sound.soundInstance)],[3,4])
        texto = int2str(sound.soundId.id);
        text(d(sound.soundInstance),ys,texto,'HorizontalAlignment','center');
        ys=ys+0.2;
        if ys>4
            ys=3;
        end
    end
end

