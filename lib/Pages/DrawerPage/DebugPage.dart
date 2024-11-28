import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wefriend_flutter/Util/global.dart';
import 'package:wefriend_flutter/Pages/ExtraPage/hero_page1.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Page'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with your desired number of tiles
        itemBuilder: (context, index) {
          return CustomTile(
            title: 'Tile $index',
            imagepaths: [
              'https://source.unsplash.com/800x600/?nature,index=${randomNum(20)}',
              'https://source.unsplash.com/800x600/?nature,index=${randomNum(30)}',
              'https://source.unsplash.com/800x600/?nature,index=${randomNum(15)}',
            ],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HeroPage1()),
              );
            },
          );
        },
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  const CustomTile({super.key, 
    required this.title,
    required this.imagepaths,
    required this.onTap,
  });

  final List<String> imagepaths;
  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.normal,
        ),
      ),
      onTap: onTap,
      subtitle: Column(
        children: [
          Row(children: [
            CachedNetworkImage(imageUrl: imagepaths[0],width: 100,height: 100,),
            const SizedBox(width: 16),
            CachedNetworkImage(imageUrl: imagepaths[1],width: 100,height: 100,),
            const SizedBox(width: 16),
            CachedNetworkImage(imageUrl: imagepaths[2],width: 100,height: 100,),
          ]),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter text',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: onTap,
              child: const Text('hero animate to next page'),
            ),
          )
        ],
      ),
    );
  }
}
