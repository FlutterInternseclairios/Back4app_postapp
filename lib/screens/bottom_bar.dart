import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:back4app_posts_app/screens/MyPosts.dart';
import 'package:back4app_posts_app/screens/create_post.dart';
import 'package:back4app_posts_app/screens/posts_screen.dart';
import 'package:back4app_posts_app/screens/profile_screen.dart';
import 'package:back4app_posts_app/screens/search_users.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) {
            controller.selectedIndex.value = index;
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(CupertinoIcons.home, size: 32),
              label: "All Post",
            ),
            const NavigationDestination(
                icon: Icon(Icons.my_library_books), label: "My Posts"),
            NavigationDestination(
              icon: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              label: "Add Post",
            ),
            const NavigationDestination(
              icon: Icon(Icons.search),
              label: "Search",
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_2_outlined),
              label: "Profile",
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  RxInt selectedIndex = 0.obs;

  List screens = [
    const PostScreen(),
    const MyPosts(),
    const CreatePost(),
    const SearchUsers(),
    const ProfileScreen(),
  ];
}
