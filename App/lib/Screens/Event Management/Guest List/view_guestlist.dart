import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Cards/c_guest_list_card.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Components/global/header.dart';

class CreateGuestList_List extends StatefulWidget {
  const CreateGuestList_List({super.key});

  @override
  State<CreateGuestList_List> createState() => _CreateGuestList_ListState();
}

class _CreateGuestList_ListState extends State<CreateGuestList_List> {
  final GlobalKey _headerKey = GlobalKey();
  final Map<String, dynamic> _guests = {};

  
  bool _isFunction = false;
  int _functionId = 0;
  int _eventId = 0;
  bool _isLoading = true;
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
    _fetchData();
  }

  Future<void> _fetchData() async {
    await ApiCall.fetchAPI(
      'show/guest/',
      type: 'post',
      body: {
        'EventId': _eventId,
        'FunctionID': _isFunction ? _functionId : "None"
      },
      onSuccess: (token, data) {
        if (mounted) {
          setState(() {
            _guests.addAll(data);
            _isLoading = false;
          });
        }
      },
      context: mounted ? context : null,
    );
  }

  void _updateHeaderHeight(RenderBox renderBox) {
    if (mounted) {
      setState(() => UI_Management.headerHeight = renderBox.size.height);
    }
  }

  Future<void> _deleteGuest(int index) async {
    final guestId = _guests['Guests'][index]['id'].toString();
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";

    final response = await MyApi.postRequest(
      headers: {'Authorization': 'Bearer $token'},
      endpoint: 'Delete/guest/',
      body: {'guestId': guestId},
    );

    if (!mounted) return;

    if (response['status'] == 'error') {
      MyScaffold(text: 'Something Went Wrong!').show(context);
    } else {
      setState(() => _guests['Guests'].removeAt(index));
    }
  }

  void _showAddGuestOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(Screen.max(context) * 0.02),
          decoration: BoxDecoration(
            color: MyColors.DarkLighter,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Screen.max(context) * 0.05),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAddOptionButton(
                    text: 'Add Person',
                    route: '/CreateGuestList_AddPerson',
                  ),
                  _buildAddOptionButton(
                    text: 'Add Family',
                    route: '/CreateGuestList_AddFamily',
                  ),
                ],
              ),
              SizedBox(height: Screen.max(context) * 0.03),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddOptionButton({required String text, required String route}) {
    return ColoredButton(
      text: text,
      width: Screen.width(context) * 0.4,
      textSize: Screen.max(context) * 0.015,
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route, arguments: _routeArgs);
      },
    );
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
              heading: 'Guest List',
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Container(
        width: Screen.width(context),
        constraints: BoxConstraints(minHeight: Screen.height(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              SizedBox(height: UI_Management.headerHeight),
              _isLoading ? _buildLoadingIndicator() : _buildGuestList(),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
      ),
    );
  }

  Widget _buildGuestList() {
    return SizedBox(
      width: Screen.width(context) * 0.9,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _guests['Guests']?.length ?? 0,
        itemBuilder: (context, index) => _buildGuestListItem(index),
      ),
    );
  }

  Widget _buildGuestListItem(int index) {
    final guest = _guests['Guests'][index];
    return Guests(
      onpressed: () {},
      ondelete: () => _deleteGuest(index),
      name: guest['name'] ?? '',
      contact: guest['type'] == "Family"
          ? guest['members']?.toString() ?? ''
          : guest['phone'] ?? '',
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: MyColors.Yellow,
      onPressed: _showAddGuestOptions,
      child: Icon(
        Icons.add,
        color: MyColors.Dark,
        size: Screen.max(context) * 0.04,
      ),
    );
  }
}
