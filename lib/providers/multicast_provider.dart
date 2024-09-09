import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multicast_dns/multicast_dns.dart';

// Creating a stream provider that provides a list of discovered clients
final multicastProvider = StreamProvider.autoDispose<List<String>>((ref) async* {
  final client = MDnsClient();
  final name = '_chatapp._tcp.local'; // Ensure the correct service name is used
  List<String> clients = [];

  // Start the mDNS client
  await client.start();
  print("mDNS client started");

  // Ensure that the client is properly stopped when the provider is disposed
  ref.onDispose(() {
    client.stop();
    print("mDNS client stopped");
  });

  // Listen for service pointers matching the service name
  await for (final PtrResourceRecord ptr in client.lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(name))) {
    print('Discovered service pointer: ${ptr.domainName}');

    // For each PTR record, lookup the service details (SRV records)
    await for (final SrvResourceRecord srv in client.lookup<SrvResourceRecord>(ResourceRecordQuery.service(ptr.domainName))) {
      print('Found service at ${srv.target}:${srv.port}');

      // Retrieve the IP address for the service
      await for (final IPAddressResourceRecord ip in client.lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv4(srv.target))) {
        print('Found IP address: ${ip.address}');

        // Add the client's IP address to the list if it's not already in the list
        if (!clients.contains(ip.address.toString())) {
          clients.add(ip.address.toString());
          print("Discovered clients: $clients");

          // Yield the updated list of clients
          yield [...clients];
        }
      }
    }
  }
});
