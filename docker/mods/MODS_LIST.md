# Puppy Stardew Server - Included Mods

这个服务器包含以下自定义 Mods，用于增强游戏体验。

## Mod 列表

### 核心功能 Mods

1. **Stardew Multiplayer Server Mod**
   - 多人服务器核心模组
   - 支持 24/7 无人运行
   - 提供服务器管理功能

2. **ContentPatcher**
   - 内容补丁框架
   - 其他很多 mod 的依赖

3. **GenericModConfigMenu**
   - 通用 Mod 配置菜单
   - 方便在游戏内配置其他 mod

### 游戏增强 Mods

4. **ConsoleCommands**
   - 控制台命令支持
   - 方便服务器管理

5. **SaveBackup**
   - 自动存档备份
   - 防止存档丢失

6. **TMXLoader**
   - TMX 地图加载器
   - 支持自定义地图

### 便利功能 Mods

7. **ConvenientInventory**
   - 便捷背包管理
   - 自动整理、快速堆叠等功能

8. **Giant backpack**
   - 巨型背包
   - 增加背包容量

9. **YetAnotherAutoWatering**
   - 自动浇水
   - 减少重复劳动

10. **Trading**
    - 交易功能增强
    - 玩家间交易更方便

11. **SelfServe**
    - 自助服务
    - 提供便利功能

### 地图相关 Mods

12. **FarmSleepPatch_TMXL**
    - 农场睡眠补丁
    - TMX 地图相关

### 其他 Mods

13. **ChuanXiao**
    - 自定义功能模组

14. **AutoLoadGame** (已禁用)
    - 自动加载游戏
    - 当前版本中已禁用

## 说明

所有 mods 已预装并配置好，容器启动时会自动加载。

## Mod 要求

- **SMAPI**: 4.1.10 或更高版本
- **游戏版本**: Stardew Valley 1.6+

## 使用说明

### 首次设置

1. 启动容器
2. 通过 VNC (端口 5900) 连接创建或加载存档
3. 存档加载后游戏会持续运行

### 容器重启后

- 容器重启后，通过 VNC 重新加载存档即可
- 所有 mod 会自动加载

## 配置

如需自定义 mod 配置，可以通过以下方式：

1. 通过 VNC 连接，在游戏内使用 GenericModConfigMenu 配置
2. 直接编辑 `/home/steam/stardewvalley/Mods/` 目录下的 config.json 文件
