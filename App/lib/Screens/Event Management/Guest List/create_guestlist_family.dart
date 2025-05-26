import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class CreateGuestListAddFamily extends StatefulWidget {
  const CreateGuestListAddFamily({super.key});

  @override
  State<CreateGuestListAddFamily> createState() =>
      _CreateGuestListAddFamilyState();
}

class _CreateGuestListAddFamilyState extends State<CreateGuestListAddFamily> {
  final GlobalKey _headerKey = GlobalKey();
  final List<Map<String, String>> _guestList = [];
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _membersController = TextEditingController();
  final TextEditingController _familyContactController =
      TextEditingController();
  final FocusNode _familyNameFocus = FocusNode();
  final FocusNode _membersFocus = FocusNode();
  final FocusNode _familyContactFocus = FocusNode();

  bool _isFunction = false;
  int _functionId = 0;
  int _eventId = 0;
  Map<String, dynamic> _routeArgs = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UImanagement.getHeaderHeight(
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
      setState(() => UImanagement.headerHeight = renderBox.size.height);
    }
  }

  void _addFamily() {
    if (_familyNameController.text.isEmpty ||
        _membersController.text.isEmpty ||
        _familyContactController.text.isEmpty) {
      MyScaffold(text: 'Please fill all fields').show(context);
      return;
    }
    if (Validations.validateName(_familyNameController.text) != "Ok") {
      MyScaffold(text: Validations.validateName(_familyNameController.text))
          .show(context);
      return;
    }

    if (Validations.validateContact(_familyContactController.text) != "Ok") {
      MyScaffold(
              text: Validations.validateContact(_familyContactController.text))
          .show(context);
      return;
    }
    setState(() {
      _guestList.add({
        'name': _familyNameController.text,
        'members': _membersController.text,
        'contact': _familyContactController.text
      });
      _familyNameController.clear();
      _membersController.clear();
      _familyContactController.clear();
      _familyNameFocus.requestFocus();
    });
  }

  void _removeFamily(int index) {
    setState(() => _guestList.removeAt(index));
  }

  Future<void> _submitFamilies() async {
    if (_guestList.isEmpty) {
      MyScaffold(text: 'Please add at least one family').show(context);
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
          'guesttype': 'Family',
          'FamilyName': guest['name'],
          'member': guest['members'],
          'PersonContact': guest['contact'],
        },
      );

      if (response['status'] != 'success') {
        allSuccess = false;
      }
    }

    if (mounted) {
      MyScaffold(
        text: allSuccess ? 'Families Added' : 'Some families not added',
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
    _familyNameController.dispose();
    _membersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return Scaffold(
      backgroundColor: colors.dark,
      body: Stack(
        children: [
          _buildContent(),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Add Family',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: SizedBox(
        width: Screen.width(context),
        child: Column(
          children: [
            SizedBox(
                height: (Screen.height(context) * 0.05) +
                    UImanagement.headerHeight),
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
          prefixIcon: FontAwesomeIcons.houseChimneyWindow,
          focusNode: _familyNameFocus,
          onFieldSubmitted: (_) =>
              FocusScope.of(context).requestFocus(_membersFocus),
          hint: 'Family Name',
          valueController: _familyNameController,
        ),
        MyTextBox(
          prefixIcon: FontAwesomeIcons.peopleGroup,
          focusNode: _membersFocus,
          onFieldSubmitted: (_) =>
              FocusScope.of(context).requestFocus(_familyContactFocus),
          hint: 'No. of Members',
          isNum: true,
          valueController: _membersController,
        ),
        MyTextBox(
          prefixIcon: FontAwesomeIcons.peopleGroup,
          focusNode: _familyContactFocus,
          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          hint: 'Family Contact',
          isNum: true,
          valueController: _familyContactController,
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
          ondelete: () => _removeFamily(index),
          mywidth: Screen.width(context) * 0.8,
          name: _guestList[index]['name'] ?? '',
          members: int.parse(_guestList[index]['members'].toString()),
          contact: _guestList[index]['contact'] ?? '',
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ColoredButton(
          text: 'Add Family',
          width: Screen.width(context) * 0.7,
          onPressed: _addFamily,
        ),
        BorderButton(
          text: 'Done',
          width: Screen.width(context) * 0.7,
          onPressed: _submitFamilies,
        ),
      ],
    );
  }
}
