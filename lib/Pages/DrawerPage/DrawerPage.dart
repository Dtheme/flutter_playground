import 'package:flutter/material.dart';
import 'LayoutDemoPage.dart';
import 'BloCDemoPage.dart';
import 'SettingsPage.dart';
import 'DebugPage.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        // color: Colors.blue[200],
        decoration: BoxDecoration(
          color: Colors.blue[200]!.withOpacity(0.2),
          image: DecorationImage(
            image: const NetworkImage(
                'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.jj20.com%2Fup%2Fallimg%2F1011%2F0Q51G53052%2F1FQ5153052-9.jpg&refer=http%3A%2F%2Fpic.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1661263294&t=e28d0c55edb213e1ff935d1ceb063112'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.blue[200]!.withOpacity(0.2), BlendMode.hardLight),
          ),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.clamp,
              colors: [
                Colors.blue[200]!.withOpacity(0.2),
                const Color.fromARGB(255, 255, 255, 255)
              ]),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text(
                'zw_:D',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              accountEmail: const Text(
                'armchannel_dzw@163.com',
                style: TextStyle(color: Colors.black),
              ),
              currentAccountPicture: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'http://t14.baidu.com/it/u=8758091981641796806,931356984778388245&fm=3008&app=3011&f=JPEG')),
              decoration: BoxDecoration(
                color: Colors.blue[200]!,
                image: DecorationImage(
                  image: const NetworkImage(
                      'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.jj20.com%2Fup%2Fallimg%2F1011%2F0Q51G53052%2F1FQ5153052-9.jpg&refer=http%3A%2F%2Fpic.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1661263294&t=e28d0c55edb213e1ff935d1ceb063112'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.blue[200]!.withOpacity(0.2), BlendMode.hardLight),
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'Layout',
                textAlign: TextAlign.right,
              ),
              trailing: Icon(
                Icons.message,
                color: Colors.blue[200],
                size: 22.0,
              ),
              onTap: () => {
                Navigator.pop(context),
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LayoutDemoPage())),
              },
            ),
            ListTile(
              title: const Text(
                'BloC',
                textAlign: TextAlign.right,
              ),
              trailing: Icon(
                Icons.water_drop_outlined,
                color: Colors.blue[200],
                size: 22.0,
              ),
              onTap: () => {
                Navigator.pop(context),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BloCDemoPage())),
              },
            ),
            ListTile(
              title: const Text(
                'Settings',
                textAlign: TextAlign.right,
              ),
              trailing: Icon(
                Icons.settings,
                color: Colors.blue[200],
                size: 22.0,
              ),
              onTap: () => {
                Navigator.pop(context),
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage())),
              },
            ),
            ListTile(
              title: const Text(
                '[Debug]',
                textAlign: TextAlign.right,
              ),
              trailing: Icon(
                Icons.flip_rounded,
                color: Colors.blue[200],
                size: 22.0,
              ),
              onTap: () => {
                Navigator.pop(context),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const DebugPage())),
              },
            )
          ],
        ),
      ),
    );
  }
}
