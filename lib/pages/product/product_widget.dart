import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/components/empty_component/empty_component_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_search/text_search.dart';
import 'product_model.dart';
export 'product_model.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({super.key});

  static String routeName = 'Product';
  static String routePath = '/product';

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  late ProductModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      try {
        _model.allproduct = await ProductTable().queryRows(
          queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
        );
        _model.products = _model.allproduct!.toList().cast<ProductRow>();
        _model.productcount = _model.allproduct!.length;

        // Load profile data
        await _model.name(
          requestFn: () => ProfileTable().querySingleRow(
            queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
          ),
        );

        // Load product value data
        await _model.value(
          requestFn: () => ProductTable().queryRows(
            queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
          ),
        );
      } catch (e) {
        print('Error loading data: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    });

    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your project logo
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(
                    'assets/images/Frame_1000004833.png',
                  ).image,
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Text(
              'Loading Products...',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(fontWeight: FontWeight.w500),
                fontSize: 16.0,
                letterSpacing: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            context.pushNamed(
              AddProductsWidget.routeName,
              extra: <String, dynamic>{
                kTransitionInfoKey: const TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.bottomToTop,
                  duration: Duration(milliseconds: 0),
                ),
              },
            );
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          elevation: 8.0,
          child: Icon(
            Icons.add_rounded,
            color: FlutterFlowTheme.of(context).info,
            size: 24.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(1.0, 0.0, 0.0, 0.0),
              child: RefreshIndicator(
                onRefresh: () async {
                  safeSetState(() {
                    _model.clearPersonalCache();
                    _model.requestCompleted = false;
                  });
                  await _model.waitForRequestCompleted();
                },
                child: SingleChildScrollView(
                  primary: false,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          12.0,
                          20.0,
                          12.0,
                          0.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              color: Colors.transparent,
                              elevation: 5.0,
                              shape: const CircleBorder(),
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: FlutterFlowIconButton(
                                  borderRadius: 80.0,
                                  buttonSize: 40.0,
                                  fillColor: FlutterFlowTheme.of(
                                    context,
                                  ).primaryBackground,
                                  icon: Icon(
                                    Icons.menu_rounded,
                                    color: FlutterFlowTheme.of(
                                      context,
                                    ).primaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    context.pushNamed(
                                      MenuWidget.routeName,
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey:
                                            const TransitionInfo(
                                              hasTransition: true,
                                              transitionType: PageTransitionType
                                                  .rightToLeft,
                                              duration: Duration(
                                                milliseconds: 0,
                                              ),
                                            ),
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                10.0,
                                0.0,
                                10.0,
                                0.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Product Worth',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(
                                            context,
                                          ).primaryText,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontStyle,
                                        ),
                                  ),
                                  Align(
                                    alignment: const AlignmentDirectional(
                                      0.0,
                                      0.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(
                                          context,
                                        ).primaryText,
                                        borderRadius: BorderRadius.circular(
                                          80.0,
                                        ),
                                      ),
                                      alignment: const AlignmentDirectional(
                                        0.0,
                                        0.0,
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                              10.0,
                                              5.0,
                                              10.0,
                                              5.0,
                                            ),
                                        child: FutureBuilder<List<ProductRow>>(
                                          future: _model.value(
                                            requestFn: () =>
                                                ProductTable().queryRows(
                                                  queryFn: (q) => q.eqOrNull(
                                                    'user_id',
                                                    currentUserUid,
                                                  ),
                                                ),
                                          ),
                                          builder: (context, snapshot) {
                                            // While waiting, show nothing (null)
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              // Show a small shimmer or placeholder while loading
                                              return Center(
                                                child:
                                                    SizedBox.shrink(), // this renders nothing
                                              );
                                            }

                                            if (snapshot.hasData &&
                                                snapshot.data!.isEmpty) {
                                              // Show empty only when loading is *complete* and truly empty
                                              return const EmptyComponentWidget();
                                            }

                                            // When data exists
                                            final textProductRowList =
                                                snapshot.data!;
                                            return Text(
                                              '₹${functions.sumpurchaseValue(textProductRowList.map((e) => e.purchaseValue).toList())}',
                                              style:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                    font: GoogleFonts.readexPro(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).secondaryBackground,
                                                    fontSize: 12.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontStyle,
                                                  ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ].divide(const SizedBox(width: 5.0)),
                              ),
                            ),
                          ].divide(const SizedBox(width: 10.0)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          12.0,
                          0.0,
                          12.0,
                          0.0,
                        ),
                        child: FutureBuilder<List<ProfileRow>>(
                          future: _model.name(
                            requestFn: () => ProfileTable().querySingleRow(
                              queryFn: (q) =>
                                  q.eqOrNull('user_id', currentUserUid),
                            ),
                          ),
                          builder: (context, snapshot) {
                            // While loading, show nothing
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Show a small shimmer or placeholder while loading
                              return Center(
                                child:
                                    SizedBox.shrink(), // this renders nothing
                              );
                            }

                            if (snapshot.hasData && snapshot.data!.isEmpty) {
                              // Show empty only when loading is *complete* and truly empty
                              return const EmptyComponentWidget();
                            }

                            // Otherwise, proceed with your existing UI
                            final rowProfileRowList = snapshot.data!;
                            final rowProfileRow = rowProfileRowList.isNotEmpty
                                ? rowProfileRowList.first
                                : null;

                            return Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                              0.0,
                                              20.0,
                                              0.0,
                                              0.0,
                                            ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Hello',
                                              textAlign: TextAlign.end,
                                              style:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                    font: GoogleFonts.readexPro(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    fontSize: 20.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontStyle,
                                                  ),
                                            ),
                                            SizedBox(
                                              width: 250.0,
                                              child: TextFormField(
                                                controller:
                                                    _model.textController1 ??=
                                                        TextEditingController(
                                                          text: rowProfileRow
                                                              ?.name,
                                                        ),
                                                focusNode:
                                                    _model.textFieldFocusNode1,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                      '_model.textController1',
                                                      const Duration(
                                                        milliseconds: 2000,
                                                      ),
                                                      () async {
                                                        await ProfileTable().update(
                                                          data: {
                                                            'name': _model
                                                                .textController1
                                                                .text,
                                                          },
                                                          matchingRows: (rows) =>
                                                              rows.eqOrNull(
                                                                'user_id',
                                                                currentUserUid,
                                                              ),
                                                        );
                                                      },
                                                    ),
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).labelMedium.override(
                                                        font: GoogleFonts.readexPro(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).primaryText,
                                                        fontSize: 20.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .labelMedium
                                                                .fontStyle,
                                                      ),
                                                  hintText: 'Your Name ',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).labelMedium.override(
                                                        font: GoogleFonts.readexPro(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).primaryText,
                                                        fontSize: 20.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .labelMedium
                                                                .fontStyle,
                                                      ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                              color: Color(
                                                                0x00000000,
                                                              ),
                                                              width: 1.0,
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8.0,
                                                            ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                              color: Color(
                                                                0x00000000,
                                                              ),
                                                              width: 1.0,
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8.0,
                                                            ),
                                                      ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8.0,
                                                        ),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              FlutterFlowTheme.of(
                                                                context,
                                                              ).error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8.0,
                                                            ),
                                                      ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).secondaryBackground,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).bodyMedium.override(
                                                      font: GoogleFonts.readexPro(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      fontSize: 20.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                cursorColor:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).primaryText,
                                                validator: _model
                                                    .textController1Validator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                10.0,
                                0.0,
                                10.0,
                                0.0,
                              ),
                              child: Container(
                                decoration: const BoxDecoration(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                            0.0,
                                            10.0,
                                            0.0,
                                            0.0,
                                          ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primaryText,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: SizedBox(
                                                      width: 250.0,
                                                      child: TextFormField(
                                                        controller: _model
                                                            .textController2,
                                                        focusNode: _model
                                                            .textFieldFocusNode2,
                                                        onChanged: (_) => EasyDebounce.debounce(
                                                          '_model.textController2',
                                                          const Duration(
                                                            milliseconds: 2000,
                                                          ),
                                                          () async {
                                                            if (_model
                                                                    .textController2
                                                                    .text ==
                                                                '') {
                                                              _model.searchedproduct =
                                                                  [];
                                                              safeSetState(
                                                                () {},
                                                              );
                                                              safeSetState(() {
                                                                _model
                                                                    .clearPersonalCache();
                                                                _model.requestCompleted =
                                                                    false;
                                                              });
                                                              await _model
                                                                  .waitForRequestCompleted();
                                                            } else {
                                                              safeSetState(() {
                                                                _model.simpleSearchResults =
                                                                    TextSearch(
                                                                          (_model.products
                                                                                      .map(
                                                                                        (
                                                                                          e,
                                                                                        ) => e.name,
                                                                                      )
                                                                                      .toList()
                                                                                  as List)
                                                                              .cast<
                                                                                String
                                                                              >()
                                                                              .map(
                                                                                (
                                                                                  str,
                                                                                ) => TextSearchItem.fromTerms(
                                                                                  str,
                                                                                  [
                                                                                    str,
                                                                                  ],
                                                                                ),
                                                                              )
                                                                              .toList(),
                                                                        )
                                                                        .search(
                                                                          _model
                                                                              .textController2
                                                                              .text,
                                                                        )
                                                                        .map(
                                                                          (
                                                                            r,
                                                                          ) => r
                                                                              .object,
                                                                        )
                                                                        .toList();
                                                              });
                                                              _model
                                                                  .searchedproduct = _model
                                                                  .products
                                                                  .where(
                                                                    (
                                                                      e,
                                                                    ) => _model
                                                                        .simpleSearchResults
                                                                        .contains(
                                                                          e.name,
                                                                        ),
                                                                  )
                                                                  .toList()
                                                                  .cast<
                                                                    ProductRow
                                                                  >();
                                                              safeSetState(
                                                                () {},
                                                              );
                                                            }
                                                          },
                                                        ),
                                                        autofocus: false,
                                                        obscureText: false,
                                                        decoration: InputDecoration(
                                                          isDense: true,
                                                          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                            font: GoogleFonts.readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontStyle,
                                                            ),
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          hintText:
                                                              'Search your Products here',
                                                          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                            font: GoogleFonts.readexPro(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontStyle,
                                                            ),
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                  color: Color(
                                                                    0x00000000,
                                                                  ),
                                                                  width: 1.0,
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8.0,
                                                                ),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                  color: Color(
                                                                    0x00000000,
                                                                  ),
                                                                  width: 1.0,
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8.0,
                                                                ),
                                                          ),
                                                          errorBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color:
                                                                  FlutterFlowTheme.of(
                                                                    context,
                                                                  ).error,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8.0,
                                                                ),
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      FlutterFlowTheme.of(
                                                                        context,
                                                                      ).error,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8.0,
                                                                    ),
                                                              ),
                                                          filled: true,
                                                          fillColor:
                                                              FlutterFlowTheme.of(
                                                                context,
                                                              ).secondaryBackground,
                                                        ),
                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          font: GoogleFonts.readexPro(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        maxLines: null,
                                                        cursorColor:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).primaryText,
                                                        validator: _model
                                                            .textController2Validator
                                                            .asValidator(
                                                              context,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  if ((_model
                                                          .searchedproduct
                                                          .isNotEmpty) ==
                                                      true)
                                                    FlutterFlowIconButton(
                                                      borderRadius: 8.0,
                                                      buttonSize: 40.0,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).secondaryBackground,
                                                      icon: Icon(
                                                        Icons.close,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).primaryText,
                                                        size: 24.0,
                                                      ),
                                                      onPressed: () async {
                                                        safeSetState(() {
                                                          _model.textController2
                                                              ?.clear();
                                                        });
                                                        _model.searchedproduct =
                                                            [];
                                                        safeSetState(() {});
                                                        safeSetState(() {
                                                          _model
                                                              .clearPersonalCache();
                                                          _model.requestCompleted =
                                                              false;
                                                        });
                                                        await _model
                                                            .waitForRequestCompleted();
                                                      },
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ].divide(const SizedBox(width: 5.0)).around(const SizedBox(width: 5.0)),
                                      ),
                                    ),
                                    if (_model.searchedproduct.isEmpty)
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                              0.0,
                                              5.0,
                                              0.0,
                                              10.0,
                                            ),
                                        child: FutureBuilder<List<ProductRow>>(
                                          future: _model
                                              .personal(
                                                requestFn: () =>
                                                    ProductTable().queryRows(
                                                      queryFn: (q) => q
                                                          .eqOrNull(
                                                            'user_id',
                                                            currentUserUid,
                                                          )
                                                          .order(
                                                            'validity_date',
                                                            ascending: true,
                                                          )
                                                          .order('created_at'),
                                                    ),
                                              )
                                              .then((result) {
                                                _model.requestCompleted = true;
                                                return result;
                                              }),
                                          builder: (context, snapshot) {
                                            // Customize what your widget looks like when it's loading.
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child:
                                                    SizedBox.shrink(), // this renders nothing
                                              );
                                            }
                                            List<ProductRow>
                                            listViewProductProductRowList =
                                                snapshot.data!;

                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              primary: false,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount:
                                                  listViewProductProductRowList
                                                      .length,
                                              itemBuilder: (context, listViewProductIndex) {
                                                final listViewProductProductRow =
                                                    listViewProductProductRowList[listViewProductIndex];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional.fromSTEB(
                                                        0.0,
                                                        10.0,
                                                        0.0,
                                                        0.0,
                                                      ),
                                                  child: FutureBuilder<ApiCallResponse>(
                                                    future: GetSignedUrlCall.call(
                                                      imagepathsList:
                                                          listViewProductProductRow
                                                              .productPhoto,
                                                    ),
                                                    builder: (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const SizedBox.shrink();
                                                      }

                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        if (!snapshot.hasData ||
                                                            snapshot.data ==
                                                                null ||
                                                            (snapshot
                                                                    .data
                                                                    ?.jsonBody ==
                                                                null) ||
                                                            (snapshot
                                                                        .data
                                                                        ?.jsonBody
                                                                    is List &&
                                                                (snapshot
                                                                            .data
                                                                            ?.jsonBody
                                                                        as List)
                                                                    .isEmpty)) {
                                                          return const EmptyComponentWidget();
                                                        }
                                                      }

                                                      // 3️⃣ Success → proceed with your container
                                                      final containerGetSignedUrlResponse =
                                                          snapshot.data!;

                                                      return InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          context.pushNamed(
                                                            ProductDetailsWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'product':
                                                                  serializeParam(
                                                                    listViewProductProductRow
                                                                        .id,
                                                                    ParamType
                                                                        .String,
                                                                  ),
                                                            }.withoutNulls,
                                                            extra: <String, dynamic>{
                                                              kTransitionInfoKey: const TransitionInfo(
                                                                hasTransition:
                                                                    true,
                                                                transitionType:
                                                                    PageTransitionType
                                                                        .scale,
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                duration: Duration(
                                                                  milliseconds:
                                                                      0,
                                                                ),
                                                              ),
                                                            },
                                                          );

                                                          safeSetState(() {
                                                            _model
                                                                .clearPersonalCache();
                                                            _model.requestCompleted =
                                                                false;
                                                          });
                                                          await _model
                                                              .waitForRequestCompleted();
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: FlutterFlowTheme.of(
                                                              context,
                                                            ).secondaryBackground,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  15.0,
                                                                ),
                                                            shape: BoxShape
                                                                .rectangle,
                                                            border: Border.all(
                                                              color:
                                                                  FlutterFlowTheme.of(
                                                                    context,
                                                                  ).primaryText,
                                                              width: 0.5,
                                                            ),
                                                          ),
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                0.0,
                                                                0.0,
                                                              ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional.fromSTEB(
                                                                      0.0,
                                                                      7.5,
                                                                      0.0,
                                                                      7.5,
                                                                    ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children:
                                                                      [
                                                                            if (containerGetSignedUrlResponse.succeeded ==
                                                                                true)
                                                                              Flexible(
                                                                                child: Stack(
                                                                                  alignment: const AlignmentDirectional(
                                                                                    1.0,
                                                                                    -1.0,
                                                                                  ),
                                                                                  children: [
                                                                                    ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(
                                                                                        8.0,
                                                                                      ),
                                                                                      child: CachedNetworkImage(
                                                                                        fadeInDuration: const Duration(
                                                                                          milliseconds: 0,
                                                                                        ),
                                                                                        fadeOutDuration: const Duration(
                                                                                          milliseconds: 0,
                                                                                        ),
                                                                                        imageUrl: getJsonField(
                                                                                          containerGetSignedUrlResponse.jsonBody,
                                                                                          r'''$.signedUrls[0]''',
                                                                                        ).toString(),
                                                                                        width: 75.0,
                                                                                        height: 75.0,
                                                                                        fit: BoxFit.cover,
                                                                                      ),
                                                                                    ),
                                                                                    if (listViewProductProductRow.purchaseValue !=
                                                                                        0)
                                                                                      Padding(
                                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                          0.0,
                                                                                          5.0,
                                                                                          10.0,
                                                                                          0.0,
                                                                                        ),
                                                                                        child: Container(
                                                                                          decoration: BoxDecoration(
                                                                                            color: const Color(
                                                                                              0xFF88929A,
                                                                                            ),
                                                                                            borderRadius: BorderRadius.circular(
                                                                                              10.0,
                                                                                            ),
                                                                                          ),
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                              7.0,
                                                                                              3.0,
                                                                                              7.0,
                                                                                              3.0,
                                                                                            ),
                                                                                            child: Text(
                                                                                              valueOrDefault<
                                                                                                String
                                                                                              >(
                                                                                                functions.formatIndianCurrency(
                                                                                                  listViewProductProductRow.purchaseValue,
                                                                                                ),
                                                                                                '0',
                                                                                              ),
                                                                                              style:
                                                                                                  FlutterFlowTheme.of(
                                                                                                    context,
                                                                                                  ).bodyMedium.override(
                                                                                                    font: GoogleFonts.readexPro(
                                                                                                      fontWeight: FlutterFlowTheme.of(
                                                                                                        context,
                                                                                                      ).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(
                                                                                                        context,
                                                                                                      ).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    fontSize: 10.0,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FlutterFlowTheme.of(
                                                                                                      context,
                                                                                                    ).bodyMedium.fontWeight,
                                                                                                    fontStyle: FlutterFlowTheme.of(
                                                                                                      context,
                                                                                                    ).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            Container(
                                                                              width: 200.0,
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).secondaryBackground,
                                                                              ),
                                                                              alignment: const AlignmentDirectional(
                                                                                0.0,
                                                                                -1.0,
                                                                              ),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children:
                                                                                    [
                                                                                          Container(
                                                                                            width: double.infinity,
                                                                                            decoration: const BoxDecoration(),
                                                                                            child: Text(
                                                                                              valueOrDefault<
                                                                                                String
                                                                                              >(
                                                                                                listViewProductProductRow.name,
                                                                                                'Product_name',
                                                                                              ),
                                                                                              style:
                                                                                                  FlutterFlowTheme.of(
                                                                                                    context,
                                                                                                  ).bodyMedium.override(
                                                                                                    font: GoogleFonts.readexPro(
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                      fontStyle: FlutterFlowTheme.of(
                                                                                                        context,
                                                                                                      ).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontStyle: FlutterFlowTheme.of(
                                                                                                      context,
                                                                                                    ).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                          ),
                                                                                          if (listViewProductProductRow.description !=
                                                                                              '')
                                                                                            Container(
                                                                                              width: double.infinity,
                                                                                              decoration: const BoxDecoration(),
                                                                                              child: Text(
                                                                                                valueOrDefault<
                                                                                                  String
                                                                                                >(
                                                                                                  listViewProductProductRow.description,
                                                                                                  'Product_description',
                                                                                                ),
                                                                                                style:
                                                                                                    FlutterFlowTheme.of(
                                                                                                      context,
                                                                                                    ).bodyMedium.override(
                                                                                                      font: GoogleFonts.readexPro(
                                                                                                        fontWeight: FlutterFlowTheme.of(
                                                                                                          context,
                                                                                                        ).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(
                                                                                                          context,
                                                                                                        ).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      color: FlutterFlowTheme.of(
                                                                                                        context,
                                                                                                      ).primaryText,
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(
                                                                                                        context,
                                                                                                      ).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(
                                                                                                        context,
                                                                                                      ).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          if (containerGetSignedUrlResponse.succeeded !=
                                                                                              true)
                                                                                            Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children:
                                                                                                  [
                                                                                                    Text(
                                                                                                      valueOrDefault<
                                                                                                        String
                                                                                                      >(
                                                                                                        functions.formatIndianCurrency(
                                                                                                          listViewProductProductRow.purchaseValue,
                                                                                                        ),
                                                                                                        '0',
                                                                                                      ),
                                                                                                      style:
                                                                                                          FlutterFlowTheme.of(
                                                                                                            context,
                                                                                                          ).bodyMedium.override(
                                                                                                            font: GoogleFonts.readexPro(
                                                                                                              fontWeight: FlutterFlowTheme.of(
                                                                                                                context,
                                                                                                              ).bodyMedium.fontWeight,
                                                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                                                context,
                                                                                                              ).bodyMedium.fontStyle,
                                                                                                            ),
                                                                                                            letterSpacing: 0.0,
                                                                                                            fontWeight: FlutterFlowTheme.of(
                                                                                                              context,
                                                                                                            ).bodyMedium.fontWeight,
                                                                                                            fontStyle: FlutterFlowTheme.of(
                                                                                                              context,
                                                                                                            ).bodyMedium.fontStyle,
                                                                                                          ),
                                                                                                    ),
                                                                                                  ].divide(
                                                                                                    const SizedBox(
                                                                                                      width: 10.0,
                                                                                                    ),
                                                                                                  ),
                                                                                            ),
                                                                                          if (dateTimeFormat(
                                                                                                "d/M/y",
                                                                                                listViewProductProductRow.purchaseDate,
                                                                                              ) !=
                                                                                              '')
                                                                                            Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children:
                                                                                                  [
                                                                                                    Text(
                                                                                                      'Purchased :',
                                                                                                      style:
                                                                                                          FlutterFlowTheme.of(
                                                                                                            context,
                                                                                                          ).bodyMedium.override(
                                                                                                            font: GoogleFonts.readexPro(
                                                                                                              fontWeight: FlutterFlowTheme.of(
                                                                                                                context,
                                                                                                              ).bodyMedium.fontWeight,
                                                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                                                context,
                                                                                                              ).bodyMedium.fontStyle,
                                                                                                            ),
                                                                                                            color: FlutterFlowTheme.of(
                                                                                                              context,
                                                                                                            ).secondaryText,
                                                                                                            letterSpacing: 0.0,
                                                                                                            fontWeight: FlutterFlowTheme.of(
                                                                                                              context,
                                                                                                            ).bodyMedium.fontWeight,
                                                                                                            fontStyle: FlutterFlowTheme.of(
                                                                                                              context,
                                                                                                            ).bodyMedium.fontStyle,
                                                                                                          ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      valueOrDefault<
                                                                                                        String
                                                                                                      >(
                                                                                                        functions.datecount(
                                                                                                          getCurrentTimestamp,
                                                                                                          listViewProductProductRow.purchaseDate,
                                                                                                        ),
                                                                                                        'purchased_date',
                                                                                                      ),
                                                                                                      style:
                                                                                                          FlutterFlowTheme.of(
                                                                                                            context,
                                                                                                          ).bodyMedium.override(
                                                                                                            font: GoogleFonts.readexPro(
                                                                                                              fontWeight: FlutterFlowTheme.of(
                                                                                                                context,
                                                                                                              ).bodyMedium.fontWeight,
                                                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                                                context,
                                                                                                              ).bodyMedium.fontStyle,
                                                                                                            ),
                                                                                                            letterSpacing: 0.0,
                                                                                                            fontWeight: FlutterFlowTheme.of(
                                                                                                              context,
                                                                                                            ).bodyMedium.fontWeight,
                                                                                                            fontStyle: FlutterFlowTheme.of(
                                                                                                              context,
                                                                                                            ).bodyMedium.fontStyle,
                                                                                                          ),
                                                                                                    ),
                                                                                                  ].divide(
                                                                                                    const SizedBox(
                                                                                                      width: 10.0,
                                                                                                    ),
                                                                                                  ),
                                                                                            ),
                                                                                          if (listViewProductProductRow.validityDate !=
                                                                                              null)
                                                                                            SingleChildScrollView(
                                                                                              scrollDirection: Axis.horizontal,
                                                                                              child: Row(
                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children:
                                                                                                    [
                                                                                                      Text(
                                                                                                        'Warranty till',
                                                                                                        style:
                                                                                                            FlutterFlowTheme.of(
                                                                                                              context,
                                                                                                            ).bodyMedium.override(
                                                                                                              font: GoogleFonts.readexPro(
                                                                                                                fontWeight: FlutterFlowTheme.of(
                                                                                                                  context,
                                                                                                                ).bodyMedium.fontWeight,
                                                                                                                fontStyle: FlutterFlowTheme.of(
                                                                                                                  context,
                                                                                                                ).bodyMedium.fontStyle,
                                                                                                              ),
                                                                                                              color:
                                                                                                                  functions.isDateWithin30Days(
                                                                                                                        getCurrentTimestamp,
                                                                                                                        listViewProductProductRow.validityDate,
                                                                                                                      ) ==
                                                                                                                      true
                                                                                                                  ? FlutterFlowTheme.of(
                                                                                                                      context,
                                                                                                                    ).error
                                                                                                                  : FlutterFlowTheme.of(
                                                                                                                      context,
                                                                                                                    ).secondary,
                                                                                                              letterSpacing: 0.0,
                                                                                                              fontWeight: FlutterFlowTheme.of(
                                                                                                                context,
                                                                                                              ).bodyMedium.fontWeight,
                                                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                                                context,
                                                                                                              ).bodyMedium.fontStyle,
                                                                                                            ),
                                                                                                      ),
                                                                                                      Text(
                                                                                                        dateTimeFormat(
                                                                                                          "d MMMM y",
                                                                                                          listViewProductProductRow.validityDate!,
                                                                                                        ),
                                                                                                        style:
                                                                                                            FlutterFlowTheme.of(
                                                                                                              context,
                                                                                                            ).bodyMedium.override(
                                                                                                              font: GoogleFonts.readexPro(
                                                                                                                fontWeight: FlutterFlowTheme.of(
                                                                                                                  context,
                                                                                                                ).bodyMedium.fontWeight,
                                                                                                                fontStyle: FlutterFlowTheme.of(
                                                                                                                  context,
                                                                                                                ).bodyMedium.fontStyle,
                                                                                                              ),
                                                                                                              color:
                                                                                                                  functions.isDateWithin30Days(
                                                                                                                        getCurrentTimestamp,
                                                                                                                        listViewProductProductRow.validityDate,
                                                                                                                      ) ==
                                                                                                                      true
                                                                                                                  ? FlutterFlowTheme.of(
                                                                                                                      context,
                                                                                                                    ).error
                                                                                                                  : FlutterFlowTheme.of(
                                                                                                                      context,
                                                                                                                    ).secondary,
                                                                                                              letterSpacing: 0.0,
                                                                                                              fontWeight: FlutterFlowTheme.of(
                                                                                                                context,
                                                                                                              ).bodyMedium.fontWeight,
                                                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                                                context,
                                                                                                              ).bodyMedium.fontStyle,
                                                                                                            ),
                                                                                                      ),
                                                                                                    ].divide(
                                                                                                      const SizedBox(
                                                                                                        width: 4.0,
                                                                                                      ),
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                        ]
                                                                                        .divide(
                                                                                          const SizedBox(
                                                                                            height: 7.0,
                                                                                          ),
                                                                                        )
                                                                                        .around(
                                                                                          const SizedBox(
                                                                                            height: 7.0,
                                                                                          ),
                                                                                        ),
                                                                              ),
                                                                            ),
                                                                          ]
                                                                          .divide(
                                                                            const SizedBox(
                                                                              width: 15.0,
                                                                            ),
                                                                          )
                                                                          .around(
                                                                            const SizedBox(
                                                                              width: 15.0,
                                                                            ),
                                                                          ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    Builder(
                                      builder: (context) {
                                        final searchproduct = _model
                                            .searchedproduct
                                            .toList()
                                            .take(10)
                                            .toList();

                                        return InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            _model.searchedproduct = [];
                                            safeSetState(() {});
                                            safeSetState(() {
                                              _model.textController2?.clear();
                                            });
                                          },
                                          child: ListView.separated(
                                            padding: EdgeInsets.zero,
                                            primary: false,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: searchproduct.length,
                                            separatorBuilder: (_, __) =>
                                                const SizedBox(height: 10.0),
                                            itemBuilder: (context, searchproductIndex) {
                                              final searchproductItem =
                                                  searchproduct[searchproductIndex];
                                              return Padding(
                                                padding:
                                                    const EdgeInsetsDirectional.fromSTEB(
                                                      0.0,
                                                      10.0,
                                                      0.0,
                                                      0.0,
                                                    ),
                                                child: FutureBuilder<ApiCallResponse>(
                                                  future: GetSignedUrlCall.call(
                                                    imagepathsList:
                                                        searchproductItem
                                                            .productPhoto,
                                                  ),
                                                  builder: (context, snapshot) {
                                                    // Customize what your widget looks like when it's loading.
                                                    if (!snapshot.hasData) {
                                                      return Center(
                                                        child: SizedBox(
                                                          width: 40.0,
                                                          height: 40.0,
                                                          child: SpinKitPulse(
                                                            color:
                                                                FlutterFlowTheme.of(
                                                                  context,
                                                                ).primary,
                                                            size: 40.0,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    final containerGetSignedUrlResponse =
                                                        snapshot.data!;

                                                    return InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        context.pushNamed(
                                                          ProductDetailsWidget
                                                              .routeName,
                                                          queryParameters: {
                                                            'product':
                                                                serializeParam(
                                                                  searchproductItem
                                                                      .id,
                                                                  ParamType
                                                                      .String,
                                                                ),
                                                          }.withoutNulls,
                                                          extra: <String, dynamic>{
                                                            kTransitionInfoKey: const TransitionInfo(
                                                              hasTransition:
                                                                  true,
                                                              transitionType:
                                                                  PageTransitionType
                                                                      .scale,
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              duration: Duration(
                                                                milliseconds: 0,
                                                              ),
                                                            ),
                                                          },
                                                        );

                                                        safeSetState(() {
                                                          _model
                                                              .clearPersonalCache();
                                                          _model.requestCompleted =
                                                              false;
                                                        });
                                                        await _model
                                                            .waitForRequestCompleted();
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: FlutterFlowTheme.of(
                                                            context,
                                                          ).secondaryBackground,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15.0,
                                                              ),
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                            color:
                                                                FlutterFlowTheme.of(
                                                                  context,
                                                                ).primaryText,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        alignment:
                                                            const AlignmentDirectional(
                                                              0.0,
                                                              0.0,
                                                            ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional.fromSTEB(
                                                                    0.0,
                                                                    7.5,
                                                                    0.0,
                                                                    7.5,
                                                                  ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children:
                                                                    [
                                                                          if (containerGetSignedUrlResponse.succeeded ==
                                                                              true)
                                                                            Flexible(
                                                                              child: Stack(
                                                                                alignment: const AlignmentDirectional(
                                                                                  1.0,
                                                                                  -1.0,
                                                                                ),
                                                                                children: [
                                                                                  ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      8.0,
                                                                                    ),
                                                                                    child: CachedNetworkImage(
                                                                                      fadeInDuration: const Duration(
                                                                                        milliseconds: 0,
                                                                                      ),
                                                                                      fadeOutDuration: const Duration(
                                                                                        milliseconds: 0,
                                                                                      ),
                                                                                      imageUrl: getJsonField(
                                                                                        containerGetSignedUrlResponse.jsonBody,
                                                                                        r'''$.signedUrls[0]''',
                                                                                      ).toString(),
                                                                                      width: 100.0,
                                                                                      height: 100.0,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                  if (searchproductItem.purchaseValue !=
                                                                                      0)
                                                                                    Padding(
                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                        0.0,
                                                                                        5.0,
                                                                                        10.0,
                                                                                        0.0,
                                                                                      ),
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: const Color(
                                                                                            0xFF88929A,
                                                                                          ),
                                                                                          borderRadius: BorderRadius.circular(
                                                                                            10.0,
                                                                                          ),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                            10.0,
                                                                                            5.0,
                                                                                            10.0,
                                                                                            5.0,
                                                                                          ),
                                                                                          child: Text(
                                                                                            valueOrDefault<
                                                                                              String
                                                                                            >(
                                                                                              functions.formatIndianCurrency(
                                                                                                searchproductItem.purchaseValue,
                                                                                              ),
                                                                                              '0',
                                                                                            ),
                                                                                            style:
                                                                                                FlutterFlowTheme.of(
                                                                                                  context,
                                                                                                ).bodyMedium.override(
                                                                                                  font: GoogleFonts.readexPro(
                                                                                                    fontWeight: FlutterFlowTheme.of(
                                                                                                      context,
                                                                                                    ).bodyMedium.fontWeight,
                                                                                                    fontStyle: FlutterFlowTheme.of(
                                                                                                      context,
                                                                                                    ).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FlutterFlowTheme.of(
                                                                                                    context,
                                                                                                  ).bodyMedium.fontWeight,
                                                                                                  fontStyle: FlutterFlowTheme.of(
                                                                                                    context,
                                                                                                  ).bodyMedium.fontStyle,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          Container(
                                                                            width:
                                                                                200.0,
                                                                            decoration: BoxDecoration(
                                                                              color: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).secondaryBackground,
                                                                            ),
                                                                            alignment: const AlignmentDirectional(
                                                                              -1.0,
                                                                              0.0,
                                                                            ),
                                                                            child: Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children:
                                                                                  [
                                                                                        Container(
                                                                                          width: double.infinity,
                                                                                          decoration: const BoxDecoration(),
                                                                                          child: Text(
                                                                                            valueOrDefault<
                                                                                              String
                                                                                            >(
                                                                                              searchproductItem.name,
                                                                                              'Product_name',
                                                                                            ),
                                                                                            style:
                                                                                                FlutterFlowTheme.of(
                                                                                                  context,
                                                                                                ).bodyMedium.override(
                                                                                                  font: GoogleFonts.readexPro(
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontStyle: FlutterFlowTheme.of(
                                                                                                      context,
                                                                                                    ).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  fontStyle: FlutterFlowTheme.of(
                                                                                                    context,
                                                                                                  ).bodyMedium.fontStyle,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                        if (searchproductItem.description !=
                                                                                            '')
                                                                                          Container(
                                                                                            width: double.infinity,
                                                                                            decoration: const BoxDecoration(),
                                                                                            child: Text(
                                                                                              valueOrDefault<
                                                                                                String
                                                                                              >(
                                                                                                searchproductItem.description,
                                                                                                'product_description',
                                                                                              ),
                                                                                              style:
                                                                                                  FlutterFlowTheme.of(
                                                                                                    context,
                                                                                                  ).bodyMedium.override(
                                                                                                    font: GoogleFonts.readexPro(
                                                                                                      fontWeight: FlutterFlowTheme.of(
                                                                                                        context,
                                                                                                      ).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(
                                                                                                        context,
                                                                                                      ).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    color: FlutterFlowTheme.of(
                                                                                                      context,
                                                                                                    ).primaryText,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FlutterFlowTheme.of(
                                                                                                      context,
                                                                                                    ).bodyMedium.fontWeight,
                                                                                                    fontStyle: FlutterFlowTheme.of(
                                                                                                      context,
                                                                                                    ).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                          ),
                                                                                        if (containerGetSignedUrlResponse.succeeded !=
                                                                                            true)
                                                                                          Row(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            children:
                                                                                                [
                                                                                                  Text(
                                                                                                    valueOrDefault<
                                                                                                      String
                                                                                                    >(
                                                                                                      functions.formatIndianCurrency(
                                                                                                        searchproductItem.purchaseValue,
                                                                                                      ),
                                                                                                      '0',
                                                                                                    ),
                                                                                                    style:
                                                                                                        FlutterFlowTheme.of(
                                                                                                          context,
                                                                                                        ).bodyMedium.override(
                                                                                                          font: GoogleFonts.readexPro(
                                                                                                            fontWeight: FlutterFlowTheme.of(
                                                                                                              context,
                                                                                                            ).bodyMedium.fontWeight,
                                                                                                            fontStyle: FlutterFlowTheme.of(
                                                                                                              context,
                                                                                                            ).bodyMedium.fontStyle,
                                                                                                          ),
                                                                                                          letterSpacing: 0.0,
                                                                                                          fontWeight: FlutterFlowTheme.of(
                                                                                                            context,
                                                                                                          ).bodyMedium.fontWeight,
                                                                                                          fontStyle: FlutterFlowTheme.of(
                                                                                                            context,
                                                                                                          ).bodyMedium.fontStyle,
                                                                                                        ),
                                                                                                  ),
                                                                                                ].divide(
                                                                                                  const SizedBox(
                                                                                                    width: 10.0,
                                                                                                  ),
                                                                                                ),
                                                                                          ),
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children:
                                                                                              [
                                                                                                Text(
                                                                                                  'Purchased :',
                                                                                                  style:
                                                                                                      FlutterFlowTheme.of(
                                                                                                        context,
                                                                                                      ).bodyMedium.override(
                                                                                                        font: GoogleFonts.readexPro(
                                                                                                          fontWeight: FlutterFlowTheme.of(
                                                                                                            context,
                                                                                                          ).bodyMedium.fontWeight,
                                                                                                          fontStyle: FlutterFlowTheme.of(
                                                                                                            context,
                                                                                                          ).bodyMedium.fontStyle,
                                                                                                        ),
                                                                                                        color: FlutterFlowTheme.of(
                                                                                                          context,
                                                                                                        ).secondaryText,
                                                                                                        letterSpacing: 0.0,
                                                                                                        fontWeight: FlutterFlowTheme.of(
                                                                                                          context,
                                                                                                        ).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(
                                                                                                          context,
                                                                                                        ).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                ),
                                                                                                Text(
                                                                                                  valueOrDefault<
                                                                                                    String
                                                                                                  >(
                                                                                                    functions.datecount(
                                                                                                      getCurrentTimestamp,
                                                                                                      searchproductItem.purchaseDate,
                                                                                                    ),
                                                                                                    'purchased_date',
                                                                                                  ),
                                                                                                  style:
                                                                                                      FlutterFlowTheme.of(
                                                                                                        context,
                                                                                                      ).bodyMedium.override(
                                                                                                        font: GoogleFonts.readexPro(
                                                                                                          fontWeight: FlutterFlowTheme.of(
                                                                                                            context,
                                                                                                          ).bodyMedium.fontWeight,
                                                                                                          fontStyle: FlutterFlowTheme.of(
                                                                                                            context,
                                                                                                          ).bodyMedium.fontStyle,
                                                                                                        ),
                                                                                                        letterSpacing: 0.0,
                                                                                                        fontWeight: FlutterFlowTheme.of(
                                                                                                          context,
                                                                                                        ).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(
                                                                                                          context,
                                                                                                        ).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                ),
                                                                                              ].divide(
                                                                                                const SizedBox(
                                                                                                  width: 10.0,
                                                                                                ),
                                                                                              ),
                                                                                        ),
                                                                                        if (searchproductItem.validityDate !=
                                                                                            null)
                                                                                          SingleChildScrollView(
                                                                                            scrollDirection: Axis.horizontal,
                                                                                            child: Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              children:
                                                                                                  [
                                                                                                    Text(
                                                                                                      'Warranty till',
                                                                                                      style:
                                                                                                          FlutterFlowTheme.of(
                                                                                                            context,
                                                                                                          ).bodyMedium.override(
                                                                                                            font: GoogleFonts.readexPro(
                                                                                                              fontWeight: FlutterFlowTheme.of(
                                                                                                                context,
                                                                                                              ).bodyMedium.fontWeight,
                                                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                                                context,
                                                                                                              ).bodyMedium.fontStyle,
                                                                                                            ),
                                                                                                            color:
                                                                                                                functions.isDateWithin30Days(
                                                                                                                      getCurrentTimestamp,
                                                                                                                      searchproductItem.validityDate,
                                                                                                                    ) ==
                                                                                                                    true
                                                                                                                ? FlutterFlowTheme.of(
                                                                                                                    context,
                                                                                                                  ).error
                                                                                                                : FlutterFlowTheme.of(
                                                                                                                    context,
                                                                                                                  ).secondary,
                                                                                                            letterSpacing: 0.0,
                                                                                                            fontWeight: FlutterFlowTheme.of(
                                                                                                              context,
                                                                                                            ).bodyMedium.fontWeight,
                                                                                                            fontStyle: FlutterFlowTheme.of(
                                                                                                              context,
                                                                                                            ).bodyMedium.fontStyle,
                                                                                                          ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      dateTimeFormat(
                                                                                                        "d MMMM y",
                                                                                                        searchproductItem.validityDate!,
                                                                                                      ),
                                                                                                      style:
                                                                                                          FlutterFlowTheme.of(
                                                                                                            context,
                                                                                                          ).bodyMedium.override(
                                                                                                            font: GoogleFonts.readexPro(
                                                                                                              fontWeight: FlutterFlowTheme.of(
                                                                                                                context,
                                                                                                              ).bodyMedium.fontWeight,
                                                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                                                context,
                                                                                                              ).bodyMedium.fontStyle,
                                                                                                            ),
                                                                                                            color:
                                                                                                                functions.isDateWithin30Days(
                                                                                                                      getCurrentTimestamp,
                                                                                                                      searchproductItem.validityDate,
                                                                                                                    ) ==
                                                                                                                    true
                                                                                                                ? FlutterFlowTheme.of(
                                                                                                                    context,
                                                                                                                  ).error
                                                                                                                : FlutterFlowTheme.of(
                                                                                                                    context,
                                                                                                                  ).secondary,
                                                                                                            letterSpacing: 0.0,
                                                                                                            fontWeight: FlutterFlowTheme.of(
                                                                                                              context,
                                                                                                            ).bodyMedium.fontWeight,
                                                                                                            fontStyle: FlutterFlowTheme.of(
                                                                                                              context,
                                                                                                            ).bodyMedium.fontStyle,
                                                                                                          ),
                                                                                                    ),
                                                                                                  ].divide(
                                                                                                    const SizedBox(
                                                                                                      width: 4.0,
                                                                                                    ),
                                                                                                  ),
                                                                                            ),
                                                                                          ),
                                                                                      ]
                                                                                      .divide(
                                                                                        const SizedBox(
                                                                                          height: 7.0,
                                                                                        ),
                                                                                      )
                                                                                      .around(
                                                                                        const SizedBox(
                                                                                          height: 7.0,
                                                                                        ),
                                                                                      ),
                                                                            ),
                                                                          ),
                                                                        ]
                                                                        .divide(
                                                                          const SizedBox(
                                                                            width:
                                                                                15.0,
                                                                          ),
                                                                        )
                                                                        .around(
                                                                          const SizedBox(
                                                                            width:
                                                                                15.0,
                                                                          ),
                                                                        ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_model.productcount == 0)
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0,
                            20.0,
                            20.0,
                            0.0,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 500.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(
                                  context,
                                ).secondaryBackground,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 200.0,
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(
                                        context,
                                      ).secondaryBackground,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: Image.asset(
                                          'assets/images/Frame_1000004810.png',
                                        ).image,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'You doent have a Products yet\nClick the button to Add',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontStyle,
                                          ),
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontStyle,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? _buildLoadingScreen() : _buildMainContent();
  }
}
