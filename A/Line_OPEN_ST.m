function lineOPEN=Line_OPEN_ST(Optimal_path_ts,CLOSED,Num_obs,Num_Opt)
 n=Num_Opt;v=1;
 Optimal_path_st=[1 1 1 1];
   for q=1:1:Num_Opt
      Optimal_path_st(q,1)= Optimal_path_ts(n+1-q,3);
      Optimal_path_st(q,2)= Optimal_path_ts(n+1-q,4);
      Optimal_path_st(q,3)= Optimal_path_ts(n+1-q,1);
      Optimal_path_st(q,4)= Optimal_path_ts(n+1-q,2);
   end
  Optimal_path=Optimal_path_st;
  
  while (n>1)
        n=n-1;
        parent_node=[Optimal_path(v,1),Optimal_path(v,2)];  %%% 当前点的坐标
        parentP_node=[Optimal_path(v,3),Optimal_path(v,4)]; %%% 当前点子节点的坐标
        index=Optimal_index(Optimal_path,Optimal_path(v,3),Optimal_path(v,4));
        parentPP_node=[Optimal_path(index,3),Optimal_path(index,4)];  %%% 当前点的子节点的子节点坐标
        
        
       x_n1 = parentP_node(1,1) - parent_node(1,1) ;  %%向量1
       y_n1 = parentP_node(1,2) - parent_node(1,2) ;
       x_n2 = parentPP_node(1,1) - parentP_node(1,1) ;   %%向量2
       y_n2 = parentPP_node(1,2) - parentP_node(1,2) ;
        
        angle=myangle( x_n1,y_n1,x_n2,y_n2); %%%判断两个向量的夹角
   
        if angle==0         %%%夹角为0，说明在一条直线上，修改父节点
            Optimal_path(v,3) = Optimal_path(index,3);
            Optimal_path(v,4) = Optimal_path(index,4);
        else
            x1 = parent_node(1,1);    y1 = parent_node(1,2);
            x3 = parentPP_node(1,1);  y3 = parentPP_node(1,2);
            k = (y3-y1)/(x3-x1); b =y1-k*x1; %%两点之间直线方程 y=k*x+b
            x_min=min(x1,x3);  x_max=max(x1,x3);
            y_min=min(y1,y3);  y_max=max(y1,y3);
         
            f=0;
            for j=1:1:Num_obs
                x_obn=CLOSED(j,1); y_obn=CLOSED(j,2); %%判断障碍点是否在行驶区域内
                if (x_obn>=x_min && x_obn<=x_max && y_obn>=y_min && y_obn<=y_max)
                  yline=x_obn*k+b; D=1;
                  d=abs(y_obn-yline)*cos(atan(k));
                  if d<=D
                      f=1;
                  end
                  
                  
                  
%                   if y_obn>=(yline-1.2)&&y_obn<=(yline+1.2)
%                       f=1;
%                   end
%                   xline=(y_obn-b)/k;
%                   if x_obn>=(xline-1.2)&&x_obn<=(xline+1.2)
%                       f=1;
%                   end
                  
                end
            end
             
             if f==0                 %% f=0 表示两点之间无障碍物，修改父节点
                Optimal_path(v,3) = Optimal_path(index,3);
                Optimal_path(v,4) = Optimal_path(index,4);
             else                    %%% f/=0 表示两点之间有障碍物，不改变父节点 
                v=index;    %%%有障碍物，则设当前点变为父节点，
             end   
        end 
      
  end
    lineOPEN =  Optimal_path;









