import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/model/post.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';
import '/Network/RequestManager.dart';

class listViewPage extends StatelessWidget {
  final List<Post> data = [];

  listViewPage({super.key});
  Widget _listItemBuilder(BuildContext context, int index) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.network(posts[index].imageUrl),
          const SizedBox(height: 16.0),
          Text(
            posts[index].title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            posts[index].author,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getdata();
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: _listItemBuilder,
    );
  }
}

//dio请求https://jimmyarea.com/api/public/article?page=-1数据
void getdata() async {
  final Dio dio = RequestManager.getInstance();
  
  dio.options.baseUrl = 'https://jsonplaceholder.typicode.com';
  // dio.get('api/public/article?page=-1');
  // try {
  //   Response response = await dio.get('api/public/article?page=-1');
  //   print(response.data);

  // } catch (e) {
  //   print(e);
  // }
  // try {
  //   Response response =
  //       await Dio().get("https://jimmyarea.com/api/public/article?page=-1");
  //   print(response.data);
  // } catch (e) {
  //   print(e);
  // }
}
