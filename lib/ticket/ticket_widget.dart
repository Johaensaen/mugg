import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../backend/firebase_storage/storage.dart';
import '../dashboard/dashboard_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/upload_media.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketWidget extends StatefulWidget {
  const TicketWidget({Key key}) : super(key: key);

  @override
  _TicketWidgetState createState() => _TicketWidgetState();
}

class _TicketWidgetState extends State<TicketWidget> {
  String uploadedFileUrl = '';
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30,
                  borderWidth: 1,
                  buttonSize: 46,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF303030),
                    size: 24,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRight,
                        duration: Duration(milliseconds: 300),
                        reverseDuration: Duration(milliseconds: 300),
                        child: DashboardWidget(),
                      ),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 48),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Ticket',
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.bodyText1.override(
                        fontFamily: 'Poppins',
                        color: Color(0xFF303030),
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 30,
                        buttonSize: 46,
                        icon: Icon(
                          Icons.add_circle,
                          color: Color(0xFF8992FF),
                          size: 24,
                        ),
                        onPressed: () async {
                          final selectedMedia =
                              await selectMediaWithSourceBottomSheet(
                            context: context,
                            allowPhoto: true,
                            pickerFontFamily: 'Poppins',
                          );
                          if (selectedMedia != null &&
                              validateFileFormat(
                                  selectedMedia.storagePath, context)) {
                            showUploadMessage(context, 'Uploading file...',
                                showLoading: true);
                            final downloadUrl = await uploadData(
                                selectedMedia.storagePath, selectedMedia.bytes);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            if (downloadUrl != null) {
                              setState(() => uploadedFileUrl = downloadUrl);
                              showUploadMessage(context, 'Success!');
                            } else {
                              showUploadMessage(
                                  context, 'Failed to upload media');
                              return;
                            }
                          }

                          final usersUpdateData = createUsersRecordData(
                            ticketUrl: uploadedFileUrl,
                          );
                          await currentUserReference.update(usersUpdateData);
                          await Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              duration: Duration(milliseconds: 300),
                              reverseDuration: Duration(milliseconds: 300),
                              child: TicketWidget(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  width: 300,
                  height: 325,
                  decoration: BoxDecoration(
                    color: Color(0x98EE8B60),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(25, 25, 0, 0),
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Text(
                            'Lade über \"plus\"\nden QR-Code\ndes Tickets hoch',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.bodyText1,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                              child: Icon(
                                Icons.add_circle,
                                color: Color(0xFF303030),
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(50, 50, 0, 0),
                  child: AuthUserStreamWidget(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        currentUserDocument?.ticketUrl,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(25, 283, 0, 0),
                  child: AuthUserStreamWidget(
                    child: Text(
                      valueOrDefault<String>(
                        currentUserDisplayName,
                        'Name',
                      ),
                      style: FlutterFlowTheme.subtitle1.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
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
