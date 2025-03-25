import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_color_picker.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/Inputs/c_input_dropdown.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/header_secondary.dart';
import 'package:taqreeb/Screens/Temp/For%20Fyp2/Create%20AI%20Package/Components/Date%20Question.dart';
import 'package:taqreeb/Screens/Temp/For%20Fyp2/Create%20AI%20Package/Components/question%20group.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/images.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

// Event Form Data Model
class _EventFormData {
  final TextEditingController eventName = TextEditingController();
  final TextEditingController type = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController budget = TextEditingController();
  final TextEditingController themeColor = TextEditingController();
  final TextEditingController guestMin = TextEditingController();
  final TextEditingController guestMax = TextEditingController();

  final FocusNode eventNameFocus = FocusNode();
  final FocusNode typeFocus = FocusNode();
  final FocusNode dateFocus = FocusNode();
  final FocusNode locationFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final FocusNode budgetFocus = FocusNode();
  final FocusNode guestMinFocus = FocusNode();
  final FocusNode guestMaxFocus = FocusNode();
  final FocusNode themeColorFocus = FocusNode();

  void dispose() {
    eventName.dispose();
    type.dispose();
    date.dispose();
    location.dispose();
    description.dispose();
    budget.dispose();
    themeColor.dispose();
    guestMin.dispose();
    guestMax.dispose();

    eventNameFocus.dispose();
    typeFocus.dispose();
    dateFocus.dispose();
    locationFocus.dispose();
    descriptionFocus.dispose();
    budgetFocus.dispose();
    guestMinFocus.dispose();
    guestMaxFocus.dispose();
    themeColorFocus.dispose();
  }
}

class _CreateEventState extends State<CreateEvent> {
  final _formData = _EventFormData();
  final Map<String, dynamic> _eventTypes = {};
  bool _isLoading = true;
  bool _isEditMode = false;
  String _eventId = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeFromArguments();
  }

  void _initializeFromArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as String? ?? '';
    if (args.isNotEmpty) {
      setState(() {
        _eventId = args;
        _isEditMode = true;
      });
      _fetchEventDetails();
    }
  }

  Future<void> _fetchEventDetails() async {
    if (!_isEditMode) return;

    await ApiCall.fetchAPI(
      'eventdetails/$_eventId',
      onSuccess: (token, data) {
        if (!mounted) return;

        final eventDetail = data['EventDetail'];
        setState(() {
          _formData.eventName.text = eventDetail['name'];
          _formData.type.text = eventDetail['type'];
          _formData.date.text = eventDetail['date'];
          _formData.location.text = eventDetail['location'];
          _formData.description.text = eventDetail['description'];
          _formData.budget.text = eventDetail['budget'].toString();
          _formData.themeColor.text = eventDetail['themeColor'];
          _formData.guestMax.text = eventDetail['guestsmax'].toString();
          _formData.guestMin.text = eventDetail['guestsmin'].toString();
          _isLoading = false;
        });
      },
      context: mounted ? context : null,
    );
  }

  Future<void> _submitEvent() async {
    if (!_validateForm()) {
      MyScaffold(text: 'Please fill all the fields').show(context);
      return;
    }

    final response = await _sendEventRequest();
    _handleResponse(response);
  }

  bool _validateForm() {
    return _formData.eventName.text.isNotEmpty &&
        _formData.type.text.isNotEmpty &&
        _formData.date.text.isNotEmpty &&
        _formData.location.text.isNotEmpty &&
        _formData.description.text.isNotEmpty &&
        _formData.budget.text.isNotEmpty;
  }

  Future<Map<String, dynamic>> _sendEventRequest() async {
    final userId = await MyStorage.getToken(MyTokens.userId) ?? "";

    return await MyApi.postRequest(
      endpoint: _isEditMode ? 'EditEvent/' : 'CreateEvent/',
      headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      },
      body: {
        'userId': userId,
        'Event Name': _formData.eventName.text,
        'Event Type': _formData.type.text,
        'Date': _formData.date.text,
        'Location': _formData.location.text,
        'description': _formData.description.text,
        'Theme': _formData.themeColor.text,
        'Budget': _formData.budget.text,
        'EventId': _eventId,
        'guestmin': _formData.guestMin.text,
        'guestmax': _formData.guestMax.text,
      },
    );
  }

  void _handleResponse(Map<String, dynamic> response) {
    if (response['status'] == 'error') {
      MyScaffold(text: 'Something Went Wrong! Please Try Again Later!')
          .show(context);
      return;
    }

    final successMessage = _isEditMode
        ? 'Event Updated Successfully'
        : 'Event Created Successfully';
    final errorMessage =
        _isEditMode ? 'Error Updating Event' : 'Error Creating Event';

    if (response['status'] == 'success') {
      MyScaffold(text: successMessage).show(context);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/YourEvents',
        ModalRoute.withName('/'),
      );
    } else {
      MyScaffold(text: errorMessage).show(context);
    }
  }

  @override
  void dispose() {
    _formData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          _buildContent(),
          const Positioned(top: 0, child: Header()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Headersecondary(
            heading: _isEditMode ? "Edit Event" : "Create Event",
            para: "Plan your event effortlessly!",
            image: MyImages.SingupPng,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: Screen.width(context) * 0.05,
            ),
            child: Column(
              children: [
                _buildBasicInfoSection(),
                _buildDescriptionSection(),
                _buildGuestInfoSection(),
                _buildBudgetSection(),
              ],
            ),
          ),
          ColoredButton(
            text: _isEditMode ? "Edit Event" : "Create Event",
            onPressed: _submitEvent,
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return QuestionGroup(
      Heading: "Basic Info",
      questions: [
        MyTextBox(
          focusNode: _formData.eventNameFocus,
          onFieldSubmitted: (_) => _focusNext(_formData.typeFocus),
          hint: "Event Name",
          valueController: _formData.eventName,
        ),
        ResponsiveDropdown(
          focusNode: _formData.typeFocus,
          onFieldSubmitted: (_) => _focusNext(_formData.dateFocus),
          items: _isLoading
              ? []
              : _eventTypes['eventTypes']
                  .map((val) => val['name'].toString())
                  .cast<String>()
                  .toList(),
          labelText: 'Event Type',
          onChanged: (value) => setState(() => _formData.type.text = value),
        ),
        DateQuestion(
          focusNode: _formData.dateFocus,
          onFieldSubmitted: (_) => _focusNext(_formData.locationFocus),
          question: '',
          valuecontroller: _formData.date,
        ),
        MyTextBox(
          focusNode: _formData.locationFocus,
          onFieldSubmitted: (_) => _focusNext(_formData.themeColorFocus),
          hint: "Location",
          valueController: _formData.location,
        ),
        ColorPickerTextBox(
          focusNode: _formData.themeColorFocus,
          onFieldSubmitted: (_) => _focusNext(_formData.descriptionFocus),
          hint: "Theme Color",
          valueController: _formData.themeColor,
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return QuestionGroup(
      Heading: "Describe Your Event",
      questions: [
        DescriptionBox(
          focusNode: _formData.descriptionFocus,
          onFieldSubmitted: (_) => _focusNext(_formData.guestMinFocus),
          valueController: _formData.description,
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildGuestInfoSection() {
    return QuestionGroup(
      Heading: "Guest Info",
      questions: [
        MyTextBox(
          focusNode: _formData.guestMinFocus,
          onFieldSubmitted: (_) => _focusNext(_formData.guestMaxFocus),
          hint: "Minimum Guests",
          isNum: true,
          valueController: _formData.guestMin,
        ),
        MyTextBox(
          focusNode: _formData.guestMaxFocus,
          onFieldSubmitted: (_) => _focusNext(_formData.budgetFocus),
          hint: "Maximum Guests",
          isNum: true,
          valueController: _formData.guestMax,
        ),
      ],
    );
  }

  Widget _buildBudgetSection() {
    return QuestionGroup(
      Heading: "Budget",
      questions: [
        MyTextBox(
          focusNode: _formData.budgetFocus,
          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          hint: "Enter Budget",
          isNum: true,
          isPrice: true,
          valueController: _formData.budget,
        ),
      ],
    );
  }

  void _focusNext(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }
}
