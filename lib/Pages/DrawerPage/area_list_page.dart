import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:wefriend_flutter/Pages/DrawerPage/administrative_division_controller.dart';

class AreaListPage extends StatelessWidget {
  final AdministrativeDivisionController controller = Get.put(AdministrativeDivisionController());

  AreaListPage({super.key});

  Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('省市列表'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        } else {
          return ListView.builder(
            itemCount: controller.provinces.length,
            itemBuilder: (context, index) {
              final province = controller.provinces[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    splashColor: Colors.transparent, // 去掉水波纹效果
                    highlightColor: Colors.transparent, // 去掉高亮效果
                  ),
                  child: ExpansionTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(province.name),
                    children: province.cityList
                        .map((city) => ExpansionTile(
                              title: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(city.name),
                              ),
                              children: city.areaList
                                  .map((area) => ListTile(
                                        title: Padding(
                                          padding: const EdgeInsets.only(left: 32.0),
                                          child: Text(area.name),
                                        ),
                                        onTap: () {
                                          final boxColor = _generateRandomColor();
                                          final isDark = ThemeData.estimateBrightnessForColor(boxColor) == Brightness.dark;

                                          if (Get.isSnackbarOpen) Get.closeAllSnackbars();
                                          Get.snackbar(
                                            province.name,
                                            "${city.name}-${area.name}",
                                            backgroundColor: boxColor,
                                            titleText: Text(
                                              "当前点击的地区是：",  
                                              style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                            ),
                                            snackPosition: SnackPosition.TOP,
                                            duration: const Duration(seconds: 3),
                                          );
                                        },
                                      ))
                                  .toList(),
                            ))
                        .toList(),
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
} 