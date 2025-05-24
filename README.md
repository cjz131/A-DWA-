# A*与DWA算法在电气设备巡检机器人中的路径规划研究
针对传统人工巡检效率低、风险高，及普通路径规划算法全局最优与动态避障矛盾的问题，本项目提出改进的 A与 DWA 融合算法。优化 A算法，优化权启发式函数和转向惩罚项；改进 DWA 算法，结合运动学模型与轨迹预测 。二者融合后，通过固定采样分辨率等策略，确保算法稳定性与可靠性。经 20m×20m 栅格地图 Matlab 仿真，改进算法成功率达 91.00%（提升 20%），平均转折度数降低 41.44°，规划速度提升 2.46%，为电气设备巡检自动化、智能化提供技术支撑。欢迎交流
## A文件为传统A*与改进A*的对比代码
其中，A_1.m为传统A*算法，A_2.m为改进A*算法，直接运行A_main.m可对比两者优缺点，结果展示：
![image](https://github.com/user-attachments/assets/2a8c9a0c-b71e-4618-a3a4-2d8c80135c61)
![image](https://github.com/user-attachments/assets/125882ee-4ef8-4837-9267-83f4d401abcd)
![image](https://github.com/user-attachments/assets/e2759f91-bc9d-4484-b987-f4cfd11072fa)
![image](https://github.com/user-attachments/assets/153c0b4d-9754-4781-a3d4-a23d89180210)
## A+DWA文件为改进的A*与DWA融合算法的代码
其中，A_dwa_main为融合算法路径规划过程代码。AD_gai_textmain.m为模拟仿真代码，执行此代码建议修改（添加）DWA_ct_dong.m的超时检测模块，具体为去掉下图的注释
启用超时检测，减小仿真次数过多，时间的巨大消耗。
![image](https://github.com/user-attachments/assets/c08d0b8f-07ef-4882-b7bd-82119bae157d)
### 部分结果代码展示：
![image](https://github.com/user-attachments/assets/d36380cc-874e-47cc-926c-a48ab3ceceaa)
![image](https://github.com/user-attachments/assets/39d93953-50e8-4274-b85c-f4005b6060b0)
![image](https://github.com/user-attachments/assets/e146a781-fc51-45b1-a7f6-d22aa022d3ed)
![image](https://github.com/user-attachments/assets/a591aca2-51c9-4230-b482-a8832343b684)
![image](https://github.com/user-attachments/assets/845beb2d-d406-47ca-bb82-52909b26e423)
![image](https://github.com/user-attachments/assets/ee309fdd-d09b-4688-8836-5d2efd51f5e6)
![image](https://github.com/user-attachments/assets/808049bb-7276-4082-9e72-c978a1cd9588)
![image](https://github.com/user-attachments/assets/6644979d-23ab-4399-a814-34cbdb83357b)
![image](https://github.com/user-attachments/assets/f18ca655-c449-4342-ae74-e666ca9048d1)

![image](https://github.com/user-attachments/assets/4ba2f08e-b2e2-4048-918e-a9ec13057f64)
![image](https://github.com/user-attachments/assets/dc976441-3cac-43c0-9aca-bbbeadd7f416)
![image](https://github.com/user-attachments/assets/13785291-6714-4f58-896f-9539e97ecbb9)
![image](https://github.com/user-attachments/assets/d58253ff-4ba8-4381-b196-255cdc801b00)
![image](https://github.com/user-attachments/assets/a1d6f4f0-bd2b-434c-a0ab-388f277f7663)
![image](https://github.com/user-attachments/assets/e4cfc20f-3590-4efd-ac7c-658db54e6777)
![image](https://github.com/user-attachments/assets/3047143f-5d4f-436a-b854-aad41c61ddff)
![image](https://github.com/user-attachments/assets/b8d4e9e4-46dc-4853-bb79-9b12b77f4bba)
![image](https://github.com/user-attachments/assets/50160e37-d85a-4fc3-9c6c-e0323cbc52aa)
![image](https://github.com/user-attachments/assets/1ff31f18-85c1-4550-b225-74d7a34bbd77)
![image](https://github.com/user-attachments/assets/49c4a50f-d383-4ce3-ad48-9ebe4ed10c5d)
![image](https://github.com/user-attachments/assets/fb851702-dca4-42d7-83a1-6a94bb6447e2)
