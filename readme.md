## Descriptipon

| File Name           | File Description                   |
| ------------------- | ---------------------------------- |
| GUI_Main.m          | 逐步操作的 GUI 实现函数            |
| GUI_Main.fig        | 逐步操作的 GUI 界面                |
| GUI_Comparison1.m   | 多个论文中FOPID对比的 GUI 实现函数 |
| GUI_Comparison1.fig | 多个论文中FOPID对比的 GUI 界面     |
| GUI_Comparison2.m   | 多个模型对比的 GUI 实现函数        |
| GUI_Comparison2.fig | 多个模型对比的 GUI 界面            |

## Internal Functions for GUI

| File Name              | File Description                                             |
| ---------------------- | ------------------------------------------------------------ |
| function_Compensator.m | 计算补偿器的函数                                             |
| function_FOPID.m       | 计算论文中 FOPID 控制器的函数                                |
| function_FOPID_para    | 计算论文中出现的 α，β 和 γ 的函数                            |
| function_PI_lambdaD.m  | 计算 PIλD 控制器，论文《Optimal robust fractional order PIλD controller synthesis for first order plus time delay systems》 |
| function_RZNFOPID.m    | 计算 PIλDλ 控制器，论文《Revisiting Ziegler–Nichols. A fractional order approach》 |
| irid_fod.m             | 分数阶计算函数                                               |
| ousta_fod.m            | 分数阶计算函数                                               |
| programEx6PILamD.m     | 用于得出论文中最后一张时域响应图                             |


## Simulink Files

| File Name                  | File Description                                           |
| -------------------------- | ---------------------------------------------------------- |
| Model_ZN_PID.mdl           | 论文中 FOPID 控制器的仿真模型                              |
| Model_ZN_FOPID.mdl         | 整数阶 Ziegler–Nichols PID控制器的仿真模型                 |
| Model_RZN_FOPID.mdl        | PIλDλ 控制器的仿真模型                                     |
| Model_PI_lambdaD.mdl       | PIλD 控制器的仿真模型，用在 simulation_comparison.m 文件中 |
| Model_PI_lambdaD_FOPDT.mdl | PIλD 控制器的仿真模型，用在 function_PI_lambdaD.m 文件中   |


​				
​	