import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/Inputs/c_input_dropdown.dart';
import 'package:taqreeb/Components/Inputs/c_input_location.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/core/utils/color.dart';

class AddCategoryListing extends StatefulWidget {
  const AddCategoryListing({super.key});

  @override
  State<AddCategoryListing> createState() => _AddCategoryListingState();
}

class _AddCategoryListingState extends State<AddCategoryListing> {
  final _formController = ListingFormController();
  final GlobalKey _headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeScreen();
    _fetchCategories();
  }

  void _initializeScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UImanagement.getHeaderHeight(
        headerKey: _headerKey,
        callback: _updateHeaderHeight,
      );
      _checkPreviousAttempt();
    });
  }

  void _updateHeaderHeight(RenderBox renderbox) {
    setState(() => UImanagement.headerHeight = renderbox.size.height);
  }

  Future<void> _checkPreviousAttempt() async {
    if (await MyStorage.exists(MyTokens.acname)) {
      WarningDialog(
        title: 'Fresh Start',
        message:
            'We noticed that you had lately attempted to Add a Listing Before. '
            'Do you want to continue where you left or want a Fresh Start?',
        actions: [
          ColoredButton(
            text: 'Fresh Start',
            onPressed: () {
              MyStorage.deleteToken(MyTokens.acname);
              Navigator.pop(context);
            },
          ),
          ColoredButton(
            text: 'Continue',
            onPressed: _navigateToSavedState,
          )
        ],
      ).showDialogBox(context);
    }
  }

  Future<void> _navigateToSavedState() async {
    if (await MyStorage.exists(MyTokens.packages)) {
      Navigator.pushNamed(
        context,
        '/AddCategory_MoreDetails',
        arguments: {'type': 'Business'},
      );
    } else if (await MyStorage.exists(MyTokens.bsfront)) {
      Navigator.pushNamed(context, '/BusinessSignup_Description');
    } else {
      Navigator.pushNamed(context, '/AddCategory_MoreDetails');
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final token = await MyStorage.getToken(MyTokens.accessToken) ?? '';
      final type = await MyTokens.getBusinessType();
      final response = await MyApi.getRequest(
        context: context,
        endpoint: 'business/categories/$type',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (!mounted) return;

      setState(() {
        _formController.token = token;
        _formController.categories = response ?? {};
        _formController.isLoading = false;
      });

      if (response == null || response['status'] == 'error') {
        MyScaffold(text: 'Something Went Wrong!').show(context);
      }
    } catch (e) {
      if (!mounted) return;
      MyScaffold(text: 'Failed to load categories').show(context);
      setState(() => _formController.isLoading = false);
    }
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    await _fetchCategories();
  }

  void _submitForm() {
    if (!_formController.validateForm()) {
      MyScaffold(text: 'Please fill all the fields').show(context);
      return;
    }

    String nameValidation =
        Validations.validateServiceName(_formController.nameController.text);
    if (nameValidation != 'Ok') {
      MyScaffold(text: nameValidation).show(context);
      return;
    }
    String descriptionValidation = Validations.validateDescription(
        _formController.descriptionController.text);

    if (descriptionValidation != 'Ok') {
      MyScaffold(text: descriptionValidation).show(context);
      return;
    }

    if (int.parse(
            _formController.priceminController.text.replaceAll(',', '')) >=
        int.parse(
            _formController.pricemaxController.text.replaceAll(',', ''))) {
      MyScaffold(text: 'Minimum Price should be less than Maximum Price')
          .show(context);
      return;
    }

    if (_formController.charactersLeft > 1050) {
      MyScaffold(text: 'Description is too Short').show(context);
      return;
    }

    if (_formController.charactersLeft < 0) {
      MyScaffold(text: 'Description is too Long').show(context);
      return;
    }

    final args = _formController.createArguments();
    final nextRoute = _formController.categoryRequiresAddons()
        ? '/AddCategory_Addons'
        : '/AddCategory_MoreDetails';

    Navigator.pushNamed(context, nextRoute, arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    UImanagement.getHeaderHeight(
      headerKey: _headerKey,
      callback: _updateHeaderHeight,
    );

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          _buildContent(),
          _buildHeader(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      color: MyColors.red,
      displacement: Screen.height(context) * 0.2,
      backgroundColor: MyColors.dark,
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: UImanagement.headerHeight),
            _buildNameField(),
            _buildDescriptionField(),
            _buildCharacterCounter(),
            _buildLocationField(),
            _buildCategoryDropdown(),
            _buildPriceFields(),
            const SizedBox(height: 16),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return MyTextBox(
      prefixIcon: FontAwesomeIcons.user,
      focusNode: _formController.nameFocus,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_formController.descriptionFocus),
      hint: 'Name',
      valueController: _formController.nameController,
    );
  }

  Widget _buildDescriptionField() {
    return DescriptionBox(
      focusNode: _formController.descriptionFocus,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_formController.locationFocus),
      valueController: _formController.descriptionController,
      onChanged: (value) =>
          setState(() => _formController.charactersLeft = 1100 - value.length),
    );
  }

  Widget _buildCharacterCounter() {
    return SizedBox(
      width: Screen.width(context) * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "${_formController.charactersLeft} characters left",
            style: GoogleFonts.roboto(
              color: MyColors.white,
              fontSize: Screen.max(context) * 0.015,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField() {
    return LocationInputWidget(
      locationController: _formController.locationController,
      onLocationChanged: (value) =>
          _formController.locationController.text = value,
    );
  }

  Widget _buildCategoryDropdown() {
    return ResponsiveDropdown(
      items: _formController.isLoading
          ? []
          : _formController.categories['categories']
              .map((value) => value['name'].toString())
              .cast<String>()
              .toList(),
      labelText: 'Category',
      onChanged: (value) => _formController.typeController.text = value,
    );
  }

  Widget _buildPriceFields() {
    return Column(
      children: [
        MyTextBox(
          prefixIcon: FontAwesomeIcons.moneyBill,
          focusNode: _formController.priceminFocus,
          onFieldSubmitted: (_) => FocusScope.of(context)
              .requestFocus(_formController.pricemaxFocus),
          hint: 'Minimum Price',
          isNum: true,
          isPrice: true,
          valueController: _formController.priceminController,
        ),
        MyTextBox(
          prefixIcon: FontAwesomeIcons.moneyBill,
          focusNode: _formController.pricemaxFocus,
          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          hint: 'Maximum Price',
          isNum: true,
          isPrice: true,
          valueController: _formController.pricemaxController,
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return ColoredButton(
      text: 'Continue',
      onPressed: _submitForm,
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      child: Header(
        key: _headerKey,
        heading: 'Add Service',
        para: 'Add your Services or Halls in the Application',
      ),
    );
  }
}

class ListingFormController {
  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController =
      TextEditingController(text: 'fsd');
  final TextEditingController priceminController = TextEditingController();
  final TextEditingController pricemaxController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  // Focus Nodes
  final FocusNode nameFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final FocusNode locationFocus = FocusNode();
  final FocusNode priceminFocus = FocusNode();
  final FocusNode pricemaxFocus = FocusNode();

  // State
  String token = '';
  Map<String, dynamic> categories = {};
  bool isLoading = true;
  int charactersLeft = 1100;

  bool validateForm() {
    return nameController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        typeController.text.isNotEmpty;
  }

  Map<String, dynamic> createArguments() {
    return {
      'name': nameController.text,
      'description': descriptionController.text,
      'location': locationController.text,
      'category': typeController.text,
      'pricemin': priceminController.text,
      'pricemax': pricemaxController.text,
    };
  }

  bool categoryRequiresAddons() {
    return typeController.text == 'Salon' || typeController.text == 'Parlour';
  }

  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    priceminController.dispose();
    pricemaxController.dispose();
    typeController.dispose();

    nameFocus.dispose();
    descriptionFocus.dispose();
    locationFocus.dispose();
    priceminFocus.dispose();
    pricemaxFocus.dispose();
  }
}
