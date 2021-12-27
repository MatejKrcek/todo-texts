import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/text_provider.dart';
import 'package:todo/util/text_model.dart';

class TextWidget extends StatefulWidget {
  const TextWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TextProvider>(context);
    final listOfTexts = context.watch<TextProvider>().listOfTexts;
    return listOfTexts.isEmpty
        ? SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 30,
                ),
                const Center(
                  child: Text('Hey! You don\'t have any texts.'),
                ),
              ],
            ),
          )
        : SliverReorderableList(
            key: UniqueKey(),
            itemCount: listOfTexts.length,
            onReorder: (int oldIndex, int newIndex) {
              provider.changeEleOrder(
                  oldIndex, newIndex, listOfTexts[oldIndex].id);
            },
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key('${listOfTexts[index].id}'),
                onDismissed: (direction) {
                  provider.removeEleFromList(index, listOfTexts[index].id);
                  final snackBar = SnackBar(
                    content: const Text('The text was archived'),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        provider.undoRemoveEle(index);
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                background: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.restore_from_trash_rounded),
                        Icon(Icons.restore_from_trash_rounded),
                      ],
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                child: ReorderableDelayedDragStartListener(
                  index: index,
                  key: Key('${listOfTexts[index].id}'),
                  child: Card(
                    key: Key('${listOfTexts[index].id}'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Theme.of(context).colorScheme.secondary,
                    child: Column(
                      children: [
                        ListTile(
                          key: Key('${listOfTexts[index].id}'),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              listOfTexts[index].text,
                              style: const TextStyle(height: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
