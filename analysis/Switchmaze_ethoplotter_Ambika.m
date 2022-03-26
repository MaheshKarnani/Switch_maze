close all, clear all
animals={'141821018138';'141821018163';'141821018308'; '2006010137'};
'3 have pfc->lh dreadd 141821018138 is ctrl';
f1=figure;
f2=figure;
for a=1:4
clearvars -except a f1 f2 f3 f4 f5 animals binned b_trials b_dur binned_exp
animal=animals{a, 1};
filename=['C:\Data\Tmaze\' animal '_events.csv'];
%% Import csv
opts = delimitedTextImportOptions("NumVariables", 3);
opts.DataLines = [7, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Date_Time", "Rotation", "Pellet_Retrieval", "Type", "Wheel_Position", "FED_Position"];
opts.VariableTypes = ["string", "categorical", "categorical", "categorical", "categorical", "categorical"];
opts = setvaropts(opts, 1, "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 2, 4, 5, 6], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
events = readtable(filename, opts); 
events(find(events.Type=={'end session'}),:)%read out list of events
opts.VariableTypes = ["string", "categorical", "double", "categorical", "categorical", "categorical"];
events = readtable(filename, opts);
clear opts
%% chop
chop_from=datetime('2022-Mar-20 10:00:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
chop_to=datetime('2022-Mar-24 23:00:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
bin=hours(1);

% % dreadd bsl exp 0.5mg/kg
% bsl_from=datetime('2022-Mar-10 11:30:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
% dreadd_from=datetime('2022-Mar-11 11:30:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
% wo_from=datetime('2022-Mar-12 11:30:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
% effect_window=hours(6);

% % dreadd switch exp
% bsl_from=datetime('2022-Mar-11 11:30:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
% dreadd_from=datetime('2022-Mar-18 11:30:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
% wo_from=datetime('2022-Mar-18 11:30:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
% effect_window=hours(3);

% % dreadd no FED3 exp
% bsl_from=datetime('2022-Mar-13 15:00:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
% dreadd_from=datetime('2022-Mar-16 15:00:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
% wo_from=datetime('2022-Mar-17 15:00:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
% effect_window=hours(6);

% %dreadd hungry refeeding exp
% bsl_from=datetime('2022-Mar-14 11:30:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
% dreadd_from=datetime('2022-Mar-17 11:30:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
% wo_from=datetime('2022-Mar-18 11:30:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
% effect_window=hours(6);


x=datetime(events.(1),'InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
events(find(x<chop_from),:)=[];
x=datetime(events.(1),'InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
events(find(x>chop_to),:)=[];
x=datetime(events.(1),'InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
events(find(isnat(x)==1),:)=[];
x(find(isnat(x)==1))=[];
event_type=events.(4);
%% cleanup
water_time_was=events.Pellet_Retrieval(find(event_type=='begin session',1))
wheel_time_was=events.Rotation(find(event_type=='begin session',1))
clean_rows=[find(event_type=='begin session');find(event_type=='end session');find(event_type=='room door opened');find(event_type=='room door closed');];
events.Pellet_Retrieval(clean_rows)=NaN;
events.Rotation(clean_rows)='NaN';

%% plot
x=datetime(events.(1),'Format','yyyy-MM-dd HH:mm:ss.SSS');
y=NaN(size(x));
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
lick_contact(find(event_type=='Food_retrieval'))=NaN;
wheel=str2mat(string(events.(2)));
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
subplot(size(animals,1),1,a),plot(x,yy,'k');hold on
subplot(size(animals,1),1,a),plot(x,y,'ko');hold on
subplot(size(animals,1),1,a),plot(x,fed_pos,'b');
title(animal);
yticks([0.5 1.5 2 2.6 3 3.5 4]);
yticklabels({'goals switched','goals normal','nest','first_lick','run-wheel/water','decision point','food area'});
ylabel('area');

for i=1:length(starts)
    subplot(size(animals,1),1,a),plot([x(starts(i)) x(starts(i))],[1 5],'g');
end
for i=1:length(ends)
    subplot(size(animals,1),1,a),plot([x(ends(i)) x(ends(i))],[1 5],'r');
end
for i=1:1:length(first_lick)
    subplot(size(animals,1),1,a),plot([x(first_lick(i)) x(first_lick(i))],[2.4 2.8],'c');
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
for i=1:length(fed_pos)   
    if isnan(pel(i))==0
        subplot(size(animals,1),1,a),plot(x(i),4.0,'y*','MarkerSize',10,'LineWidth',3);
    end
    if str2double(wheel(i,:))>0.3
        subplot(size(animals,1),1,a),plot(x(i-1),3.0,'g*','MarkerSize',10,'LineWidth',3);
        revolutions(i)=str2double(wheel(i,:));
    end
end

if a==3
    h(1)=plot(x(end),1,'y*','MarkerSize',10,'LineWidth',3);
    h(2)=plot(x(end),1,'g*','MarkerSize',10,'LineWidth',3);
    plot(x(end),1,'w*','MarkerSize',10,'LineWidth',4);
    legend(h,'eat 14mg pellet','run >1 wheel rev','Location','South');
end
%% summary stats

%prep figure landmarks
        figure(f2);
        subplot(size(animals,1),1,a),plot(x,fed_pos,'b');hold on
        for i=1:length(starts)
            subplot(size(animals,1),1,a),plot([x(starts(i)) x(starts(i))],[1 50],'g');
        end
        for i=1:length(ends)
            subplot(size(animals,1),1,a),plot([x(ends(i)) x(ends(i))],[1 50],'r');
        end
        for i=1:length(attempts)
            subplot(size(animals,1),1,a),plot([x(attempts(i)) x(attempts(i))],[1.5 4.5],'k--');
        end
        for i=1:length(attempts_crowd)
            subplot(size(animals,1),1,a),plot([x(attempts_crowd(i)) x(attempts_crowd(i))],[1.5 4.5],'k');
        end
        for i=1:length(session_starts)
            subplot(size(animals,1),1,a),plot([x(session_starts(i)) x(session_starts(i))],[0 50],'m','LineWidth',3);
        end
        for i=1:length(session_ends)
            subplot(size(animals,1),1,a),plot([x(session_ends(i)) x(session_ends(i))],[0 50],'m','LineWidth',6);
        end
        for i=1:length(room_door_open)
            subplot(size(animals,1),1,a),plot([x(room_door_open(i)) x(room_door_open(i))],[0 50],'b--','LineWidth',2);
        end
        for i=1:length(room_door_close)
            subplot(size(animals,1),1,a),plot([x(room_door_close(i)) x(room_door_close(i))],[0 50],'b','LineWidth',2);
        end
    
%block duration and trial number
for i=1:size(starts,1)-1 %clean up
    if size(starts,1)>i
        if ends(i)>starts(i+1)
            starts(i)=[];
        end
    end
end
for i=1:size(ends,1)-1 %clean up
    if starts(i)>ends(i)
        ends(i)=[];
    end
end

for i=1:size(ends,1) %blocks
    b_dur(a).dur(i)=x(ends(i))-x(starts(i));
    events_block=events(starts(i):ends(i),:);
    event_type_block=events_block.(4);
    b_trials(a).w(i)=length(find(event_type_block=='BB3'));   
    b_trials(a).f(i)=length(find(event_type_block=='BB4'));    
    b_trials(a).total(i)=b_trials(a).w(i)+b_trials(a).f(i);
    
    %high res analyses
    b_trials_water=find(event_type_block=='BB3');
    b_trials_water_end=find(event_type_block=='Run_log_BB2');
    if length(b_trials_water) ~= length(b_trials_water_end)
        'problem inconsistent water trials in this block'
        'correcting by adding next read'
        b_trials_water_end=[b_trials_water_end; b_trials_water(end)+2];
    end
    b_trials_food=find(event_type_block=='BB4');
    b_trials_food_end=find(event_type_block=='Food_log_BB2');
    if length(b_trials_food) ~= length(b_trials_food_end)
        'problem inconsistent food trials in this block'
        'correcting by adding next read'
        b_trials_food_end=[b_trials_food_end;b_trials_food(end)+2];
    end
    b_trials_total=sort([b_trials_water;b_trials_food]);
    b_trials_total_end=sort([b_trials_water_end;b_trials_food_end]);
    if size(b_trials_total,1)>1
        j=0;%switch counter
        clear exploit
        ex_ind=1;
        exploit(ex_ind)=0; %exploit counter
        b_trial_dur=[];%trial duration accumulator
        b_choice_dur=[];%choice duration accumulator
        for e=2:size(b_trials_total,1)
            if find(b_trials_water==b_trials_total(e)) & find(b_trials_food==b_trials_total(e-1))
                j=j+1;
                ex_ind=ex_ind+1;
                exploit(ex_ind)=0;
            elseif find(b_trials_water==b_trials_total(e-1)) & find(b_trials_food==b_trials_total(e))
                j=j+1;
                ex_ind=ex_ind+1;
                exploit(ex_ind)=0;
            else %it was the same then
                exploit(ex_ind)=exploit(ex_ind)+1;
            end
            b_trial_dur=[b_trial_dur; milliseconds(x(b_trials_total_end(e))-x(b_trials_total(e)))];
            b_choice_dur=[b_choice_dur; milliseconds(x(b_trials_total(e))-x(b_trials_total_end(e-1)))];
        end
        b_trials(a).mean_choice_dur(i)=nanmean(b_choice_dur);
        b_trials(a).mean_trial_dur(i)=nanmean(b_trial_dur);
    else
        j=NaN;
        exploit=NaN;
        b_trials(a).mean_trial_dur(i)=NaN;
        b_trials(a).mean_choice_dur(i)=NaN;
    end
    b_trials(a).switch_index(i)=j/size(b_trials_total,1);
    b_trials(a).exploit_index_max(i)=max(exploit);
    b_trials(a).exploit_index_mean(i)=mean(exploit);
    b_trials(a).exploit_index_min(i)=min(exploit);
    b_trials(a).start_time(i)=x(starts(i));
    b_trials(a).revolutions(i)=sum(revolutions(starts(i):ends(i)));
    
end

figure(f2);
xx=x(ends);
subplot(size(animals,1),1,a),plot(xx,b_trials(a).total,'ko','MarkerFaceColor','k');hold on
plot(xx,b_trials(a).w,'co','MarkerFaceColor','c');
plot(xx,b_trials(a).f,'yo','MarkerFaceColor','y');

%weight
filename=['C:\Data\Tmaze\' animal '_weight.csv'];
opts = delimitedTextImportOptions("NumVariables", 5);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Weight_Mean", "Weight_Median", "Weight_Mode", "Weight_Max_Mode", "Date_Time"];
opts.VariableTypes = ["double", "double", "double", "categorical", "string"];
opts = setvaropts(opts, 5, "WhitespaceRule", "preserve");
opts = setvaropts(opts, [4, 5], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
weight = readtable(filename, opts);
clear opts
xw=datetime(weight.(5),'Format','yyyy-MM-dd HH:mm:ss.SSS');
% chop
weight(find(xw<chop_from),:)=[];
xw=datetime(weight.(5),'Format','yyyy-MM-dd HH:mm:ss.SSS');
yw=weight.(1);
subplot(size(animals,1),1,a),plot(xw,yw,'ks-');
title(animal);
ylabel('sq=w,g circles=trials/block');
(set(gca, 'YGrid', 'on', 'XGrid', 'off'));

%% plots for Ambika to make:

%rolling average of maze entries over time range chop_from=datetime('2022-Mar-01 10:00:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
% to chop_to=datetime('2022-Mar-18 23:00:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');

j=1;%index counter
for t=chop_from:bin:chop_to
    binned(a).starts(j)=size(find(x(starts)>t & x(starts)<t+bin),1);
    j=j+1;
end

%number of maze entries during a 6h window after saline, 6h window after C21 and 6h window after
%saline the following day on these days
% % dreadd bsl exp 0.5mg/kg
% bsl_from=datetime('2022-Mar-10 11:30:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
% dreadd_from=datetime('2022-Mar-11 11:30:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
% wo_from=datetime('2022-Mar-12 11:30:00.000','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
% effect_window=hours(6);

end
figure(f1);
linkaxes
ylim([0 4.5]);

figure(f2);
linkaxes
ylim([0 max([b_trials(:).total])]);

