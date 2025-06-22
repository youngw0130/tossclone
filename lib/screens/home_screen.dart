import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  // 계좌 mock 데이터
  List<Map<String, dynamic>> accounts = [
    {
      'name': '내 모든 계좌',
      'amount': 10000,
    },
    {
      'name': '포인트 · 머니 · 1개',
      'amount': 28,
    },
  ];

  // 계좌 개설 함수
  void _addAccount(String name, int amount) {
    setState(() {
      accounts.add({'name': name, 'amount': amount});
    });
  }

  // 송금 함수
  void _sendMoney(int idx, int amount) {
    setState(() {
      accounts[idx]['amount'] -= amount;
      if (accounts[idx]['amount'] < 0) accounts[idx]['amount'] = 0;
    });
  }

  // 계좌 개설 다이얼로그
  void _showAddAccountDialog() {
    String newName = '';
    String newAmount = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF23222A),
          title: const Text('계좌 개설', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: '계좌명', labelStyle: TextStyle(color: Colors.white70)),
                onChanged: (v) => newName = v,
              ),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: '초기 금액', labelStyle: TextStyle(color: Colors.white70)),
                keyboardType: TextInputType.number,
                onChanged: (v) => newAmount = v,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소', style: TextStyle(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () {
                if (newName.isNotEmpty && int.tryParse(newAmount) != null) {
                  _addAccount(newName, int.parse(newAmount));
                  Navigator.pop(context);
                }
              },
              child: const Text('확인', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // 송금 다이얼로그
  void _showSendMoneyDialog(int idx) {
    String sendAmount = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF23222A),
          title: const Text('송금', style: TextStyle(color: Colors.white)),
          content: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: '금액', labelStyle: TextStyle(color: Colors.white70)),
            keyboardType: TextInputType.number,
            onChanged: (v) => sendAmount = v,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소', style: TextStyle(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () {
                if (int.tryParse(sendAmount) != null) {
                  _sendMoney(idx, int.parse(sendAmount));
                  Navigator.pop(context);
                  // 송금 완료 알림
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('송금이 완료되었습니다.'),
                      backgroundColor: Color(0xFF23222A),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('확인', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF18171C),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 환율/알림/결제 영역
            _TopBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _ExchangeCard(),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: '토스뱅크',
                    trailing: Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.7)),
                    children: const [],
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: '토스머니',
                    children: [
                      _AccountRow(
                        icon: Icons.account_balance_wallet,
                        iconColor: Color(0xFF2563EB),
                        name: '토스뱅크 가상계좌',
                        amount: '9,999,999,999,999원',
                        buttonText: '송금',
                      ),
                      _AccountRow(
                        icon: Icons.savings,
                        iconColor: Color(0xFFE57373),
                        name: '저금통',
                        amount: '0원',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: '교통카드',
                    trailing: Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.7)),
                    children: [
                      _CardRow(
                        image: Icons.credit_card,
                        name: '토스유스카드',
                        amount: '0원',
                        subText: '3개월 전',
                        buttonText: '충전',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: '계좌',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: _showAddAccountDialog,
                          tooltip: '계좌 개설',
                        ),
                        Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.7)),
                      ],
                    ),
                    children: [
                      for (int i = 0; i < accounts.length; i++)
                        _AccountRow(
                          icon: Icons.account_balance,
                          iconColor: const Color(0xFF60A5FA),
                          name: accounts[i]['name'],
                          amount: '${accounts[i]['amount']}원',
                          buttonText: '송금',
                          onSend: () => _showSendMoneyDialog(i),
                        ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            // 하단 네비게이션 바 (장식용)
            _BottomNavBar(),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: '환율',
              items: const [
                DropdownMenuItem(value: '환율', child: Text('환율', style: TextStyle(color: Colors.white))),
              ],
              onChanged: (_) {},
              dropdownColor: const Color(0xFF23222A),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            ),
          ),
          const Spacer(),
          Icon(Icons.qr_code_scanner, color: Color(0xFF2563EB)),
          const SizedBox(width: 16),
          Stack(
            children: [
              Icon(Icons.notifications_none, color: Colors.white.withOpacity(0.7)),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExchangeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF23222A),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _FlagCircle('US'),
          const SizedBox(width: 12),
          const Text('USD', style: TextStyle(color: Colors.white, fontSize: 16)),
          const Spacer(),
          const Text('1', style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}

class _FlagCircle extends StatelessWidget {
  final String country;
  const _FlagCircle(this.country);
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: Text(country, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? trailing;
  const _SectionCard({required this.title, required this.children, this.trailing});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF23222A),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          ...children,
        ],
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String name;
  final String amount;
  final String? buttonText;
  final VoidCallback? onSend;
  const _AccountRow({required this.icon, required this.iconColor, required this.name, required this.amount, this.buttonText, this.onSend});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                Text(amount, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          if (buttonText != null)
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFF23222A),
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                ),
                onPressed: onSend,
                child: Text(buttonText!, style: const TextStyle(color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}

class _CardRow extends StatelessWidget {
  final IconData image;
  final String name;
  final String amount;
  final String subText;
  final String? buttonText;
  const _CardRow({required this.image, required this.name, required this.amount, required this.subText, this.buttonText});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(image, color: Colors.grey.shade700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                Row(
                  children: [
                    Text(amount, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(subText, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                    const SizedBox(width: 2),
                    const Icon(Icons.refresh, color: Colors.white38, size: 14),
                  ],
                ),
              ],
            ),
          ),
          if (buttonText != null)
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFF23222A),
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                ),
                onPressed: () {},
                child: Text(buttonText!, style: const TextStyle(color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFF23222A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _NavBarItem(icon: Icons.home, label: '홈', selected: true),
          _NavBarItem(icon: Icons.card_giftcard, label: '혜택'),
          _NavBarItem(icon: Icons.shopping_bag, label: '토스쇼핑'),
          _NavBarItem(icon: Icons.show_chart, label: '증권'),
          _NavBarItem(icon: Icons.menu, label: '전체'),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  const _NavBarItem({required this.icon, required this.label, this.selected = false});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: selected ? Colors.white : Colors.white38),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: selected ? Colors.white : Colors.white38, fontSize: 12)),
      ],
    );
  }
}
