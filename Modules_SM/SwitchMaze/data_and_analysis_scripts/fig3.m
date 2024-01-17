%% plot fig3B-D (fig3A is the same as fig2A inset)
load('SM_Hartmann2023_biorxiv_data.mat');
session=session_fig3;
animals={'141821018163';'141821018308';'2006010137';'141821018138'};
tic
for a=1:size(session,2)
    session(a).shuffles.Etypes=[];
    session(a).shuffles.E=[];
    for shuf=1:100
        L=session(a).sequence;
        L=L(randperm(length(L))); %SHUFFLE order
        j=1;
        k=1;
        if L(1)=="BB3" %init Etypes, treating first as E->x transition
            Etypes={'ED'};
        elseif L(1)=="BB4"
            Etypes={'EF'};
        elseif L(1)=="END"
            Etypes={'EE'};
        end

        for i=2:length(L)-1
            if L(i)==L(i-1)
                j=j+1;
                if L(i)=="BB4"
                    Etypes=[Etypes 'FF'];
                elseif L(i)=="BB3"
                    Etypes=[Etypes 'DD'];
                elseif L(i)=="END"
                    Etypes=[Etypes 'EE'];
                end
            else
                session(a).shuffles(shuf).E(k)=j; %run length
                session(a).shuffles(shuf).Etypes(k).Etypes=Etypes; %types of trial transition for confusion matrix
                %init next round
                k=k+1;
                j=1;
                if L(i-1)=="BB4"
                    if L(i)=="BB3"
                        Etypes={'FD'};
                    elseif L(i)=="BB4"
                        Etypes={'FF'};
                    elseif L(i)=="END"
                        Etypes={'FE'};
                    end
                elseif L(i-1)=="BB3"
                    if L(i)=="BB3"
                        Etypes={'DD'};
                    elseif L(i)=="BB4"
                        Etypes={'DF'};
                    elseif L(i)=="END"
                        Etypes={'DE'};
                    end
                elseif L(i-1)=="END"
                    if L(i)=="BB3"
                        Etypes={'ED'};
                    elseif L(i)=="BB4"
                        Etypes={'EF'};
                    elseif L(i)=="END"
                        Etypes={'EE'};
                    end
                end 
            end
        end
        %the correction for ends as below before next shuffle
        list(a).list=[];
        list(a).feeding_length=[];
        for i=1:size(session(a).shuffles(shuf).Etypes,2)
            t=categorical(session(a).shuffles(shuf).Etypes(i).Etypes(1)); 
            if t=='FE' | t=='DE' | t=='EE'
                list(a).list=[list(a).list i];
            end
    %         if t=='ED' | t=='FD'
            if t=='EF' | t=='DF'
                list(a).feeding_length=[list(a).feeding_length session(a).shuffles(shuf).E(i)];
            end
        end
        session(a).shuffles(shuf).E(list(a).list)=[];%remove maze exits
        session(a).shuffles(shuf).feeding_length=list(a).feeding_length;
        % end correction
    end
end

toc


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
% s_bsl_exp=binned_exp;
figure;
B=session(1).E; %note, the E in session struct denotes 'Exploitation run' 
C=session(2).E;
D=session(3).E;
E=session(4).E;
a=1;
subplot(1,4,1),histogram(B,'DisplayStyle','stairs','EdgeColor',[a/size(animals,1) 1-a/size(animals,1) a/size(animals,1)],'LineWidth',1.5);
% a=2;subplot(1,4,2),histogram(C,'DisplayStyle','stairs','EdgeColor',[a/size(animals,1) 1-a/size(animals,1) a/size(animals,1)],'LineWidth',1.5);
% a=3;subplot(1,4,3),histogram(D,'DisplayStyle','stairs','EdgeColor',[a/size(animals,1) 1-a/size(animals,1) a/size(animals,1)],'LineWidth',1.5);
% a=4;subplot(1,4,4),histogram(E,'DisplayStyle','stairs','EdgeColor',[a/size(animals,1) 1-a/size(animals,1) a/size(animals,1)],'LineWidth',1.5);
title('ctrl');xlabel('n');

% MSR
%% switching index
clear A B
figure;
for a=1:size(session,2)
    A(a)=length(find(session(a).E==1));
    Am(a)=length(find(session(a).E>1));
    bar(a/size(animals,1)*5,A(a)/Am(a),0.25,'FaceColor',[a/size(animals,1) 1-a/size(animals,1) a/size(animals,1)]);
    hold on;
    for shuf=1:size(session(a).shuffles,2)
        B(a,shuf)=length(find(session(a).shuffles(shuf).E==1));
        Bm(a,shuf)=length(find(session(a).shuffles(shuf).E>1)); 
    end
    session(a).SI_shuf_av=mean(B(a,:)./Bm(a,:),2);
    plot([a/size(animals,1)*5-0.2 a/size(animals,1)*5+0.2],[median(B(a,:)./Bm(a,:),2) median(B(a,:)./Bm(a,:),2)],'k-');
    s(a).s=B(a,:)./Bm(a,:);
%     bar(a/size(animals,1)*5+0.1,mean(B(a,:)./Bm(a,:),2),0.15,'FaceColor',[a/size(animals,1) 1-a/size(animals,1) a/size(animals,1)]);
%     scatter(B(a,:)./B(a,:)*a/size(animals,1)*5+0.1,B(a,:)./Bm(a,:),'ko','MarkerEdgeAlpha',0.2);
    [p(1+a),h(1+a)] = ranksum(A(a)/Am(a),B(a,:)./Bm(a,:))
    RD_shufs=B(a,:)./Bm(a,:);
    stats_table(a,[1 2 3])=[A(a)/Am(a) prctile(RD_shufs,99) A(a)/Am(a)>prctile(RD_shufs,99)];
    plot([a/size(animals,1)*5-0.2 a/size(animals,1)*5+0.2],[prctile(RD_shufs,99) prctile(RD_shufs,99)],'k--');
end
boxplot([s(1).s; s(2).s; s(3).s; s(4).s]','positions', [1.75 3.0 4.25 5.5],'Notch','on');
xlim([0 6]);
ylim([0 2.5]);
title('Singles/runs');

figure;histogram(s(1).s,'FaceColor',[0.1 0.1 0.1]);hold on;
plot([median(s(1).s) median(s(1).s)], [-10 180],'k--');
plot([prctile(s(1).s,99) prctile(s(1).s,99)], [-10 180],'c--');
plot([A(1)/Am(1) A(1)/Am(1)], [-0 120],'g--');
