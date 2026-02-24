---
name: frontend-design
description: Senior UI/UX Engineer. 前端设计避坑指南，覆盖设计规范、动效技巧、布局模式、反 AI 套路清单。做前端设计时必须参考。
---

# 前端设计技能指南

## 1. 核心设计维度

**三维度调节（默认值）：**
- **DESIGN_VARIANCE: 8** (1=对称，10=艺术混乱)
- **MOTION_INTENSITY: 6** (1=静态，10=电影级物理)
- **VISUAL_DENSITY: 4** (1=画廊/通透，10=驾驶舱/密集)

根据用户请求动态调整这些值。

## 2. 技术规范

### 依赖检查 [强制]
- 使用第三方库前**必须**检查 `package.json`
- 缺失时先输出安装命令（如 `npm install package-name`）

### 框架选择
- React/Next.js，默认 Server Components (RSC)
- 交互组件用 `'use client'` 隔离
- 全局状态仅在 Client Components 中工作

### 样式策略
- Tailwind CSS (v3/v4)，**注意版本兼容性**
  - v4: 使用 `@tailwindcss/postcss`，不在 postcss.config.js 中用 tailwindcss 插件
- **禁止 emoji**，用高质量图标替代（Radix, Phosphor）
- **不用 `h-screen`**，用 `min-h-[100dvh]`（防止移动端布局跳动）
- Grid 优于 Flex 复杂计算（`grid grid-cols-1 md:grid-cols-3 gap-6`）

### 响应式规范
- 标准断点：`sm`, `md`, `lg`, `xl`
- 页面容器：`max-w-[1400px] mx-auto` 或 `max-w-7xl`
- 移动端折叠：高方差设计必须在 `<768px` 时单列布局

### 图标
- 必须使用 `@phosphor-icons/react` 或 `@radix-ui/react-icons`
- 全局统一 `strokeWidth`（1.5 或 2.0）

## 3. 设计工程指令（纠正 LLM 偏见）

### Rule 1: 字体
- **Display/Headlines:** `text-4xl md:text-6xl tracking-tighter leading-none`
- **ANTI-SLOP:** 禁止 `Inter` 用于"Premium"或"Creative"风格
- **推荐:** `Geist`, `Outfit`, `Cabinet Grotesk`, `Satoshi`
- **Dashboard 禁止 Serif**，仅用 Sans-Serif（Geist + Geist Mono, Satoshi + JetBrains Mono）
- **Body:** `text-base text-gray-600 leading-relaxed max-w-[65ch]`

### Rule 2: 色彩
- 最多 1 个强调色，饱和度 < 80%
- **THE LILA BAN:** 禁止"AI Purple/Blue"美学
  - 无紫色按钮发光、无霓虹渐变
  - 用绝对中性底色（Zinc/Slate）+ 高对比单一强调色（Emerald, Electric Blue, Deep Rose）
- 全项目保持一个调色板，不在冷暖灰之间切换

### Rule 3: 布局多样化
- **ANTI-CENTER BIAS:** 当 `LAYOUT_VARIANCE > 4` 时，禁止居中 Hero/H1
- 强制使用：分屏（50/50）、左对齐内容/右对齐资产、非对称留白

### Rule 4: 材质与阴影
- **DASHBOARD HARDENING:** 当 `VISUAL_DENSITY > 7`，禁止通用卡片容器
- 用逻辑分组：`border-t`, `divide-y`，或纯负空间
- 卡片仅用于需要 elevation 传达层级时
- 阴影应着色到背景色调

### Rule 5: 交互状态 [强制]
LLM 默认生成静态成功状态，必须实现完整交互周期：
- **Loading:** 骨架屏匹配布局尺寸（避免通用圆形 spinner）
- **Empty States:** 美观的空状态指示如何填充数据
- **Error States:** 清晰的内联错误报告
- **Tactile Feedback:** `:active` 时用 `-translate-y-[1px]` 或 `scale-[0.98]` 模拟物理按压

### Rule 6: 表单模式
- Label 必须在 input 上方
- Helper text 可选但应存在于标记中
- Error text 在 input 下方
- 标准间距 `gap-2`

## 4. 创意主动性（反套路实现）

### Liquid Glass 折射
毛玻璃效果增强：
```css
backdrop-blur: ...;
border: 1px solid rgba(255,255,255,0.1);
box-shadow: inset 0 1px 0 rgba(255,255,255,0.1);
```

### Magnetic Micro-physics (MOTION_INTENSITY > 5)
按钮随鼠标微移：
- **CRITICAL:** 禁止用 React `useState`
- **必须**用 Framer Motion 的 `useMotionValue` 和 `useTransform`

### Perpetual Micro-Interactions (MOTION_INTENSITY > 5)
连续无限微动画（Pulse, Typewriter, Float, Shimmer, Carousel）
Spring 物理：`type: "spring", stiffness: 100, damping: 20`

### Layout Transitions
大量使用 Framer Motion 的 `layout` 和 `layoutId` props

### Staggered Orchestration
列表不用即时挂载，用 `staggerChildren` 或 CSS `animation-delay: calc(var(--index) * 100ms)`

## 5. 性能护栏

### DOM 成本
噪点/纹理滤镜仅用于 fixed, pointer-events-none 伪元素

### 硬件加速
**禁止**动画 `top`, `left`, `width`, `height`
**仅**动画 `transform` 和 `opacity`

### Z-Index 克制
不随意使用 `z-50` 或 `z-10`
仅用于系统层上下文（Sticky Navbar, Modal, Overlay）

## 6. AI 设计避坑清单 [关键]

### 视觉与 CSS
- ❌ 霓虹/外发光（box-shadow 发光或自动发光）
- ❌ 纯黑 `#000000`（用 Off-Black, Zinc-950, Charcoal）
- ❌ 过度饱和强调色
- ❌ 大标题渐变文字
- ❌ 自定义鼠标光标

### 字体
- ❌ **Inter 字体**（已过时）
- ✅ 推荐：Geist, Outfit, Cabinet Grotesk, Satoshi
- ❌ 过大 H1（用 weight 和 color 控制层级，不只是尺寸）
- ❌ Dashboard 上用 Serif

### 布局与间距
- ❌ 填充和边距不完美对齐
- ❌ **三列等宽卡片**（"3 equal cards horizontally" 功能行已禁止）
- ✅ 用 2 列 Zig-Zag、非对称网格、水平滚动

### 内容与数据（"Jane Doe" 效应）
- ❌ 通用姓名："John Doe", "Sarah Chan", "Jack Su"
- ❌ 通用头像：标准 SVG "蛋"或 Lucide 用户图标
- ❌ 假数字：99.99%, 50%, 1234567
- ✅ 用有机、杂乱的数据：47.2%, +1 (312) 847-1928
- ❌ Startup 套路名："Acme", "Nexus", "SmartFlow"
- ❌ AI 填充词："Elevate", "Seamless", "Unleash", "Next-Gen"
- ✅ 用具体动词

### 外部资源
- ❌ Unsplash 链接（会失效）
- ✅ 用 `https://picsum.photos/seed/{random_string}/800/600` 或 SVG UI Avatars
- ❌ shadcn/ui 默认状态
- ✅ 必须自定义 radii, colors, shadows

## 7. Bento 2.0 架构（现代 SaaS Dashboard）

### 核心设计哲学
- **Aesthetic:** 高端、极简、功能
- **Palette:** 背景 `#f9fafb`，卡片纯白 `#ffffff` + `border-slate-200/50`
- **Surfaces:** `rounded-[2.5rem]`，扩散阴影 `shadow-[0_20px_40px_-15px_rgba(0,0,0,0.05)]`
- **Typography:** Geist/Satoshi/Cabinet Grotesk，`tracking-tight`
- **Labels:** 标题和描述放在卡片**外部下方**，保持画廊式展示
- **Padding:** 卡片内 `p-8` 或 `p-10`

### 动画引擎规范（Perpetual Motion）
每个卡片必须包含**永久微交互**：
- **Spring Physics:** `type: "spring", stiffness: 100, damping: 20`
- **Layout Transitions:** 大量使用 `layout` 和 `layoutId`
- **Infinite Loops:** Pulse, Typewriter, Float, Carousel
- **Performance:** 用 `<AnimatePresence>` 包装动态列表
- **CRITICAL:** 永久动画必须 `React.memo` 并隔离在独立 Client Component

### 5 种卡片原型
1. **Intelligent List:** 无限自动排序循环，items 用 `layoutId` 交换位置
2. **Command Input:** 多步打字机效果，闪烁光标 + 处理状态闪烁
3. **Live Status:** 呼吸状态指示器 + 弹出通知徽章（Overshoot spring，停留 3 秒消失）
4. **Wide Data Stream:** 水平无限轮播 `x: ["0%", "-100%"]`，无缝循环
5. **Contextual UI (Focus Mode):** 文本块交错高亮 + 浮动工具栏 Float-in

## 8. 预检清单

代码输出前必须检查：
- [ ] 全局状态是否合理使用（避免深度 prop-drilling）
- [ ] 移动端布局是否保证折叠（`w-full`, `px-4`, `max-w-7xl mx-auto`）
- [ ] 全高 section 是否用 `min-h-[100dvh]` 而非 `h-screen`
- [ ] `useEffect` 动画是否包含严格清理函数
- [ ] 是否提供了 empty, loading, error 状态
- [ ] 卡片是否尽可能用间距替代
- [ ] CPU 密集型永久动画是否隔离在独立 Client Component

## 9. 创意武器库（高级灵感）

### 导航与菜单
- Mac OS Dock 放大效果
- Magnetic Button（物理拉向光标）
- Gooey Menu（子项像粘性液体分离）
- Dynamic Island（药丸形态显示状态/警报）
- Contextual Radial Menu（圆形菜单在点击坐标展开）
- Floating Speed Dial（FAB 弹出曲线排列的次要操作）
- Mega Menu Reveal（全屏下拉交错淡入复杂内容）

### 布局与网格
- Bento Grid（非对称瓷砖分组，Apple Control Center）
- Masonry Layout（瀑布流，Pinterest）
- Chroma Grid（网格边框或瓷砖显示微妙持续动画颜色渐变）
- Split Screen Scroll（滚动时两屏幕半反向滑动）
- Curtain Reveal（Hero 像窗帘一样向两边分开）

### 卡片与容器
- Parallax Tilt Card（3D 倾斜跟踪鼠标）
- Spotlight Border Card（边框在光标下动态发光）
- Glassmorphism Panel（真正磨砂玻璃 + 内折射边框）
- Holographic Foil Card（虹彩彩虹光反射随悬停变化）
- Tinder Swipe Stack（物理卡片堆，用户可滑动）
- Morphing Modal（按钮无缝扩展为全屏对话框）

### 滚动动画
- Sticky Scroll Stack（卡片固定顶部并物理堆叠）
- Horizontal Scroll Hijack（垂直滚动转水平画廊）
- Locomotive Scroll Sequence（帧率绑定滚动条的视频/3D 序列）
- Zoom Parallax（中心背景图片随滚动缩放）
- Scroll Progress Path（滚动时绘制的 SVG 矢量线）
- Liquid Swipe Transition（像粘性液体一样的页面过渡）

### 画廊与媒体
- Dome Gallery（3D 全景圆顶画廊）
- Coverflow Carousel（3D 轮播，中心聚焦边缘后倾）
- Drag-to-Pan Grid（可自由拖动的无限网格）
- Accordion Image Slider（悬停时展开的窄垂直/水平图片条）
- Hover Image Trail（鼠标留下弹出/淡出图片轨迹）
- Glitch Effect Image（悬停时 RGB 通道数字故障）

### 字体与文本
- Kinetic Marquee（滚动时无限文本带反向或加速）
- Text Mask Reveal（巨大字体作为视频背景透明窗口）
- Text Scramble Effect（Matrix 风格字符解码）
- Circular Text Path（沿旋转圆形路径弯曲的文字）
- Gradient Stroke Animation（渐变沿描边连续运行的轮廓文字）
- Kinetic Typography Grid（躲避或旋转远离光标的字母网格）

### 微交互与效果
- Particle Explosion Button（成功时 CTA 碎裂成粒子）
- Liquid Pull-to-Refresh（移动刷新指示器像水滴分离）
- Skeleton Shimmer（移动的偏移光反射穿过占位框）
- Directional Hover Aware Button（填充从鼠标进入侧进入）
- Ripple Click Effect（从点击坐标精确波纹）
- Animated SVG Line Drawing（实时绘制轮廓的矢量）
- Mesh Gradient Background（有机、熔岩灯风格动画颜色团）
- Lens Blur Depth（动态模糊背景 UI 层以突出前景动作）
