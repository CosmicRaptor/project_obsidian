import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bonsoir/bonsoir.dart';

// StateNotifier to handle discovery state and persist it across rebuilds
class MulticastNotifier extends StateNotifier<List<String>> {
  MulticastNotifier(this.ref) : super([]) {
    _startDiscovery();
  }

  final Ref ref;
  late BonsoirDiscovery discovery;
  Set<String> discoveredServices = {};

  Future<void> _startDiscovery() async {
    String type = '_chat._tcp'; // The service type for the chat application.
    discovery = BonsoirDiscovery(type: type);
    await discovery.ready;

    // Start the broadcast before starting the discovery
    await ref.read(multicastBroadcastProvider.future);

    // Start the discovery process:
    await discovery.start();

    // Listen to the discovery events:
    discovery.eventStream!.listen((event) {
      if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
        String? serviceName = event.service?.name;

        // Check if service was already discovered
        if (serviceName != null && !discoveredServices.contains(serviceName)) {
          print('Service found : ${event.service?.toJson()}');
          discoveredServices.add(serviceName); // Add to discovered set
          state = [...state, serviceName]; // Update state with new clients
        }
      } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
        String? serviceName = event.service?.name;

        if (serviceName != null && discoveredServices.contains(serviceName)) {
          print('Service lost : ${event.service?.toJson()}');
          discoveredServices.remove(serviceName); // Remove from discovered set
          state = state.where((client) => client != serviceName).toList(); // Update state
        }
      }
    });
  }

  Future<void> stopDiscovery() async {
    await discovery.stop();
  }

  @override
  void dispose() {
    stopDiscovery();
    super.dispose();
  }
}

// Create a provider for MulticastNotifier
final multicastProvider = StateNotifierProvider<MulticastNotifier, List<String>>((ref) {
  return MulticastNotifier(ref);
});

// Provider for broadcasting services
final multicastBroadcastProvider = FutureProvider.autoDispose<void>((ref) async {
  BonsoirBroadcast broadcast = ref.read(bonsoirBroadcast);
  await broadcast.ready;

  // Start the broadcast **after** listening to broadcast events:
  await broadcast.start();
});

// Provide the BonsoirService instance so it can be stopped/started:
final bonsoirBroadcast = Provider<BonsoirBroadcast>((ref) {
  return BonsoirBroadcast(service: BonsoirService(name: 'Flutter Chat', type: '_chat._tcp', port: 45000));
});
