%% Esta rutina filtra los datos de la base de datos para seleccionar los de un usuario en particular a partir de su identificador

function User = User (LongId)

addpath(genpath('/home/ionatan/Matlab/jsonlab'));
dbOriginal = CleanDb ('db.json');
db = struct;

% Carga los logs

last=0;
for i=1:length(dbOriginal.logs)
    if dbOriginal.logs{i}.userID == LongId
       last=last+1;
       db.logs{last} = dbOriginal.logs{i};
    end
end


% Carga los levels
last=0;
for i=1:length(dbOriginal.levels)
    if dbOriginal.levels{i}.idUser == LongId
       last=last+1;
       db.levels{last} = dbOriginal.levels{i};
    end
end


% Carga los levels
last=0;
for i=1:length(dbOriginal.trials)
    if dbOriginal.trials{i}.userId == LongId
       last=last+1;
       db.trials{last} = dbOriginal.trials{i};
    end
end

User = db;