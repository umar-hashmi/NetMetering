clear 
close all
format long;

lt=load('complexityanalysisLOAD.mat');
pt=load('complexityanalysisPRICE.mat');
index=800;
load=lt.load(1:index,1);
real=pt.real(1:index,1);


tic
global p_elec h P_cons alpha_mat e_ch e_dis del_max del_min

% epsilon_j = 0.1*rand(96,1);


e_ch=0.9;
e_dis =0.9;
del_max = 1000;
del_min = -del_max;
B_0 = 500;
B_max = 3000;
B_min = 100;
h=1;


e_round =e_ch*e_dis;

p_elec=real;
alpha =0.5;
alpha_mat = 0.5*ones(length(real),1);

P_cons =load;

mu=0;
n=0;
breakpt =0; j=1;
N=length(p_elec);
j_memory =0;
b_0= [B_0 B_0];
b=zeros(N,2);
b_opt=zeros(N,1);

while (1)
    
    for i=n+1:N             
        X = efficiency_correction(cap_jump_doc_based_netmetering(i,mu));
        if i==1
            b(i,:)= b_0  + X;
        elseif i==n+1
            b(i,:)= b_opt(n,1) + X;
        else
            b(i,:)= b(i-1,:) + X;
        end       
        b(i,:)=[max(b(i,1),B_min) min(b(i,2),B_max)];        
        if b(i,2)<b(i,1) || (i==N && b(i,1) > B_min && mu>0)
            j = i;
            breakpt=1;
            break;
        else
            breakpt=0;
        end        
    end
    
    if breakpt == 1        
        if b(j,2) < B_min                      %% Breaking the lower boundary increase mu           
            if j >= j_memory                
                mu_memory=mu;
                q_mat= [p_elec(n+1:j).*alpha_mat(n+1:j)*e_dis;p_elec(n+1:j).*alpha_mat(n+1:j)/e_ch; p_elec(n+1:j)*e_dis; p_elec(n+1:j)/e_ch];
                q_mat= sort(q_mat);
                for i=1:length(q_mat)
                    if q_mat(i) > mu
                        mu= q_mat(i);
                        break
                    end
                end           
            elseif j < j_memory                
                mu=mu_memory;
                for i=n+1:j_memory
                    X = efficiency_correction(cap_jump_doc_based_netmetering(i,mu));
                    if i==1
                        b(i,:)= b_0 + X;
                    elseif i==n+1
                        b(i,:)= b_opt(n,1) + X;
                    else
                        b(i,:)= b(i-1,:) + X;
                    end
                    b(i,:)=[max(b(i,1),B_min) min(b(i,2),B_max)];
                    if min(b(i,:)) == B_min
                        n_temp=i;
                    end
                end
                                
                k=n_temp;
                b_opt(k,1)=B_min;
                mu_mat(n+1:k,1) = mu;
                
                while k >= n+2                    
                    temp=b_opt(k,1)-efficiency_correction(cap_jump_doc_based_netmetering(k,mu));
                    if temp(1)==temp(2)
                        b_opt(k-1,1)=temp(1);
                    else
                        temp=[max(min(temp),min(b(k-1,:))) min(max(temp),max(b(k-1,:)))];
                        b_opt(k-1,1)=(temp(1)+temp(2))/2;
                    end
                    k=k-1;
                end
                n=n_temp;
            end
                                   
        elseif b(j,1) > B_max                      %% Breaking the upper boundary decrease mu     
%             b(j,1) > B_max
%             b(j,1)
            if j >= j_memory
                mu_memory=mu;
                q_mat= [p_elec(n+1:j).*alpha_mat(n+1:j)*e_dis;p_elec(n+1:j).*alpha_mat(n+1:j)/e_ch; p_elec(n+1:j)*e_dis; p_elec(n+1:j)/e_ch];
                q_mat= sort(q_mat,'descend');
                for i=1:length(q_mat)
                    if q_mat(i) < mu
                        mu= q_mat(i);
                        break
                    end
                end           
            elseif j < j_memory                
                mu=mu_memory;
                for i=n+1:j_memory
                    X = efficiency_correction(cap_jump_doc_based_netmetering(i,mu));
                    if i==1
                        b(i,:)= b_0 + X;
                    elseif i==n+1
                        b(i,:)= b_opt(n,1) + X;
                    else
                        b(i,:)= b(i-1,:) + X;
                    end
                    b(i,:)=[max(b(i,1),B_min) min(b(i,2),B_max)];
                    if max(b(i,:)) == B_max
                        n_temp=i;
                    end
                end               
                k=n_temp;
                b_opt(k,1)=B_max;
                mu_mat(n+1:k,1) = mu;
                
                while k >= n+2                    
                    temp=b_opt(k,1)-efficiency_correction(cap_jump_doc_based_netmetering(k,mu));
                    if temp(1)==temp(2)
                        b_opt(k-1,1)=temp(1);
                    else
                        temp=[max(min(temp),min(b(k-1,:))) min(max(temp),max(b(k-1,:)))]; 
                        b_opt(k-1,1)=(temp(1)+temp(2))/2;
                    end
                    k=k-1;
                end
                n=n_temp;
            end
            
        elseif j==N && b(j,1) > B_min && mu>0          %% breaking the last constraint decrease mu            
            mu_memory=mu;
            q_mat= [p_elec(n+1:j).*alpha_mat(n+1:j)*e_dis;p_elec(n+1:j).*alpha_mat(n+1:j)/e_ch; p_elec(n+1:j)*e_dis; p_elec(n+1:j)/e_ch];
            q_mat= sort(q_mat,'descend');
            for i=1:length(q_mat)
                if q_mat(i) < mu
                    mu= q_mat(i);
                    break
                end
            end                       
        end
        
        j_memory = j;         
        
    
    elseif breakpt == 0        
        if mu > 0
            b_opt(N,1)=B_min;
            mu_mat(n+1:N,1)=mu;
            k=N;
            while k >= n+2
                temp=b_opt(k,1)-efficiency_correction(cap_jump_doc_based_netmetering(k,mu));
                temp=[max(min(temp),min(b(k-1,:))) min(max(temp),max(b(k-1,:)))];
                if temp(1)==temp(2)
                        b_opt(k-1,1)=temp(1);
                else
                    temp=[max(min(temp),min(b(k-1,:))) min(max(temp),max(b(k-1,:)))];

                    b_opt(k-1,1)=(temp(2)+2*temp(2))/3;
                end
                k=k-1;
            end
        elseif mu==0
            for i=n+1:N
                X = efficiency_correction(cap_jump_doc_based_netmetering(i,mu));
                if i==1
                    b(i,:)= b_0 + X;
                elseif i==n+1
                    b(i,:)= b_opt(n,1) + X;
                else
                    b(i,:)= b(i-1,:) + X;
                end
                b_opt(i,1) = max(b(i,1), B_min);
                mu_mat(i,1) = mu;
            end
        end
        break;
    end
    
    breakpt=0;
    
end
toc
t(1,1)=0;

x_adj=[b_opt-[B_0; b_opt(1:end-1)]];



x2=b_opt-[B_0; b_opt(1:end-1)];

x_ch = max(0,x2);
x_ds = -min(0,x2);


cost_of_consumption_nominal = sum(real'*subplus(load)-alpha*real'*subplus(-load))/1000

lhouse = load+x_ch/e_ch - x_ds*e_dis;

profit_only_arbitrage =  cost_of_consumption_nominal - ((real'*subplus(lhouse) - alpha*real'*subplus(-lhouse)))/1000


