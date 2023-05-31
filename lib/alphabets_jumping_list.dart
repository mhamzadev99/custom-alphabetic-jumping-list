
import 'dart:convert';

import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AlphabetsJumpingList extends StatelessWidget {
  AlphabetsJumpingList({super.key});

  int selectedIndex = 0;

  Future<List<Category>> get _getCategory async {
    try {
      final response = await http.get(Uri.parse('http://159.223.140.6/api/categories'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<Category> items = (jsonResponse as List).map((e) => Category.fromJson(e)).toList();
        return items;
      } else {
        throw Exception('Failed to load category');
      }
    } catch (e) {
      print(e.toString());
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jumping list'),
      ),
      body: Center(
        child: Container(
          //color: Colors.grey,
          width: 300,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(20.0),
          ),
          alignment: Alignment.center,
          child: ListTile(
            title: Text(
              'Choose',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (_) {
                  final size = MediaQuery.of(context).size;
                  return AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    content: FutureBuilder<List<Category>>(
                        future: _getCategory,
                        builder: (context, snapshot) {
                          // return const Center(child: CircularProgressIndicator());
                          // List<Category> items = snapshot.data ?? [];
                          return snapshot.connectionState != ConnectionState.done
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Container(
                              color: Colors.white,
                              height: 200.0,
                              width: size.width * 0.75,
                              child: const Center(child: CircularProgressIndicator()),
                            ),
                          )
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: const Color(0xFFFFFF),
                                border: Border.all(color: Colors.green, width: 4.0),
                              ),
                              child: Container(
                                color: Colors.green,
                                height: size.height * 0.75,
                                width: size.width * 0.75,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        border: Border.all(color: Colors.green, width: 4.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Choose Category',
                                            style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: Container(
                                              height: 28.0,
                                              width: 28.0,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(40.0),
                                              ),
                                              child: const Icon(Icons.close, size: 18.0, color: Colors.green),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    alphaScroll(snapshot.data ?? []),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget alphaScroll(List<Category> items) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.0),
      child: AlphabetScrollView(
        list: items.map((e) => AlphaModel(e.businessCategoryName)).toList(),
        alignment: LetterAlignment.right,
        unselectedTextStyle: const TextStyle(fontSize: 18, color: Colors.black),
        selectedTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
        itemBuilder: (_, k, id) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  height: 40.0,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.1)),
                    ),
                  ),
                  child: Text(
                    '$id',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Container(
                width: 40.0,
                height: 40.0,
                decoration: const BoxDecoration(color: Color(0xffd9d9d9)),
              )
            ],
          );
        },
      ),
    );
  }
}

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  int businessCategoryId;
  String businessCategoryName;

  Category({
    required this.businessCategoryId,
    required this.businessCategoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        businessCategoryId: json["business_category_id"],
        businessCategoryName: json["business_category_name"],
      );

  Map<String, dynamic> toJson() => {
        "business_category_id": businessCategoryId,
        "business_category_name": businessCategoryName,
      };
}
