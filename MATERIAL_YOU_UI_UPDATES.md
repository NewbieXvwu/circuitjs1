# Material You (MD3) UI 更新说明

本文档详细说明了 CircuitJS1 的 Material You (Material Design 3) 界面更新内容。

## 🎨 设计系统更新

### 1. 颜色方案

我们已经实现了完整的 Material Design 3 颜色系统：

#### 主色调 (Primary)
- **Primary**: `#6750A4` - 紫色调，用于主要操作按钮
- **Primary Container**: `#EADDFF` - 浅紫色，用于强调区域
- **On Primary**: `#FFFFFF` - 主色调上的文字颜色

#### 次要色调 (Secondary)
- **Secondary**: `#625B71` - 中性紫灰色
- **Secondary Container**: `#E8DEF8` - 浅紫灰色
- **On Secondary**: `#FFFFFF` - 次要色调上的文字颜色

#### 第三色调 (Tertiary)
- **Tertiary**: `#7D5260` - 玫瑰色调
- **Tertiary Container**: `#FFD8E4` - 浅玫瑰色
- **On Tertiary**: `#FFFFFF` - 第三色调上的文字颜色

#### 错误状态 (Error)
- **Error**: `#B3261E` - 红色，用于错误提示
- **Error Container**: `#F9DEDC` - 浅红色
- **On Error**: `#FFFFFF` - 错误色上的文字颜色

#### 表面和背景 (Surface & Background)
- **Background**: `#FEF7FF` - 浅紫色背景
- **Surface**: `#FEF7FF` - 卡片和组件表面颜色
- **Surface Variant**: `#E7E0EC` - 变体表面颜色
- **On Surface**: `#1C1B1F` - 表面上的主要文字颜色
- **On Surface Variant**: `#49454F` - 表面上的次要文字颜色

#### 轮廓 (Outline)
- **Outline**: `#79747E` - 边框和分隔线
- **Outline Variant**: `#CAC4D0` - 次要边框

### 2. 圆角设计 (Shape)

Material You 强调柔和的圆角设计：

- **Extra Small**: `4px` - 用于小组件（展开按钮）
- **Small**: `8px` - 用于按钮和卡片
- **Medium**: `12px` - 用于较大的组件
- **Large**: `16px` - 用于主要操作按钮
- **Extra Large**: `28px` - 用于特殊强调元素

### 3. 阴影系统 (Elevation)

使用多层阴影创建深度感：

- **Level 1**: 轻微阴影，用于按钮和卡片
  ```css
  box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.3), 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
  ```

- **Level 2**: 中等阴影，用于悬停状态
  ```css
  box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.3), 0px 2px 6px 2px rgba(0, 0, 0, 0.15);
  ```

- **Level 3**: 较强阴影，用于模态框和对话框
  ```css
  box-shadow: 0px 1px 3px rgba(0, 0, 0, 0.3), 0px 4px 8px 3px rgba(0, 0, 0, 0.15);
  ```

### 4. 字体系统

使用 Google 的 Roboto 字体家族：

- **字体**: Roboto (300, 400, 500, 700)
- **基础字号**: 14px
- **标题字号**: 1.3em
- **小字号**: 0.875em
- **字重**: 
  - Regular (400) - 普通文本
  - Medium (500) - 按钮和强调文本
  - Bold (700) - 标题

## 🔧 组件更新

### 按钮 (Buttons)

#### 主要操作按钮 (.topButton)
```css
- 背景色: Primary (#6750A4)
- 文字色: On Primary (#FFFFFF)
- 圆角: 16px (Large)
- 内边距: 10px 24px
- 阴影: Level 1
- 悬停效果: 
  - 背景变为 Primary Container
  - 阴影提升到 Level 2
  - 向上平移 1px
```

#### 错误按钮 (.topButton-red)
```css
- 背景色: Error (#B3261E)
- 文字色: On Error (#FFFFFF)
- 其他样式与主要按钮相同
```

#### 工具按钮 (.gwt-Button.chbut)
```css
- 背景色: Surface (#FEF7FF)
- 边框: Outline (#79747E)
- 圆角: 8px (Small)
- 内边距: 8px 12px
- 选中状态:
  - 背景色: Primary Container
  - 文字色: On Primary Container
  - 边框: Primary
```

#### 展开/折叠按钮 (.gwt-Button.expand-but)
```css
- 背景色: Secondary (#625B71)
- 文字色: On Secondary (#FFFFFF)
- 尺寸: 18x18px
- 圆角: 4px (Extra Small)
- 无边框
- 阴影: Level 1
```

### 菜单 (Menus)

#### 菜单栏 (.gwt-MenuBar-horizontal)
```css
- 背景色: Surface
- 圆角: 8px (Small)
- 阴影: Level 1
- 字号: 14px
```

#### 菜单项 (.gwt-MenuItem)
```css
- 内边距: 12px 16px
- 圆角: 4px (Extra Small)
- 悬停效果: Surface Variant 背景
- 平滑过渡: 200ms cubic-bezier
```

#### 禁用菜单项 (.gwt-MenuItem-disabled)
```css
- 颜色: Outline
- 不透明度: 38%
```

### 输入框 (Text Boxes)

#### 文本输入框 (.gwt-TextBox.scalebox)
```css
- 宽度: 120px
- 内边距: 12px 16px
- 边框: Outline (1px)
- 圆角: 4px (Extra Small)
- 字体: Roboto 14px
- 焦点状态:
  - 边框色: Primary
  - 边框宽度: 2px
  - 无外轮廓
```

### 标签 (Labels)

#### 选中标签 (.gwt-Label-selected)
```css
- 字号: 1.3em
- 字重: 500 (Medium)
- 边框: 2px solid Primary
- 文字色: Primary
```

#### 次要标签 (.gwt-Label-1off)
```css
- 颜色: On Surface Variant
```

#### 禁用标签 (.gwt-Label-2off)
```css
- 字号: 0.875em
- 颜色: Outline
```

## ⚡ 动画和过渡

所有交互元素都采用 Material Design 的标准缓动函数：

```css
transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
```

这个缓动函数（也称为 "standard easing"）创建了自然流畅的动画效果。

### 按钮交互动画

1. **悬停 (Hover)**
   - 阴影从 Level 1 提升到 Level 2
   - 向上平移 1px
   - 背景色渐变到 Container 颜色

2. **按下 (Active)**
   - 阴影回到 Level 1
   - 位置回到原点
   - 创建按下的视觉反馈

## 🌈 颜色使用指南

### 何时使用每种颜色

#### Primary (主色调)
- 主要操作按钮
- 重要信息强调
- 选中状态
- 活动状态指示器

#### Secondary (次要色调)
- 次要操作按钮
- 辅助控件
- 工具栏图标
- 展开/折叠按钮

#### Tertiary (第三色调)
- 特殊功能按钮
- 装饰性元素
- 可选的强调元素

#### Error (错误色)
- 错误提示
- 警告按钮
- 删除操作
- 危险操作确认

#### Surface (表面色)
- 卡片背景
- 对话框背景
- 菜单背景
- 输入框背景

#### Background (背景色)
- 页面主背景
- 应用整体背景

## 📱 响应式设计

Material You UI 已针对不同屏幕尺寸优化：

### 触摸目标
- 最小触摸目标: 48x48dp
- 主要按钮: 充足的内边距 (10px 24px)
- 工具按钮: 合适的间距 (6px margin)

### 字体缩放
- 支持系统字体缩放
- 使用相对单位 (em, rem)
- 保持可读性

### 视窗适配
```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

## 🔍 可访问性改进

### 对比度
所有颜色组合都符合 WCAG 2.1 AA 级标准：
- 正常文本: 至少 4.5:1
- 大文本: 至少 3:1
- UI 组件: 至少 3:1

### 焦点指示
- 输入框获得焦点时有明显的边框变化
- 使用 Primary 色作为焦点指示器
- 移除默认 outline，使用自定义边框

### 状态指示
- 禁用状态: 38% 不透明度
- 悬停状态: Surface Variant 背景
- 选中状态: Primary Container 背景

## 🎯 浏览器兼容性

Material You UI 支持所有现代浏览器：

- ✅ Chrome/Edge 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Opera 76+

### CSS 特性使用
- CSS 自定义属性 (CSS Variables)
- CSS Grid 和 Flexbox
- CSS 过渡和动画
- CSS 阴影效果

## 🔄 从旧版 UI 迁移

### 主要变化

1. **颜色系统**
   - 旧: 硬编码的颜色值
   - 新: CSS 变量，易于主题定制

2. **圆角**
   - 旧: 3px 统一圆角
   - 新: 4px-28px 分级圆角

3. **阴影**
   - 旧: 简单的边框
   - 新: 多层次阴影系统

4. **字体**
   - 旧: 系统默认字体
   - 新: Roboto 字体家族

5. **动画**
   - 旧: 无过渡效果
   - 新: 流畅的 200ms 过渡

### 向后兼容性

所有 GWT 生成的类名都保持不变，确保：
- ✅ 功能完全不受影响
- ✅ JavaScript 交互正常工作
- ✅ 布局结构保持一致
- ✅ 现有定制不会破坏

## 🎨 自定义主题

如果你想自定义配色方案，只需修改 CSS 变量：

```css
:root {
  /* 修改主色调 */
  --md-sys-color-primary: #YOUR_COLOR;
  --md-sys-color-primary-container: #YOUR_LIGHT_COLOR;
  
  /* 修改次要色调 */
  --md-sys-color-secondary: #YOUR_COLOR;
  
  /* 其他颜色... */
}
```

### 推荐的配色工具
- **Material Theme Builder**: https://m3.material.io/theme-builder
- **Material Color Tool**: https://material.io/resources/color/

## 📊 性能影响

Material You UI 更新对性能的影响：

### 优点
- ✅ 使用 Web 字体（缓存后加载更快）
- ✅ CSS 动画（GPU 加速）
- ✅ 优化的阴影（使用 box-shadow）

### 字体加载
- Google Fonts 使用 CDN，全球加速
- 字体子集化，只加载需要的字符
- 支持字体显示策略（font-display: swap）

### 建议
- 首次加载可能稍慢（加载 Roboto 字体）
- 后续访问会从缓存加载，速度更快
- 可选择自托管字体以进一步优化

## 🚀 下一步

1. **深色模式**: 可以添加暗色主题支持
2. **主题切换**: 实现动态主题切换功能
3. **更多组件**: 升级更多 UI 组件到 MD3 风格
4. **动画增强**: 添加更多微交互动画

---

**设计标准**: Material Design 3 (Material You)  
**参考文档**: https://m3.material.io/  
**更新日期**: 2024年

如有任何问题或建议，欢迎提交 Issue 或 Pull Request！
