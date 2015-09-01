function SelectSesion()
%% Carga los datos

load('dbProcesada')
id=logsInstances(1).id;
%% Busca la info del usuario asociado a esa sesion

user = unique([logsInstances([logsInstances.id]==id).userID]); % Busca el id del usuario
levels = levelsInstances([levelsInstances.idUser]==id); % Selecciona los logs de levels asociados al usuario

%% primero graficamos el historial para una session

% Seleccionamos cada session

listaSessiones = unique([levels.sessionId]) % Omite automaticamente las sessiones en que el usuario ni entro a un nivel porque las saca del registro de niveles

for iSessiones=1:length(listaSessiones)
    
levels = levelsInstances([levelsInstances.sessionId]==id); % Selecciona los logs de levels asociados
    % Buscamos el tiempo inicial y el final
    t_inicial=0;
    t_final=0;
    for i=1:length(levels)
        level=levels(i);
        if t_inicial == 0
            t_inicial = level.timeStarts;
        else
            if t_inicial > level.timeStarts
                t_inicial = level.timeStarts;
            end
        end
        if t_final == 0
            t_final = level.timeExit;
        end
    end
    
    
    date = datestr([levels.sessionId]/86400/1000 + datenum(1970,1,1))
    
    % Create dates as serial numbers
    serdates = fix(now) + 9/24 :  1/(24*4) : fix(now) + 11/24;
    
    % plot
    plot(serdates)
    
    % Set ticks to serial dates (just to make sure they fall on serdates)
    set(gca,'xtick',serdates)
    
    % Format into time
    datetick('x','keepticks')
    
    
end

end

