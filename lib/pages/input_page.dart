import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/text_provider.dart';
import 'package:todo/util/text_model.dart';

class InputPage extends StatefulWidget {
  const InputPage({
    Key? key,
    required this.type,
    this.element,
  }) : super(key: key);

  final String type;
  final TextModel? element;

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.element?.text != null && widget.type == 'edit') {
      _controller = TextEditingController(text: widget.element!.text);
    } else {
      _controller = TextEditingController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TextProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Add a New Text'),
        backgroundColor: const Color(0xFF212332),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: SizedBox(
                    width: size.width * 0.9,
                    child: TextFormField(
                      // initialValue: _controller.text,
                      controller: _controller,
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.5,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        provider.addEle(_controller.text);
                        Navigator.pop(context);
                        _controller.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error'),
                          ),
                        );
                      }
                    },
                    child: Text(widget.type == 'edit' ? 'Save edit' : 'Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
