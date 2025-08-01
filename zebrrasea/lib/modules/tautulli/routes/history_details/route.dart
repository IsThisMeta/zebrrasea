import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/modules/tautulli.dart';

class HistoryDetailsRoute extends StatefulWidget {
  final int ratingKey;
  final int? sessionKey;
  final int? referenceId;

  const HistoryDetailsRoute({
    Key? key,
    required this.ratingKey,
    this.sessionKey,
    this.referenceId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<HistoryDetailsRoute>
    with ZebrraLoadCallbackMixin, ZebrraScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Future<void> loadCallback() async {
    context.read<TautulliState>().setIndividualHistory(
          widget.ratingKey,
          context.read<TautulliState>().api!.history.getHistory(
                length: TautulliDatabase.CONTENT_LOAD_LENGTH.read(),
                ratingKey: widget.ratingKey,
              ),
        );
    await context.read<TautulliState>().individualHistory[widget.ratingKey];
  }

  @override
  Widget build(BuildContext context) {
    return ZebrraScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
    );
  }

  Widget _appBar() {
    return ZebrraAppBar(
      title: 'History Details',
      scrollControllers: [scrollController],
      actions: [
        TautulliHistoryDetailsUser(
            ratingKey: widget.ratingKey,
            sessionKey: widget.sessionKey,
            referenceId: widget.referenceId),
        TautulliHistoryDetailsMetadata(
            ratingKey: widget.ratingKey,
            sessionKey: widget.sessionKey,
            referenceId: widget.referenceId),
      ],
    );
  }

  Widget _body() {
    return ZebrraRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: loadCallback,
      child: FutureBuilder(
        future:
            context.watch<TautulliState>().individualHistory[widget.ratingKey],
        builder: (context, AsyncSnapshot<TautulliHistory> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting)
              ZebrraLogger().error(
                'Unable to pull Tautulli history session',
                snapshot.error,
                snapshot.stackTrace,
              );
            return ZebrraMessage.error(onTap: _refreshKey.currentState!.show);
          }
          if (snapshot.hasData) {
            TautulliHistoryRecord? _record =
                snapshot.data!.records!.firstWhereOrNull((record) {
              if (record.referenceId == (widget.referenceId ?? -1) ||
                  record.sessionKey == (widget.sessionKey ?? -1)) return true;
              return false;
            });
            if (_record != null)
              return TautulliHistoryDetailsInformation(
                scrollController: scrollController,
                history: _record,
              );
            return _unknown();
          }
          return const ZebrraLoader();
        },
      ),
    );
  }

  Widget _unknown() {
    return ZebrraMessage.goBack(
      context: context,
      text: 'History Not Found',
    );
  }
}
