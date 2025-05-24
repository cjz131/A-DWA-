clc
clear
figure 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                ��ͼ��ģ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%ֻ�����������ξ����к�����ȣ�������תʱ����ִ���
MAX0= [     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 0 0
             0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 0 0
             0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 0 0
             0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 0 0
             0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 0 0 
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
             1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
             1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
             1 1 1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 ] ;
%%% ͨ������Ϊ 0 ���ϰ�������Ϊ 1 ����ʼ������Ϊ 2 ��Ŀ�������Ϊ -1 ��
MAX=rot90(MAX0,3);      %%%����0,1�ڷŵ�ͼ�����������鲻һ������Ҫ����ʱ����ת90*3=270�ȸ����飬����������ͼ������Լ����ŵ�ͼ��
MAX_X=size(MAX,2);                                %%%  ��ȡ��������x�᳤��
MAX_Y=size(MAX,1);                                %%%  ��ȡ��������y�᳤��
MAX_VAL=10;                              %%%   ������������ɵ��ַ����ʽ������ֵ�����Ǻ������ڽ���ֵ�ַ���ת��Ϊ��ֵ

x_val = 1;
y_val = 1;
axis([1 MAX_X+1, 1 MAX_Y+1])                %%%  ����x��y��������
set(gca,'xtick',1:1:MAX_X+1,'ytick',1:1:MAX_Y+1,'GridLineStyle','-',... 
    'xGrid','on','yGrid','on')
grid on;                                   %%%  �ڻ�ͼ��ʱ�����������
hold on;                                   %%%  ��ǰ�ἰͼ�񱣳ֶ�����ˢ�£�׼�����ܴ˺󽫻��Ƶ�ͼ�Σ���ͼ����
n=0;%Number of Obstacles                   %%%  �ϰ�������


k=1;          %%%% �������ϰ�����ڹر��б��У��ϰ����ֵΪ1;������ʾ�ϰ���
CLOSED=[];
for j=1:MAX_X
    for i=1:MAX_Y
        if (MAX(i,j)==1)
          %%plot(i+.5,j+.5,'ks','MarkerFaceColor','b'); ԭ���Ǻ��Բ��ʾ
          fill([i,i+1,i+1,i],[j,j,j+1,j+1],'k');  %%%�ĳ� �úڷ�������ʾ�ϰ���
          CLOSED(k,1)=i;  %%% ���ϰ��㱣�浽CLOSE������
          CLOSED(k,2)=j; 
          k=k+1;
        end
    end
end
Area_MAX(1,1)=MAX_X;
Area_MAX(1,2)=MAX_Y;
Obs_Closed=CLOSED;
num_Closed=size(CLOSED,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                       ������ʼ��Ͷ��Ŀ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ������ʼ�㡢Ŀ���
%%%   ѡ��Ŀ��λ��
pause(0.5);                                  %%%   ������ͣ1��
h=msgbox('��ʹ��������ѡ������豸λ��');          %%%   Please Select the Target using the Left Mouse button
uiwait(h,5);                               %%%   ������ͣ
if ishandle(h) == 1                        %%%   ishandle(H) ������һ��Ԫ��Ϊ 1 �����飻���򣬽����� 0��
    delete(h);
end
xlabel('��ʹ��������ѡ������豸λ��','Color','black');   %%%   Please Select the Target using the Left Mouse button
but=0;
while (but ~= 1) %Repeat until the Left button is not clicked  %%%  �ظ���ֱ��û�е��������󡱰�ť
    [xval,yval,but]=ginput(1);                                 %%%  ginput�ṩ��һ��ʮ�ֹ��ʹ�����ܸ���ȷ��ѡ����������Ҫ��λ�ã�����������ֵ��
end
xval=floor(xval);                                              %%%  floor����ȡ�����ڴ���ֵ���������������ȡ��
yval=floor(yval);
xTarget=xval;%X Coordinate of the Target                       %%%   Ŀ�������
yTarget=yval;%Y Coordinate of the Target
plot(xval+.5,yval+.5,'go');                                    %%%   Ŀ�����ɫb ��ɫ g ��ɫ k ��ɫ w��ɫ r ��ɫ y��ɫ m�Ϻ�ɫ c����ɫ
text(xval+1,yval+1,'Target')                                  %%%   text(x,y,'string')�ڶ�άͼ����ָ����λ��(x,y)����ʾ�ַ���string

%%%   ѡ����ʼλ��
h=msgbox('��ʹ��������ѡ��Ѳ������˳�ʼλ��');                    %%%Please Select the Vehicle initial position using the Left Mouse button
uiwait(h,5);
if ishandle(h) == 1
    delete(h);
end
xlabel('��ѡ��Ѳ������˳�ʼλ�� ','Color','black');                %%%  Please Select the Vehicle initial position
but=0;
while (but ~= 1) %Repeat until the Left button is not clicked %%%�ظ���ֱ��û�е��������󡱰�ť
    [xval,yval,but]=ginput(1);
    xval=floor(xval);
    yval=floor(yval);
end
xStart=xval;%Starting Position
yStart=yval;%Starting Position
plot(xval+.5,yval+.5,'b^');
text(xval+1,yval+1,'Start')  
xlabel('��ʼ��λ�ñ��Ϊ �� ��Ŀ���λ�ñ��Ϊ o ','Color','black'); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Start=[xStart yStart];
Goal=[xTarget yTarget];

[Line_path,distance_x,OPEN_num]=Astar_G_du(Obs_Closed,Start,Goal,MAX_X,MAX_Y);
%Line_path=[3,11;5,14;7,17;9,17;11,17;13,17;15,17;18,11]
%                                     �ֲ�����
figure 
axis([1 MAX_X+1, 1 MAX_Y+1])                %%%  ����x��y��������
set(gca,'xtick',1:1:MAX_X+1,'ytick',1:1:MAX_Y+1,'GridLineStyle','-',...
        'xGrid','on','yGrid','on');   
grid on;       
hold on;
num_obc=size(Obs_Closed,1);
for i_obs=1:1:num_obc
         x_obs=Obs_Closed(i_obs,1);
         y_obs=Obs_Closed(i_obs,2);
         fill([x_obs,x_obs+1,x_obs+1,x_obs],[y_obs,y_obs,y_obs+1,y_obs+1],'k');hold on;
end
 plot( Line_path(:,1)+.5, Line_path(:,2)+.5,'b:','linewidth',2); 
 plot(xStart+.5,yStart+.5,'b^');
 plot(Goal(1,1)+.5,Goal(1,2)+.5,'bo');   
% 
pause(1);
h=msgbox('�����ƶ��ϰ���� ���');
uiwait(h,5);
if ishandle(h) == 1
    delete(h);
end
xlabel('�����ƶ��ϰ���� ���','Color','black');
but=0;
while (but ~= 1) %Repeat until the Left button is not clicked
    [xval,yval,but]=ginput(1);
end
xval=floor(xval);
yval=floor(yval);
Obst_xS=xval;%X Coordinate of the Target
Obst_yS=yval;%Y Coordinate of the Target

plot(xval+.5,yval+.5,'k^');
 
pause(1);

h=msgbox('�����ƶ��ϰ���� �յ�');
uiwait(h,5);
if ishandle(h) == 1
    delete(h);
end
xlabel('�����ƶ��ϰ���� �յ� ','Color','black');
but=0;
while (but ~= 1) %Repeat until the Left button is not clicked
    [xval,yval,but]=ginput(1);
    xval=floor(xval);
    yval=floor(yval);
end
Obst_xT=xval;%Starting Position
Obst_yT=yval;%Starting Position
 plot(xval+.5,yval+.5,'ko');
 Obst_d_d_St=[Obst_xS Obst_yS];
Obst_d_d_Ta=[Obst_xT Obst_yT];
[Obst_d_path,Obst_d_distance_x,Obst_d_OPEN_num]=Astar_G_du(Obs_Closed,Obst_d_d_St,Obst_d_d_Ta,MAX_X,MAX_Y);
Obst_d_path_X=[Obst_d_path;Obst_d_d_Ta];
L_obst=0.026;% �����ƶ��ϰ�����ٶ� 0.1s���˶� L_obst m  �ٶ�Ϊ10*L_obst m/s
Obst_d_d_line=Line_obst(Obst_d_path_X,L_obst);
plot( Obst_d_d_line(:,1)+.5, Obst_d_d_line(:,2)+.5,'r','linewidth',1); 

pause(1);
h=msgbox('����δ֪��ֹ�ϰ��� ���ȷ����������ã��Ҽ�ȷ�������');
  xlabel('����δ֪��ֹ�ϰ��� ���ȷ����������ã��Ҽ�ȷ�������','Color','blue');
uiwait(h,10);
if ishandle(h) == 1
    delete(h);
end
but=1;
while but == 1
    [xval,yval,but] = ginput(1);
    xval=floor(xval);
    yval=floor(yval);
    MAX(xval,yval)=8;%Put on the closed list as well
    %plot(xval+.5,yval+.5,'rp');
    fill([xval,xval+1,xval+1,xval],[yval,yval,yval+1,yval+1],[0.8 0.8 0.8]); 
 end%End of While loop

dg=0;%Dummy counter
Obs_d_j=[0 0 ];
for i=1:MAX_X
    for j=1:MAX_Y
        if(MAX(i,j) == 8)
            dg=dg+1;
            Obs_d_j(dg,1)=i; 
            Obs_d_j(dg,2)=j; 
        end
    end
end

%% �������˶�ѧģ��
% �����˳�ʼ����Ƕ� s_du
angle_node=pi/4;
% �������ٶȲ���
% Kinematic = [   ����ٶ�[m/s], �����ת�ٶ�[rad/s], ���ٶ�[m/ss], ��ת���ٶ�[rad/ss], �ٶȷֱ���[m/s], ת�ٷֱ���[rad/s]  ]

Kinematic=[1.5,toRadian(20.0),0.2,toRadian(50.0),0.02,toRadian(1)];
% ���ۺ���ϵ������ [heading,dist,velocity,predictDT]
%  [��λ�����ۺ���ϵ���� �ϰ���������ۺ���ϵ���� ��ǰ�ٶȴ�С���ۺ���ϵ��, Ԥ����ʱ�� �����䣩]
evalParam=[0.05,0.2,0.3,3.0];%


path_node=Line_path;
Result_x=DWA_ct_dong(Obs_Closed,Obst_d_d_line,Obs_d_j,Area_MAX,Goal,Line_path,path_node,Start,angle_node,Kinematic,evalParam);

%%%%%%%%%%% ��ͼ
figure 
axis([1 MAX_X+1, 1 MAX_Y+1])                %%%  ����x��y��������
set(gca,'xtick',1:1:MAX_X+1,'ytick',1:1:MAX_Y+1,'GridLineStyle','-',...
        'xGrid','on','yGrid','on');   
grid on;       
hold on;

 for i_obs=1:1:num_obc
         x_obs=Obs_Closed(i_obs,1);
         y_obs=Obs_Closed(i_obs,2);
         fill([x_obs,x_obs+1,x_obs+1,x_obs],[y_obs,y_obs,y_obs+1,y_obs+1],'k');hold on;
 end
 plot( Line_path(:,1)+.5, Line_path(:,2)+.5,'b:','linewidth',1.5); 
 plot(xStart+.5,yStart+.5,'b^');
 plot(Goal(1,1)+.5,Goal(1,2)+.5,'bo');
  num_o=size(Obst_d_d_line,1);
 x_do=Obst_d_d_line(num_o,1);
 y_do=Obst_d_d_line(num_o,2);
 fill([x_do+0.15,x_do+0.85,x_do+0.85,x_do+0.15],[y_do+0.15,y_do+0.15,y_do+0.85,y_do+0.85],'y');
 num_lin=size(Line_path,1);
 for i_lin=2:1:num_lin-1
     plot(Line_path(i_lin,1)+.5,Line_path(i_lin,2)+.5,'r*');
 end

%     dong_num=size(Obs_d_j,1);
%     for i_d=1:1:dong_num
%       x_do=Obs_d_j(i_d,1);
%       y_do=Obs_d_j(i_d,2);
%       fill([x_do,x_do+1,x_do+1,x_do],[y_do,y_do,y_do+1,y_do+1],[0.8 0.8 0.8]);
%     end
num_x=size(Result_x,1);
Result_plot=[Result_x;Goal(1,1) Goal(1,2) Result_x(num_x,3) 0 0];


 plot(Result_x(:,1)+0.5, Result_x(:,2)+0.5,'b','linewidth',2);hold on;
 num_p=num_x+1;
 ti=1:1:num_p;
 figure
 plot(ti,Result_plot(:,3),'-b');hold on;
 legend('��̬�Ƕ�')
 figure
 plot(ti,Result_plot(:,4),'-b');hold on;
 
 plot(ti,Result_plot(:,5),'-r');hold on;
 legend('���ٶ�','���ٶ�')
  S=0;
 for i=1:1:num_x  %%%% ��·�����õ�ʵ�ʳ���
     Dist=sqrt( ( Result_plot(i,1) - Result_plot(i+1,1) )^2 + ( Result_plot(i,2) - Result_plot(i+1,2))^2);
     S=S+Dist;
 end
disp('·������')
 S
%  
%  % �����˵�״̬Result_x=[x(m),y(m),yaw(Rad),v(m/s),w(rad/s)]
%  i=1
%  figure
%  axis([0 2000, -0.4 0.8])                %%%  ����x��y��������
%  set(gca,'xtick',0:100:2100,'ytick',-0.4:0.2:0.8,'GridLineStyle','-',... 
%     'xGrid','on','yGrid','on')
%  grid off;
% xlabel('���ƽڵ����');hold on
% ylabel('���ٶ�(m/s) ���ٶ�(rad/s)');hold on
% 
% plot(ti,Result_plot(:,4),'-b','linewidth',1.5);hold on;
% plot(ti,Result_plot(:,5),':r','linewidth',1.5);hold on;

 
 
 