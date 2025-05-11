import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_date_question.dart';
import 'package:taqreeb/Components/Inputs/c_input_location.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/Inputs/c_input_time.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/core/utils/color.dart';

class CreateInvitation extends StatefulWidget {
  const CreateInvitation({super.key});

  @override
  State<CreateInvitation> createState() => _CreateInvitationState();
}

class _CreateInvitationState extends State<CreateInvitation> {
  // bool _isLoading = false;
  bool _isChanged = false;
  String eventType = '';
  String functionType = '';

  // Basic Info Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController name2Controller = TextEditingController();
  TextEditingController sonController = TextEditingController();
  TextEditingController daughterController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController locationController =
      TextEditingController(text: 'North');
  TextEditingController fromNameController = TextEditingController();
  List<Map<String, TextEditingController>> programDetails = [];
  TextEditingController venueNameController = TextEditingController();
  List<Map<String, TextEditingController>> contactInfo = [];

  // Focus Nodes
  FocusNode nameFocus = FocusNode();
  FocusNode sonFocus = FocusNode();
  FocusNode name2Focus = FocusNode();
  FocusNode daughterFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode locationFocus = FocusNode();
  FocusNode fromNameFocus = FocusNode();
  List<FocusNode> programNameFocusNodes = [];
  List<FocusNode> programTimeFocusNodes = [];
  FocusNode venueNameFocus = FocusNode();
  List<FocusNode> contactNameFocusNodes = [];
  List<FocusNode> contactNumberFocusNodes = [];

  @override
  void initState() {
    super.initState();
    // Initialize with one contact field
    addContactInfo();
    _setupFocusNodes();
  }

  void _setupFocusNodes() {
    nameFocus.addListener(() {
      if (!nameFocus.hasFocus) {
        name2Focus.requestFocus();
      }
    });
    name2Focus.addListener(() {
      if (!name2Focus.hasFocus) {
        dateFocus.requestFocus();
      }
    });
    dateFocus.addListener(() {
      if (!dateFocus.hasFocus) {
        locationFocus.requestFocus();
      }
    });
    locationFocus.addListener(() {
      if (!locationFocus.hasFocus) {
        fromNameFocus.requestFocus();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isChanged) return;
    _isChanged = true;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (args['type'] != null) {
      setState(() {
        eventType = args['type'];
        functionType = args['functionType'] ?? "";
      });
    }
  }

  void addProgramDetail() {
    if (programDetails.length < 3) {
      setState(() {
        programDetails.add({
          'name': TextEditingController(),
          'time': TextEditingController(),
        });
        programNameFocusNodes.add(FocusNode());
        programTimeFocusNodes.add(FocusNode());

        // Setup focus node listeners
        if (programNameFocusNodes.length > 1) {
          programTimeFocusNodes[programTimeFocusNodes.length - 2]
              .addListener(() {
            if (!programTimeFocusNodes[programTimeFocusNodes.length - 2]
                .hasFocus) {
              programNameFocusNodes.last.requestFocus();
            }
          });
        }
      });
    }
  }

  void removeProgramDetail(int index) {
    setState(() {
      programDetails.removeAt(index);
      programNameFocusNodes.removeAt(index);
      programTimeFocusNodes.removeAt(index);
    });
  }

  void addContactInfo() {
    if (contactInfo.length < 3) {
      setState(() {
        contactInfo.add({
          'name': TextEditingController(),
          'number': TextEditingController(),
        });
        contactNameFocusNodes.add(FocusNode());
        contactNumberFocusNodes.add(FocusNode());

        if (contactNameFocusNodes.length > 1) {
          contactNumberFocusNodes[contactNumberFocusNodes.length - 2]
              .addListener(() {
            if (!contactNumberFocusNodes[contactNumberFocusNodes.length - 2]
                .hasFocus) {
              contactNameFocusNodes.last.requestFocus();
            }
          });
        }
      });
    }
  }

  void removeContactInfo(int index) {
    if (contactInfo.length > 1) {
      setState(() {
        contactInfo.removeAt(index);
        contactNameFocusNodes.removeAt(index);
        contactNumberFocusNodes.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: Screen.width(context),
              child: Column(
                children: [
                  SizedBox(height: Screen.height(context) * 0.2),
                  if (eventType.isNotEmpty) _buildFormContent(),
                ],
              ),
            ),
          ),
          const Positioned(
            top: 0,
            child: Header(heading: 'Create Invitation'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return Column(
      children: [
        _buildSection(
          title: 'Basic Info',
          children: [
            if (eventType == 'Wedding') ...[
              MyTextBox(
                prefixIcon: FontAwesomeIcons.person,
                hint: 'Groom Name',
                valueController: nameController,
                focusNode: nameFocus,
                onFieldSubmitted: (_) => sonFocus.requestFocus(),
              ),
              MyTextBox(
                prefixIcon: FontAwesomeIcons.user,
                hint: 'Son Of',
                valueController: sonController,
                focusNode: sonFocus,
                onFieldSubmitted: (_) => name2Focus.requestFocus(),
              ),
              MyTextBox(
                prefixIcon: FontAwesomeIcons.personDress,
                hint: 'Bride Name',
                valueController: name2Controller,
                focusNode: name2Focus,
                onFieldSubmitted: (_) => daughterFocus.requestFocus(),
              ),
              MyTextBox(
                prefixIcon: FontAwesomeIcons.user,
                hint: 'Daughter of',
                valueController: daughterController,
                focusNode: daughterFocus,
                onFieldSubmitted: (_) => dateFocus.requestFocus(),
              ),
            ] else if (eventType == 'Birthday') ...[
              MyTextBox(
                prefixIcon: FontAwesomeIcons.child,
                hint: 'Birthday Boy/Girl Name',
                valueController: nameController,
                focusNode: nameFocus,
                onFieldSubmitted: (_) => dateFocus.requestFocus(),
              ),
            ] else ...[
              // For all other event types (Corporate, Religious, etc.)
              MyTextBox(
                prefixIcon: FontAwesomeIcons.calendar,
                hint: 'Event Title',
                valueController: nameController,
                focusNode: nameFocus,
                onFieldSubmitted: (_) => dateFocus.requestFocus(),
              ),
            ],
            DateQuestion(
              question: 'Event Date',
              valuecontroller: dateController,
              focusNode: dateFocus,
              onFieldSubmitted: (_) => locationFocus.requestFocus(),
            ),
            LocationInputWidget(
              locationController: locationController,
              onLocationChanged: (value) {
                locationController.text = value;
              },
            ),
            MyTextBox(
              prefixIcon: FontAwesomeIcons.user,
              hint: 'Host Name',
              valueController: fromNameController,
              focusNode: fromNameFocus,
              onFieldSubmitted: (_) {
                if (programDetails.isNotEmpty) {
                  programNameFocusNodes.first.requestFocus();
                } else if (venueNameFocus.hasFocus) {
                  venueNameFocus.requestFocus();
                } else {
                  contactNameFocusNodes.first.requestFocus();
                }
              },
            ),
          ],
        ),

        _buildSection(
          title: 'Program Details (Optional)',
          children: [
            ...programDetails.asMap().entries.map((entry) {
              int index = entry.key;
              return Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: MyTextBox(
                      prefixIcon: FontAwesomeIcons.calendarDay,
                      hint: 'Program Name',
                      valueController: entry.value['name']!,
                      focusNode: programNameFocusNodes[index],
                      onFieldSubmitted: (_) =>
                          programTimeFocusNodes[index].requestFocus(),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: TimeInputWidget(
                      hint: 'Time',
                      valueController: entry.value['time']!,
                      focusNode: programTimeFocusNodes[index],
                      onFieldSubmitted: (_) {
                        if (index < programDetails.length - 1) {
                          programNameFocusNodes[index + 1].requestFocus();
                        } else if (venueNameFocus.hasFocus) {
                          venueNameFocus.requestFocus();
                        } else {
                          contactNameFocusNodes.first.requestFocus();
                        }
                      },
                      textInputAction: index == programDetails.length - 1
                          ? TextInputAction.done
                          : TextInputAction.next,
                    ),
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.circleMinus, color: MyColors.red),
                    onPressed: () => removeProgramDetail(index),
                  ),
                ],
              );
            }),
            if (programDetails.length < 3)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(FontAwesomeIcons.circlePlus, color: MyColors.yellow),
                  onPressed: addProgramDetail,
                ),
              ),
          ],
        ),

        // Venue Details Section (for Wedding, Corporate Meeting, Religious Event, Birthday, etc.)
        _buildSection(
          title: 'Venue Details (Optional)',
          children: [
            MyTextBox(
              prefixIcon: FontAwesomeIcons.house,
              hint: 'Venue Name',
              valueController: venueNameController,
              focusNode: venueNameFocus,
              onFieldSubmitted: (_) =>
                  contactNameFocusNodes.first.requestFocus(),
            ),
          ],
        ),

        // Contact Info Section (for all event types)
        _buildSection(
          title: 'Contact Info (At least one required)',
          children: [
            ...contactInfo.asMap().entries.map((entry) {
              int index = entry.key;
              return Row(
                children: [
                  Expanded(
                    child: MyTextBox(
                      prefixIcon: FontAwesomeIcons.user,
                      hint: 'Contact Name',
                      valueController: entry.value['name']!,
                      focusNode: contactNameFocusNodes[index],
                      onFieldSubmitted: (_) =>
                          contactNumberFocusNodes[index].requestFocus(),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: MyTextBox(
                      prefixIcon: FontAwesomeIcons.phone,
                      hint: 'Contact Number',
                      valueController: entry.value['number']!,
                      focusNode: contactNumberFocusNodes[index],
                      onFieldSubmitted: (_) {
                        if (index < contactInfo.length - 1) {
                          contactNameFocusNodes[index + 1].requestFocus();
                        }
                      },
                      isNum: true,
                    ),
                  ),
                  if (contactInfo.length > 1)
                    IconButton(
                      icon: Icon(FontAwesomeIcons.circleMinus, color: MyColors.red),
                      onPressed: () => removeContactInfo(index),
                    ),
                ],
              );
            }),
            if (contactInfo.length < 3)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(FontAwesomeIcons.circlePlus, color: MyColors.yellow),
                  onPressed: addContactInfo,
                ),
              ),
          ],
        ),

        // Submit Button
        Padding(
            padding: EdgeInsets.all(Screen.max(context) * 0.03),
            child: ColoredButton(
              text: 'Create Invitation',
              onPressed: _submitForm,
            )),
      ],
    );
  }

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(Screen.max(context) * 0.02),
      margin: EdgeInsets.all(Screen.max(context) * 0.02),
      decoration: BoxDecoration(
        color: MyColors.darkLighter,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: Screen.max(context) * 0.02,
              fontWeight: FontWeight.w700,
              color: MyColors.yellow,
            ),
          ),
          SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  void _submitForm() async {
    if (contactInfo.isEmpty) {
      MyScaffold(text: 'Please add at least one contact info').show(context);
      return;
    }

    // Validate contact numbers
    for (var contact in contactInfo) {
      final numberValidation =
          Validations.validateContact(contact['number']!.text);
      if (numberValidation != "Ok") {
        MyScaffold(text: numberValidation).show(context);
        return;
      }
    }

    // Validate basic info based on event type
    if (eventType == 'Wedding') {
      final groomValidation = Validations.validateName(nameController.text);
      if (groomValidation != "Ok") {
        MyScaffold(text: groomValidation).show(context);
        return;
      }

      final sonValidation = Validations.validateName(sonController.text);
      if (sonValidation != "Ok") {
        MyScaffold(text: sonValidation).show(context);
        return;
      }

      final daughterValidation =
          Validations.validateName(daughterController.text);
      if (daughterValidation != "Ok") {
        MyScaffold(text: daughterValidation).show(context);
        return;
      }

      final brideValidation = Validations.validateName(name2Controller.text);
      if (brideValidation != "Ok") {
        MyScaffold(text: brideValidation).show(context);
        return;
      }
    } else if (eventType == 'Birthday') {
      final birthdayPersonValidation =
          Validations.validateName(nameController.text);
      if (birthdayPersonValidation != "Ok") {
        MyScaffold(text: birthdayPersonValidation).show(context);
        return;
      }
    } else {
      // For all other event types
      final eventNameValidation = Validations.validateName(nameController.text);
      if (eventNameValidation != "Ok") {
        MyScaffold(text: eventNameValidation).show(context);
        return;
      }
    }

    // Validate date
    if (dateController.text.isEmpty) {
      MyScaffold(text: 'Please select an event date').show(context);
      return;
    }

    // Validate location
    if (locationController.text.isEmpty) {
      MyScaffold(text: 'Please enter a location').show(context);
      return;
    }

    // Validate host name
    final hostValidation = Validations.validateName(fromNameController.text);
    if (hostValidation != "Ok") {
      MyScaffold(text: hostValidation).show(context);
      return;
    }

    // Validate program details (if any)
    for (var program in programDetails) {
      if (program['name']!.text.isEmpty) {
        MyScaffold(text: 'Please enter program name').show(context);
        return;
      }
      if (program['time']!.text.isEmpty) {
        MyScaffold(text: 'Please select program time').show(context);
        return;
      }
    }

    // Validate venue name (if present)
    if (venueNameController.text.isEmpty) {
      MyScaffold(text: 'Please enter venue name').show(context);
      return;
    }

    // All validations passed - proceed with form submission
    Map<String, dynamic> formData = {
      'uid': await MyStorage.getToken(MyTokens.userId),
      'eventType': eventType,
      'functionType': functionType,
      'basicInfo': {
        'name1': nameController.text,
        if (eventType == 'Wedding') 'name2': name2Controller.text,
        if (eventType == 'Wedding') 's/o': sonController.text,
        if (eventType == 'Wedding') 'd/o': daughterController.text,
        'date': dateController.text,
        'location': locationController.text,
        'hostName': fromNameController.text,
      },
      'programDetails': programDetails
          .map((program) => {
                'name': program['name']!.text,
                'time': program['time']!.text,
              })
          .toList(),
      'venueName': venueNameController.text,
      'contactInfo': contactInfo
          .map((contact) => {
                'name': contact['name']!.text,
                'number': contact['number']!.text,
              })
          .toList(),
    };
    if (mounted) {
      Navigator.pushNamed(context, '/InvitationCardView',
          arguments: {'data': formData});
      MyScaffold(text: 'Creating Your Invitation Card, This may Take a While!')
          .show(context);
    }
  }

  @override
  void dispose() {
    // Dispose all controllers and focus nodes
    nameController.dispose();
    name2Controller.dispose();
    dateController.dispose();
    locationController.dispose();
    fromNameController.dispose();
    venueNameController.dispose();

    for (var program in programDetails) {
      program['name']!.dispose();
      program['time']!.dispose();
    }

    for (var contact in contactInfo) {
      contact['name']!.dispose();
      contact['number']!.dispose();
    }
    super.dispose();
  }
}
