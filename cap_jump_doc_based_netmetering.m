function [S_out] = cap_jump_doc_based_netmetering(i,mu)

global p_elec h P_cons alpha_mat e_ch e_dis del_max del_min 

alpha= alpha_mat(i);
p_smaller=p_elec(i)*alpha;
p_higher=p_elec(i);

e_round =e_ch*e_dis;
z=P_cons(i);
S_min = h*del_min*e_dis; %Power seen outside battery DISCHARGING
S_max = h*del_max/e_ch; %Need This power CHARGING

if p_smaller == p_higher && e_dis==1 && e_ch ==1
    case_def=1;
elseif p_smaller == p_higher && e_dis< 1 && e_ch < 1
    case_def=2;
elseif p_smaller < p_higher && e_dis<1 && e_ch <1
    if alpha < e_round
        case_def =3;
    elseif alpha > e_round
        case_def=4;
    elseif alpha == e_round
        case_def=5;
    end
end


if case_def == 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASE 1 %%%%%%%%%%%%%%%%%%%%
    % CASE 1
    if mu < p_smaller*e_dis
        L=[S_min S_min];
    elseif mu == p_smaller*e_dis
        L=[S_min S_max];
    elseif mu > p_higher/e_ch
        L=[S_max S_max];
    end
    
    
    
elseif case_def == 2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASE 2 %%%%%%%%%%%%%
    if mu < p_smaller*e_dis
        L=[S_min S_min];
    elseif mu == p_smaller*e_dis
        L=[S_min 0];
    elseif mu > p_smaller*e_dis && mu < p_higher/e_ch
        L=[0 0];
    elseif mu == p_higher/e_ch
        L=[0 S_max];
    elseif mu > p_higher/e_ch
        L=[S_max S_max];        
    end
    
    
    
    
 
    
    
    
    
    
elseif case_def == 3
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASE 3 %%%%%%%%%%%%%%%%%%%%   
    if mu < p_smaller*e_dis
        L=[S_min S_min];
    elseif mu == p_smaller*e_dis
        if z >= 0
            L=[S_min (max(-z,S_min))];
        else
            L=[S_min 0];
        end
    elseif mu > p_smaller*e_dis && mu < p_smaller/e_ch
        if z >= 0
            L=[max(-z, S_min) max(-z, S_min)];
        else
            L=[0 0];
        end
    elseif mu == p_smaller/e_ch
        if z >= 0
            L=[max(-z, S_min) max(-z, S_min)];    
        else
            L=[0 min(-z, S_max)];
        end
    elseif mu > p_smaller/e_ch && mu < p_higher*e_dis
        if z >= 0
            L=[max(-z, S_min) max(-z, S_min)];
        else
            L=[min(-z, S_max) min(-z, S_max)];
        end
    elseif mu == p_higher*e_dis
        if z >= 0
            L=[max(-z, S_min) 0];
        else
            L=[min(-z, S_max) min(-z, S_max)];
        end
    elseif mu > p_higher*e_dis && mu < p_higher/e_ch
        if z >= 0
            L=[0 0];
        else
            L=[min(-z, S_max) min(-z, S_max)];
        end
    elseif mu==p_higher/e_ch
        if z >= 0
            L=[0 S_max];
        else
            L=[(min(-z,S_max)) S_max];
        end
    elseif mu > p_higher/e_ch
        L=[S_max S_max];
    end
    
    
    
    
    
elseif case_def == 4
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASE 4 %%%%%%%%%%%%%%%%%%%%%%%
    if mu < p_smaller*e_dis
        L=[S_min S_min];
    elseif mu == p_smaller*e_dis
        if z >= 0
            L=[S_min (max(-z,S_min))];
        else
            L=[S_min 0];
        end
    elseif mu > p_smaller*e_dis && mu < p_higher*e_dis
        if z >= 0
            L=[max(-z,S_min) max(-z,S_min)];
        else
            L=[0 0];
        end
    elseif mu == p_higher*e_dis
        if z >= 0
            L=[max(-z,S_min) 0];
        else
            L=[0 0];
        end
    elseif mu < p_smaller/e_ch && mu > p_higher*e_dis
        L=[0 0];
        
    elseif mu == p_smaller/e_ch
        if z >= 0
            L=[0 0];
        else
            L=[0 min(-z,S_max)];
        end
    elseif mu > p_smaller/e_ch && mu < p_higher/e_ch
        if z >= 0
            L=[0,0];
        else
            L=[min(-z,S_max) min(-z,S_max)];
        end
    elseif mu==p_higher/e_ch
        if z >= 0
            L=[0 S_max];
        else
            L=[min(-z,S_max) S_max];
        end
    elseif mu > p_higher/e_ch
        L=[S_max S_max];
    end
    
    
    
    
    
    
    
    
    
    
elseif case_def == 5
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASE 5 %%%%%%%%%%%%%%%%%%%%%%%
    if mu < p_smaller*e_dis
        L=[S_min S_min];
    elseif mu == p_smaller*e_dis
        if z >= 0
            L=[S_min (max(-z,S_min))];
        else
            L=[S_min 0];
        end
    elseif mu > p_smaller*e_dis && mu < p_higher*e_dis
        if z >= 0
            L=[max(-z,S_min) max(-z,S_min)];
        else
            L=[0 0];
        end
    elseif mu == p_higher*e_dis
        if z >= 0
            L=[max(-z,S_min) 0];
        else
            L=[0 min(-z,S_max)];
        end
    elseif mu > p_higher*e_dis && mu < p_higher/e_ch
        if z >= 0
            L=[0,0];
        else
            L=[min(-z,S_max) min(-z,S_max)];
        end
    elseif mu==p_higher/e_ch
        if z >= 0
            L=[0 S_max];
        else
            L=[min(-z,S_max) S_max];
        end
    elseif mu > p_higher/e_ch
        L=[S_max S_max];
    end    


end

S_out=L;













