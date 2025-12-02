import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'card_produto_model.dart';
export 'card_produto_model.dart';

class CardProdutoWidget extends StatefulWidget {
  const CardProdutoWidget({
    super.key,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    this.productUrl,
  });

  /// imagem
  final String? productImage;

  /// nome
  final String? productName;

  /// price
  final double? productPrice;

  final String? productUrl;

  @override
  State<CardProdutoWidget> createState() => _CardProdutoWidgetState();
}

class _CardProdutoWidgetState extends State<CardProdutoWidget> {
  late CardProdutoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CardProdutoModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = FFLocalizations.of(context);
    final currencyLocale =
        localization.languageCode.startsWith('pt') ? 'pt_BR' : 'en_US';
    final priceValue = widget.productPrice ?? 0.0;
    final formattedPrice =
        NumberFormat.simpleCurrency(locale: currencyLocale).format(priceValue);
    final productUrl = widget.productUrl ?? '';
    final canOpenProductUrl = productUrl.isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: Color(0x1A000000),
            offset: Offset(
              0.0,
              2.0,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                fadeInDuration: Duration(milliseconds: 300),
                fadeOutDuration: Duration(milliseconds: 300),
                imageUrl: widget.productImage!,
                width: double.infinity,
                height: 120.0,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 4.0),
              child: SelectionArea(
                  child: Text(
                valueOrDefault<String>(
                  widget.productName,
                  'Nome',
                ),
                maxLines: 2,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      font: GoogleFonts.raleway(
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleMedium.fontStyle,
                    ),
              )),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
              child: Text(
                formattedPrice,
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      font: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 14.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                    ),
              ),
            ),
            FFButtonWidget(
              onPressed: canOpenProductUrl
                  ? () async {
                      await launchURL(productUrl);
                    }
                  : null,
              text: valueOrDefault<String>(
                productUrl,
                'Link indisponível',
              ),
              options: FFButtonOptions(
                width: double.infinity,
                height: 36.0,
                padding: EdgeInsets.all(8.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      font: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                      color: Colors.white,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
                elevation: 0.0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
