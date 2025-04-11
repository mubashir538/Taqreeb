import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/global/header_secondary.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';

class CreateChecklistItems extends StatefulWidget {
  const CreateChecklistItems({super.key});

  @override
  State<CreateChecklistItems> createState() => _CreateChecklistItemsState();
}

class _CreateChecklistItemsState extends State<CreateChecklistItems> {
  final _checklistController = ChecklistController();
  final TextEditingController _textController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      _checklistController.initializeFromArgs(args as Map<String, dynamic>);
      if (!_checklistController.hasData) {
        _fetchChecklistData();
      }
    }
  }

  Future<void> _fetchChecklistData() async {
    await _checklistController.fetchData(
      context: context,
      onSuccess: () => setState(() {}),
    );
  }

  void _addChecklistItem(String text) {
    setState(() => _checklistController.addItem(text));
    _textController.clear();
  }

  void _toggleChecklistItem(int index) {
    setState(() => _checklistController.toggleItem(index));
  }

  Future<void> _showAddItemDialog() async {
    final maxDimension = Screen.max(context);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MyColors.Dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          "Add Checklist Item",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: MyTextBox(
          hint: 'Enter Checklist Item',
          valueController: _textController,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: GoogleFonts.montserrat(
                color: MyColors.red,
                fontSize: maxDimension * 0.015,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (_textController.text.trim().isNotEmpty) {
                _addChecklistItem(_textController.text.trim());
                Navigator.pop(context);
              }
            },
            child: Text(
              "Add",
              style: GoogleFonts.montserrat(
                fontSize: maxDimension * 0.015,
                color: MyColors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveChecklist() async {
    final success = await _checklistController.saveChecklist();
    if (!mounted) return;

    MyScaffold(
      text:
          success ? 'Checklist Saved successfully' : 'Failed to save checklist',
    ).show(context);

    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          _buildContent(),
          const Positioned(top: 0, child: Header()),
          _buildSaveButton(),
        ],
      ),
      floatingActionButton: _buildAddButton(),
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
      image: MyImages.CheckList,
    );
  }

  Widget _buildChecklistItems() {
    if (_checklistController.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _checklistController.items.length,
      itemBuilder: (context, index) => _buildChecklistItem(index),
    );
  }

  Widget _buildChecklistItem(int index) {
    final item = _checklistController.items[index];
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Screen.max(context) * 0.02,
        vertical: Screen.max(context) * 0.01,
      ),
      padding: EdgeInsets.symmetric(
        vertical: Screen.max(context) * 0.007,
        horizontal: Screen.max(context) * 0.02,
      ),
      decoration: BoxDecoration(
        color: MyColors.DarkLighter,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: MyColors.red,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: item["isChecked"],
            onChanged: (_) => _toggleChecklistItem(index),
            activeColor: MyColors.red,
          ),
          Text(
            item["description"],
            style: GoogleFonts.montserrat(
              color: Colors.white,
              decoration: item["isChecked"]
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Positioned(
      bottom: 0,
      child: Container(
        width: Screen.width(context),
        decoration: BoxDecoration(
          color: MyColors.DarkLighter,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.02,horizontal: Screen.width(context)*0.25),
        child: ColoredButton(
          text: 'Save',
          onPressed: _saveChecklist,
          width: Screen.width(context) * 0.2,
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton(
      onPressed: _showAddItemDialog,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      backgroundColor: MyColors.red,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}

class ChecklistController {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> newItems = [];
  List<Map<String, dynamic>> changedFields = [];
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
    items.add({"description": text, "isChecked": false});
    newItems.add({"description": text, "isChecked": false});
  }

  void toggleItem(int index) {
    items[index]["isChecked"] = !items[index]["isChecked"];

    final isNewItem = newItems
        .any((item) => item["description"] == items[index]["description"]);

    if (!isNewItem) {
      _updateChangedFields(index);
    } else {
      _updateNewItems(index);
    }
  }

  void _updateChangedFields(int index) {
    final existingIndex = changedFields.indexWhere(
        (item) => item["description"] == items[index]["description"]);

    if (existingIndex == -1) {
      changedFields.add({
        "id": items[index]["id"],
        "description": items[index]["description"],
        "isChecked": items[index]["isChecked"],
      });
    } else {
      changedFields[existingIndex]["isChecked"] = items[index]["isChecked"];
    }
  }

  void _updateNewItems(int index) {
    final newIndex = newItems.indexWhere(
        (item) => item["description"] == items[index]["description"]);
    newItems[newIndex]["isChecked"] = items[index]["isChecked"];
  }

  Future<bool> saveChecklist() async {
    bool success = true;

    // Save changed items
    for (final item in changedFields) {
      final response = await MyApi.postRequest(
        endpoint: 'update/checklist',
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'id': item["id"],
          'item': item["description"],
          'ischecked': item["isChecked"],
        },
      );
      if (response['status'] != 'success') {
        success = false;
      }
    }

    // Save new items
    for (final item in newItems) {
      final response = await MyApi.postRequest(
        endpoint: 'add/checklist',
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'functionId': isFunction ? functionId : "None",
          'eventId': eventId,
          'item': item["description"],
          'ischecked': item["isChecked"],
        },
      );
      if (response['status'] != 'success') {
        success = false;
      }
    }

    return success;
  }
}
