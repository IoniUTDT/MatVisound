TR=struct([]);

for indtrial=1:length(db.trials)
    untrial=db.trials{indtrial};
    
    fnames=fieldnames(untrial);
    
    for indfn=1:length(fnames)
        TR(indtrial).(fnames{indfn})=untrial.(fnames{indfn});
    end
    
end

%%
%busco todos los trials del sujeto 1
index=[TR.userId]==TR(1).userId & [TR.trialId]==1;

TRsuj=TR(index)

sujetos=unique([TR.userId])


