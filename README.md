# Project Obsidian

A WIP TCP socket based chat/file transfer program, developed using the Yaru theme for linux distributions. 

## How it works:
- It's completely peer to peer, clients discover each other using multicast DNS.
- Connections will be made to the port broadcasted by mDNS.
- Uses TCP for the sockets to ensure a reliable connection.

## What's working:
- [x] discovery of clients
- [x] advertising your client using mDNS
- [x] connect using TCP
- [x] sending and recieving text messages 
- [ ] encryption
- [ ] message persistence
- [ ] file sharing  
