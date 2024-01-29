import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/common/color_tool.dart';
import 'package:wows_kokomi_app/common/user_global.dart';
import 'package:wows_kokomi_app/models/auto_size_model.dart';
import 'package:wows_kokomi_app/models/enum_name.dart';
import 'package:wows_kokomi_app/models/ship_list_info.dart';

class ShipListPage extends StatefulWidget {
  final ServerName serverName;
  final String aid;

  const ShipListPage({Key? key, required this.aid, required this.serverName})
      : super(key: key);

  @override
  State<ShipListPage> createState() => _ShipListPageState();
}

class _ShipListPageState extends State<ShipListPage> {
  late Future<ShipListModel> _shipListFuture;
  List<Ship> shipList = [];
  List<Ship> filteredShips = [];
  List<Ship> allShips = [];
  bool _isFiltered = false;
  final ScrollController _scrollController = ScrollController();
  late final List<bool> _sortAscending = [true, true, true, true, true, true];
  @override
  void initState() {
    super.initState();
    _shipListFuture = _fetchShipList();
  }

  Future<ShipListModel> _fetchShipList() async {
    ShipListResponse response = ShipListResponse();
    await response.init(widget.serverName, widget.aid);
    return response.shipListModel!;
  }

  Future<void> _refreshShipList() async {
    setState(() {
      _shipListFuture = _fetchShipList();
    });
  }

  void _filterShips(
      {required List<int> tiers,
      required List<NationName> nations,
      required List<ShipTypeName> types,
      required List<Ship> ships}) {
    setState(() {
      _isFiltered = true;
      filteredShips = ships.where((ship) {
        NationName shipNation = nationNameMap[ship.shipInfo.nation]!;
        ShipTypeName shipType = shipTypeNameMap[ship.shipInfo.type]!;
        return tiers.contains(ship.shipInfo.tier) &&
            nations.contains(shipNation) &&
            types.contains(shipType);
      }).toList();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          onApply: (tiers, nations, types) {
            _filterShips(
                tiers: tiers, nations: nations, types: types, ships: allShips);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _sortShips(int sortIndex) async {
    for (int i = 0; i < _sortAscending.length; i++) {
      if (i != sortIndex) {
        _sortAscending[i] = true; // Reset all others to true
      }
    }
    _sortAscending[sortIndex] = !_sortAscending[sortIndex];
    Comparator<Ship> compareFunction;
    switch (sortIndex) {
      case 0:
        compareFunction = (a, b) => a.shipInfo.tier.compareTo(b.shipInfo.tier);
        break;
      case 1:
        compareFunction = (a, b) =>
            a.shipData.battlesCount.compareTo(b.shipData.battlesCount);
        break;
      case 2:
        compareFunction =
            (a, b) => a.shipData.winRate.compareTo(b.shipData.winRate);
        break;
      case 3:
        compareFunction =
            (a, b) => a.shipData.avgDamage.compareTo(b.shipData.avgDamage);
        break;
      case 4:
        compareFunction =
            (a, b) => a.shipData.avgPr.compareTo(b.shipData.avgPr);
        break;
      case 5:
        compareFunction =
            (a, b) => a.shipData.avgFrags.compareTo(b.shipData.avgFrags);
        break;
      default:
        throw ArgumentError('Invalid sort index.');
    }

    if (_sortAscending[sortIndex]) {
      shipList.sort(compareFunction);
    } else {
      shipList.sort((a, b) => compareFunction(b, a));
    }
    setState(() {
      _shipListFuture = Future.value(ShipListModel(
          data: {for (var ship in allShips) ship.shipInfo.nameEn: ship},
          status: 'ok',
          message: 'o'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultFront = FontSize.of(context, 0.05);
    final size8 = defaultFront * 0.75;
    final size7 = defaultFront * 0.78;
    final size2 = defaultFront * 0.65;
    return Scaffold(
        body: Stack(children: [
      Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshShipList,
              child: FutureBuilder<ShipListModel>(
                future: _shipListFuture,
                builder: (context, snapshot) {
                  
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('加载错误: ${snapshot.error}'));
                  } else {
                    allShips = snapshot.data!.data.values.toList();
                    if (_isFiltered) {
                      _isFiltered = false;
                      shipList = filteredShips;
                    }
                    if (shipList.isEmpty) {
                      shipList = allShips;
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: shipList.length,
                      itemBuilder: (context, index) {
                        final ship = shipList[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 15,
                          child: Column(
                            children: [
                              Expanded(
                                child: FutureBuilder<Image>(
                                  future: LocalStorage.getImage(
                                      ship.shipInfo.pngUrl),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<Image> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return snapshot.data ?? const SizedBox();
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.error != null) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return const Text('Unknown error');
                                    }
                                  },
                                ),
                              ),
                              Text(
                                  '${intToRoman(ship.shipInfo.tier)} ${ship.shipInfo.nameZh}', // 添加船只名字
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text('场数',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: size2)),
                                      Text('${ship.shipData.battlesCount}',
                                          style: TextStyle(
                                              fontSize: size7,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('胜率',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: size2)),
                                      Text('${ship.shipData.winRate}%',
                                          style: TextStyle(
                                              fontSize: size7,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('场均',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: size2)),
                                      Text('${ship.shipData.avgDamage}',
                                          style: TextStyle(
                                              fontSize: size7,
                                              color: Colors.black)),
                                    ],
                                  ),
                                ],
                              ),
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                child: Container(
                                  height: 30, // 增加颜色条的高度
                                  width: double.infinity,
                                  color: colorFromStr(ship.shipData.avgPrColor),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${strFromePR(ship.shipData.avgPr)}(+${ship.shipData.avgPrDis})',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: size8),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                List<String> buttonNames = ['等级', '场数', '胜率', '场均', 'PR', 'KD'];
                return TextButton(
                  onPressed: () => _sortShips(index),
                  child: Text(
                    buttonNames[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _sortAscending[index] ? Colors.black : Colors.blue,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      Positioned(
        top: 10,
        right: 10,
        child: FloatingActionButton(
          onPressed: _showFilterDialog,
          backgroundColor: Colors.grey,
          child: const Icon(Icons.filter_list, color: Colors.white),
        ),
      ),
    ]));
  }
}

class FilterDialog extends StatefulWidget {
  final Function(List<int>, List<NationName>, List<ShipTypeName>) onApply;

  const FilterDialog({Key? key, required this.onApply}) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final List<int> _selectedTiers = [];
  final List<NationName> _selectedNations = [];
  final List<ShipTypeName> _selectedTypes = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('筛选'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('等级:'),
            Wrap(
              children: List<Widget>.generate(
                11,
                (index) {
                  return FilterChip(
                    label: Text((index + 1).toString()),
                    selected: _selectedTiers.contains(index + 1),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedTiers.add(index + 1);
                        } else {
                          _selectedTiers.remove(index + 1);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            const Text('国家:'),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: NationName.values.map((nation) {
                return FilterChip(
                  label: Text(
                    nationNameChinese[nation]!,
                    style: _selectedNations.contains(nation)
                        ? const TextStyle(color: Colors.white)
                        : const TextStyle(color: Colors.black),
                  ),
                  selected: _selectedNations.contains(nation),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedNations.add(nation);
                      } else {
                        _selectedNations.remove(nation);
                      }
                    });
                  },
                  selectedColor: Colors.grey,
                  checkmarkColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.grey),
                  ),
                );
              }).toList(),
            ),
            const Text('类型:'),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: ShipTypeName.values.map((type) {
                return FilterChip(
                  label: Text(
                    shipTypeNameChinese[type]!,
                    style: _selectedTypes.contains(type)
                        ? const TextStyle(color: Colors.white)
                        : const TextStyle(color: Colors.black),
                  ),
                  selected: _selectedTypes.contains(type),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedTypes.add(type);
                      } else {
                        _selectedTypes.remove(type);
                      }
                    });
                  },
                  selectedColor: Colors.grey,
                  checkmarkColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.grey),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onApply(
              _selectedTiers.isEmpty
                  ? List<int>.generate(11, (index) => index + 1)
                  : _selectedTiers,
              _selectedNations.isEmpty
                  ? List<NationName>.from(NationName.values)
                  : _selectedNations,
              _selectedTypes.isEmpty
                  ? List<ShipTypeName>.from(ShipTypeName.values)
                  : _selectedTypes,
            );
          },
          child: const Text('应用'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('取消'),
        ),
      ],
    );
  }
}

String intToRoman(int num) {
  if (num < 1 || num > 11) {
    throw ArgumentError('The input number must be between 1 and 11.');
  }

  List<String> romanSymbols = [
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
    'VIII',
    'IX',
    'X',
    '★'
  ];
  return romanSymbols[num - 1];
}
