import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_border_button.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Cards/c_guest_list_card.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Components/global/header.dart';

class CreateGuestList_AddPerson extends StatefulWidget {
  const CreateGuestList_AddPerson({super.key});

  @override
  State<CreateGuestList_AddPerson> createState() =>
      _CreateGuestList_AddPersonState();
}

class _CreateGuestList_AddPersonState extends State<CreateGuestList_AddPerson> {
  final GlobalKey _headerKey = GlobalKey();
  final List<Map<String, String>> _guestList = [];
  final TextEditingController _personController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final FocusNode _personFocus = FocusNode();
  final FocusNode _contactFocus = FocusNode();

  bool _isFunction = false;
  int _functionId = 0;
  int _eventId = 0;
  Map<String, dynamic> _routeArgs = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UI_Management.getHeaderHeight(
        headerKey: _headerKey,
        callback: _updateHeaderHeight,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeFromArguments();
  }

  void _initializeFromArguments() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _routeArgs = args;

    setState(() {
      _isFunction = args['functionid'] != null;
      _functionId = args['functionid'] ?? 0;
      _eventId = args['eventId'] ?? 0;
    });
  }

  void _updateHeaderHeight(RenderBox renderBox) {
    if (mounted) {
      setState(() => UI_Management.headerHeight = renderBox.size.height);
    }
  }

  void _addPerson() {
    if (_personController.text.isEmpty || _contactController.text.isEmpty) {
      MyScaffold(text: 'Please fill all fields').show(context);
      return;
    }

    if (Validations.validateContact(_contactController.text) != "Ok") {
      MyScaffold(text: Validations.validateContact(_contactController.text))
          .show(context);
      return;
    }
    setState(() {
      _guestList.add(
          {'name': _personController.text, 'contact': _contactController.text});
      _personController.clear();
      _contactController.clear();
      _personFocus.requestFocus();
    });
  }

  void _removePerson(int index) {
    setState(() => _guestList.removeAt(index));
  }

  Future<void> _submitPersons() async {
    if (_guestList.isEmpty) {
      MyScaffold(text: 'Please add at least one person').show(context);
      return;
    }

    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    bool allSuccess = true;

    for (final guest in _guestList) {
      final response = await MyApi.postRequest(
        headers: {'Authorization': 'Bearer $token'},
        endpoint: 'add/guests/',
        body: {
          'eid': _eventId,
          'fid': _isFunction ? _functionId : 'None',
          'guesttype': 'Person',
          'PersonName': guest['name'],
          'PersonContact': guest['contact']
        },
      );

      if (response['status'] != 'success') {
        allSuccess = false;
      }
    }

    if (mounted) {
      MyScaffold(
        text: allSuccess ? 'Persons Added' : 'Some persons not added',
      ).show(context);

      Navigator.pushReplacementNamed(
        context,
        '/CreateGuestList_List',
        arguments: _routeArgs,
      );
    }
  }

  @override
  void dispose() {
    _personController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          _buildContent(),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Add Person',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Container(
        width: Screen.width(context),
        child: Column(
          children: [
            SizedBox(
                height: (Screen.height(context) * 0.05) +
                    UI_Management.headerHeight),
            _buildInputFields(),
            _buildGuestList(),
            SizedBox(height: Screen.height(context) * 0.05),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        MyTextBox(
          focusNode: _personFocus,
          onFieldSubmitted: (_) =>
              FocusScope.of(context).requestFocus(_contactFocus),
          hint: 'Person Name',
          valueController: _personController,
        ),
        MyTextBox(
          focusNode: _contactFocus,
          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          hint: 'Contact Number',
          isNum: true,
          valueController: _contactController,
        ),
      ],
    );
  }

  Widget _buildGuestList() {
    return SizedBox(
      width: Screen.width(context) * 0.9,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _guestList.length,
        itemBuilder: (context, index) => Guests(
          onpressed: () {},
          ondelete: () => _removePerson(index),
          mywidth: Screen.width(context) * 0.8,
          name: _guestList[index]['name'] ?? '',
          contact: _guestList[index]['contact'] ?? '',
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ColoredButton(
          text: 'Add Person',
          width: Screen.width(context) * 0.7,
          onPressed: _addPerson,
        ),
        BorderButton(
          text: 'Done',
          width: Screen.width(context) * 0.7,
          onPressed: _submitPersons,
        ),
      ],
    );
  }
}
