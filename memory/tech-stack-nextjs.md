# Next.js 通用 SaaS 技术栈

> 经过测试，可部署在任何平台，涵盖大多数 SaaS 需求

## 核心框架
- **Runtime**: Next.js (App Router)
- **Language**: TypeScript
- **Lint/Format**: Biome

## 数据层
- **Database ORM**: [Drizzle ORM](https://orm.drizzle.team/)
- **Auth**: [Better Auth](https://better-auth.com/)
- **Object Storage**: [S3](https://aws.amazon.com/s3/)

## 支付
- **Primary**: [Stripe](https://stripe.com/)
- **Alternative**: [Creem](https://creem.io/)

## 通讯
- **Email Templates**: [React Email](https://react.email/)
- **Email Service**: [Resend](https://resend.com/)

## 内容
- **Blog/CMS**: [MDX](https://mdxjs.com/) + [Fumadocs MDX](https://fumadocs.dev/docs/mdx)
- **Documentation**: [Fumadocs](https://fumadocs.dev/) with search

## 国际化 & 主题
- **i18n**: [Next-intl](https://next-intl.dev/)
- **Dark Mode**: [Next-themes](https://github.com/pacocoursey/next-themes)

## 分析
- **Cookie Consent**: [vanilla-cookieconsent](https://github.com/orestbida/cookieconsent)
- **Google Analytics**: [GA](https://analytics.google.com/)
- **Open Source**: [Umami](https://umami.is/)
- **Privacy-first**: [Plausible](https://plausible.io/)

## UI/UX
- **CSS**: [Tailwind CSS](https://tailwindcss.com/)
- **Components**: [Shadcn/UI](https://ui.shadcn.com/)
- **Primitives**: [Radix UI](https://www.radix-ui.com/)
- **Animation**: [Framer Motion](https://www.framer.com/motion/)

## 状态管理
- **Global State**: [Zustand](https://github.com/pmndrs/zustand)
- **Server State**: [TanStack Query](https://tanstack.com/query/latest)
- **Forms**: [React Hook Form](https://react-hook-form.com/)

## 类型安全
- **Runtime Validation**: [Zod](https://zod.dev/)
- **Static Types**: Full TypeScript

---

## 部署兼容性
✅ Vercel
✅ Cloudflare Pages
✅ Netlify
✅ Railway
✅ 自托管 (Docker)
✅ VPS (PM2/Systemd)
