import 'dart:async';

import 'package:bonsoir/bonsoir.dart';
import 'package:chat_app/models/BonsoirModels.dart';
import 'package:chat_app/models/app_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The model provider.
final discoveryModelProvider = ChangeNotifierProvider<BonsoirDiscoveryModel>((ref) {
  BonsoirDiscoveryModel model = BonsoirDiscoveryModel();
  model.start(DefaultAppService.service.type);
  return model;
});

/// Provider model that allows to handle Bonsoir discoveries.
class BonsoirDiscoveryModel extends BonsoirActionModel<String, BonsoirDiscovery, BonsoirDiscoveryEvent> {
  /// A map containing all discovered services.
  final Map<String, List<BonsoirService>> _services = {};

  @override
  BonsoirDiscovery createAction(String argument) => BonsoirDiscovery(type: argument);

  @override
  Future<void> start(String argument, {bool notify = true}) async {
    _services[argument] ??= [];
    await super.start(argument, notify: notify);
  }

  /// Returns the services map.
  Map<String, List<BonsoirService>> get services => Map.from(_services);

  @override
  void onEventOccurred(BonsoirDiscoveryEvent event) {
    if (event.service == null) {
      return;
    }

    BonsoirService service = event.service!;
    List<BonsoirService> services = _services[service.type]!;
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
      services.add(service);
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
      services.removeWhere((foundService) => foundService.name == service.name);
      services.add(service);
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
      services.removeWhere((foundService) => foundService.name == service.name);
    }
    services.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  @override
  Future<void> stop(String argument, {bool notify = true}) async {
    await super.stop(argument, notify: false);
    _services.remove(argument);
    if (notify) {
      notifyListeners();
    }
  }

  /// Resolves the given service.
  void resolveService(BonsoirService service) {
    BonsoirDiscovery? discovery = getAction(service.type);
    if (discovery != null) {
      service.resolve(discovery.serviceResolver);
    }
  }
}
/// The model provider.
final broadcastModelProvider = ChangeNotifierProvider((ref) {
  BonsoirBroadcastModel model = BonsoirBroadcastModel();
  model.start(DefaultAppService.service);
  return model;
});

/// Provider model that allows to handle Bonsoir broadcasts.
class BonsoirBroadcastModel extends BonsoirActionModel<BonsoirService, BonsoirBroadcast, BonsoirEvent> {
  /// Returns the broadcasted services.
  Iterable<BonsoirService> get broadcastedServices => actions.map((broadcast) => broadcast.service);

  @override
  BonsoirBroadcast createAction(BonsoirService argument) => BonsoirBroadcast(service: argument);
}
