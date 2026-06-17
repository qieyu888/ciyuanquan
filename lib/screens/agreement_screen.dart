import 'package:flutter/material.dart';
import '../utils/constants.dart';

// ─────────────────────────────────────────────
// 协议类型
// ─────────────────────────────────────────────
enum AgreementType { privacy, user }

// ─────────────────────────────────────────────
// 本地协议文案
// ─────────────────────────────────────────────
const _privacyContent = [
  _Section('一、信息收集', '''
次元圈（以下简称"本应用"）在您使用服务过程中，可能收集以下信息：

• 注册信息：用户名、密码（加密存储）、头像等基本资料。
• 设备信息：设备型号、操作系统版本、唯一设备标识符，用于保障账号安全。
• 使用数据：您发布的内容、互动记录（点赞、评论、收藏），以便为您提供个性化服务。
• 图片权限：仅在您主动上传图片时申请，不会在后台读取您的相册。

本应用不会收集您的精确地理位置信息。'''),

  _Section('二、信息使用', '''
我们将所收集的信息用于以下目的：

• 提供、维护和改进本应用的核心功能；
• 展示与您兴趣相关的内容；
• 预防违规行为，保障平台安全；
• 回应您的反馈与投诉请求。

我们不会将您的个人信息出售给任何第三方。'''),

  _Section('三、信息存储与安全', '''
• 您的个人信息存储于安全的服务器，采用业界标准加密措施保护。
• 我们设有严格的内部访问控制，限制员工对用户数据的访问权限。
• 若发生数据安全事件，我们将依法及时通知受影响用户。'''),

  _Section('四、信息共享', '''
我们不会将您的个人信息共享给任何第三方，以下情况除外：

• 您明确同意的情况；
• 遵守适用法律法规、法院命令或政府机构要求；
• 保护本应用及其用户的合法权益。'''),

  _Section('五、用户权利', '''
您对自己的个人信息享有以下权利：

• 查阅权：随时查看您的账号资料；
• 更正权：修改不准确的个人信息；
• 删除权：申请注销账号，我们将在 15 个工作日内完成处理；
• 撤回同意：可随时在设置中撤回对特定权限的授权。

如需行使上述权利，请通过应用内反馈功能联系我们。'''),

  _Section('六、未成年人保护', '''
本应用适合 16 周岁及以上用户使用。若您是未成年人，请在监护人陪同下阅读并同意本协议，我们将依法对未成年人信息给予特殊保护。'''),

  _Section('七、隐私政策更新', '''
我们可能不定期更新本隐私政策。重大变更将通过应用内通知或弹窗告知您，继续使用本应用即视为您同意更新后的政策。

本政策最后更新日期：2025 年 1 月 1 日'''),
];

const _userContent = [
  _Section('一、服务说明', '''
次元圈是一款面向二次元文化爱好者的社区应用，为用户提供内容分享、手办交流、发现同好等功能。使用本服务前，请仔细阅读并同意本用户协议。'''),

  _Section('二、账号注册与使用', '''
• 您需提供真实、准确的注册信息，并对账号的所有操作行为负责。
• 禁止将账号出租、出售或转让给他人使用。
• 若发现账号异常或被盗，应立即通过应用内渠道联系我们。
• 长期（超过 180 天）未登录的账号，平台有权回收其用户名。'''),

  _Section('三、用户行为规范', '''
使用本应用时，您承诺不进行以下行为：

• 发布违反国家法律法规的内容；
• 传播色情、暴力、歧视性或侵权内容；
• 恶意骚扰、辱骂或威胁其他用户；
• 散布虚假信息或从事任何欺诈行为；
• 使用技术手段干扰平台正常运营；
• 未经授权抓取、复制平台内容。

违反上述规定者，平台有权采取警告、限流、封号等处理措施。'''),

  _Section('四、内容版权', '''
• 您在本应用发布的内容（文字、图片等），版权归您所有。
• 发布即授予平台在全球范围内免费、非独家地展示、传播该内容的权利。
• 您保证所发布内容不侵犯任何第三方的知识产权，否则由此产生的法律责任由您自行承担。
• 平台内其他用户的原创内容受版权保护，未经许可不得转载或商业使用。'''),

  _Section('五、禁止转载与商业使用', '''
未经平台书面授权，禁止将本应用内容用于任何商业目的，包括但不限于：

• 出售、授权或再分发平台内容；
• 将平台内容用于广告或商业推广。'''),

  _Section('六、免责声明', '''
• 本应用按"现状"提供服务，不对服务的连续性或无错误性作出保证。
• 因不可抗力（包括自然灾害、网络故障等）导致的服务中断，平台不承担责任。
• 用户与其他用户之间的纠纷，由当事人自行协商解决，平台不承担连带责任。'''),

  _Section('七、协议变更', '''
我们保留修改本协议的权利，修改后将通过应用内通知告知用户。继续使用本应用视为同意变更后的协议。

如有疑问，请通过应用内「意见反馈」功能联系我们。

本协议最后更新日期：2025 年 1 月 1 日'''),
];

// ─────────────────────────────────────────────
// 内部数据类
// ─────────────────────────────────────────────
class _Section {
  final String title;
  final String content;
  const _Section(this.title, this.content);
}

// ─────────────────────────────────────────────
// 协议展示页面
// ─────────────────────────────────────────────
class AgreementScreen extends StatelessWidget {
  final AgreementType type;

  const AgreementScreen({super.key, required this.type});

  String get _title =>
      type == AgreementType.privacy ? '隐私协议' : '用户需知';

  List<_Section> get _sections =>
      type == AgreementType.privacy ? _privacyContent : _userContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(_title, style: AppTextStyles.headline2),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // 顶部说明卡
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEC7BA8), Color(0xFFB39DDB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                Icon(
                  type == AgreementType.privacy
                      ? Icons.privacy_tip_outlined
                      : Icons.description_outlined,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '次元圈 · $_title',
                        style: AppTextStyles.labelLarge
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '请仔细阅读以下条款，使用即视为同意',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 各章节
          ..._sections.map((s) => _SectionCard(section: s)),

          const SizedBox(height: AppSpacing.xxl),

          // 底部返回按钮
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEC7BA8), Color(0xFFB39DDB)],
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Center(
                child: Text(
                  '我已阅读并了解',
                  style: AppTextStyles.labelLarge
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 章节卡片
// ─────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final _Section section;
  const _SectionCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [AppShadows.sm],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(section.title,
                  style: AppTextStyles.labelLarge
                      .copyWith(color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // 内容
          Text(
            section.content,
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.7,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
