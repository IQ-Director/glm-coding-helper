# 智谱 GLM Coding Plan 抢购助手 + 本地 OCR 自动验证码

这是一个面向智谱 GLM Coding Plan 的抢购辅助项目，包含 Tampermonkey 油猴脚本和本地 CPU/GPU OCR 后端，用于限时抢购流程辅助、中文点选验证码自动识别、验证码自动点击、套餐按钮提前可点、限流重试和多窗口监控。

如果你在搜索“GLM Coding Rush”“GLM Coding Plan 抢购助手”“智谱 GLM Coding Plan 抢购”“GLM Coding 抢购脚本”“GLM Coding 一键抢购”“GLM Coding Plan 油猴脚本”“Tampermonkey 抢购脚本”“GLM Coding Plan 自动验证码”“GLM Coding Plan OCR”“智谱编程套餐抢购”，这个项目就是完整的一套前端油猴脚本 + 本地识别后端。

默认使用作者内置折扣入口，可获得 95 折优惠；介意者可在脚本中自行替换入口参数。

关键词：GLM Coding Rush、GLM Coding Plan 抢购助手、GLM Coding Plan 抢购脚本、GLM Coding Plan 一键抢购、智谱 GLM Coding 抢购、智谱编程套餐抢购、GLM Coding 油猴脚本、Tampermonkey userscript、Auto-Purchase Userscript、自动解锁售罄、限流重试、多窗口并发、本地 OCR、CPU OCR、GPU OCR、中文点选验证码、验证码自动点击、订阅助手。

English keywords: GLM Coding Rush, GLM Coding Plan auto purchase, GLM Coding Plan rush helper, GLM Coding userscript, Tampermonkey script, local OCR captcha solver, CPU OCR backend, GPU OCR backend, Chinese captcha auto click.

## 演示

https://github.com/user-attachments/assets/e1a56d07-5c4d-4aa1-a567-909dd25bd037

## 能做什么

- GLM Coding Plan 抢购流程辅助，减少手动刷新和返回操作
- 提前解除页面按钮不可点击状态，让订阅按钮可以操作
- 自动切换套餐和订阅周期，按配置顺序尝试
- 遇到中文点选验证码时，调用本地 OCR 后端自动识别并点击目标文字
- 支持 CPU/GPU 本地识别，不上传验证码图片到第三方服务
- 支持一键多开窗口，方便补货前预热和同时监控
- 默认不自动关闭无效支付链接/限流弹窗，需要在配置面板里手动开启
- 默认使用作者内置折扣入口进入 GLM Coding Plan

后端的安装、GPU/CPU 自动选择、worker 数、OCR 配置等说明见：

```text
docs/backend_config.md
```

验证码识别模型从传统 CV、YOLO、GLM-OCR/VLM 标注、手搓排序模型到 PP-OCRv5 的开发历程见：

```text
docs/captcha_model_journey.md
```

## 快速开始

如果你想让 AI 助手代为安装和排错，可以把本仓库发给支持 Skills 的 AI 助手，并让它读取根目录 `SKILL.md`。

### 1. 安装后端

如果你没有 Python，直接运行：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\bootstrap_windows.ps1 -Target auto
```

如果已经有 Python，也可以运行：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\setup_backend.ps1 -Target auto
```

### 2. 启动后端

```powershell
powershell -ExecutionPolicy Bypass -File scripts\start_backend.ps1 -Mode auto
```

启动后可检查：

```powershell
Invoke-RestMethod http://127.0.0.1:8888/health
```

### 3. 安装油猴脚本

1. 安装 Tampermonkey https://www.tampermonkey.net。
2. （1）访问https://greasyfork.org/zh-CN/scripts/579760-glm-coding-helper获取
或者
   （2）打开仓库根目录的 `glm-coding-helper.user.js`。
选择一种方式
3. 复制全部内容，新建 Tampermonkey 脚本并保存。
4. 打开 GLM Coding Plan 页面。

仓库根目录的 `glm-coding-helper.user.js` 是给普通用户安装的入口；`scripts/userscripts/` 只是保留给开发和旧路径兼容。

脚本默认连接本地后端：

```text
http://127.0.0.1:8888
```

## 抢购步骤

1、先安装好油猴插件，配置好油猴脚本，使用 chrome 插件时要在页面右上角开启开发者模式，然后找到篡改猴插件点击详情，把允许运行用户脚本、在无痕模式下启用、允许访问文件网址都打开

2、安装后端，到 github 目录根据引导手动安装或者根据 skill 让 ai 助手安装

3、打开抢购网址测试看工作是不是正常

4、每天9点50分前进入抢购页面准备，晚了可能就打不开了，顺便准备好手机支付宝准备付款（我曾经有金额但是付晚了就没了）

5、多开几个窗口，等快到10点的时候点击好验证码但是不要确定，等10点一到就开始按确定

6、如果这波没抢到就盯着一个窗口用我们的 ocr 来识别点击，默认不会自动关闭支付页面。注意！！！如果看到没有金额的支付页面那就是没抢到，要关了继续抢。这时候可以使用我的快捷键进行快速操作。

### 快捷键

- `Esc`：关闭系统繁忙弹窗或支付弹窗
- `Enter` / `Space`：点击验证码确认按钮

### 重要提醒

- 默认不会自动关闭无效支付链接或限流弹窗，需要在配置面板里手动开启。
- 遇到真正有金额的支付二维码，请自行确认后再扫码支付。
- 抢购是否成功受库存、限流、账号状态、支付速度等因素影响，脚本不能保证一定抢到。

油猴菜单里可以打开配置面板、一键多开窗口、清除今日套餐状态缓存。

## 常用启动方式

强制 GPU：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\start_backend.ps1 -Mode gpu
```

强制 CPU：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\start_backend.ps1 -Mode cpu
```

指定 CPU worker：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\start_backend.ps1 -Mode cpu -CpuWorkers 3
```

## 模型文件

默认检测权重路径：

```text
models/weights/yolo-captcha-detector.pt
```

也可以用环境变量覆盖：

```powershell
$env:CNCAPTCHA_DETECTOR_PATH="D:\path\to\best.pt"
```

## 致谢

本项目的油猴前端脚本是在 Greasy Fork 用户 `mumumi` 的《GLM Coding Plan抢购助手》基础上二次开发而来：

https://greasyfork.org/zh-CN/scripts/572157-glm-coding-plan%E6%8A%A2%E8%B4%AD%E5%8A%A9%E6%89%8B

感谢原作者长期维护和分享。原脚本采用 GNU GPLv3 许可证；本仓库继续保留相同许可证声明，并在其基础上增加本地 CPU/GPU OCR 后端、自动验证码识别和开源部署脚本。

## 许可证

本项目基于 GNU GPLv3 发布。油猴脚本基于 Greasy Fork 用户 `mumumi` 的 GPLv3 脚本二次开发，继续保留相同许可证。

## 说明

本项目用于本地 OCR、自动化辅助和技术研究。请遵守目标网站服务条款和当地法律法规，自行承担使用风险。
