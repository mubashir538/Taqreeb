import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taqreeb/Components/Inputs/c_date_question.dart';
import 'package:taqreeb/Components/global/header_secondary.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_dropdown.dart';
import 'package:taqreeb/core/utils/images.dart';

class CreateFunction extends StatefulWidget {
  const CreateFunction({super.key});

  @override
  State<CreateFunction> createState() => _CreateFunctionState();
}

class _FunctionFormData {
  final TextEditingController name = TextEditingController();
  final TextEditingController budget = TextEditingController();
  final TextEditingController type = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController guestMax = TextEditingController();
  final TextEditingController guestMin = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode budgetFocus = FocusNode();
  final FocusNode typeFocus = FocusNode();
  final FocusNode dateFocus = FocusNode();
  final FocusNode guestMaxFocus = FocusNode();
  final FocusNode guestMinFocus = FocusNode();

  void dispose() {
    name.dispose();
    budget.dispose();
    type.dispose();
    date.dispose();
    guestMax.dispose();
    guestMin.dispose();
  }
}

class _CreateFunctionState extends State<CreateFunction> {
  final _formData = _FunctionFormData();
  final GlobalKey headerKey = GlobalKey();
  final Map<String, dynamic> _functionTypes = {};

  String _token = '';
  String _functionId = '';
  int _eventTypeId = 0;
  int _eventId = 0;
  bool _isLoading = true;
  bool _isEditMode = false;
  bool _hasChanges = false;
  Map<String, dynamic> _functionDetails = {};
  Map<String, dynamic> _routeArgs = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeFromArguments();
  }

  void _initializeFromArguments() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    _routeArgs = args;

    setState(() {
      _isEditMode = args['functionId'] != null;
      _functionId = args['functionId'] ?? '';
      _eventId = int.parse(args['eventId']?.toString() ?? '0');
    });

    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await _fetchEventTypes();
    await _fetchFunctionTypes();

    if (_isEditMode) {
      await _fetchFunctionDetails();
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchEventTypes() async {
    await ApiCall.fetchAPI(
      'getEventTypes/',
      onSuccess: (token, data) {
        _token = token;
        _findEventTypeId(data['eventTypes']);
      },
      context: mounted ? context : null,
    );
  }

  void _findEventTypeId(List<dynamic> eventTypes) {
    for (final type in eventTypes) {
      if (type['name'] == _routeArgs['type']) {
        _eventTypeId = type['id'];
        break;
      }
    }
  }

  Future<void> _fetchFunctionTypes() async {
    await ApiCall.fetchAPI(
      'getFunctionTypes/$_eventTypeId',
      onSuccess: (token, data) {
        if (mounted) {
          setState(() => _functionTypes.addAll(data));
        }
      },
      context: mounted ? context : null,
    );
  }

  Future<void> _fetchFunctionDetails() async {
    await ApiCall.fetchAPI(
      'ViewFunction/$_functionId',
      onSuccess: (token, data) {
        if (!mounted) return;

        setState(() {
          _functionDetails = data; // Store the complete response
          _token = token;

          if (!_hasChanges) {
            _populateFormData(
                _functionDetails['Fuctions']); // Use the stored data
            _hasChanges = true;
          }
        });
      },
      context: mounted ? context : null,
    );
  }

  void _populateFormData(Map<String, dynamic> function) {
    _formData.name.text = function['name'];
    _formData.type.text = function['type'];
    _formData.date.text = function['date'];
    _formData.budget.text = function['budget'].toString();
    _formData.guestMax.text = function['guestsmax'].toString();
    _formData.guestMin.text = function['guestsmin'].toString();
    _eventId = int.parse(function['eventId'].toString());
  }

  void _updateHeaderHeight(RenderBox renderBox) {
    if (mounted) {
      setState(() => UImanagement.headerHeight = renderBox.size.height);
    }
  }

  Future<void> _submitFunction() async {
    if (!_validateForm()) {
      MyScaffold(text: 'Please fill all the fields').show(context);
      return;
    }

    String nameValidation =
        Validations.validateServiceName(_formData.name.text);
    if (nameValidation != 'Ok') {
      MyScaffold(text: nameValidation).show(context);
      return;
    }
    if (int.parse(_formData.guestMin.text) >
        int.parse(_formData.guestMax.text)) {
      MyScaffold(text: 'Minimum Guests should be less than Maximum Guests')
          .show(context);
      return;
    }

    final response = await _sendFunctionRequest();
    _handleResponse(response);
  }

  bool _validateForm() {
    return _formData.name.text.isNotEmpty &&
        _formData.type.text.isNotEmpty &&
        _formData.date.text.isNotEmpty &&
        _formData.budget.text.isNotEmpty &&
        _formData.guestMax.text.isNotEmpty &&
        _formData.guestMin.text.isNotEmpty;
  }

  Future<Map<String, dynamic>> _sendFunctionRequest() async {
    return await MyApi.postRequest(
      endpoint: _isEditMode ? 'editfunction/' : 'createfunction/',
      headers: {'Authorization': 'Bearer $_token'},
      body: {
        'Function Name': _formData.name.text,
        'Date': _formData.date.text,
        'Type': _formData.type.text,
        'Budget': _formData.budget.text,
        'guest min': _formData.guestMin.text,
        'guest max': _formData.guestMax.text,
        'Function Id': _functionId,
        'Event Id': _eventId,
      },
    );
  }

  void _handleResponse(Map<String, dynamic> response) {
    if (response['status'] == 'success') {
      _showSuccessMessage();
      _navigateAfterSubmit();
    } else if (response['status'] == 'BudgetError') {
      _showBudgetWarning();
    } else {
      _showErrorMessage();
    }
  }

  void _showSuccessMessage() {
    MyScaffold(
      text: _isEditMode
          ? 'Function Updated Successfully'
          : 'Function Added Successfully',
    ).show(context);
  }

  void _navigateAfterSubmit() async {
    setState(() {
      _isLoading = true;
    });
    final userId = await MyStorage.getToken(MyTokens.userId) ?? "";

    await MyApi.deleteCache('YourEvents/$userId');

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/YourEvents',
      (route) => route.isFirst,
    );
  }

  void _showBudgetWarning() {
    WarningDialog(
      message: 'Event Budget is Exceeding',
      title: 'Budget Exceed',
      actions: [
        ColoredButton(text: 'Ok', onPressed: () => Navigator.pop(context))
      ],
    ).showDialogBox(context);
  }

  void _showErrorMessage() {
    MyScaffold(
      text: _isEditMode ? 'Error Updating Function' : 'Error Creating Function',
    ).show(context);
  }

  @override
  void dispose() {
    _formData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UImanagement.getHeaderHeight(
      headerKey: headerKey,
      callback: _updateHeaderHeight,
    );

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          _buildContent(),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
            ),
          ),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Headersecondary(
            heading: _isEditMode ? 'Edit Function' : 'Create Function',
            image: MyImages.function,
          ),
          SizedBox(height: Screen.height(context) * 0.04),
          SizedBox(
            width: Screen.width(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNameField(),
                _buildBudgetField(),
                _buildTypeDropdown(),
                _buildDateField(),
                _buildGuestMinField(),
                _buildGuestMaxField(),
                SizedBox(height: Screen.height(context) * 0.12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return MyTextBox(
      prefixIcon: FontAwesomeIcons.champagneGlasses,
      focusNode: _formData.nameFocus,
      onFieldSubmitted: (_) => _focusNext(_formData.budgetFocus),
      hint: 'Function Name',
      valueController: _formData.name,
    );
  }

  Widget _buildBudgetField() {
    return MyTextBox(
      prefixIcon: FontAwesomeIcons.moneyBill1Wave,
      focusNode: _formData.budgetFocus,
      onFieldSubmitted: (_) => _focusNext(_formData.typeFocus),
      hint: 'Budget',
      isNum: true,
      isPrice: true,
      valueController: _formData.budget,
    );
  }

  Widget _buildTypeDropdown() {
    return ResponsiveDropdown(
      focusNode: _formData.typeFocus,
      onFieldSubmitted: (_) => _focusNext(_formData.guestMinFocus),
      items: _isLoading
          ? []
          : _functionTypes['functionTypes']
              .map((val) => val['name'].toString())
              .cast<String>()
              .toList(),
      labelText: 'Function Type',
      onChanged: (value) => setState(() => _formData.type.text = value),
    );
  }

  Widget _buildDateField() {
    return DateQuestion(
      question: '',
      valuecontroller: _formData.date,
      focusNode: _formData.dateFocus,
      onFieldSubmitted: (_) => _focusNext(_formData.guestMinFocus),
    );
  }

  Widget _buildGuestMinField() {
    return MyTextBox(
      prefixIcon: FontAwesomeIcons.userGroup,
      focusNode: _formData.guestMinFocus,
      onFieldSubmitted: (_) => _focusNext(_formData.guestMaxFocus),
      hint: 'Minimum Guests',
      isNum: true,
      valueController: _formData.guestMin,
    );
  }

  Widget _buildGuestMaxField() {
    return MyTextBox(
      prefixIcon: FontAwesomeIcons.userGroup,
      focusNode: _formData.guestMaxFocus,
      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
      hint: 'Maximum Guests',
      isNum: true,
      valueController: _formData.guestMax,
    );
  }

  Widget _buildSubmitButton() {
    return Positioned(
      bottom: 0,
      child: Container(
        width: Screen.width(context),
        decoration: BoxDecoration(
          color: MyColors.darkLighter,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: EdgeInsets.all(Screen.max(context) * 0.02),
        child: ColoredButton(
          text: _isEditMode ? 'Edit Function' : 'Add Function',
          onPressed: _submitFunction,
        ),
      ),
    );
  }

  void _focusNext(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }
}
