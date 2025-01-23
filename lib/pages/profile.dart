import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 닉네임 상태를 관리할 ChangeNotifier 클래스
class NicknameProvider extends ChangeNotifier {
  String _nickname = "사용자";

  String get nickname => _nickname;

  void setNickname(String newNickname) {
    _nickname = newNickname;
    notifyListeners();
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final nicknameProvider = Provider.of<NicknameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("프로필"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: IconButton(
                onPressed: () {
                  // 프로필 사진 추가 동작
                },
                icon: const Icon(Icons.add_circle, size: 30),
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              initialValue: nicknameProvider.nickname,
              decoration: const InputDecoration(
                labelText: "닉네임 정보",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                nicknameProvider.setNickname(value);
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text("비밀번호 변경"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // 비밀번호 변경 동작
              },
            ),
            ListTile(
              title: const Text("공지사항"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // 공지사항 동작
              },
            ),
            ListTile(
              title: const Text("1:1 문의"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // 1:1 문의 동작
              },
            ),
          ],
        ),
      ),
    );
  }
}
