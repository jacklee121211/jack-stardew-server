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

所有 mods 已预装并配置好。**首次启动**时会自动安装，之后 Mods 目录完全由您控制。

## Mod 要求

- **SMAPI**: 4.1.10 或更高版本
- **游戏版本**: Stardew Valley 1.6+

## 使用说明

### 首次设置

1. 启动容器
2. **14 个预装 mod 会自动安装**（仅首次）
3. 创建标记文件 `.mods_installed` 表示已初始化
4. 通过 VNC (端口 5900) 连接创建或加载存档

### 容器重启后

- ✅ **Mods 目录不会被重置**
- ✅ 您添加的自定义 mod 会保留
- ✅ 您修改的配置会保留
- 容器重启后，通过 VNC 重新加载存档即可

### 添加自定义 Mod

您可以自由添加或删除 mod：

```bash
# 方法 1: 直接复制到宿主机的 data/game/Mods/ 目录
cp your-mod/ ./data/game/Mods/

# 方法 2: 在容器内操作
docker exec puppy-stardew cp -r /path/to/your-mod /home/steam/stardewvalley/Mods/

# 重启容器使新 mod 生效
docker compose restart
```

### 重置 Mods（恢复到默认 14 个）

如果您想重置为初始的 14 个 mod：

```bash
# 删除标记文件
docker exec puppy-stardew rm /home/steam/stardewvalley/Mods/.mods_installed

# 删除所有 mod
rm -rf ./data/game/Mods/*

# 重启容器，会重新安装默认 mods
docker compose restart
```

## 配置

如需自定义 mod 配置，可以通过以下方式：

1. 通过 VNC 连接，在游戏内使用 GenericModConfigMenu 配置
2. 直接编辑 `./data/game/Mods/` 目录下对应 mod 的 config.json 文件
3. 配置修改后重启容器生效
