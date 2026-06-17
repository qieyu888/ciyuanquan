import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/block_service.dart';
import 'figure_detail_screen.dart';

// ─────────────────────────────────────────────
// 数据模型
// ─────────────────────────────────────────────
class FigurePost {
  final int id;
  final String userName;
  final String userAvatar; // 本地头像路径 或 emoji
  final String figureName;
  final String series;
  final String? imageAsset; // null → 纯文案封面
  final Color bgColor;
  final String desc;
  final String time;
  int likes;
  int comments;
  bool isLiked;
  bool isFavorited;

  FigurePost({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.figureName,
    required this.series,
    this.imageAsset,
    required this.bgColor,
    required this.desc,
    required this.time,
    required this.likes,
    required this.comments,
    this.isLiked = false,
    this.isFavorited = false,
  });

  FigurePost copyWith({
    int? likes,
    int? comments,
    bool? isLiked,
    bool? isFavorited,
  }) =>
      FigurePost(
        id: id,
        userName: userName,
        userAvatar: userAvatar,
        figureName: figureName,
        series: series,
        imageAsset: imageAsset,
        bgColor: bgColor,
        desc: desc,
        time: time,
        likes: likes ?? this.likes,
        comments: comments ?? this.comments,
        isLiked: isLiked ?? this.isLiked,
        isFavorited: isFavorited ?? this.isFavorited,
      );
}

// ─────────────────────────────────────────────
// Mock 数据
// ─────────────────────────────────────────────
final List<FigurePost> _mockFigures = [
  FigurePost(
    id: 1,
    userName: '听不见',
    userAvatar: 'assets/images/tx_g.jpg',
    figureName: '初音未来 2024 Anniversary Ver.',
    series: '初音未来',
    imageAsset: 'assets/images/img_i.jpg',
    bgColor: const Color(0xFFB2EBF2),
    desc: '终于等到这款！蓝色透明裙摆细节超绝，立体分层做得相当扎实，底座水晶感十足。拿到手比官图更好看，真的超出预期😭 推荐所有初音粉入手！',
    time: '10分钟前',
    likes: 86,
    comments: 5,
  ),
  FigurePost(
    id: 2,
    userName: '奶茶去冰',
    userAvatar: 'assets/images/tx_h.jpg',
    figureName: '五条悟 领域展开 特装版',
    series: '咒术回战',
    imageAsset: 'assets/images/img_b.jpg',
    bgColor: const Color(0xFFEDE7F6),
    desc: '六眼的蓝色真的会发光！做旧质感的衬衫纹理超细腻，白发配蒙眼布的设计完美还原。站姿霸气侧漏，帅到下巴要掉了。附赠领域展开特效底座🔮',
    time: '32分钟前',
    likes: 134,
    comments: 6,
    isLiked: true,
    isFavorited: true,
  ),
  FigurePost(
    id: 3,
    userName: '草莓大福',
    userAvatar: 'assets/images/tx_a.jpg',
    figureName: '娜娜奇 森林小屋场景版',
    series: '来自深渊',
    imageAsset: 'assets/images/img_e.jpg',
    bgColor: const Color(0xFFDCEDC8),
    desc: '场景底座里的苔藓和蘑菇每一颗都是手工上色，精细程度超出手办应有的水准。娜娜奇的毛茸茸耳朵摸起来有绒面质感，摆在书桌上治愈感爆棚✨ 绝对值回票价。',
    time: '1小时前',
    likes: 67,
    comments: 4,
  ),
  FigurePost(
    id: 4,
    userName: '月光不暖',
    userAvatar: 'assets/images/tx_f.jpg',
    figureName: '零二 Darling 限定版',
    series: 'DARLING in the FranXX',
    imageAsset: 'assets/images/img_d.jpg',
    bgColor: const Color(0xFFFCE4EC),
    desc: '头发的红粉渐变处理得太自然了，完全没有明显色差。裙摆上有细小的蕾丝暗纹，头上的角做成了半透明树脂效果，迎光看超级好看。面部妆容精致，嘴角那一点微笑很传神！',
    time: '2小时前',
    likes: 201,
    comments: 6,
  ),
  FigurePost(
    id: 5,
    userName: '单向箭头',
    userAvatar: 'assets/images/tx_bb.jpg',
    figureName: 'RX-78-2 元祖高达 MG Ver.3.0',
    series: '机动战士高达',
    imageAsset: 'assets/images/img_g.jpg',
    bgColor: const Color(0xFFE3F2FD),
    desc: '拼了整整两周终于完工！内部框架比例精准，关节可动范围很大，各部位拼合卡榫严密不松动。变形功能流畅无掉件，上色后整体质感拉满。入门级高达模型强烈推荐这款！',
    time: '3小时前',
    likes: 95,
    comments: 5,
  ),
  FigurePost(
    id: 6,
    userName: 'Lullaby',
    userAvatar: 'assets/images/tx_f.jpg',
    figureName: '爱丽丝 梦境茶会场景版',
    series: '爱丽丝梦游仙境',
    imageAsset: null,
    bgColor: const Color(0xFFFFF8E1),
    desc: '茶杯和茶壶都是单独可拆卸的小道具，拇指甲大小的茶具做工居然如此精致。手部姿势和神情做得温柔又可爱，搭配整体奶油色系超级和谐。书架或梳妆台必备单品！',
    time: '5小时前',
    likes: 112,
    comments: 4,
    isLiked: true,
  ),
  FigurePost(
    id: 7,
    userName: '云边小卖部',
    userAvatar: 'assets/images/tx_cc.jpg',
    figureName: '钟离 岩神战甲版',
    series: '原神',
    imageAsset: 'assets/images/img_c.jpg',
    bgColor: const Color(0xFFE8EAF6),
    desc: '原神手办里少见的男性角色精品！战甲每块金属甲片都有做旧描边处理，岩元素特效底座有琥珀感。配套护盾道具可以单独摆放，武器拄地的姿势霸气感十足，神明气质完全拿捏。',
    time: '昨天',
    likes: 58,
    comments: 5,
  ),
  FigurePost(
    id: 8,
    userName: '保持距离',
    userAvatar: 'assets/images/tx_aa.jpg',
    figureName: '雷电将军 雷神战姿版',
    series: '原神',
    imageAsset: 'assets/images/img_j.jpg',
    bgColor: const Color(0xFFEDE7F6),
    desc: '等了整整半年终于到货！开箱那一刻真的震惊了，紫色闪光金属漆面效果绝美，面部雕刻细腻传神，雷刀刃部做成了半透明蓝紫渐变树脂。和服腰带布料感极强，永恒梦核的气质完全复现！',
    time: '昨天',
    likes: 176,
    comments: 6,
  ),
  FigurePost(
    id: 9,
    userName: '风信子',
    userAvatar: 'assets/images/tx_a.jpg',
    figureName: '炭治郎 水之呼吸 战斗版',
    series: '鬼灭之刃',
    imageAsset: 'assets/images/img_a.jpg',
    bgColor: const Color(0xFFE0F7FA),
    desc: '水之呼吸特效做成了UV树脂透明效果，蓝色流动感超逼真。市松纹羽织还原极高，面部表情坚毅传神。底座是鬼杀队总本山的竹林场景，超级用心。限定版附赠禰豆子竹篓道具🎋',
    time: '2天前',
    likes: 143,
    comments: 5,
  ),
  FigurePost(
    id: 10,
    userName: '贝贝',
    userAvatar: 'assets/images/tx_ff.jpg',
    figureName: '艾伦·耶格尔 巨人化版',
    series: '进击的巨人',
    imageAsset: null,
    bgColor: const Color(0xFFFFE0B2),
    desc: '巨人化特效底座用了渐变烟雾树脂，蒸汽感拉满。人物部分真人化比例极其精准，蒸汽和肌肉线条的细节刻画震撼。调查兵团斗篷布料做了做旧染色处理，超还原最终季风格！',
    time: '3天前',
    likes: 89,
    comments: 5,
  ),
];

// ─────────────────────────────────────────────
// 主页面
// ─────────────────────────────────────────────
class AnimeScreen extends StatefulWidget {
  const AnimeScreen({super.key});

  @override
  State<AnimeScreen> createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<FigurePost> _figures;
  final BlockService _blockService = BlockService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _figures = List.from(_mockFigures);
    _blockService.addListener(_onBlockChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _blockService.removeListener(_onBlockChanged);
    super.dispose();
  }

  void _onBlockChanged() => setState(() {});

  List<FigurePost> get _visibleFigures => _figures
      .where((f) =>
          !_blockService.isPostHidden(f.id) &&
          !_blockService.isUserBlocked(f.id))
      .toList();

  void _toggleLike(int id) {
    setState(() {
      final i = _figures.indexWhere((f) => f.id == id);
      if (i != -1) {
        final f = _figures[i];
        _figures[i] = f.copyWith(
          isLiked: !f.isLiked,
          likes: f.isLiked ? f.likes - 1 : f.likes + 1,
        );
      }
    });
  }

  void _toggleFavorite(int id) {
    setState(() {
      final i = _figures.indexWhere((f) => f.id == id);
      if (i != -1) {
        final f = _figures[i];
        _figures[i] = f.copyWith(isFavorited: !f.isFavorited);
      }
    });
  }

  void _updateComments(int id, int count) {
    setState(() {
      final i = _figures.indexWhere((f) => f.id == id);
      if (i != -1) {
        _figures[i] = _figures[i].copyWith(comments: count);
      }
    });
  }

  void _openDetail(FigurePost figure) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FigureDetailScreen(
          figure: figure,
          onLike: () => _toggleLike(figure.id),
          onFavorite: () => _toggleFavorite(figure.id),
          onCommentsChanged: (count) => _updateComments(figure.id, count),
        ),
      ),
    ).then((result) {
      if (result == 'blocked') setState(() {});
    });
  }

  void _showPublishSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PublishSheet(
        onPublish: (post) {
          setState(() => _figures.insert(0, post));
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('晒单成功 🎉')),
          );
        },
        nextId: _figures.length + 100,
      ),
    );
  }

  List<FigurePost> get _favorited =>
      _visibleFigures.where((f) => f.isFavorited).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('手办圈', style: AppTextStyles.headline2),
        centerTitle: true,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: _showPublishSheet,
            tooltip: '晒手办',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textTertiary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 2.5,
          tabs: const [
            Tab(text: '广场'),
            Tab(text: '晒单'),
            Tab(text: '收藏'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _FigureList(
            figures: _visibleFigures,
            onLike: _toggleLike,
            onFavorite: _toggleFavorite,
            onTap: _openDetail,
          ),
          _PostGuide(onTap: _showPublishSheet),
          _FigureList(
            figures: _favorited,
            onLike: _toggleLike,
            onFavorite: _toggleFavorite,
            onTap: _openDetail,
            emptyText: '还没有收藏，去广场逛逛吧～',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 手办列表
// ─────────────────────────────────────────────
class _FigureList extends StatelessWidget {
  final List<FigurePost> figures;
  final void Function(int) onLike;
  final void Function(int) onFavorite;
  final void Function(FigurePost) onTap;
  final String emptyText;

  const _FigureList({
    required this.figures,
    required this.onLike,
    required this.onFavorite,
    required this.onTap,
    this.emptyText = '暂无内容',
  });

  @override
  Widget build(BuildContext context) {
    if (figures.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🪆', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(emptyText, style: AppTextStyles.bodySmall),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 80),
      itemCount: figures.length,
      itemBuilder: (_, i) => _FigureCard(
        figure: figures[i],
        onLike: () => onLike(figures[i].id),
        onFavorite: () => onFavorite(figures[i].id),
        onTap: () => onTap(figures[i]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 手办卡片
// ─────────────────────────────────────────────
class _FigureCard extends StatelessWidget {
  final FigurePost figure;
  final VoidCallback onLike;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  const _FigureCard({
    required this.figure,
    required this.onLike,
    required this.onFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [AppShadows.sm],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 封面区 ──
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.lg),
                topRight: Radius.circular(AppRadius.lg),
              ),
              child: figure.imageAsset != null
                  ? Image.asset(
                      figure.imageAsset!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _TextCover(figure: figure),
                    )
                  : _TextCover(figure: figure),
            ),

            // ── 内容区 ──
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 用户行
                  Row(
                    children: [
                      _AvatarWidget(
                          avatar: figure.userAvatar, bg: figure.bgColor),
                      const SizedBox(width: AppSpacing.sm),
                      Text(figure.userName,
                          style: AppTextStyles.labelMedium),
                      const Spacer(),
                      Text(figure.time, style: AppTextStyles.bodySmall),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // 手办名称
                  Text(figure.figureName,
                      style: AppTextStyles.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),

                  // 系列标签
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: figure.bgColor,
                      borderRadius:
                          BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      figure.series,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.primaryDark),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // 描述（列表页截断）
                  Text(figure.desc,
                      style: AppTextStyles.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: AppSpacing.md),

                  // 操作栏
                  Row(
                    children: [
                      _ActionBtn(
                        icon: figure.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        label: '${figure.likes}',
                        color: figure.isLiked
                            ? AppColors.primary
                            : AppColors.textTertiary,
                        onTap: onLike,
                      ),
                      const SizedBox(width: AppSpacing.xl),
                      _ActionBtn(
                        icon: Icons.chat_bubble_outline,
                        label: '${figure.comments}',
                        color: AppColors.textTertiary,
                        onTap: onTap,
                      ),
                      const Spacer(),
                      _ActionBtn(
                        icon: figure.isFavorited
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        label: figure.isFavorited ? '已收藏' : '收藏',
                        color: figure.isFavorited
                            ? const Color(0xFFFF9800)
                            : AppColors.textTertiary,
                        onTap: onFavorite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 无图时纯文案封面
// ─────────────────────────────────────────────
class _TextCover extends StatelessWidget {
  final FigurePost figure;
  const _TextCover({required this.figure});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      color: figure.bgColor,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(figure.figureName,
              style: AppTextStyles.headline3,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text('系列：${figure.series}', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 头像组件（支持本地图或 emoji）
// ─────────────────────────────────────────────
class _AvatarWidget extends StatelessWidget {
  final String avatar;
  final Color bg;
  const _AvatarWidget({required this.avatar, required this.bg});

  @override
  Widget build(BuildContext context) {
    if (!avatar.contains('/')) {
      return CircleAvatar(
        radius: 16,
        backgroundColor: bg,
        child: Text(avatar, style: const TextStyle(fontSize: 16)),
      );
    }
    return CircleAvatar(
      radius: 16,
      backgroundColor: AppColors.primaryLight,
      backgroundImage: AssetImage(avatar),
    );
  }
}

// ─────────────────────────────────────────────
// 操作按钮
// ─────────────────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: AppTextStyles.bodySmall.copyWith(color: color)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 晒单引导页
// ─────────────────────────────────────────────
class _PostGuide extends StatelessWidget {
  final VoidCallback onTap;
  const _PostGuide({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🪆', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 16),
          Text('晒出你的宝贝手办！', style: AppTextStyles.headline3),
          const SizedBox(height: 8),
          Text(
            '分享摆拍照片、入手感想、开箱评测\n让同好看到你的珍藏',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEC7BA8), Color(0xFFB39DDB)],
                ),
                borderRadius: BorderRadius.circular(AppRadius.full),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                '立即晒单',
                style:
                    AppTextStyles.labelLarge.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 发布 BottomSheet
// ─────────────────────────────────────────────
class _PublishSheet extends StatefulWidget {
  final void Function(FigurePost) onPublish;
  final int nextId;

  const _PublishSheet({required this.onPublish, required this.nextId});

  @override
  State<_PublishSheet> createState() => _PublishSheetState();
}

class _PublishSheetState extends State<_PublishSheet> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  final _seriesList = [
    '初音未来', '咒术回战', '鬼灭之刃', '进击的巨人',
    '来自深渊', '高达', '原神', '其他',
  ];
  String _selectedSeries = '其他';

  final _bgColors = [
    const Color(0xFFB2EBF2),
    const Color(0xFFEDE7F6),
    const Color(0xFFDCEDC8),
    const Color(0xFFFCE4EC),
    const Color(0xFFE3F2FD),
    const Color(0xFFFFF8E1),
  ];
  int _selectedBgIdx = 0;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请填写手办名称')));
      return;
    }
    widget.onPublish(FigurePost(
      id: widget.nextId,
      userName: '我',
      userAvatar: 'assets/images/tx_e.jpg',
      figureName: _nameCtrl.text.trim(),
      series: _selectedSeries,
      imageAsset: null,
      bgColor: _bgColors[_selectedBgIdx],
      desc: _descCtrl.text.trim().isEmpty ? '暂无描述' : _descCtrl.text.trim(),
      time: '刚刚',
      likes: 0,
      comments: 0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg,
          AppSpacing.lg, AppSpacing.lg + bottomPadding),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl),
          topRight: Radius.circular(AppRadius.xl),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('晒出我的手办 🪆', style: AppTextStyles.headline3),
            const SizedBox(height: AppSpacing.xl),

            _Label('手办名称'),
            _Field(ctrl: _nameCtrl, hint: '例：初音未来 2024 Anniversary Ver.'),
            const SizedBox(height: AppSpacing.lg),

            _Label('所属系列'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _seriesList.map((s) {
                final selected = _selectedSeries == s;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSeries = s),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : AppColors.greyLight,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.divider,
                      ),
                    ),
                    child: Text(
                      s,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: selected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            _Label('卡片配色'),
            Row(
              children: _bgColors.asMap().entries.map((e) {
                final selected = _selectedBgIdx == e.key;
                return GestureDetector(
                  onTap: () => setState(() => _selectedBgIdx = e.key),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: e.value,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            _Label('晒单感受（选填）'),
            _Field(ctrl: _descCtrl, hint: '说说开箱感受、细节亮点…', maxLines: 3),
            const SizedBox(height: AppSpacing.xxl),

            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: _submit,
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
                      '发布晒单',
                      style:
                          AppTextStyles.labelLarge.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 小工具
// ─────────────────────────────────────────────
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: AppTextStyles.labelMedium
                .copyWith(fontWeight: FontWeight.w600)),
      );
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final int maxLines;

  const _Field({
    required this.ctrl,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        style:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodySmall
              .copyWith(color: AppColors.textTertiary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.md),
        ),
      ),
    );
  }
}
