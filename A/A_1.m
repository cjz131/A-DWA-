%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 
% 
% ��ͳA*�㷨
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%ֻ�����������ξ����к�����ȣ�������תʱ����ִ���
function Optimal_path=A_1(MAX,xStart,yStart,xTarget,yTarget,CLOSED,hui)
figure

MAX_X=size(MAX,2);                                %%%  ��ȡ��������x�᳤��
MAX_Y=size(MAX,1);                                %%%  ��ȡ��������y�᳤��
axis([1 MAX_X+1, 1 MAX_Y+1])                %%%  ����x��y��������
set(gca,'xtick',1:1:MAX_X+1,'ytick',1:1:MAX_Y+1,'GridLineStyle','-',... 
    'xGrid','on','yGrid','on')
grid on;                                   %%%  �ڻ�ͼ��ʱ�����������
hold on;                                   %%%  ��ǰ�ἰͼ�񱣳ֶ�����ˢ�£�׼�����ܴ˺󽫻��Ƶ�ͼ�Σ���ͼ����
% 


for j=1:MAX_X
    for i=1:MAX_Y
        if (MAX(i,j)==1)
          %%plot(i+.5,j+.5,'ks','MarkerFaceColor','b'); ԭ���Ǻ��Բ��ʾ
          fill([i,i+1,i+1,i],[j,j,j+1,j+1],'k');  %%%�ĳ� �úڷ�������ʾ�ϰ���
          
        end
    end
end

tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LISTS USED FOR ALGORITHM %%%�����㷨���б�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%OPEN LIST STRUCTURE  %%%�����б�ṹ
%--------------------------------------------------------------------------
%IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
%--------------------------------------------------------------------------
OPEN=[];
%CLOSED LIST STRUCTURE %%% ��յ��б�ṹ
%--------------
%X val | Y val |
%--------------
% CLOSED=zeros(MAX_VAL,2); %%% ����MAX_VAL�У�2�е�0����
CLOSED_COUNT=size(CLOSED,1);   %%% CLOSED�����������ϰ���ĸ��� 
xNode=xStart;      %%% =xStart
yNode=yStart;      %%% =yStart
OPEN_COUNT=1;    %%% OPEN_COUNT �����б��������־
path_cost=0;
goal_distance=distance(xNode,yNode,xTarget,yTarget);                                                                                    %%%  ***����distance�������������������֮��ĵѿ�������

OPEN(OPEN_COUNT,:)=insert_open(xNode,yNode,xNode,yNode,path_cost,goal_distance,goal_distance);  %%%   ���뵽�����б�
                            %%%        OPEN����һ�е�Ԫ�أ�=��1��xNode,yNode,xNode,yNode,path_cost,goal_distance,goal_distanc����
OPEN(OPEN_COUNT,1)=0;      %%%   OPEN(1,1)=0
CLOSED_COUNT=CLOSED_COUNT+1;  %%%   CLOSED �洢���ϰ������һ����Ԫ
CLOSED(CLOSED_COUNT,1)=xNode; %%%   ��һ���洢��ʼ��� ����
CLOSED(CLOSED_COUNT,2)=yNode;
NoPath=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START ALGORITHM ��ʼ�㷨
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while((xNode ~= xTarget || yNode ~= yTarget) && NoPath == 1)       %%%  �жϵ�ǰ���Ƿ����Ŀ���
%  plot(xNode+.5,yNode+.5,'go');
%  xnode=xNode,ynode=yNode  %%%****�����ǰ�ڵ㣬����ѧϰ�˽�A*�㷨���������****  ///����Ҫ֪�����̿�ע�͵�///
 
 exp_array=expand_array01(xNode,yNode,path_cost,xTarget,yTarget,CLOSED,MAX_X,MAX_Y);
 exp_count=size(exp_array,1);   %%%  ��ѡ����ӽڵ����
 %UPDATE LIST OPEN WITH THE SUCCESSOR NODES
 %OPEN LIST FORMAT
 %--------------------------------------------------------------------------
 %IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
 %--------------------------------------------------------------------------
 %EXPANDED ARRAY FORMAT ��չ���и�ʽ
 %--------------------------------
 %|X val |Y val ||h(n) |g(n)|f(n)|
 %--------------------------------
 for i=1:exp_count         %%% ��exp_array�ڵ�Ԫ����ӵ� �����б� ����
    flag=0;                %%% ��exp_array�ڵĵ�ı�־λ��Ϊ0
    for j=1:OPEN_COUNT         %%% OPEN_COUNT ��1��ʼ���Լ�
        if(exp_array(i,1) == OPEN(j,2) && exp_array(i,2) == OPEN(j,3) )    %%%�жϿ�ѡ�ӽڵ��Ƿ���OPEN[]�еĵ���ͬ
            OPEN(j,8)=min(OPEN(j,8),exp_array(i,5));                       %%%�����ͬ���Ƚ�����fn��ֵ�Ĵ�С������fnС������㸳ֵ��OPEN(j,8)
            if OPEN(j,8)== exp_array(i,5)                                  %%% ��ʾ����һ���Ƚ��� exp_array(i,5)С�����exp_array(i,�����е�ֵ����OPEN
                %UPDATE PARENTS,gn,hn
                OPEN(j,4)=xNode;
                OPEN(j,5)=yNode;
                OPEN(j,6)=exp_array(i,3);
                OPEN(j,7)=exp_array(i,4);
            end;%End of minimum fn check
            flag=1;                    %%%����ϣУţ���ͬ�ģ���磽��
        end;%End of node check
%         if flag == 1
%             break;
    end;%End of j for
    if flag == 0
        OPEN_COUNT = OPEN_COUNT+1; 
        OPEN(OPEN_COUNT,:)=insert_open(exp_array(i,1),exp_array(i,2),xNode,yNode,exp_array(i,3),exp_array(i,4),exp_array(i,5));
     end;%End of insert new element into the OPEN list
 end;%End of i for
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %END OF WHILE LOOP
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Find out the node with the smallest fn  �ҳ�fn��С�Ľڵ�
  index_min_node = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget);   %%%ѡ��fn��С��һ�У����������� index_min_node
  if (index_min_node ~= -1)    
   %Set xNode and yNode to the node with minimum fn ��xNode��yNode����Ϊ��Сfn�Ľڵ�
   xNode=OPEN(index_min_node,2);
   yNode=OPEN(index_min_node,3);
   path_cost=OPEN(index_min_node,6);% Update the cost of reaching the parent node ���µ��︸�ڵ�ĳɱ�  gn
  %Move the Node to list CLOSED   ���ڵ��ƶ����б�CLOSED  
  CLOSED_COUNT=CLOSED_COUNT+1;
  CLOSED(CLOSED_COUNT,1)=xNode;
  CLOSED(CLOSED_COUNT,2)=yNode;
  OPEN(index_min_node,1)=0;
%   CLOSED  %%%****���CLOSE[]��
%   OPEN    %%%****���OPEN[]��
  else
      %No path exists to the Target!!
      NoPath=0;%Exits the loop!
  end;%End of index_min_node check
end;%End of While Loop
%Once algorithm has run The optimal path is generated by starting of at the
%last node(if it is the target node) and then identifying its parent node
%until it reaches the start node.This is the optimal path

i=size(CLOSED,1);
Optimal_path=[];
xval=CLOSED(i,1);
yval=CLOSED(i,2);
i=1;
Optimal_path(i,1)=xval;
Optimal_path(i,2)=yval;
i=i+1;

if ( (xval == xTarget) && (yval == yTarget))
    
   parent_x=OPEN(node_index(OPEN,xval,yval),4);%node_index returns the index of the node
   parent_y=OPEN(node_index(OPEN,xval,yval),5);
   
   while( parent_x ~= xStart || parent_y ~= yStart)
           Optimal_path(i,1) = parent_x;
           Optimal_path(i,2) = parent_y;
           %Get the grandparents:-)
           inode=node_index(OPEN,parent_x,parent_y);
           parent_x=OPEN(inode,4);%node_index returns the index of the node
           parent_y=OPEN(inode,5);
           i=i+1;
    end;
 j = size(Optimal_path,1) + 1;
  Optimal_path(j,1) = xStart;           
  Optimal_path(j,2) = yStart; %%%����ʼ��ӽ�ȥ
  
  NewOptimal_path=Optimal_path;
 disp('��ͳA*�㷨�滮ʱ��')
 toc
 j = size(NewOptimal_path,1) ;

 
angle_du=0;
 for i=1:1:(j-2)  %%%% 
     du=angle6(  NewOptimal_path(i,1),NewOptimal_path(i,2),NewOptimal_path(i+1,1) ,NewOptimal_path(i+1,2),NewOptimal_path(i+2,1) ,NewOptimal_path(i+2,2));
     angle_du=angle_du+du;
     
 end
 disp('��ͳA*�㷨ת�۶���')
 angle_du
 disp('��ͳA*�㷨ת�۴���')
 ci=angle_du/45
 S=0;
 for i=1:1:(j-1)  %%%% ��·�����õ�ʵ�ʳ���
     Dist=sqrt( ( NewOptimal_path(i,1) - NewOptimal_path(i+1,1) )^2 + ( NewOptimal_path(i,2) - NewOptimal_path(i+1,2))^2);
     S=S+Dist;
     
 end
disp('��ͳA*�㷨·������')
 S 
  disp('��ͳA*�㷨�����ڵ���')
  op_size=size(OPEN,1)

if hui==1  
  for n=1:op_size
     i=OPEN(n,2);
     j=OPEN(n,3);
     fill([i,i+1,i+1,i],[j,j,j+1,j+1],[0.85 0.85 0.85]);
 end
end 
plot(xTarget+0.5,yTarget+0.5,'go');
plot(xStart+0.5,yStart+0.5,'b^');
plot(Optimal_path(:,1)+.5,Optimal_path(:,2)+.5,'b','linewidth',2); %5%����
xlabel('����A*�㷨��·���滮 ','Color','black'); 
else
 pause(1);
 h=msgbox('Sorry, No path exists to the Target!','warn');
 uiwait(h,5);
end

    





