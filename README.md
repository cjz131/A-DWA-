# A-DWA-
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
部分结果代码展示：
![image](https://github.com/user-attachments/assets/4ba2f08e-b2e2-4048-918e-a9ec13057f64)
