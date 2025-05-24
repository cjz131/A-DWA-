function lineOPEN=Line_OPEN_STtwo(Optimal_path,CLOSED,Num_obs,num_op)
     i_t=1;
      v=2;   %% Optimal_path 路径节点 
     line_open_t(1,1)=Optimal_path(1,1); %%%%line_open_t 新的路径节点
     line_open_t(1,2)=Optimal_path(1,2);
   
     while v <  num_op 
       
        p_node=[line_open_t(i_t,1),line_open_t(i_t,2)];  %%% 当前点的坐标
        p_node_1=[Optimal_path(v,1),Optimal_path(v,2)]; %%% 当前点子节点的坐标
        p_node_2=[Optimal_path(v+1,1),Optimal_path(v+1,2)] ; %%% 当前点的子节点的子节点坐标
       % p_node_3=[Optimal_path(v+3,1),Optimal_path(v+3,2)];  %%% 当前点的子节点的子节点的子节点坐标
        v=v+1;
       % line_node1=LINE(p_node_2,p_node_3); %%%%%把2,3两节点之间连线上的节点求出来
        line_node=LINE(p_node_1,p_node_2); %%%%%把1,2两节点之间连线上的节点求出来
        
       % line_node=[line_node1;line_node2]; %%%%%%求出的节点组合`
%         i_l=0;
        num_ln=size(line_node,1);
        p_x=p_node(1,1);
        p_y=p_node(1,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%判断当前点和线段上的节点之间是否有障碍物 
      fn=0;f=1;
      for j=num_ln:-1:1
            l_x=line_node(j,1); l_y=line_node(j,2); 
           
            x_min=min(p_x,l_x)-0.8;  x_max=max(p_x,l_x)+0.8;
            y_min=min(p_y,l_y)-0.8;  y_max=max(p_y,l_y)+0.8; 
            k = (l_y-p_y)/(l_x-p_x); b =p_y-k*p_x; %%两点之间直线方程 y=k*x+b
           
            for a=1:1:Num_obs
                x_obn=CLOSED(a,1); y_obn=CLOSED(a,2); %%判断障碍点是否在行驶区域内
                if (x_obn>=x_min && x_obn<=x_max && y_obn>=y_min && y_obn<=y_max)
                  yline=x_obn*k+b; D=1;
                  
                  d=abs(y_obn-yline)*cos(atan(k));
                  if d<=D
                      f=0; %%%两点之间有障碍物
                  
                  end
                end
            end   
            
            if f==1
               node_l(2,1)=l_x;
               node_l(2,2)=l_y;  
               fn=1; %%判断有可连接点
            end
          
      end
%%%%%%%%%%%%%%%%%%%%%%%%%%将可连接的第一个点存储到新的路径中，并做当前点        
        i_t=i_t+1;

        if fn==1
           line_open_t(i_t,1)=node_l(2,1);
           line_open_t(i_t,2)=node_l(2,2);
           if  node_l(2,1)==line_node(1,1)&&node_l(2,2)==line_node(1,2)
               v=v+1;
           end
        else
           line_open_t(i_t,1)=p_node_1(1,1);
           line_open_t(i_t,2)=p_node_1(1,2);
        end
        
     end
     lineOPEN=line_open_t;
      
        
        
        
        
        
        
        
        
        
        
        
        


