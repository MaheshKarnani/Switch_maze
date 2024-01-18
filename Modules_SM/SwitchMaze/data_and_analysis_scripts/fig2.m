clear all; close all
load('SM_Hartmann2023_biorxiv_data.mat');
animals={'141821018163';'141821018308';'2006010137';'141821018138'};
f1=figure;
for a=1:4
    clearvars -except a f1 f2 f3 f4 f5 animals binned b_trials b_dur binned_exp cleaned_data_fig2
    animal=animals{a, 1};
    events=cleaned_data_fig2(a).events;
    x=datetime(events.(1),'InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
    event_type=events.(4);
    %% plot panel A
    x=datetime(events.(1),'Format','yyyy-MM-dd HH:mm:ss.SSS');
    y=NaN(size(x));
    y(1)=2; y(end)=2;
    y(find(event_type=='BB4'))=4; %food entry
    y(find(event_type=='BB3'))=3; %wheel entry
    y(find(event_type=='BB2'))=3.5; %decision point logs
    y(find(event_type=='Food_log_BB2'))=3.5;
    y(find(event_type=='Run_log_BB2'))=3.5;
    y(find(event_type=='exit_drink'))=3.5;
    fed_pos=grp2idx(events.(6))-0.5;
    pel=events.(3);
    pel(find(event_type=='drink'))=NaN;
    pel(find(event_type=='Run_log_BB2'))=NaN;
    pel(find(event_type=='exit_drink'))=NaN;
    lick_contact=events.(3);
    licks=events.(2);
    keep=find(event_type=='exit_drink'); 
    licks(setdiff(1:end,keep))=NaN; %
    lick_contact(find(event_type=='Food_retrieval'))=NaN;
    wheel=double(events.(2));
    wheel(find(event_type=='drink'),:)=NaN;
    wheel(find(event_type=='exit_drink'),:)=NaN;
    room_door_open=find(event_type=='room door opened');
    room_door_close=find(event_type=='room door closed');
    starts=find(event_type=='START');
    ends=find(event_type=='END');
    %refine ends
    ends(find(ends<starts(1)))=[]; %clean ends before first start
    for i=1:size(starts,1)-1
        next_start=starts(i+1);
        next_end=ends(find(ends>starts(i),1));
        if next_start<next_end
            refined_ends(i)=next_start-1;
        else
            refined_ends(i)=next_end;
        end
    end
    if ends(end)>starts(end)
        refined_ends(end+1)=ends(end);
    else
        starts(end)=[];
    end
    clear ends
    ends=refined_ends';
    first_lick=find(event_type=='drink');
    attempts=find(event_type=='ENTRY DENIED');
    attempts_crowd=find(event_type=='ENTRY DENIED MULTIPLE ANIMALS');
    session_starts=find(event_type=='begin session');
    session_ends=find(event_type=='end session');
    y([starts; ends])=2;
    yy=fillmissing(y,'linear');
    
    figure(f1);
    m=size(animals,1);
    n=1;
    p=a;
    subplot(m,n,p),plot(x,yy,'k');hold on
    subplot(size(animals,1),1,a),plot(x,y,'ko');hold on
    title(animal);
    yticks([2 2.6 3 3.5 4]);
    yticklabels({'nest','first_lick','run-wheel/water','decision point','food area'});
    ylabel('area');
    
    for i=1:length(starts)
        subplot(size(animals,1),1,a),plot([x(starts(i)) x(starts(i))],[1 5],'g');
    end
    for i=1:length(ends)
        subplot(size(animals,1),1,a),plot([x(ends(i)) x(ends(i))],[1 5],'r');
    end
    for i=1:1:length(first_lick)
        subplot(size(animals,1),1,a),plot([x(first_lick(i)) x(first_lick(i))],[2.4 2.8],'b');
    end
    for i=1:length(attempts)
        subplot(size(animals,1),1,a),plot([x(attempts(i)) x(attempts(i))],[1.5 4.5],'k--');
    end
    for i=1:length(attempts_crowd)
        subplot(size(animals,1),1,a),plot([x(attempts_crowd(i)) x(attempts_crowd(i))],[1.5 4.5],'k');
    end
    for i=1:length(session_starts)
        subplot(size(animals,1),1,a),plot([x(session_starts(i)) x(session_starts(i))],[0 6],'m','LineWidth',3);
    end
    for i=1:length(session_ends)
        subplot(size(animals,1),1,a),plot([x(session_ends(i)) x(session_ends(i))],[0 6],'m','LineWidth',6);
    end
    for i=1:length(room_door_open)
        subplot(size(animals,1),1,a),plot([x(room_door_open(i)) x(room_door_open(i))],[0 6],'b--','LineWidth',2);
    end
    for i=1:length(room_door_close)
        subplot(size(animals,1),1,a),plot([x(room_door_close(i)) x(room_door_close(i))],[0 6],'b','LineWidth',2);
    end
    
    revolutions=zeros(size(events,1),1);
    for i=2:length(fed_pos)   
        if isnan(pel(i))==0
            subplot(size(animals,1),1,a),plot(x(i),4.0,'y*','MarkerSize',5,'LineWidth',3);
        end
        if wheel(i,:)>25 %more than one turn
            subplot(size(animals,1),1,a),plot(x(i-1),3.0,'c*','MarkerSize',5,'LineWidth',3);
            revolutions(i)=str2double(wheel(i,:));
        end
    end
    
    if a==3
        h(1)=plot(x(end),1,'y*','MarkerSize',5,'LineWidth',3);
        h(2)=plot(x(end),1,'c*','MarkerSize',5,'LineWidth',3);
        plot(x(end),1,'w*','MarkerSize',10,'LineWidth',4);
        legend(h,'eat 14mg pellet','run >1 wheel rev','Location','South');
    end
end
figure(f1);
linkaxes
ylim([1.5 4.5]);
%% prep for other plots
load('SM_Hartmann2023_biorxiv_data.mat', 'session_fig2')
binned=session_fig2.binned;
session=session_fig2.session;
binned_exp=session_fig2.binned_exp;

%list exploitation runs
for an=1:size(session,2)
    list(an).list=[];
    list(an).feeding_length=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
        if t=='EF' | t=='DF'
            list(an).feeding_length=[list(an).feeding_length session(an).E(i)];
        end
    end
    session(an).E(list(an).list)=[]; %remove maze exits
    session(an).feeding_length=list(an).feeding_length;
end
s_bsl=session;
s_bsl_exp=binned_exp;

% trial and block durations and counts
figure;
for a=1:size(session,2)
    bar(a/size(animals,1),binned_exp(a).starts,0.15,'FaceColor',[a/size(animals,1) 1-a/size(animals,1) a/size(animals,1)]);
    hold on;
end
xlim([0 1.2]);ylim([0 15]);
title('Blocks');

figure;
for a=1:size(session,2)    
    bar(a/size(animals,1),binned_exp(a).block_dur,0.15,'FaceColor',[a/size(animals,1) 1-a/size(animals,1) a/size(animals,1)]);
    hold on;
end
xlim([0 1.2]);ylim([minutes(0) minutes(9)]);
title('Block duration');

figure;
for a=1:size(session,2)
    bar(a/size(animals,1),binned_exp(a).decisions,0.15,'FaceColor',[a/size(animals,1) 1-a/size(animals,1) a/size(animals,1)]);
    hold on;
end
xlim([0 1.2]);ylim([0 170]);
title('Trials');

figure;
for a=1:size(session,2)
    bar(a/size(animals,1),binned_exp(a).trial_dur/1000,0.15,'FaceColor',[a/size(animals,1) 1-a/size(animals,1) a/size(animals,1)]);
    hold on;
end
xlim([0 1.2]);ylim([0 35]);
title('Trial duration,s');

%% histograms
%load habituation dataset to get 13 animals into these plots.
binned_Bdur=session_fig2.binned_Bdur;
binned_Tdurs=session_fig2.binned_Tdurs;
binned_exp=session_fig2.binned_exp;
'steady state stats from 7d - 8d 24h span'
win=45:50;
average_block_dur=nanmean(minutes(cat(1,binned_Bdur(win).Bdur)))
min_block_dur=min(cat(1,binned_Bdur(win).Bdur))
max_block_dur=max(cat(1,binned_Bdur(win).Bdur))
sd_block_dur=nanstd(minutes(cat(1,binned_Bdur(win).Bdur)),0,1)
figure;histogram(minutes(cat(1,binned_Bdur(win).Bdur)),'BinWidth',0.5)
xticks(0:30);set (gca,'TickDir','out')
prctile(minutes(cat(1,binned_Bdur(win).Bdur)),95)
title('Block duration,min');

average_trial_dur=nanmean(cat(2,binned_Tdurs(win).Tdurs))
min_trial_dur=min(cat(2,binned_Tdurs(win).Tdurs))
max_trial_dur=max(cat(2,binned_Tdurs(win).Tdurs))
sd_trial_dur=nanstd((cat(2,binned_Tdurs(win).Tdurs)),0,2)
figure;h=histogram(milliseconds((cat(2,binned_Tdurs(win).Tdurs))),'BinWidth',milliseconds(1000))
xticks(milliseconds(0:5000:600000));set (gca,'TickDir','out')
prctile(cat(2,binned_Tdurs(win).Tdurs),95)
title('Trial duration,s');