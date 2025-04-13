import 'package:flutter/material.dart';
import '../models/score_item.dart';
import '../models/score_dao.dart';
import '../models/collection_dao.dart';
import 'score_detail_page.dart';
import '../models/collection_info_dao.dart';
import '../models/collection_item_dao.dart';


class CollectionDetailPage extends StatefulWidget {
  final Map<String, dynamic> collection;
  const CollectionDetailPage({required this.collection});

  @override
  State<CollectionDetailPage> createState() => _CollectionDetailPageState();
}

class _CollectionDetailPageState extends State<CollectionDetailPage> {
  List<ScoreItem> scoreList = [];

  @override
  void initState() {
    super.initState();
    loadScores();
  }

  void loadScores() async {
    final collectionId = widget.collection['Collectionid'];
    print("🧭 当前查询 CollectionId: $collectionId");

    // 打印所有 CollectionItem 表数据
    await CollectionItemDao.debugPrintAllCollectionItems();

    // 打印所有 Score 表数据
    await ScoreDao.debugPrintAllScores();

    final items = await CollectionItemDao.fetchScoresInCollection(collectionId);
    print("🎯 查询谱集内曲谱数量: ${items.length}");

    setState(() {
      scoreList = items;
    });
  }

  void navigateToScoreDetail(ScoreItem item) {
    ScoreDao.updateAccessTime(item.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScoreDetailPage(scoreItem: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('谱集内容')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          itemCount: scoreList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final item = scoreList[index];
            return GestureDetector(
              onTap: () => navigateToScoreDetail(item),
              child: Column(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(item.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 110,
                    child: Text(
                      item.name,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
