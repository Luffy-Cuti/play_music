import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'setting_controller.dart';
import 'package:get_storage/get_storage.dart';

class SettingPage extends StatelessWidget {
  final controller = Get.put(SettingController());
  final box = GetStorage();
  late List history = box.read("history") ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('setting'.tr)),
      body: Column(
        children: [
          Obx(
            () => SwitchListTile(
              title: Text("Đổi ngôn ngữ"),
              value: controller.isVietnamese.value,
              onChanged: (v) => controller.changeLanguage(),
            ),
          ),

          Divider(),

          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'history'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: Builder(
              builder: (_) {
                final box = GetStorage();
                List history = box.read("history") ?? [];

                return ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(history[index]));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
