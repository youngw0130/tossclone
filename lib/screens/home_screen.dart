import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final double totalBalance = 700000000;

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '토스 클론',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '안녕하세요 👋 윤건우님',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text(
              '총 자산',
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              '₩${totalBalance.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureButton(
                  icon: Icons.account_balance,
                  label: '계좌 관리',
                  onTap: () {
                    // 계좌 관리 화면으로 이동
                  },
                ),
                _buildFeatureButton(
                  icon: Icons.send,
                  label: '송금하기',
                  onTap: () {
                    // 송금 화면으로 이동
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade200,
            child: Icon(icon, size: 30, color: Colors.black),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}