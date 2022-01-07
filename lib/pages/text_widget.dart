import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/pages/input_page.dart';
import 'package:todo/provider/text_provider.dart';
import 'package:flutter/services.dart';

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
            onReorder: (int oldIndex, int newIndex) async {
              HapticFeedback.mediumImpact();
              provider.changeEleOrder(
                  oldIndex, newIndex, listOfTexts[oldIndex].id);
            },
            itemBuilder: (context, index) {
              return Padding(
                key: Key('${listOfTexts[index].id}'),
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Dismissible(
                  direction: DismissDirection.horizontal,
                  key: Key('${listOfTexts[index].id}'),
                  onDismissed: (DismissDirection direction) {
                    HapticFeedback.mediumImpact();
                    if (direction == DismissDirection.startToEnd) {
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
                    } else {
                      provider.removeEleFromList(index, listOfTexts[index].id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InputPage(
                            type: 'edit',
                            element: listOfTexts[index],
                          ),
                        ),
                      );
                    }
                  },
                  background: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.restore_from_trash_rounded),
                            Icon(Icons.restore_from_trash_rounded),
                          ],
                        ),
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  secondaryBackground: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.edit),
                            Icon(Icons.edit),
                          ],
                        ),
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  child: ReorderableDelayedDragStartListener(
                    index: index,
                    // key: Key('${listOfTexts[index].id}'),
                    child: Card(
                      // key: Key('${listOfTexts[index].id}'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      child: Column(
                        children: [
                          ListTile(
                            key: UniqueKey(),
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                listOfTexts[index].text,
                                style: const TextStyle(
                                  height: 2,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
