// ignore_for_file: unused_element

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/export_providers.dart';
import '../../utils/hooks/scroll_controller_hook.dart';
import '../../utils/unique_keys.dart';
import '../widgets/todo_item.dart';
import '../widgets/toolbar.dart';
import 'back_layer_page.dart';

class Home extends StatefulHookConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    ref.read(todoListProvider.notifier).loadData();
  }

  @override
  Widget build(BuildContext context) {


    AnimationController mainTitleAnimController = useAnimationController(
        duration: kThemeAnimationDuration, initialValue: 1);
    AnimationController appbarTitleAnimController = useAnimationController(
        duration: kThemeAnimationDuration, initialValue: 0);
    ScrollController scrollController = useControllerForAnimation(
        mainTitleAnimController, appbarTitleAnimController);
    final todos = ref.watch(filteredTodos);
    final newTodoController = useTextEditingController();
    final bool isDark = ref.watch(isDarkProvider).getTheme();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BackdropScaffold(
        frontLayerBackgroundColor: Theme.of(context).colorScheme.primary,
        backLayerBackgroundColor: Theme.of(context).colorScheme.primary,
        headerHeight: 0,
        frontLayerBorderRadius: BorderRadius.circular(0),
        stickyFrontLayer: true,
        frontLayerScrim: isDark ? Colors.black54 : Colors.white60,
        backLayerScrim: isDark ? Colors.white54 : Colors.black54,
        // backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          actions: [
            BackdropToggleButton(
              color: isDark ? Colors.white : Colors.black,
              icon: AnimatedIcons.close_menu,
            ),
            const SizedBox(
              width: 16,
            )
          ],
        ),
        backLayer: const BackLayerPage(),
        frontLayer: ListView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [

            const SizedBox(
              height: 8,
            ),
            TextField(
              key: addTodoKey,

              controller: newTodoController,
              cursorColor: Theme.of(context).colorScheme.secondary,
              decoration:
                   InputDecoration(labelText: 'Add Task',
                   enabledBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.zero,
                     borderSide: BorderSide(color: isDark?Colors.white:Colors.black,width: 2)
                   ),
                     focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.zero,
                         borderSide: BorderSide(color: isDark?Colors.white:Colors.black,width: 3)
                     ),
                   suffixIcon: IconButton(icon: Icon(Icons.add,color: isDark?Colors.white:Colors.black,), onPressed: () {
                     ref.read(todoListProvider.notifier).add(newTodoController.text);
                     newTodoController.clear();
                   },),),
              onSubmitted: (value) {
                ref.read(todoListProvider.notifier).add(value);
                newTodoController.clear();
              },

            ),
            const SizedBox(height: 20,),

            ToolBar(filter: ref.watch(todoFilterType.state)),
            if (todos.data.isEmpty) ...[
              const SizedBox(
                height: 24,
              ),


              const Text(
                'No Task available!\n Try to add a new one.',
                textAlign: TextAlign.center,
              ),
            ],
            for (var i = 0; i < todos.data.length; i++) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Dismissible(
                  key: ValueKey(todos.data[i].id),
                  onDismissed: (_) {
                    ref.read(todoListProvider.notifier).remove(todos.data[i]);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text("Task Deleted!"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                  },
                  child: ProviderScope(
                    overrides: [
                      if (ref.watch(totalTodoCount) != 0)
                        currentTodo.overrideWithValue(todos.data[i])
                    ],
                    child: const TodoItem(),
                  ),
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: isDark?Colors.white:Colors.black,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
