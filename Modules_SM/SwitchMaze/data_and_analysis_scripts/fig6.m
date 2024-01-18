
close all;clear all;
n_shuffles=1000;

load('SM_Hartmann2023_biorxiv_data.mat', 'session_PFCdreadd_Sal_fig6_fig7_fig8')
binned=session_PFCdreadd_Sal_fig6_fig7_fig8.binned;
binned_exp=session_PFCdreadd_Sal_fig6_fig7_fig8.binned_exp;
session=session_PFCdreadd_Sal_fig6_fig7_fig8.session;

%% get chance estimate
tic
for a=1:size(session,2)
    session(a).shuffles.Etypes=[];
    session(a).shuffles.E=[];
    for shuf=1:n_shuffles
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
        session(a).shuffles(shuf).E(list(a).list)=[];
        session(a).shuffles(shuf).feeding_length=list(a).feeding_length;
        % end correction
    end
    % shuffels made, count average SI across shuffles
    for shuf=1:size(session(a).shuffles,2)
        S(a,shuf)=length(find(session(a).shuffles(shuf).E==1));
        Sm(a,shuf)=length(find(session(a).shuffles(shuf).E>1)); 
    end
    session(a).SI_shuf_med=median(S(a,:)./Sm(a,:),2);
    session(a).SI_shuf_99=prctile((S(a,:)./Sm(a,:)),99);
end
toc

%% 
for an=1:size(session,2)
    list(an).list=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
    end
    session(an).E(list(an).list)=[];
end
s_PFC_bsl=session;
% s_bsl=binned_exp;

load('SM_Hartmann2023_biorxiv_data.mat', 'session_PFCdreadd_C21_fig6_fig7_fig8')
binned=session_PFCdreadd_C21_fig6_fig7_fig8.binned;
binned_exp=session_PFCdreadd_C21_fig6_fig7_fig8.binned_exp;
session=session_PFCdreadd_C21_fig6_fig7_fig8.session;
%% get chance estimate
tic
for a=1:size(session,2)
    session(a).shuffles.Etypes=[];
    session(a).shuffles.E=[];
    for shuf=1:n_shuffles
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
        session(a).shuffles(shuf).E(list(a).list)=[];
        session(a).shuffles(shuf).feeding_length=list(a).feeding_length;
        % end correction
    end
    % shuffels made, count average SI across shuffles
    for shuf=1:size(session(a).shuffles,2)
        S(a,shuf)=length(find(session(a).shuffles(shuf).E==1));
        Sm(a,shuf)=length(find(session(a).shuffles(shuf).E>1)); 
    end
    session(a).SI_shuf_med=median(S(a,:)./Sm(a,:),2);
    session(a).SI_shuf_99=prctile((S(a,:)./Sm(a,:)),99);
end
toc
for an=1:size(session,2)
    list(an).list=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
    end
    session(an).E(list(an).list)=[];
end
s_PFC_C21=session;
% s_C21=binned_exp;
for a=1:size(s_PFC_bsl,2)
    A(a)=length(find(s_PFC_bsl(a).E==1));
    B(a)=length(find(s_PFC_C21(a).E==1));
    Am(a)=length(find(s_PFC_bsl(a).E>1));
    Bm(a)=length(find(s_PFC_C21(a).E>1));
end

load('SM_Hartmann2023_biorxiv_data.mat', 'session_ctrl_Sal_fig6')
binned=session_ctrl_Sal_fig6.binned;
binned_exp=session_ctrl_Sal_fig6.binned_exp;
session=session_ctrl_Sal_fig6.session;
%% get chance estimate
tic
for a=1:size(session,2)
    session(a).shuffles.Etypes=[];
    session(a).shuffles.E=[];
    for shuf=1:n_shuffles
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
        session(a).shuffles(shuf).E(list(a).list)=[];
        session(a).shuffles(shuf).feeding_length=list(a).feeding_length;
        % end correction
    end
    % shuffels made, count average SI across shuffles
    for shuf=1:size(session(a).shuffles,2)
        S(a,shuf)=length(find(session(a).shuffles(shuf).E==1));
        Sm(a,shuf)=length(find(session(a).shuffles(shuf).E>1)); 
    end
    session(a).SI_shuf_med=median(S(a,:)./Sm(a,:),2);
    session(a).SI_shuf_99=prctile((S(a,:)./Sm(a,:)),99);
end
toc
for an=1:size(session,2)
    list(an).list=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
    end
    session(an).E(list(an).list)=[];
end
s_CTRL_bsl=session;
% s_bsl=binned_exp;
load('SM_Hartmann2023_biorxiv_data.mat', 'session_ctrl_C21_fig6')
binned=session_ctrl_C21_fig6.binned;
binned_exp=session_ctrl_C21_fig6.binned_exp;
session=session_ctrl_C21_fig6.session;
%% get chance estimate
tic
for a=1:size(session,2)
    session(a).shuffles.Etypes=[];
    session(a).shuffles.E=[];
    for shuf=1:n_shuffles
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
        session(a).shuffles(shuf).E(list(a).list)=[];
        session(a).shuffles(shuf).feeding_length=list(a).feeding_length;
        % end correction
    end
    % shuffels made, count average SI across shuffles
    for shuf=1:size(session(a).shuffles,2)
        S(a,shuf)=length(find(session(a).shuffles(shuf).E==1));
        Sm(a,shuf)=length(find(session(a).shuffles(shuf).E>1)); 
    end
    session(a).SI_shuf_med=median(S(a,:)./Sm(a,:),2);
    session(a).SI_shuf_99=prctile((S(a,:)./Sm(a,:)),99);
end
toc
for an=1:size(session,2)
    list(an).list=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
    end
    session(an).E(list(an).list)=[];
end
s_CTRL_C21=session;
% s_C21=binned_exp;for a=1:size(s_bsl,2)
for a=1:size(s_CTRL_bsl,2)
    C(a)=length(find(s_CTRL_bsl(a).E==1));
    D(a)=length(find(s_CTRL_C21(a).E==1));
    Cm(a)=length(find(s_CTRL_bsl(a).E>1));
    Dm(a)=length(find(s_CTRL_C21(a).E>1));
end

load('SM_Hartmann2023_biorxiv_data.mat', 'session_LHdreadd_Sal_fig6')
binned=session_LHdreadd_Sal_fig6.binned;
binned_exp=session_LHdreadd_Sal_fig6.binned_exp;
session=session_LHdreadd_Sal_fig6.session;
%% get chance estimate
tic
for a=1:size(session,2)
    session(a).shuffles.Etypes=[];
    session(a).shuffles.E=[];
    for shuf=1:n_shuffles
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
        session(a).shuffles(shuf).E(list(a).list)=[];
        session(a).shuffles(shuf).feeding_length=list(a).feeding_length;
        % end correction
    end
    % shuffels made, count average SI across shuffles
    for shuf=1:size(session(a).shuffles,2)
        S(a,shuf)=length(find(session(a).shuffles(shuf).E==1));
        Sm(a,shuf)=length(find(session(a).shuffles(shuf).E>1)); 
    end
    session(a).SI_shuf_med=median(S(a,:)./Sm(a,:),2);
    session(a).SI_shuf_99=prctile((S(a,:)./Sm(a,:)),99);
end
toc
for an=1:size(session,2)
    list(an).list=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
    end
    session(an).E(list(an).list)=[];
end
s_LH_bsl=session;
% s_bsl=binned_exp;
load('SM_Hartmann2023_biorxiv_data.mat', 'session_LHdreadd_C21_fig6')
binned=session_LHdreadd_C21_fig6.binned;
binned_exp=session_LHdreadd_C21_fig6.binned_exp;
session=session_LHdreadd_C21_fig6.session;
%% get chance estimate
tic
for a=1:size(session,2)
    session(a).shuffles.Etypes=[];
    session(a).shuffles.E=[];
    for shuf=1:n_shuffles
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
        session(a).shuffles(shuf).E(list(a).list)=[];
        session(a).shuffles(shuf).feeding_length=list(a).feeding_length;
        % end correction
    end
    % shuffels made, count average SI across shuffles
    for shuf=1:size(session(a).shuffles,2)
        S(a,shuf)=length(find(session(a).shuffles(shuf).E==1));
        Sm(a,shuf)=length(find(session(a).shuffles(shuf).E>1)); 
    end
    session(a).SI_shuf_med=median(S(a,:)./Sm(a,:),2);
    session(a).SI_shuf_99=prctile((S(a,:)./Sm(a,:)),99);
end
toc
for an=1:size(session,2)
    list(an).list=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
    end
    session(an).E(list(an).list)=[];
end
s_LH_C21=session;
% s_C21=binned_exp;
for a=1:size(s_LH_bsl,2)
    E(a)=length(find(s_LH_bsl(a).E==1));
    F(a)=length(find(s_LH_C21(a).E==1));
    Em(a)=length(find(s_LH_bsl(a).E>1));
    Fm(a)=length(find(s_LH_C21(a).E>1));
end

%%
% close all;
figure;
j=0;%counter for above stochastic limit
k=0;
bsl_above=0;
C21_above=0;
eb=std([A./Am; B./Bm],0,2);
h=subplot(2,3,1),errorbar(mean([A./Am; B./Bm],2),eb,'k+');hold on;
ax(1)=subplot(2,3,1),bar([1 2],mean([A./Am; B./Bm],2),0.5,'r');hold on;
plot([0.7 1.3],[mean(cat(1,s_PFC_bsl.SI_shuf_med)) mean(cat(1,s_PFC_bsl.SI_shuf_med))],'k--');
plot([0.7 1.3],[mean(cat(1,s_PFC_bsl.SI_shuf_99)) mean(cat(1,s_PFC_bsl.SI_shuf_99))],'k--');
plot([1.7 2.3],[mean(cat(1,s_PFC_C21.SI_shuf_med)) mean(cat(1,s_PFC_C21.SI_shuf_med))],'k--');
plot([1.7 2.3],[mean(cat(1,s_PFC_C21.SI_shuf_99)) mean(cat(1,s_PFC_C21.SI_shuf_99))],'k--');
% set(get(ax(1),'Children'),'FaceAlpha',0.2);
% errorbar([1 2],mean([A./Am; B./Bm],2),std([A./Am; B./Bm],0,2),'r','LineStyle','none');
plot([1.1 1.8],[A./Am; B./Bm],'k');
for a=1:size(A,2)
   if A(a)/Am(a)>s_PFC_bsl(a).SI_shuf_99
       plot(1.1,A(a)/Am(a),'mo');
       j=j+1;bsl_above=bsl_above+1;
   end
   if B(a)/Bm(a)>s_PFC_C21(a).SI_shuf_99
       plot(1.8,B(a)/Bm(a),'mo');
       C21_above=C21_above+1;
   end
   if A(a)/Am(a)>s_PFC_bsl(a).SI_shuf_med
       k=k+1;
   end
end
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('PFC dreadd');
[H(1) P(1)]=ttest(A./Am, B./Bm)
change_percent=mean(((B./Bm)-(A./Am))./(A./Am))
change_sd=std(((B./Bm)-(A./Am))./(A./Am),0,2)
subplot(2,3,4),bar([bsl_above/size(A,2) 1-bsl_above/size(A,2); C21_above/size(A,2) 1-C21_above/size(A,2)],0.5,'stacked');
xlim([0.5 2.5]);

session=s_LH_C21;
bsl_above=0;
C21_above=0;
S=[];
for a=1:size(session,2);
    for shuf=1:size(session(a).shuffles,2)
        S=[S cat(2,session(a).shuffles(shuf).E)];
    end
end
X=cat(2,session.E);
[P1 H1]=ranksum(S,X)

eb=std([C./Cm; D./Dm],0,2);
h=subplot(2,3,2),errorbar(mean([C./Cm; D./Dm],2),eb,'k+');hold on;
ax(2)=subplot(2,3,2),bar([1 2],mean([C./Cm; D./Dm],2),0.5,'k');hold on;
plot([0.7 1.3],[mean(cat(1,s_CTRL_bsl.SI_shuf_med)) mean(cat(1,s_CTRL_bsl.SI_shuf_med))],'k--');
plot([0.7 1.3],[mean(cat(1,s_CTRL_bsl.SI_shuf_99)) mean(cat(1,s_CTRL_bsl.SI_shuf_99))],'k--');
plot([1.7 2.3],[mean(cat(1,s_CTRL_C21.SI_shuf_med)) mean(cat(1,s_CTRL_C21.SI_shuf_med))],'k--');
plot([1.7 2.3],[mean(cat(1,s_CTRL_C21.SI_shuf_99)) mean(cat(1,s_CTRL_C21.SI_shuf_99))],'k--');
% set(get(ax(2),'Children'),'FaceAlpha',0.2);
plot([1.1 1.8],[C./Cm; D./Dm],'k');
for a=1:size(C,2)
   if C(a)/Cm(a)>s_CTRL_bsl(a).SI_shuf_99
       plot(1.1,C(a)/Cm(a),'mo');
       j=j+1;bsl_above=bsl_above+1;
   end
   if D(a)/Dm(a)>s_CTRL_C21(a).SI_shuf_99
       plot(1.8,D(a)/Dm(a),'mo');
       C21_above=C21_above+1;
   end
    if C(a)/Cm(a)>s_CTRL_bsl(a).SI_shuf_med
       k=k+1;
   end
end
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('ctrl');
[H(2) P(2)]=ttest(C./Cm, D./Dm)
subplot(2,3,5),bar([bsl_above/size(C,2) 1-bsl_above/size(C,2); C21_above/size(C,2) 1-C21_above/size(C,2)],0.5,'stacked');
xlim([0.5 2.5]);

bsl_above=0;
C21_above=0;
eb=std([E./Em; F./Fm],0,2);
h=subplot(2,3,3),errorbar(mean([E./Em; F./Fm],2),eb,'k+');hold on;
ax(3)=subplot(2,3,3),bar([1 2],mean([E./Em; F./Fm],2),0.5,'b');hold on;
plot([0.7 1.3],[mean(cat(1,s_LH_bsl.SI_shuf_med)) mean(cat(1,s_LH_bsl.SI_shuf_med))],'k--');
plot([0.7 1.3],[mean(cat(1,s_LH_bsl.SI_shuf_99)) mean(cat(1,s_LH_bsl.SI_shuf_99))],'k--');
plot([1.7 2.3],[mean(cat(1,s_LH_C21.SI_shuf_med)) mean(cat(1,s_LH_C21.SI_shuf_med))],'k--');
plot([1.7 2.3],[mean(cat(1,s_LH_C21.SI_shuf_99)) mean(cat(1,s_LH_C21.SI_shuf_99))],'k--');
% set(get(ax(3),'Children'),'FaceAlpha',0.2);
plot([1.1 1.8],[E./Em; F./Fm],'K');
for a=1:size(E,2)
   if E(a)/Em(a)>s_LH_bsl(a).SI_shuf_99
       plot(1.1,E(a)/Em(a),'mo');
       j=j+1;bsl_above=bsl_above+1;
   end
   if F(a)/Fm(a)>s_LH_C21(a).SI_shuf_99
       plot(1.8,F(a)/Fm(a),'mo');
       C21_above=C21_above+1;
   end
   if E(a)/Em(a)>s_LH_bsl(a).SI_shuf_med
       k=k+1;
   end
end
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('LH dreadd');
[H(3) P(3)]=ttest(E./Em, F./Fm)
linkaxes(ax);
subplot(2,3,6),bar([bsl_above/size(E,2) 1-bsl_above/size(E,2); C21_above/size(E,2) 1-C21_above/size(E,2)],0.5,'stacked');
xlim([0.5 2.5]);

sgtitle('ratio of 1-trial to >1 trial runs');

%stats
%make table
Subject=['d' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l']';
t=table(Subject,[A./Am C./Cm E./Em]',[B./Bm D./Dm F./Fm]','VariableNames',{'Subject','bsl','C21'});
t=table(Subject,[A./Am C./Cm E./Em]',[B./Bm D./Dm F./Fm]','VariableNames',{'Subject','bsl','C21'});
%define within-subjects variable
condition=[1 2]';
%fit a repeated measures model where parameter is the response and subject
%type is the predictor variable
rm=fitrm(t,'bsl-C21 ~ Subject','WithinDesign',condition);
%perform repeated measures analysis of variance
ranovatbl=ranova(rm)

%summary stats
mean_Switchrate=mean([A./Am C./Cm E./Em])
std_Switchrate=std([A./Am C./Cm E./Em],0,2)
how_many_above_99th=j
how_many_below_99th=size([A./Am C./Cm E./Em],2)-j
how_many_above_med=k

%ttests
'ttest results'
H
P
