function Tg=Target_node(dang_node,path,Obs_dong,xTarget,yTarget,goal,dis_x_du)
   num_path=size(path,1);
   num_Obs_dong=size(Obs_dong,1);
   n_index = Optimal_index(path,goal(1,1),goal(1,2));% 指出当前目标点在哪一行
   path_dis=[];
   distan_d_g = distance(dang_node(1,1),dang_node(1,2),goal(1,1),goal(1,2));
    
   
    
   for i=1:1:num_Obs_dong  % 计算目标点到动态障碍物的距离
        path_dis(i,1)=Obs_dong(i,1);
        path_dis(i,2)=Obs_dong(i,2);
        path_dis(i,3)=distance(goal(1,1),goal(1,2),Obs_dong(i,1),Obs_dong(i,2));
        %path_dis(i,4)=i;
   end
    [min_dis,temp_min]=min(path_dis(:,3)); 
    dis_d_minObs=distance(dang_node(1,1),dang_node(1,2),Obs_dong(temp_min,1),Obs_dong(temp_min,2));
    
    if n_index<num_path
       if distan_d_g<2 || ( min_dis<2&&dis_d_minObs<2) || dis_x_du<0.5
          Tg=[path(n_index+1,1) path(n_index+1,2)];
       else
          Tg = goal;
       end
    else
        Tg=[xTarget yTarget];
    end
    
    
%     for i=2:1:num_path
%         path_dis(i,1)=path(i,1);
%         path_dis(i,2)=path(i,2);
%         path_dis(i,3)=distance(dang_node(1,1),dang_node(1,2),path(i,1),path(i,2));
%         %path_dis(i,4)=i;
%     end
%     [min_dis,temp_min]=min(path_dis(:,3));
    %min_node=[path_dis(temp_min,1) path_dis(temp_min,2)];
%     hudu_n_min=sn_angle(dang_node(1,1),dang_node(1,2),path_dis(temp_min,1),path_dis(temp_min,2));
%     hudu_n_Target=sn_angle(dang_node(1,1),dang_node(1,2),path_dis(temp_min+1,1),path_dis(temp_min+1,2));
%     hu=abs(hudu_n_min-hudu_n_Target);
%     if min_dis>2&&hu<pi/2
%         g=[path_dis(temp_min,1) path_dis(temp_min,2)];
%         ind=temp_min;
%     else
%         if temp_min<num_path
%            g=[path_dis(temp_min+1,1) path_dis(temp_min+1,2)];
%            ind=temp_min+1;
%         else
%            g=[xTarget yTarget];
%         end
%     end
%     num_obs_dong=size(Obs_dong,1);
%     fa=0;
%     for t=1:1:num_obs_dong
%         %dis_on=distance(Obs_dong(t,1),Obs_dong(t,2),g(1,1),g(1,2));
%         if abs(g(1,1)-Obs_dong(t,1))<0.8&&abs(g(1,2)-Obs_dong(t,2))<0.8
%             fa=fa+1;
%         end
%     end
%     if fa==0
%        Tg=g;
%     else
%         if ind<num_path
%            Tg=[path_dis(ind+1,1) path_dis(ind+1,2)];
%         else
%             Tg=[xTarget yTarget];
%         end
%            
%     end
    


