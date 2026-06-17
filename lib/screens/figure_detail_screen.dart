import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utils/constants.dart';
import '../services/block_service.dart';
import 'anime_screen.dart';

// ─────────────────────────────────────────────
// 每条帖子对应的评论，按 figureId 索引
// ─────────────────────────────────────────────
final Map<int, List<_Comment>> _figureComments = {
  // ── id:1  初音未来 2024 Anniversary Ver. ──
  1: [
    _Comment(avatar: 'assets/images/tx_b.jpg', name: '永恒', text: '蓝色透明裙摆那段是全新工艺吗？之前的版本没见过这种做法', time: '2分钟前'),
    _Comment(avatar: 'assets/images/tx_c.jpg', name: '浅浅风', text: '底座水晶感拍个特写！！我被种草了😭', time: '8分钟前'),
    _Comment(avatar: 'assets/images/tx_d.jpg', name: '南风知意', text: '官图差距大不大？我怕踩雷哈哈', time: '15分钟前'),
    _Comment(avatar: 'assets/images/tx_e.jpg', name: '森林萤火', text: '已经下单了！看你这帖子直接破防，等不及开箱了', time: '22分钟前'),
    _Comment(avatar: 'assets/images/tx_h.jpg', name: 'momoko', text: '立体分层这个工艺确实是今年新款的亮点，比2023版进步很多', time: '40分钟前'),
  ],

  // ── id:2  五条悟 领域展开 特装版 ──
  2: [
    _Comment(avatar: 'assets/images/tx_a.jpg', name: '风信子', text: '领域展开底座是发光的吗？店家说明写的不清楚', time: '5分钟前'),
    _Comment(avatar: 'assets/images/tx_c.jpg', name: '浅浅风', text: '蒙眼布是布料还是树脂？细节控很在意这个', time: '18分钟前'),
    _Comment(avatar: 'assets/images/tx_f.jpg', name: '月光不暖', text: '白发的发丝分层感好不好？上次买了个五条感觉发色太均匀了', time: '31分钟前'),
    _Comment(avatar: 'assets/images/tx_aa.jpg', name: '寒江', text: '做旧衬衫那个细节对比图有吗？想看看近拍', time: '55分钟前'),
    _Comment(avatar: 'assets/images/tx_bb.jpg', name: '脆皮粽子', text: '这款跟上一个五条对比，站姿确实更有气势！霸气++', time: '1小时前'),
    _Comment(avatar: 'assets/images/tx_cc.jpg', name: '静音', text: '特装版附件好多，感觉性价比还不错', time: '2小时前'),
  ],

  // ── id:3  娜娜奇 森林小屋场景版 ──
  3: [
    _Comment(avatar: 'assets/images/tx_d.jpg', name: '南风知意', text: '苔藓手工上色是工厂做的还是原作者自己涂的？太细了吧', time: '10分钟前'),
    _Comment(avatar: 'assets/images/tx_e.jpg', name: '森林萤火', text: '毛茸茸耳朵的绒面质感！这个触感描述我已经心动了', time: '25分钟前'),
    _Comment(avatar: 'assets/images/tx_g.jpg', name: '听不见', text: '来自深渊的手办质量参差不齐，这款做工算好的了', time: '40分钟前'),
    _Comment(avatar: 'assets/images/tx_hh.jpg', name: 'CN药药', text: '场景底座的蘑菇颜色和原作里一样吗？好想放到书桌上治愈一下', time: '1小时前'),
  ],

  // ── id:4  零二 Darling 限定版 ──
  4: [
    _Comment(avatar: 'assets/images/tx_a.jpg', name: '风信子', text: '渐变发色好不好看真的看厂商！这款红粉过渡有没有偏色问题', time: '8分钟前'),
    _Comment(avatar: 'assets/images/tx_b.jpg', name: '永恒', text: '头上的角半透明树脂迎光照一下！这个工艺我很好奇效果', time: '20分钟前'),
    _Comment(avatar: 'assets/images/tx_cc.jpg', name: '静音', text: '蕾丝暗纹近拍一张！感觉这才是体现做工精细程度的地方', time: '45分钟前'),
    _Comment(avatar: 'assets/images/tx_dd.jpg', name: 'momoko', text: '限定版和普通版除了底座还有什么区别？感觉贵了一大截', time: '1小时前'),
    _Comment(avatar: 'assets/images/tx_ee.jpg', name: '贝贝', text: '面部嘴角那个微笑！买手办最怕脸部表情拉了，这个看着还不错', time: '2小时前'),
    _Comment(avatar: 'assets/images/tx_ff.jpg', name: '幼儿园抢饭第一名', text: '终于有一款零二不是脸崩的，入了入了！', time: '3小时前'),
  ],

  // ── id:5  RX-78-2 元祖高达 MG Ver.3.0 ──
  5: [
    _Comment(avatar: 'assets/images/tx_g.jpg', name: '听不见', text: 'MG Ver.3.0 的关节结构和 Ver.2.0 对比有多大改变？', time: '15分钟前'),
    _Comment(avatar: 'assets/images/tx_h.jpg', name: 'momoko', text: '拼合卡榫严密不松动这点太关键了，上次买了个MG卡脚掉了一地😅', time: '30分钟前'),
    _Comment(avatar: 'assets/images/tx_aa.jpg', name: '寒江', text: '变形功能有没有说明书？第一次入门高达有点懵', time: '50分钟前'),
    _Comment(avatar: 'assets/images/tx_bb.jpg', name: '脆皮粽子', text: '上色自己喷的吗？还是成品就这样？看着效果挺好', time: '1小时20分钟前'),
    _Comment(avatar: 'assets/images/tx_cc.jpg', name: '静音', text: '内部框架精度确实是3.0的卖点，2.0的框架能感觉到工艺年代感', time: '2小时前'),
  ],

  // ── id:6  爱丽丝 梦境茶会场景版 ──
  6: [
    _Comment(avatar: 'assets/images/tx_d.jpg', name: '南风知意', text: '茶具道具可拆卸！！这种细节是真的在用心做，拍个茶壶特写', time: '12分钟前'),
    _Comment(avatar: 'assets/images/tx_e.jpg', name: '森林萤火', text: '奶油色系配色跟我书桌风格超搭，想放进去当摆件', time: '28分钟前'),
    _Comment(avatar: 'assets/images/tx_f.jpg', name: '月光不暖', text: '手部姿势捧茶那个动作自然不自然？有些手办手部比例会很奇怪', time: '1小时前'),
    _Comment(avatar: 'assets/images/tx_gg.jpg', name: 'cv阿越', text: '爱丽丝的发箍和围裙细节如何？官图看着很精致但怕是渲染效果', time: '2小时前'),
  ],

  // ── id:7  钟离 岩神战甲版 ──
  7: [
    _Comment(avatar: 'assets/images/tx_a.jpg', name: '风信子', text: '琥珀感底座拍出来效果差多少？打光会影响很大吗', time: '20分钟前'),
    _Comment(avatar: 'assets/images/tx_b.jpg', name: '永恒', text: '做旧描边工艺手涂的话很考验技术，这款是手涂还是贴纸？', time: '40分钟前'),
    _Comment(avatar: 'assets/images/tx_hh.jpg', name: 'CN药药', text: '原神男角手办终于有一款做工不敷衍的，之前那批真的很拉胯', time: '1小时前'),
    _Comment(avatar: 'assets/images/tx_aa.jpg', name: '寒江', text: '护盾道具单独摆放尺寸有多大？想了解一下比例', time: '昨天'),
    _Comment(avatar: 'assets/images/tx_bb.jpg', name: '脆皮粽子', text: '武器拄地姿势感觉比站立版更有存在感，选这个没错！', time: '昨天'),
  ],

  // ── id:8  雷电将军 雷神战姿版 ──
  8: [
    _Comment(avatar: 'assets/images/tx_c.jpg', name: '浅浅风', text: '紫色闪光漆面这种工艺叫珠光漆吗？效果真的绝，迎光变色的感觉', time: '30分钟前'),
    _Comment(avatar: 'assets/images/tx_d.jpg', name: '南风知意', text: '雷刀蓝紫渐变树脂！这种刀刃工艺好难做，拍实物光照效果', time: '55分钟前'),
    _Comment(avatar: 'assets/images/tx_f.jpg', name: '月光不暖', text: '和服腰带真的是布料感？还是涂层模拟的？这个很重要', time: '1小时20分钟前'),
    _Comment(avatar: 'assets/images/tx_gg.jpg', name: 'cv阿越', text: '等了半年真的很煎熬，我比你先下单但还没到😭 怎么发货这么慢', time: '2小时前'),
    _Comment(avatar: 'assets/images/tx_hh.jpg', name: 'CN药药', text: '面部雕刻传神这种评价很少听到，一般雷电将军都被说脸僵', time: '昨天'),
    _Comment(avatar: 'assets/images/tx_aa.jpg', name: '寒江', text: '箱子和外包装有没有收藏价值？原神手办的盒子设计一般都不错', time: '昨天'),
  ],

  // ── id:9  炭治郎 水之呼吸 战斗版 ──
  9: [
    _Comment(avatar: 'assets/images/tx_e.jpg', name: '森林萤火', text: 'UV树脂水之呼吸特效的蓝色有没有荧光感？灯光下效果一定超赞', time: '1小时前'),
    _Comment(avatar: 'assets/images/tx_g.jpg', name: '听不见', text: '市松纹羽织花纹是贴纸还是印刷？贴纸的话边缘会不会翘起来', time: '1小时40分钟前'),
    _Comment(avatar: 'assets/images/tx_h.jpg', name: 'momoko', text: '竹林底座的竹子颜色分层有没有？还是一个绿色？', time: '2小时前'),
    _Comment(avatar: 'assets/images/tx_cc.jpg', name: '静音', text: '禰豆子竹篓道具多大？能放在炭治郎背上吗', time: '2天前'),
    _Comment(avatar: 'assets/images/tx_dd.jpg', name: 'momoko', text: '面部表情坚毅这个形容词我最爱了，鬼灭手办最怕做成偶像脸', time: '2天前'),
  ],

  // ── id:10  艾伦·耶格尔 巨人化版 ──
  10: [
    _Comment(avatar: 'assets/images/tx_a.jpg', name: '风信子', text: '渐变烟雾树脂底座！这个工艺价格应该不便宜，整体质感一定很强', time: '2天前'),
    _Comment(avatar: 'assets/images/tx_b.jpg', name: '永恒', text: '调查兵团斗篷做旧效果是出厂自带的吗？还是自己后期处理的', time: '2天前'),
    _Comment(avatar: 'assets/images/tx_e.jpg', name: '森林萤火', text: '巨人化肌肉线条细节拍一下！这种写实感挑战工厂雕刻水平', time: '3天前'),
    _Comment(avatar: 'assets/images/tx_f.jpg', name: '月光不暖', text: '最终季风格就是对了，之前进击手办大多数是早期设定稿', time: '3天前'),
    _Comment(avatar: 'assets/images/tx_bb.jpg', name: '脆皮粽子', text: '蒸汽感底座摆放角度有讲究吗？侧面还是正面看更震撼', time: '3天前'),
  ],
};

class FigureDetailScreen extends StatefulWidget {
  final FigurePost figure;
  final VoidCallback onLike;
  final VoidCallback onFavorite;
  final void Function(int count)? onCommentsChanged;

  const FigureDetailScreen({
    super.key,
    required this.figure,
    required this.onLike,
    required this.onFavorite,
    this.onCommentsChanged,
  });

  @override
  State<FigureDetailScreen> createState() => _FigureDetailScreenState();
}

class _FigureDetailScreenState extends State<FigureDetailScreen> {
  final BlockService _blockService = BlockService();
  final TextEditingController _commentCtrl = TextEditingController();
  late List<_Comment> _comments;

  @override
  void initState() {
    super.initState();
    // 根据帖子 id 加载对应评论，找不到则空列表
    _comments = List.from(_figureComments[widget.figure.id] ?? []);
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _submitComment() {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.insert(
        0,
        _Comment(
          avatar: 'assets/images/tx_e.jpg',
          name: '我',
          text: text,
          time: '刚刚',
        ),
      );
    });
    // 通知列表页同步评论数
    widget.onCommentsChanged?.call(_comments.length);
    _commentCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.xl),
            topRight: Radius.circular(AppRadius.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.md),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _MenuTile(
              icon: Icons.block,
              iconBg: const Color(0xFFFFE5E5),
              iconColor: const Color(0xFFFF6B6B),
              title: '屏蔽此内容',
              subtitle: '不再看到此帖子',
              onTap: () {
                Navigator.pop(context);
                _blockService.hidePost(widget.figure.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已屏蔽该内容')),
                );
                Navigator.pop(context, 'blocked');
              },
            ),
            _MenuTile(
              icon: Icons.person_off,
              iconBg: const Color(0xFFFFE5E5),
              iconColor: const Color(0xFFFF6B6B),
              title: '拉黑用户',
              subtitle: '不再看到 ${widget.figure.userName} 的内容',
              onTap: () {
                Navigator.pop(context);
                _blockService.blockUser(widget.figure.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('已拉黑 ${widget.figure.userName}')),
                );
                Navigator.pop(context, 'blocked');
              },
            ),
            _MenuTile(
              icon: Icons.flag_outlined,
              iconBg: const Color(0xFFFFF5E5),
              iconColor: const Color(0xFFFFA500),
              title: '举报',
              subtitle: '举报不当内容',
              onTap: () {
                Navigator.pop(context);
                _showReportDialog();
              },
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  void _showReportDialog() {
    String content = '';
    String? imagePath;
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(AppSpacing.lg),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.xl),
                      topRight: Radius.circular(AppRadius.xl),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text('举报内容',
                          style: AppTextStyles.headline3
                              .copyWith(color: Colors.white)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // Body
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('举报「${widget.figure.figureName}」',
                          style: AppTextStyles.labelLarge),
                      const SizedBox(height: AppSpacing.lg),
                      Text('投诉内容', style: AppTextStyles.labelMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.greyLight,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: TextField(
                          onChanged: (v) => content = v,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: '请详细描述举报原因…',
                            hintStyle: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.textTertiary),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(AppSpacing.md),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text('上传截图（选填）', style: AppTextStyles.labelMedium),
                      const SizedBox(height: AppSpacing.sm),
                      if (imagePath != null)
                        Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: Image.file(File(imagePath!),
                                width: double.infinity,
                                height: 120,
                                fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: GestureDetector(
                              onTap: () => setS(() => imagePath = null),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ])
                      else
                        GestureDetector(
                          onTap: () async {
                            final f = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (f != null) setS(() => imagePath = f.path);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.greyLight,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined,
                                    color: AppColors.primary),
                                const SizedBox(height: 4),
                                Text('点击上传',
                                    style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
                  child: Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.divider),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.lg)),
                        ),
                        child: const Text('取消'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (content.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('请填写举报原因')));
                            return;
                          }
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('举报已提交，感谢反馈')));
                          Navigator.pop(context, 'blocked');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.lg)),
                        ),
                        child: const Text('提交举报',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.figure;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── 渐变顶部背景 ──
          Container(
            height: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.85),
                  AppColors.primary,
                ],
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              // 顶部操作栏
              SliverToBoxAdapter(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_horiz,
                              color: Colors.white),
                          onPressed: _showMoreMenu,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── 主卡片 ──
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.xxl,
                      AppSpacing.lg, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    boxShadow: AppShadows.card,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 封面图
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppRadius.xl),
                          topRight: Radius.circular(AppRadius.xl),
                        ),
                        child: f.imageAsset != null
                            ? Image.asset(
                                f.imageAsset!,
                                width: double.infinity,
                                height: 260,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _buildTextCover(f),
                              )
                            : _buildTextCover(f),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 用户行
                            Row(
                              children: [
                                _UserAvatar(
                                    avatar: f.userAvatar, bg: f.bgColor),
                                const SizedBox(width: AppSpacing.sm),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(f.userName,
                                        style: AppTextStyles.labelLarge),
                                    Text(f.time,
                                        style: AppTextStyles.bodySmall),
                                  ],
                                ),
                                const Spacer(),
                                // 系列标签
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: f.bgColor,
                                    borderRadius: BorderRadius.circular(
                                        AppRadius.full),
                                  ),
                                  child: Text(f.series,
                                      style: AppTextStyles.bodySmall
                                          .copyWith(
                                              color: AppColors.primaryDark)),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            // 名称
                            Text(f.figureName,
                                style: AppTextStyles.headline3),
                            const SizedBox(height: AppSpacing.md),

                            // 描述（完整显示）
                            Text(f.desc,
                                style: AppTextStyles.bodyMedium
                                    .copyWith(height: 1.6)),
                            const SizedBox(height: AppSpacing.xl),

                            // 操作行
                            Row(
                              children: [
                                _BigActionBtn(
                                  icon: f.isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  label: '${f.likes}',
                                  color: f.isLiked
                                      ? AppColors.primary
                                      : AppColors.textTertiary,
                                  onTap: () {
                                    widget.onLike();
                                    setState(() {});
                                  },
                                ),
                                const SizedBox(width: AppSpacing.xl),
                                _BigActionBtn(
                                  icon: Icons.chat_bubble_outline,
                                  label: '${_comments.length}',
                                  color: AppColors.textTertiary,
                                  onTap: () {},
                                ),
                                const Spacer(),
                                _BigActionBtn(
                                  icon: f.isFavorited
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  label: f.isFavorited ? '已收藏' : '收藏',
                                  color: f.isFavorited
                                      ? const Color(0xFFFF9800)
                                      : AppColors.textTertiary,
                                  onTap: () {
                                    widget.onFavorite();
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── 评论区 ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg,
                      AppSpacing.xl, AppSpacing.lg, AppSpacing.sm),
                  child: Text('评论 (${_comments.length})',
                      style: AppTextStyles.labelLarge),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _CommentTile(comment: _comments[i]),
                  childCount: _comments.length,
                ),
              ),
              const SliverToBoxAdapter(
                  child: SizedBox(height: 100)),
            ],
          ),

          // ── 底部评论输入框 ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.sm +
                    MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -3),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius:
                            BorderRadius.circular(AppRadius.full),
                      ),
                      child: TextField(
                        controller: _commentCtrl,
                        decoration: InputDecoration(
                          hintText: '发表评论…',
                          hintStyle: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textTertiary),
                          border: InputBorder.none,
                        ),
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: _submitComment,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextCover(FigurePost f) {
    return Container(
      width: double.infinity,
      height: 180,
      color: f.bgColor,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(f.figureName,
              style: AppTextStyles.headline3,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Text('系列：${f.series}', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

// ── 评论模型 ──────────────────────────────────
class _Comment {
  final String avatar;
  final String name;
  final String text;
  final String time;
  _Comment(
      {required this.avatar,
      required this.name,
      required this.text,
      required this.time});
}

// ── 评论卡片 ──────────────────────────────────
class _CommentTile extends StatelessWidget {
  final _Comment comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [AppShadows.sm],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage(comment.avatar),
            backgroundColor: AppColors.primaryLight,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(comment.name, style: AppTextStyles.labelMedium),
                    const Spacer(),
                    Text(comment.time, style: AppTextStyles.bodySmall),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment.text, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── 用户头像（支持本地图和emoji） ───────────────
class _UserAvatar extends StatelessWidget {
  final String avatar;
  final Color bg;
  const _UserAvatar({required this.avatar, required this.bg});

  @override
  Widget build(BuildContext context) {
    // 如果是 emoji（非路径）
    if (!avatar.contains('/')) {
      return CircleAvatar(
        radius: 18,
        backgroundColor: bg,
        child: Text(avatar, style: const TextStyle(fontSize: 18)),
      );
    }
    return CircleAvatar(
      radius: 18,
      backgroundColor: AppColors.primaryLight,
      backgroundImage: AssetImage(avatar),
    );
  }
}

// ── 大操作按钮 ────────────────────────────────
class _BigActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _BigActionBtn(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: AppTextStyles.bodySmall.copyWith(
                  color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── 菜单选项 ──────────────────────────────────
class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration:
                  BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.labelLarge),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
