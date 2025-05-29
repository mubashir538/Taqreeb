import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/global/header_secondary.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';

class CreateChecklistItems extends StatefulWidget {
  const CreateChecklistItems({super.key});

  @override
  State<CreateChecklistItems> createState() => _CreateChecklistItemsState();
}

class _CreateChecklistItemsState extends State<CreateChecklistItems> {
  final _checklistController = ChecklistController();
  final TextEditingController _textController = TextEditingController();
  final Map<int, TextEditingController> _editControllers = {};
  final Map<int, FocusNode> _focusNodes = {};
  int? _editingIndex;
  bool _isChanged = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isChanged) return;
    _isChanged = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      _checklistController.initializeFromArgs(args as Map<String, dynamic>);
      if (!_checklistController.hasData) {
        _fetchChecklistData();
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    for (var controller in _editControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchChecklistData() async {
    await _checklistController.fetchData(
      context: context,
      onSuccess: () => setState(() {}),
    );
  }

  Future<void> _addChecklistItem(String text) async {
    setState(() => _checklistController.addItem(text));
    _textController.clear();

    // Save immediately to server
    final success = await _checklistController.saveNewItem(text);
    if (!mounted) return;

    if (!success) {
      MyScaffold(text: 'Failed to add checklist item').show(context);
      // Rollback if failed
      setState(() => _checklistController.items.removeLast());
    }
  }

  Future<void> _toggleChecklistItem(int index) async {
    if (_editingIndex == index) return; // Don't toggle while editing

    final previousState = _checklistController.items[index]["isChecked"];
    setState(() => _checklistController.toggleItem(index));

    // Save immediately to server
    final success = await _checklistController.saveItemState(
      _checklistController.items[index],
    );

    if (!mounted) return;

    if (!success) {
      // Revert if failed
      setState(
          () => _checklistController.items[index]["isChecked"] = previousState);
      MyScaffold(text: 'Failed to update checklist item').show(context);
    }
  }

  void _startEditing(int index) {
    setState(() {
      _editingIndex = index;
      _editControllers[index] = TextEditingController(
        text: _checklistController.items[index]["description"],
      );
      _focusNodes[index] = FocusNode();
      _focusNodes[index]?.requestFocus();
    });
  }

  Future<void> _finishEditing(int index) async {
    final newText = _editControllers[index]?.text.trim() ?? '';

    if (newText.isEmpty) {
      // Delete the item if text is empty
      await _deleteChecklistItem(index);
      return;
    }

    if (newText != _checklistController.items[index]["description"]) {
      final oldItem =
          Map<String, dynamic>.from(_checklistController.items[index]);
      setState(() {
        _checklistController.items[index]["description"] = newText;
        _editingIndex = null;
      });

      // Save immediately to server
      final success = await _checklistController.updateItemText(
        oldItem: oldItem,
        newText: newText,
      );

      if (!mounted) return;

      if (!success) {
        // Revert if failed
        setState(() {
          _checklistController.items[index]["description"] =
              oldItem["description"];
          _editingIndex = null;
        });
        MyScaffold(text: 'Failed to update checklist item').show(context);
      }
    } else {
      setState(() => _editingIndex = null);
    }

    _editControllers[index]?.dispose();
    _focusNodes[index]?.dispose();
    _editControllers.remove(index);
    _focusNodes.remove(index);
  }

  Future<void> _deleteChecklistItem(int index) async {
    final item = _checklistController.items[index];
    setState(() {
      _checklistController.items.removeAt(index);
      _editingIndex = null;
      _editControllers[index]?.dispose();
      _focusNodes[index]?.dispose();
      _editControllers.remove(index);
      _focusNodes.remove(index);
    });

    // Delete immediately from server
    final success = await _checklistController.deleteItem(item);
    if (!mounted) return;

    if (!success) {
      // Restore if failed
      setState(() => _checklistController.items.insert(index, item));
      MyScaffold(text: 'Failed to delete checklist item').show(context);
    }
  }

  Future<void> _showAddItemDialog() async {
    final maxDimension = Screen.max(context);
    final colors = AppColors(context);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          "Add Checklist Item",
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: MyTextBox(
            prefixIcon: FontAwesomeIcons.list,
            hint: 'Enter Checklist Item',
            valueController: _textController,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: GoogleFonts.roboto(
                color: colors.red,
                fontSize: maxDimension * 0.015,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (_textController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                await _addChecklistItem(_textController.text.trim());
              }
            },
            child: Text(
              "Add",
              style: GoogleFonts.roboto(
                fontSize: maxDimension * 0.015,
                color: colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return Scaffold(
      backgroundColor: colors.dark,
      body: Stack(
        children: [
          ShowCaseWidget(builder: (context) => _buildContent()),
          const Positioned(top: 0, child: Header()),
        ],
      ),
      floatingActionButton:
          _checklistController.items.isEmpty ? null : _buildAddButton(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(minHeight: Screen.height(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildChecklistHeader(),
            _buildChecklistItems(),
            if (_checklistController.items.isEmpty &&
                !_checklistController.isLoading)
              _buildEmptyState(),
            SizedBox(height: Screen.height(context) * 0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistHeader() {
    return Headersecondary(
      heading: "Create CheckList",
      para: "From to-do to done one check at a time!",
    );
  }

  Widget _buildChecklistItems() {
    final colors = AppColors(context);

    if (_checklistController.isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: Screen.height(context) * 0.3),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colors.white),
          ),
        ),
      );
    }

    if (_checklistController.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _checklistController.items.length,
      itemBuilder: (context, index) => _buildChecklistItem(index),
    );
  }

  Widget _buildChecklistItem(int index) {
    final colors = AppColors(context);

    final item = _checklistController.items[index];
    return Dismissible(
      key: Key(item["id"]?.toString() ?? item["description"]),
      background: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Screen.max(context) * 0.02,
          vertical: Screen.max(context) * 0.01,
        ),
        padding: EdgeInsets.symmetric(
          vertical: Screen.max(context) * 0.007,
          horizontal: Screen.max(context) * 0.02,
        ),
        decoration: BoxDecoration(
          color: colors.red.withAlpha(77),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(FontAwesomeIcons.trash, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: colors.dark,
            title: Text(
              "Delete Item",
              style: GoogleFonts.roboto(color: Colors.white),
            ),
            content: Text(
              "Are you sure you want to delete this item?",
              style: GoogleFonts.roboto(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.roboto(color: colors.red),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  "Delete",
                  style: GoogleFonts.roboto(color: colors.red),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => _deleteChecklistItem(index),
      child: GestureDetector(
        onTap: () => _toggleChecklistItem(index),
        onDoubleTap: () => _startEditing(index),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: Screen.max(context) * 0.02,
            vertical: Screen.max(context) * 0.01,
          ),
          padding: EdgeInsets.symmetric(
            vertical: Screen.max(context) * 0.007,
            horizontal: Screen.max(context) * 0.02,
          ),
          decoration: BoxDecoration(
            color: colors.darkLighter,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: colors.red,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Checkbox(
                value: item["isChecked"],
                onChanged: (_) => _toggleChecklistItem(index),
                activeColor: colors.red,
              ),
              Expanded(
                child: _editingIndex == index
                    ? TextField(
                        controller: _editControllers[index],
                        focusNode: _focusNodes[index],
                        style: GoogleFonts.roboto(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Edit item',
                          hintStyle: GoogleFonts.roboto(color: Colors.white54),
                        ),
                        autofocus: true,
                        onSubmitted: (value) => _finishEditing(index),
                      )
                    : Text(
                        item["description"],
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          decoration: item["isChecked"]
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: Screen.height(context) * 0.2),
        child: Column(
          children: [
            Text(
              "No checklist items yet",
              style: GoogleFonts.roboto(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
            SizedBox(height: Screen.height(context) * 0.03),
            ColoredButton(
              text: 'Add Your First Item',
              onPressed: _showAddItemDialog,
              width: Screen.width(context) * 0.5,
              textSize: Screen.max(context) * 0.015,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    final colors = AppColors(context);

    return FloatingActionButton(
      onPressed: _showAddItemDialog,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      backgroundColor: colors.red,
      child: const Icon(FontAwesomeIcons.plus, color: Colors.white),
    );
  }
}

class ChecklistController {
  List<Map<String, dynamic>> items = [];
  String token = '';
  bool isLoading = true;
  bool hasData = false;
  bool isFunction = false;
  int functionId = 0;
  int eventId = 0;

  void initializeFromArgs(Map<String, dynamic> args) {
    isFunction = args['functionid'] != null;
    functionId = args['functionid'] ?? 0;
    eventId = args['eventId'] ?? 0;
  }

  Future<void> fetchData({
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    final endpoint = isFunction
        ? 'show/checklist/$eventId/$functionId'
        : 'show/checklist/$eventId';

    await ApiCall.fetchAPI(endpoint, refresh: true, onSuccess: (token, data) {
      this.token = token;
      if (data['checklist'] != null) {
        items = (data['checklist'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      }
      isLoading = false;
      hasData = true;
      onSuccess();
    }, context: context);
  }

  void addItem(String text) {
    items.add({
      "description": text,
      "isChecked": false,
      "isNew": true, // Mark as new item
    });
  }

  void toggleItem(int index) {
    items[index]["isChecked"] = !items[index]["isChecked"];
  }

  Future<bool> saveNewItem(String text) async {
    try {
      final response = await MyApi.postRequest(
        endpoint: 'add/checklist',
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'functionId': isFunction ? functionId : "None",
          'eventId': eventId,
          'item': text,
          'ischecked': false,
        },
      );

      if (response['status'] == 'success') {
        // Update the item with the ID from server
        if (response['checklistItem'] != null) {
          final newItem = items.last;
          newItem["id"] = response['checklistItem']['id'];
          newItem["isNew"] = false;
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveItemState(Map<String, dynamic> item) async {
    try {
      // If it's a new item that hasn't been saved to server yet
      if (item["isNew"] == true) {
        return await saveNewItem(item["description"]);
      }

      final response = await MyApi.postRequest(
        endpoint: 'update/checklist',
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'id': item["id"],
          'item': item["description"],
          'ischecked': item["isChecked"],
        },
      );
      return response['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateItemText({
    required Map<String, dynamic> oldItem,
    required String newText,
  }) async {
    try {
      // If it's a new item that hasn't been saved to server yet
      if (oldItem["isNew"] == true) {
        return true; // The text will be saved when toggled or when app closes
      }

      final response = await MyApi.postRequest(
        endpoint: 'update/checklist',
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'id': oldItem["id"],
          'item': newText,
          'ischecked': oldItem["isChecked"],
        },
      );
      return response['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteItem(Map<String, dynamic> item) async {
    try {
      // If it's a new item that hasn't been saved to server yet
      if (item["isNew"] == true) {
        return true;
      }

      final response = await MyApi.postRequest(
        endpoint: 'delete/checklist',
        headers: {'Authorization': 'Bearer $token'},
        body: {'id': item["id"]},
      );
      return response['status'] == 'success';
    } catch (e) {
      return false;
    }
  }
}
