function P_obs=Obs_array(node_x,node_y,xTarget,yTarget,CLOSED,Nobs) % , P_tong

  x_min=min(node_x,xTarget)-0.8;  x_max=max(node_x,xTarget)+0.8;
  y_min=min(node_y,yTarget)-0.8;  y_max=max(node_y,yTarget)+0.8; 
  N_x=abs( node_x - xTarget )+1;
  N_y=abs( node_y - yTarget )+1;
  node_obs=0;
   for a=1:1:Nobs
      x_obn=CLOSED(a,1); y_obn=CLOSED(a,2); %% 判断障碍点是否在行驶区域内
       if (x_obn>=x_min && x_obn<=x_max && y_obn>=y_min && y_obn<=y_max)
         node_obs=node_obs+1;  
       end
   end   
  if  node_obs~=0
      P_obs = node_obs/(N_x*N_y);
  else
      P_obs=0;
  end
%    num_i=0;
% 
%  
% for i=(x_min+0.8):1:(x_max-0.8)
%     f=0; 
%     for n=1:1:Nobs
%        if CLOSED(n,1)==i
%            f=f+1;
%        end  
%     end
%  
%     if f==0
%      num_i=num_i+1 ;
%     end
% end
% 
% 
% for j=(y_min+0.8):1:(y_max-0.8)
%     t=0;
%     for n=1:1:Nobs
%      if CLOSED(n,2)==j
%         t=t+1;
%      end
%     end
%     
%     if t==0
%      num_i=num_i+1;  
%     end
% end
% if  num_i~=0
%       P_tong=num_i/(N_x+N_y);
% else
%       P_tong=0;
% end

